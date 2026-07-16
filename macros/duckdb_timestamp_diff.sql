-- DuckDB requires the datepart to be a quoted string literal in datediff();
-- without quotes, DuckDB treats the identifier as a column reference and fails
-- with "Binder Error: Referenced column not found in FROM clause".
{% macro duckdb__timestamp_diff(first_date, second_date, datepart) %}

    datediff('{{ datepart }}', {{ first_date }}, {{ second_date }})

{% endmacro %}
