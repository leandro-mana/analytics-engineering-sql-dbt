{# Macro that limits data in non-production environments.
   Useful for faster development iteration with large datasets. #}
{% macro limit_data_in_dev(column_name, days=90) %}
    {% if target.name != 'prod' %}
        WHERE {{ column_name }} >= CURRENT_DATE - INTERVAL '{{ days }} days'
    {% endif %}
{% endmacro %}
