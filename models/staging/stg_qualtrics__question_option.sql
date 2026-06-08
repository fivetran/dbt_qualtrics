with base as (

    select * 
    from {{ ref('stg_qualtrics__question_option_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_qualtrics__question_option_tmp')),
                staging_columns=get_question_option_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='qualtrics') }}
            
    from base
),

final as (
    
    select 
        question_id,
        survey_id,
        key,
        recode_value,
        text,
        cast(_fivetran_deleted as {{ dbt.type_boolean() }}) as is_deleted,
        _fivetran_synced,
        source_relation
        
    from fields
)

select *
from final