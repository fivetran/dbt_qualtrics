with source as (
    select 
        count(*) as row_count,
        count(distinct _fivetran_id) as response_ids 
    from {{ source('qualtrics', 'question_response') }}
),

model as (

    select
        count(*) as row_count,
        count(distinct question_response_id) as response_ids 
    from {{ ref('qualtrics__response') }}
),

comparison as (
    select
        source.row_count as source_row_count,
        source.response_ids as source_response_ids,
        model.row_count as model_row_count,
        model.response_ids as model_response_ids
    from source
    cross join model
)

select *
from comparison
where 
    source_row_count != model_row_count
    or source_response_ids != model_response_ids