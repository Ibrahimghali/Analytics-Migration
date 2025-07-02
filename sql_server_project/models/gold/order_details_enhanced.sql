{{ config(materialized='table') }}

with order_details as (
    select
        o.order_id,
        o.customer_id,
        c.full_name as customer_name,
        c.city,
        c.state,
        o.order_date,
        o.status,
        o.status_friendly,
        o.total_amount,
        -- Product details
        string_agg(
            concat(pr.product_name, ' (', oi.quantity, 'x)'), 
            ', '
        ) as products_ordered,
        sum(oi.quantity) as total_items,
        count(distinct oi.product_id) as unique_products,
        -- Category breakdown
        string_agg(distinct pr.category, ', ') as categories
    from {{ ref('stg_orders') }} o
    join {{ ref('stg_customers') }} c on o.customer_id = c.customer_id
    join {{ ref('stg_order_items') }} oi on o.order_id = oi.order_id
    join {{ ref('stg_products') }} pr on oi.product_id = pr.product_id
    group by
        o.order_id,
        o.customer_id,
        c.full_name,
        c.city,
        c.state,
        o.order_date,
        o.status,
        o.status_friendly,
        o.total_amount
)

select 
    order_id,
    customer_id,
    customer_name,
    city,
    state,
    order_date,
    status,
    status_friendly,
    total_amount,
    products_ordered,
    total_items,
    unique_products,
    categories,
    case
        when total_amount < 100 then 'Small Order'
        when total_amount between 100 and 500 then 'Medium Order'
        when total_amount between 500 and 1000 then 'Large Order'
        else 'Very Large Order'
    end as order_size_category
from order_details
order by order_date desc
