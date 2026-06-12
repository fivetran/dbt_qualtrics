{{ config(enabled=var('qualtrics__using_core_mailing_lists', false)) }}

{% if var('qualtrics_union_schemas', []) | length > 0 or var('qualtrics_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='core_mailing_list',
        database_variable='qualtrics_database',
        schema_variable='qualtrics_schema',
        default_database=target.database,
        default_schema='qualtrics',
        default_variable='core_mailing_list',
        union_schema_variable='qualtrics_union_schemas',
        union_database_variable='qualtrics_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='qualtrics_sources',
        single_source_name='qualtrics',
        single_table_name='core_mailing_list'
    )
}}

{% endif %}