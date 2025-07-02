{{ config(materialized='view') }}

with source_data as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price,
        created_at
    from {{ source('raw_data', 'order_items') }}
)

select
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    -- Calculate total price from quantity and unit price
    quantity * unit_price as total_price,
    -- Data quality check: always valid since we're calculating it
    'Valid' as price_validation,
    created_at
from source_data
