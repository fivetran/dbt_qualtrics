{% macro qualtrics_percentile(percentile_field, partition_field, percent) -%}
{{ adapter.dispatch('qualtrics_percentile', 'qualtrics') (percentile_field, partition_field, percent) }}
{%- endmacro %}

-- Redshift requires the percentile_field to be cast as a float for percentile_cont to work correctly
{% macro redshift__qualtrics_percentile(percentile_field, partition_field, percent) %}

    percentile_cont(
        {{ percent }} )
        within group ( order by cast({{ percentile_field }} as {{ dbt.type_float() }}) )
        over ( partition by {{ partition_field }} )

{% endmacro %}

{% macro default__qualtrics_percentile(percentile_field, partition_field, percent) %}

    {{ fivetran_utils.percentile(percentile_field, partition_field, percent) }}

{% endmacro %}
