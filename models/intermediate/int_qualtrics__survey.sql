{{ config(enabled=false) }}

with survey as (

    select *
    from {{ var('survey') }}
),

survey_version as (

    select *
    from {{ var('survey_version') }}
)

select *
from survey