{% snapshot orders_snapshot %}

{{
    config(
      target_database='dbt_analytics',
      target_schema='snapshots',
      unique_key='order_id',
      strategy='check',
      check_cols='all'
    )
}}

SELECT 
    order_id,
    customer_id,
    GETDATE() as snapshot_time
FROM {{ source('raw_data', 'orders') }}

{% endsnapshot %}
