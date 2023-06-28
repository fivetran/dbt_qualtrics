with directory_contact as (

    select *
    from {{ var('directory_contact') }}
),

{% if var('qualtrics__using_core_contacts', true) %}
core_contact as (

    select *
    from {{ var('core_contact') }}
),

final as (

    select 
        coalesce(directory_contact.contact_id, core_contact.mailing_list_contact_id) as contact_id,
        case 
            when directory_contact.email is not null and core_contact.email is not null then 'both'
            when directory_contact.email is not null and core_contact.email is null then 'directory'
            else 'core' 
            end as contact_type,
        directory_contact.directory_id,
        core_contact.mailing_list_id,
        coalesce(directory_contact.email, core_contact.email) as email,
        coalesce(directory_contact.email_domain, core_contact.email_domain) as email_domain,
        coalesce(directory_contact.first_name, core_contact.first_name) as first_name,
        coalesce(directory_contact.last_name, core_contact.last_name) as last_name,
        coalesce(directory_contact.ext_ref, core_contact.external_data_reference) as external_data_reference,
        coalesce(directory_contact.language, core_contact.language) as language,
        coalesce(directory_contact.is_unsubscribed_from_directory, core_contact.is_unsubscribed) as is_unsubscribed,
        directory_contact.unsubscribed_from_directory_at as unsubscribed_at,
        directory_contact.last_modified_at as last_modified_at

    from directory_contact

    full outer join core_contact 
        on directory_contact.email = core_contact.email

)
{% else %}

final as (

    select
        mailing_list_contact_id as contact_id,
        'directory' as contact_type,
        directory_id,
        null as mailing_list_id,
        email,
        email_domain,
        first_name,
        last_name,
        ext_ref as external_data_reference,
        language,
        is_unsubscribed_from_directory as is_unsubscribed,
        unsubscribed_from_directory_at as unsubscribed_at,
        last_modified_at
        
    from directory_contact 
)
{% endif %}

select * from final