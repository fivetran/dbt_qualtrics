with user as (

    select *
    from {{ var('user') }}
),

survey_version as (

    select *
    from {{ var('survey_version') }}
),

latest_version as (

    select *
    from survey_version 
    where is_published
),

agg_versions as (

    select 
        survey_id,
        source_relation,
        count(distinct version_number) as count_published_versions,
    from survey_version
    where was_published and not is_deleted
    group by 1,2
),

survey_publisher_join as (

    select
        latest_version.survey_id,
        latest_version.source_relation,
        latest_version.version_id,
        latest_version.version_number,
        latest_version.version_description,
        latest_version.created_at as survey_version_created_at,
        agg_versions.count_published_versions,
        latest_version.publisher_user_id,
        user.email as publisher_user_email, 
        user.first_name as publisher_user_first_name,
        user.last_name as publisher_user_last_name,
        user.account_status as publisher_user_status
        
    from latest_version
    left join user 
        on latest_version.publisher_user_id = user.user_id
        and latest_version.source_relation = user.source_relation
    join agg_versions 
        on latest_version.survey_id = agg_versions.survey_id
        and latest_version.source_relation = agg_versions.source_relation
)

select *
from survey_publisher_join