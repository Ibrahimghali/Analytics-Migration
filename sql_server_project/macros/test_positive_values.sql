{% macro test_positive_values(model, column_name) %}
  select {{ column_name }}
  from {{ model }}
  where {{ column_name }} is not null
    and {{ column_name }} <= 0
{% endmacro %}