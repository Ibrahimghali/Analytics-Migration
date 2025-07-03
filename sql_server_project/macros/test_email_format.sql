{% macro test_email_format(model, column_name) %}
  select {{ column_name }}
  from {{ model }}
  where {{ column_name }} is not null
    and not regexp_like({{ column_name }}, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
{% endmacro %}