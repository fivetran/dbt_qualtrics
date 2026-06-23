{% if var('qualtrics_union_schemas', []) | length > 0 or var('qualtrics_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='survey_version',
        database_variable='qualtrics_database',
        schema_variable='qualtrics_schema',
        default_database=target.database,
        default_schema='qualtrics',
        default_variable='survey_version',
        union_schema_variable='qualtrics_union_schemas',
        union_database_variable='qualtrics_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='qualtrics_sources',
        single_source_name='qualtrics',
        single_table_name='survey_version'
    )
}}

{% endif %}