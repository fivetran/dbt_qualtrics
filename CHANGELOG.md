# dbt_qualtrics v0.3.0

[PR #12](https://github.com/fivetran/dbt_qualtrics/pull/12) includes the following updates:

## Under the Hood
- Switched from using `dbt.current_timestamp_backcompat()` to the more up-to-date `dbt.current_timestamp_backcompat()` [macro](https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros#current_timestamp) in the `qualtrics__daily_breakdown` model.
- (Maintainers only) Adds consistency and integrity (row count) tests for each end model.

### [Upstream Under-the-Hood Updates](https://github.com/fivetran/dbt_qualtrics_source/blob/main/CHANGELOG.md) from `qualtrics_source` Package
- Explicitly casts all boolean fields as `{{ dbt.type_boolean() }}`.
- (Affects Redshift only) Creates new `qualtrics_union_data` macro to accommdate Redshift's treatment of empty tables.
  - For each staging model, if the source table is not found in any of your schemas, the package will create a empty table with 0 rows for non-Redshift warehouses and a table with 1 all-`null` row for Redshift destinations.
  - This is necessary as Redshift will ignore explicit data casts when a table is completely empty and materialize every column as a `varchar`. This throws errors in dowstream transformations in the `zendesk` package. The 1 row will ensure that Redshift will respect the package's datatype casts.

# dbt_qualtrics v0.2.0

[PR #8](https://github.com/fivetran/dbt_qualtrics/pull/8) includes the following updates: 

## 🚨 Breaking Changes: Upstream Changes 🚨
- This release includes an update to the upstream dbt_qualtrics_source dependency which includes breaking changes. These breaking changes included **all** staging model timestamps to be cast using the `dbt.type_timestamp()` macro in order to ensure datatype consistency with timestamp fields.
  - For an overview of all breaking changes in the dbt_qualtrics_source data model, please refer to the [respective release notes](https://github.com/fivetran/dbt_qualtrics_source/releases/tag/v0.2.0).

# dbt_qualtrics v0.1.1

[PR #6](https://github.com/fivetran/dbt_qualtrics/pull/6) applies the following changes:

## Bug Fix
- Ensures the date spine in the `qualtrics__daily_breakdown` model always has a non-null start date, especially if you do not have the `distribution_contact` source table whose `min(created_at)` is used to generate the date spine. 
  - If no `distribution_contact` table is present in your Qualtrics connector(s), the minimum date will be set to `2016-01-01`.

## Under the Hood
- Updated the pull request [templates](/.github).
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_qualtrics v0.1.0
This is the initial release of the Qualtrics dbt package!

# 📣 What does this dbt package do?

This package models Qualtrics data from [Fivetran's connector](https://fivetran.com/docs/applications/qualtrics). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/qualtrics#schemainformation) and builds off the output of our [Qualtrics source package](https://github.com/fivetran/dbt_qualtrics_source).

The main focus of the package is to transform the core object tables into analytics-ready models, including:
- A Response breakdown model which consolidates all survey responses joined with users, questions, and survey details.
- Overview models for Surveys, Contacts, Directories, and Distributions which help to understand the nuances of each and how they affect key survey aggregations.
- A daily breakdown model which provides a high level view of a variety of Qualtrics account metrics at a daily level.
