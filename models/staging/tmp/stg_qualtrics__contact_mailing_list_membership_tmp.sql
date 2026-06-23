{{ config(enabled=var('qualtrics__using_contact_mailing_list_memberships', true)) }}

{% if var('qualtrics_union_schemas', []) | length > 0 or var('qualtrics_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='contact_mailing_list_membership',
        database_variable='qualtrics_database',
        schema_variable='qualtrics_schema',
        default_database=target.database,
        default_schema='qualtrics',
        default_variable='contact_mailing_list_membership',
        union_schema_variable='qualtrics_union_schemas',
        union_database_variable='qualtrics_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='qualtrics_sources',
        single_source_name='qualtrics',
        single_table_name='contact_mailing_list_membership'
    )
}}

{% endif %}