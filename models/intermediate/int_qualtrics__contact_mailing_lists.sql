{{ config(enabled=false) }}

with directory_contact as (

    select *
    from {{ var('directory_contact') }}
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

{% if var('qualtrics__using_core_contacts', true) %}
core_contact as (

    select *
    from {{ var('core_contact') }}
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

final as (

    select
        mailing_list_contact_id as contact_id,
        'core' as contact_type,
        null as directory_id,
        mailing_list_id,
        email,
        {{ dbt.split_part('email', '@', 2) }} as email_domain,
        first_name,
        last_name,
        external_data_reference,
        language,
        is_unsubscribed,
        null as unsubscribed_at
        
    from core_join

    union all 

{% else %}
final as (
{% endif %}

    select 
        contact_id,
        'directory' as contact_type, 
        directory_id,
        mailing_list_id,
        email,
        email_domain,
        first_name,
        last_name,
        ext_ref as external_data_reference,
        language,
        is_unsubscribed_from_directory as is_unsubscribed,
        unsubscribed_from_directory_at as unsubscribed_at,
        last_modified_at

    from xm_directory_join


)

