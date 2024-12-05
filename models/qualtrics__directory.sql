with directory as (

    select *
    from {{ var('directory') }}
),

directory_contact as (
    
    select *
    from {{ var('directory_contact') }}
),

directory_mailing_list as (

    select *
    from {{ var('directory_mailing_list') }}
),

distribution_contact as (

    select *
    from {{ var('distribution_contact') }}
),

distribution as (

    select *
    from {{ var('distribution') }}
),

agg_mailing_lists as (
    
    select 
        directory_id,
        source_relation,
        count(distinct mailing_list_id) as count_mailing_lists
    
    from directory_mailing_list
    where not coalesce(is_deleted, false)
    group by 1,2
),

agg_contacts as (

    select 
        directory_id,
        source_relation,
        count(distinct email) as count_distinct_emails,
        count(distinct phone) as count_distinct_phones,
        count(distinct contact_id) as total_count_contacts,
        count(distinct case when lower(cast(is_unsubscribed_from_directory as {{ dbt.type_string() }})) = 'true' then contact_id else null end) as total_count_unsubscribed_contacts,
        count(distinct case when {{ fivetran_utils.timestamp_diff(first_date="cast(created_at as " ~ dbt.type_timestamp() ~ ')', second_date=dbt.current_timestamp(), datepart="day") }} <= 30 then contact_id else null end) as count_contacts_created_30d,
        count(distinct case when lower(cast(is_unsubscribed_from_directory as {{ dbt.type_string() }})) = 'true' and {{ fivetran_utils.timestamp_diff(first_date="cast(unsubscribed_from_directory_at as " ~ dbt.type_timestamp() ~ ')', second_date=dbt.current_timestamp(), datepart="day") }} <= 30 then contact_id else null end) as count_contacts_unsubscribed_30d

    from directory_contact
    group by 1,2
),

agg_distributions as (
-- of contacts sent surveys in the past 30 days, did they open or respond to the surveys?
    select 
        directory_contact.directory_id,
        directory_contact.source_relation, 
        count(distinct distribution_contact.contact_id) as count_contacts_sent_survey_30d, 
        count(distinct case when distribution_contact.opened_at is not null then distribution_contact.contact_id end) as count_contacts_opened_survey_30d,
        count(distinct case when distribution_contact.response_started_at is not null then distribution_contact.contact_id end) as count_contacts_started_survey_30d,
        count(distinct case when distribution_contact.response_completed_at is not null then distribution_contact.contact_id end) as count_contacts_completed_survey_30d,
        count(distinct distribution.survey_id) as count_surveys_sent_30d
        
    from distribution_contact
    inner join directory_contact 
        on distribution_contact.contact_id = directory_contact.contact_id
        and distribution_contact.source_relation = directory_contact.source_relation
    left join distribution 
        on distribution_contact.distribution_id = distribution.distribution_id 
        and distribution_contact.source_relation = distribution.source_relation
    where sent_at is not null 
        and {{ fivetran_utils.timestamp_diff(first_date="cast(distribution_contact.sent_at as " ~ dbt.type_timestamp() ~ ')', second_date=dbt.current_timestamp(), datepart="day") }} <= 30
    
    group by 1,2
),

final as (

    select 
        directory.*,
        coalesce(agg_contacts.count_distinct_emails, 0) as count_distinct_emails,
        coalesce(agg_contacts.count_distinct_phones, 0) as count_distinct_phones,
        coalesce(agg_contacts.total_count_contacts, 0) as total_count_contacts,
        coalesce(agg_contacts.total_count_unsubscribed_contacts, 0) as total_count_unsubscribed_contacts,
        coalesce(agg_contacts.count_contacts_created_30d, 0) as count_contacts_created_30d,
        coalesce(agg_contacts.count_contacts_unsubscribed_30d, 0) as count_contacts_unsubscribed_30d,
        coalesce(agg_distributions.count_contacts_sent_survey_30d, 0) as count_contacts_sent_survey_30d,
        coalesce(agg_distributions.count_contacts_opened_survey_30d, 0) as count_contacts_opened_survey_30d,
        coalesce(agg_distributions.count_contacts_started_survey_30d, 0) as count_contacts_started_survey_30d,
        coalesce(agg_distributions.count_contacts_completed_survey_30d, 0) as count_contacts_completed_survey_30d,
        coalesce(agg_distributions.count_surveys_sent_30d, 0) as count_surveys_sent_30d,
        coalesce(agg_mailing_lists.count_mailing_lists, 0) as count_mailing_lists

    from directory 
    left join agg_contacts
        on directory.directory_id = agg_contacts.directory_id
        and directory.source_relation = agg_contacts.source_relation
    left join agg_distributions
        on directory.directory_id = agg_distributions.directory_id
        and directory.source_relation = agg_distributions.source_relation
    left join agg_mailing_lists
        on directory.directory_id = agg_mailing_lists.directory_id
        and directory.source_relation = agg_mailing_lists.source_relation
)

select *
from final