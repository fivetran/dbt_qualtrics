{% set contacts_enabled = var('qualtrics__using_directory_contacts', true) or var('qualtrics__using_core_contacts', false) %}

with response as (
    -- will probably move the logic from this int model to the end model directly 
    select *
    from {{ ref('int_qualtrics__responses') }}
),

question_option as (

    select *
    from {{ ref('stg_qualtrics__question_option') }}
),

question as (

    select *
    from {{ ref('int_qualtrics__question') }}
),

-- question-level attributes (identical across sub-questions). Used when a response has no sub_question_key but the question has sub-questions.
question_level as (

    select
        question_id,
        survey_id,
        source_relation,
        question_description,
        question_type,
        block_id,
        block_description,
        block_question_randomization,
        block_type,
        block_visibility,
        validation_setting_force_response,
        validation_setting_force_response_type,
        validation_setting_type,
        is_question_deleted,
        is_block_deleted
    from (
        select
            *,
            row_number() over (
                partition by question_id, survey_id, source_relation
                order by sub_question_key nulls first
            ) as row_num
        from question
    ) as ranked_question
    where row_num = 1
),

survey as (

    select *
    from {{ ref('stg_qualtrics__survey') }}
),

embedded_data as (

    select *
    from {{ ref('int_qualtrics__survey_embedded_data') }}
),

{% if contacts_enabled %}
contacts as (

    select *
    from {{ ref('int_qualtrics__contacts') }}
),

rollup_contacts as (

    select 
        email,
        source_relation,
        max(email_domain) as email_domain,
        max(first_name) as first_name,
        max(last_name) as last_name,
        max(language) as language,
        max(external_data_reference) as external_data_reference,
        {{ fivetran_utils.max_bool(boolean_field="is_xm_directory_contact") }} as is_xm_directory_contact,
        {{ fivetran_utils.max_bool(boolean_field="is_research_core_contact") }} as is_research_core_contact

    from contacts
    group by 1,2
),
{% endif %}

final as (

    select 
        response.*,
        question_option.recode_value,
        question_option.text as question_option_text,

        {% if contacts_enabled %}
        rollup_contacts.first_name,
        rollup_contacts.last_name,
        rollup_contacts.email_domain,
        rollup_contacts.language as contact_language,
        rollup_contacts.external_data_reference as contact_external_data_reference,
        rollup_contacts.is_xm_directory_contact,
        rollup_contacts.is_research_core_contact,
        {% else %}
        cast(null as {{ dbt.type_string() }}) as first_name,
        cast(null as {{ dbt.type_string() }}) as last_name,
        cast(null as {{ dbt.type_string() }}) as email_domain,
        cast(null as {{ dbt.type_string() }}) as contact_language,
        cast(null as {{ dbt.type_string() }}) as contact_external_data_reference,
        cast(null as {{ dbt.type_boolean() }}) as is_xm_directory_contact,
        cast(null as {{ dbt.type_boolean() }}) as is_research_core_contact,
        {% endif %}

        embedded_data.embedded_data,
        survey.survey_name,
        survey.survey_status,
        survey.project_category,
        survey.project_type,
        survey.brand_base_url,
        
        -- most question fields are included, as there is no question end model. join with `int_qualtrics__question` to bring in more
        coalesce(question.question_description, question_level.question_description) as question_description,
        coalesce(question.question_type, question_level.question_type) as question_type,
        coalesce(question.block_id, question_level.block_id) as block_id,
        coalesce(question.block_description, question_level.block_description) as block_description,
        coalesce(question.block_question_randomization, question_level.block_question_randomization) as block_question_randomization,
        coalesce(question.block_type, question_level.block_type) as block_type,
        coalesce(question.block_visibility, question_level.block_visibility) as block_visibility,
        coalesce(question.validation_setting_force_response, question_level.validation_setting_force_response) as validation_setting_force_response,
        coalesce(question.validation_setting_force_response_type, question_level.validation_setting_force_response_type) as validation_setting_force_response_type,
        coalesce(question.validation_setting_type, question_level.validation_setting_type) as validation_setting_type,
        coalesce(question.is_question_deleted, question_level.is_question_deleted) as is_question_deleted,
        coalesce(question.is_block_deleted, question_level.is_block_deleted) as is_block_deleted

    from response

    left join question
        on response.question_id = question.question_id
        and response.survey_id = question.survey_id
        {# null-safe match on sub_question_key: both sides null, or both non-null and equal. Equalities only, so warehouses can still hash join. #}
        and (response.sub_question_key is null) = (question.sub_question_key is null)
        and coalesce(response.sub_question_key, '') = coalesce(question.sub_question_key, '')
        and response.source_relation = question.source_relation

    left join question_level
        on response.question_id = question_level.question_id
        and response.survey_id = question_level.survey_id
        and response.source_relation = question_level.source_relation

    left join question_option
        on response.question_id = question_option.question_id 
        and response.survey_id = question_option.survey_id
        and response.question_option_key = question_option.key
        and response.source_relation = question_option.source_relation

    left join survey
        on response.survey_id = survey.survey_id
        and response.source_relation = survey.source_relation

    left join embedded_data
        on response.survey_response_id = embedded_data.response_id
        and response.source_relation = embedded_data.source_relation

    {% if contacts_enabled %}
    left join rollup_contacts 
        on response.recipient_email = rollup_contacts.email
        and response.source_relation = rollup_contacts.source_relation
    {% endif %}
)

select *
from final