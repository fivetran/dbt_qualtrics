with distribution as (

    select *
    from {{ var('distribution') }}
),

distribution_contact as (

    select *
    from {{ var('distribution_contact') }}
),

user as (

    select *
    from {{ var('user') }}
),

contact_mailing_list_membership as (

    select *
    from {{ var('contact_mailing_list_membership') }}
),

x as (

    select 
        
    from distribution_contact 
    left join contact_mailing_list_membership
        on distribution_contact.contact_lookup_id = contact_mailing_list_membership.contact_lookup_id
        and distribution_contact.source_relation = contact_mailing_list_membership.source_relation
)

final as (

    select 
        distribution.*,
        user.email as owner_email,
        user.first_name as owner_first_name,
        user.last_name as owner_last_name
    
    from distribution
    left join user 
        on distribution.owner_user_id = user.user_id 
        and distribution.source_relation = user.source_relation
    left join distribution as parent_distribution
        on distribution.parent_distribution_id = parent_distribution.distribution_id
        and distribution.source_relation = parent_distribution.source_relation
)