{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with source as (
    select 
        count(*) as row_count,
        count(distinct id) as directory_ids 
    from {{ source('qualtrics', 'directory') }}
),

model as (

    select
        count(*) as row_count,
        count(distinct directory_id) as directory_ids 
    from {{ ref('qualtrics__directory') }}
),

comparison as (
    select
        source.row_count as source_row_count,
        source.directory_ids as source_directory_ids,
        model.row_count as model_row_count,
        model.directory_ids as model_directory_ids
    from source
    cross join model
)

select *
from comparison
where 
    source_row_count != model_row_count
    or source_directory_ids != model_directory_ids