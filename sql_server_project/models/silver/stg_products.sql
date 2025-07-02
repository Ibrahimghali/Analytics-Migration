{{ config(materialized='view') }}

with source_data as (
    select
        product_id,
        trim(product_name) as product_name,
        trim(category) as category,
        price,
        cost,
        created_at
    from {{ source('raw_data', 'products') }}
)

select
    product_id,
    product_name,
    category,
    price,
    cost,
    price - cost as profit_margin,
    case 
        when price > 0 then round(((price - cost) / price) * 100, 2)
        else 0
    end as profit_margin_percent,
    case
        when category = 'Electronics' then 'Tech'
        when category = 'Furniture' then 'Home'
        else 'Other'
    end as category_group,
    created_at
from source_data
