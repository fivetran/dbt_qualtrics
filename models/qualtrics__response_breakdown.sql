{{ config(enabled=false )}}

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

final as (

    select 
        response.*,
        question. -- 
        embedded_data.embedded_data


    from response
    join question
        on response.question_id = question.question_id
        and response.survey_id = question.survey_id
    left join question_option
        on response.question_id = question_option.question_id 
        and response.question_option_key = question_option.key
    left join embedded_data
        on response.survey_response_id = embedded_data.response_id
)

select *
from final