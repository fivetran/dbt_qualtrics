with survey as (

    select *
    from {{ var('survey') }}
),

survey_version as (

    select *
    from {{ ref('int_qualtrics__survey_version') }}
),

responses as (

    select *
    from {{ ref('int_qualtrics__responses') }}
),

question as (

    select *
    from {{ var('question') }}
),

agg_questions as (

    select 
        survey_id,
        source_relation,
        count(distinct question_id) as count_questions
    from question 
    where not coalesce(is_deleted, false)
    group by 1,2
),

agg_responses as (

    {% set distribution_channels = ('anonymous', 'social', 'gl', 'qr', 'email', 'smsinvite') %}

    select
        survey_id,
        source_relation,
        avg(duration_in_seconds) as avg_response_duration_in_seconds,
        avg(survey_progress) as avg_survey_progress_pct,
        count(distinct survey_response_id) as count_survey_responses,
        count(distinct case when is_finished_with_survey then survey_response_id else null end) as count_completed_survey_responses,
        count(distinct 
                case 
                when {{ fivetran_utils.timestamp_diff(first_date="survey_response_recorded_at", second_date=dbt.current_timestamp(), datepart="day") }} <= 30 then survey_response_id
                else null end) as count_survey_responses_30d,
        count(distinct 
                case 
                when is_finished_with_survey and {{ fivetran_utils.timestamp_diff(first_date="survey_response_recorded_at", second_date=dbt.current_timestamp(), datepart="day") }} <= 30 then survey_response_id
                else null end) as count_completed_survey_responses_30d,
        
        -- pivot out distribution channel responses
        {% for distribution_channel in distribution_channels %}
        count(distinct 
                case 
                when distribution_channel = '{{ distribution_channel }}' then survey_response_id
                else null end) as count_{{ distribution_channel }}_survey_responses,
        count(distinct 
                case 
                when distribution_channel = '{{ distribution_channel }}' and is_finished_with_survey then survey_response_id
                else null end) as count_{{ distribution_channel }}_completed_survey_responses,
        {% endfor %}

        count(distinct case 
                when distribution_channel not in {{ distribution_channels }} then survey_response_id
                else null end) as count_uncategorized_survey_responses,
        count(distinct case 
                when is_finished_with_survey and distribution_channel not in {{ distribution_channels }} then survey_response_id
                else null end) as count_uncategorized_completed_survey_responses

    from responses 
    group by 1,2
),

survey_join as (

    select
        survey.*,
        agg_questions.count_questions,

        agg_responses.avg_response_duration_in_seconds,
        agg_responses.avg_survey_progress_pct,
        agg_responses.count_survey_responses,
        agg_responses.count_completed_survey_responses,
        agg_responses.count_survey_responses_30d,
        agg_responses.count_completed_survey_responses_30d,

        {% for distribution_channel in distribution_channels %}
        agg_responses.count_{{ distribution_channel }}_survey_responses,
        agg_responses.count_{{ distribution_channel }}_completed_survey_responses,
        {% endfor %}

        agg_responses.count_uncategorized_survey_responses,
        agg_responses.count_uncategorized_completed_survey_responses,

        survey_version.version_id,
        survey_version.version_number,
        survey_version.version_description,
        survey_version.survey_version_created_at,
        survey_version.count_published_versions,
        survey_version.publisher_user_id,
        survey_version.publisher_user_email,
        survey_version.publisher_user_first_name,
        survey_version.publisher_user_last_name,
        survey_version.publisher_user_status

    from survey 
    left join survey_version
        on survey.survey_id = survey_version.survey_id 
        and survey.source_relation = survey_version.source_relation
    left join agg_questions
        on survey.survey_id = agg_questions.survey_id
        and survey.source_relation = agg_questions.source_relation
    left join agg_responses
        on survey.survey_id = agg_responses.survey_id
        and survey.source_relation = agg_responses.source_relation
)

select *
from survey_join