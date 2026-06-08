with base as (

    select * 
    from {{ ref('stg_qualtrics__sub_question_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_qualtrics__sub_question_tmp')),
                staging_columns=get_sub_question_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='qualtrics') }}
            
    from base
),

final as (
    
    select 
        choice_data_export_tag,
        key,
        question_id,
        survey_id,
        text,
        cast(_fivetran_deleted as {{ dbt.type_boolean() }}) as is_deleted,
        _fivetran_synced,
        source_relation
        
    from fields
)

select *
from final