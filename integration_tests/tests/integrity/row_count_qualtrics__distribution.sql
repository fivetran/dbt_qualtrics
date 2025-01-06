{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with source as (
    select 
        count(*) as row_count,
        count(distinct id) as distribution_ids 
    from {{ source('qualtrics', 'distribution') }}
),

model as (

    select
        count(*) as row_count,
        count(distinct distribution_id) as distribution_ids 
    from {{ ref('qualtrics__distribution') }}
),

comparison as (
    select
        source.row_count as source_row_count,
        source.distribution_ids as source_distribution_ids,
        model.row_count as model_row_count,
        model.distribution_ids as model_distribution_ids
    from source
    cross join model
)

select *
from comparison
where 
    source_row_count != model_row_count
    or source_distribution_ids != model_distribution_ids