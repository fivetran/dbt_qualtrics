{{ config(enabled=false) }}

with contacts as (

    select *
    from {{ ref('int_qualtrics__contacts') }}
),

directory_mailing_list as (

    select *
    from {{ var('directory_mailing_list') }}
),

contact_mailing_list_membership as (

    select *
    from {{ var('contact_mailing_list_membership') }}
),

xm_directory_join as (

    select
        directory_contact.*,
        directory_mailing_list.mailing_list_id,
        directory_mailing_list.name as mailing_list_name,
        directory_mailing_list.owner_user_id,
        directory_mailing_list.is_deleted as is_mailing_list_deleted,
        directory_mailing_list.created_at as mailing_list_created_at,
        directory_mailing_list.last_modified_at as mailing_list_last_modified_at

    from directory_contact

    left join directory_mailing_list
        on directory_contact.directory_id = directory_mailing_list.directory_id

    left join contact_mailing_list_membership
        on directory_contact.contact_id = contact_mailing_list_membership.contact_id 
        on directory_contact.directory_id = contact_mailing_list_membership.directory_id
        and directory_mailing_list.mailing_list_id = contact_mailing_list_membership.mailing_list_id
),


    {% if var('qualtrics__using_core_mailing_lists', true) %}
core_mailing_list as (

    select *
    from {{ var('core_mailing_list') }}
),

core_join as (

    select
        core_contact.*,
        core_mailing_list.name as mailing_list_name,
        core_mailing_list.library_id,
        core_mailing_list.category as mailing_list_category,
        core_mailing_list.folder as mailing_lit_folder,
        core_mailing_list.is_deleted as is_mailing_list_deleted

    from core_contact
    left join core_mailing_list
        on core_contact.mailing_list_id = core_mailing_list.mailing_list_id
)
{% endif %}

