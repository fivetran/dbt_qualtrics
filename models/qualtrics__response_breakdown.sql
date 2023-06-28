with response as (

    select *
    from {{ ref('int_qualtrics__responses') }}
),

question_option as (

    select *
    from {{ var('question_option') }}
),

question as (

    select *
    from {{ ref('int_qualtrics__question') }}
),

survey as (

    select *
    from {{ var('survey') }}
),

embedded_data as (

    select *
    from {{ ref('int_qualtrics__survey_embedded_data') }}
),

contacts as (

    select *
    from {{ ref('int_qualtrics__contacts') }}
),

final as (

    select 
        response.*,

        contacts.first_name,
        contacts.last_name,
        contacts.email_domain,
        contacts.language as contact_language,
        contacts.external_data_reference as contact_external_data_reference,
        contacts.contact_type,

        embedded_data.embedded_data,
        survey.survey_name,
        survey.survey_status,
        survey.project_category,
        survey.project_type,
        survey.brand_base_url,
        
        -- most question fields are included, as there is no question end model (for now). join with `int_qualtrics__question` to bring in more
        question.question_description,
        question.question_type,
        question.is_sub_question,
        question.block_id,
        question.block_description,
        question.block_question_randomization,
        question.block_type,
        question.block_visibility,
        question.validation_setting_force_response,
        question.validation_setting_force_response_type,
        question.validation_setting_type,
        question.is_question_deleted,
        question.is_sub_question_deleted,
        question.is_block_deleted

    from response

    left join question
        on response.question_id = question.question_id
        and response.survey_id = question.survey_id

    left join question_option
        on response.question_id = question_option.question_id 
        and response.question_option_key = question_option.key

    left join survey
        on response.survey_id = survey.survey_id

    left join embedded_data
        on response.survey_response_id = embedded_data.response_id

    left join contacts 
        on response.recipient_email = contacts.email

)

select *
from final