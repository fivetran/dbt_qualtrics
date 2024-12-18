{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with source as (
    select 
        count(*) as row_count,
        count(distinct id) as contact_ids 
    from {{ source('qualtrics', 'contact') }}
),

model as (

    select
        count(*) as row_count,
        count(distinct contact_id) as contact_ids 
    from {{ ref('qualtrics__contact') }}
),

comparison as (
    select
        source.row_count as source_row_count,
        source.contact_ids as source_contact_ids,
        model.row_count as model_row_count,
        model.contact_ids as model_contact_ids
    from source
    cross join model
)

select *
from comparison
where 
    source_row_count != model_row_count
    or source_contact_ids != model_contact_ids