
{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        {{ dbt_utils.star(from=ref('qualtrics__survey'), except=['avg_response_duration_in_seconds', 'avg_survey_progress_pct']) }},
        round(avg_response_duration_in_seconds, 0) as avg_response_duration_in_seconds,
        round(avg_survey_progress_pct, 0) as avg_survey_progress_pct
    from {{ target.schema }}_qualtrics_prod.qualtrics__survey
),

dev as (
    select
        {{ dbt_utils.star(from=ref('qualtrics__survey'), except=['avg_response_duration_in_seconds', 'avg_survey_progress_pct']) }},
        round(avg_response_duration_in_seconds, 0) as avg_response_duration_in_seconds,
        round(avg_survey_progress_pct, 0) as avg_survey_progress_pct
    from {{ target.schema }}_qualtrics_dev.qualtrics__survey
    
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final