{% snapshot products_snapshot %}

{{
    config(
      target_database='dbt_analytics',
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['product_name']
    )
}}

SELECT 
    product_id,
    product_name,
    GETDATE() as snapshot_time
FROM {{ source('raw_data', 'products') }}

{% endsnapshot %}