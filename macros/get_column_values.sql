{# Generic macro: given a column name and table ref, return distinct values #}
{% macro get_column_values(column_name, table_name) %}

    {% set relation_query %}
        SELECT DISTINCT {{ column_name }}
        FROM {{ table_name }}
        ORDER BY 1
    {% endset %}

    {% set results = run_query(relation_query) %}

    {% if execute %}
        {% set results_list = results.columns[0].values() %}
    {% else %}
        {% set results_list = [] %}
    {% endif %}

    {{ return(results_list) }}

{% endmacro %}


{# Macro to get distinct payment types #}
{% macro get_payment_types() %}
    {{ return(get_column_values('payment_type', ref('stg_stripe__payments'))) }}
{% endmacro %}


{# Macro to get distinct payment methods #}
{% macro get_payment_methods() %}
    {{ return(get_column_values('payment_method', ref('stg_stripe__payments'))) }}
{% endmacro %}
