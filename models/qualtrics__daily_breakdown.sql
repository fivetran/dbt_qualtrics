{{ config(enabled=false) }}

with response as (

    select *
    from {{ ref('qualtrics__response_breakdown') }}
),

contact as (

    select *
    from {{ ref('qualtrics__contact') }}
),
{#
distribution_contact as (

    select *
    from {{ var('distribution_contact') }}
),

agg_responses as (

    select 

    from 
),
#}
agg_contacts as (

    select
        source_relation,
        {{ dbt.date_trunc('day') }}
    from contact  
)


select * 
from contact