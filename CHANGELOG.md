# dbt_qualtrics v1.0.1

## Under the Hood
- Fixed integration test configuration by adding missing identifier variables to properly scope qualtrics source table references in the integration tests `dbt_project.yml`.

# dbt_qualtrics v1.0.0

[PR #18](https://github.com/fivetran/dbt_qualtrics/pull/18) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/qualtrics_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/qualtrics_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/qualtrics_source` package will also need to be removed or updated to reference this package.
  - Update any qualtrics_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_qualtrics/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Removed all `accepted_values` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_qualtrics.yml`.

# dbt_qualtrics v0.4.0

[PR #14](https://github.com/fivetran/dbt_qualtrics/pull/14) and [PR #15](https://github.com/fivetran/dbt_qualtrics/pull/15) includes the following updates:

## Schema & Data Updates
**2 total changes • 0 possible breaking changes. See [v0.4.0 dbt_qualtrics_source release](https://github.com/fivetran/dbt_qualtrics_source/releases/tag/v0.4.0) release for upstream column addition**

| Data Model | Change Type | Old Name | New Name | Notes |
| --- | --- | --- | --- | --- |
| `qualtrics__response` | New column |  | `response_text` | Captures the free text response associated with the question. |
| `stg_qualtrics__question_response` | New column |  | `response_text` | Captures the free text response associated with the question. |

## Documentation
- Added Quickstart model counts to README. ([#13](https://github.com/fivetran/dbt_qualtrics/pull/13))
- Corrected references to connectors and connections in the README. ([#13](https://github.com/fivetran/dbt_qualtrics/pull/13))

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.
- Added `+docs: show: False` to `integration_tests/dbt_project.yml`.
- Migrated `flags` (e.g., `send_anonymous_usage_stats`, `use_colors`) from `sample.profiles.yml` to `integration_tests/dbt_project.yml`.
- Updated `maintainer_pull_request_template.md` with improved checklist.
- Refreshed README tag block:
  - Standardized Quickstart-compatible badge set
  - Left-aligned and positioned below the H1 title.
- Updated `.gitignore` to exclude additional DBT, Python, and system artifacts.

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
