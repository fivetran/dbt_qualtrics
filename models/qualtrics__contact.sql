with contacts as (

    select *
    from {{ ref('int_qualtrics__contacts') }}
),

survey_response as (

    select *
    from {{ var('survey_response') }}
),

question_response as (

    select *
    from {{ var('question_response') }}
),

agg_survey_responses as (

{% set distribution_channels = ('anonymous', 'social', 'gl', 'qr', 'email', 'smsinvite') %}

    select 
        recipient_email,
        source_relation,
        count(distinct survey_id) as count_surveys,
        avg(progress) as avg_progress,
        count(distinct case when is_finished then survey_id else null end) as count_completed_surveys,
        avg(duration_in_seconds) as avg_survey_duration_in_seconds,
        {% for distribution_channel in distribution_channels %}
        count(distinct 
                case 
                when distribution_channel = '{{ distribution_channel }}' then survey_id
                else null end) as count_{{ distribution_channel }}_surveys,
        count(distinct 
                case 
                when is_finished and distribution_channel = '{{ distribution_channel }}' then survey_id
                else null end) as count_{{ distribution_channel }}_completed_surveys,
        {% endfor %}
        count(distinct 
                case 
                when distribution_channel not in {{ distribution_channels }} then survey_id
                else null end) as count_uncategorized_surveys,
        count(distinct 
                case 
                when is_finished and distribution_channel not in {{ distribution_channels }} then survey_id
                else null end) as count_uncategorized_completed_surveys,

        max(recorded_date) as last_survey_response_recorded_at,
        min(recorded_date) as first_survey_response_recorded_at
        
    from survey_response
    group by 1,2
),

agg_question_responses as (

    select
        survey_response.recipient_email,
        question_response.source_relation,
        count(distinct question_response.question_id) as count_questions_answered

    from question_response
    join survey_response 
        on question_response.response_id = survey_response.response_id
        and question_response.source_relation = survey_response.source_relation

    group by 1,2
),

contact_join as (

    select
        contacts.*,
        agg_survey_responses.last_survey_response_recorded_at,
        agg_survey_responses.first_survey_response_recorded_at,
        agg_survey_responses.count_surveys,
        agg_survey_responses.avg_progress,
        agg_survey_responses.count_completed_surveys,
        agg_survey_responses.avg_survey_duration_in_seconds,
        agg_question_responses.count_questions_answered,
        -- distribution channels - check if anonymous ones can be tied to contacts
        agg_survey_responses.count_anonymous_surveys,
        agg_survey_responses.count_anonymous_completed_surveys,
        agg_survey_responses.count_social_surveys as count_social_media_surveys,
        agg_survey_responses.count_social_completed_surveys as count_social_media_completed_surveys,
        agg_survey_responses.count_gl_surveys as count_personal_link_surveys,
        agg_survey_responses.count_gl_completed_surveys as count_personal_link_completed_surveys,
        agg_survey_responses.count_qr_surveys as count_qr_code_surveys,
        agg_survey_responses.count_qr_completed_surveys as count_qr_code_completed_surveys,
        agg_survey_responses.count_email_surveys,
        agg_survey_responses.count_email_completed_surveys,
        agg_survey_responses.count_smsinvite_surveys,
        agg_survey_responses.count_smsinvite_completed_surveys,
        agg_survey_responses.count_uncategorized_surveys,
        agg_survey_responses.count_uncategorized_completed_surveys

    from contacts 
    left join agg_survey_responses
        on contacts.email = agg_survey_responses.recipient_email
        and contacts.source_relation = agg_survey_responses.source_relation
    left join agg_question_responses
        on contacts.email = agg_question_responses.recipient_email
        and contacts.source_relation = agg_question_responses.source_relation
)

select *
from contact_join