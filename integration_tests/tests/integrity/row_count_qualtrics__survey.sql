{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with source as (
    select 
        count(*) as row_count,
        count(distinct id) as survey_ids 
    from {{ source('qualtrics', 'survey') }}
),

model as (

    select
        count(*) as row_count,
        count(distinct survey_id) as survey_ids 
    from {{ ref('qualtrics__survey') }}
),

comparison as (
    select
        source.row_count as source_row_count,
        source.survey_ids as source_survey_ids,
        model.row_count as model_row_count,
        model.survey_ids as model_survey_ids
    from source
    cross join model
)

select *
from comparison
where 
    source_row_count != model_row_count
    or source_survey_ids != model_survey_ids