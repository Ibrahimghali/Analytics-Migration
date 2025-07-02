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
        stuff((
            select ', ' + concat(pr2.product_name, ' (', oi2.quantity, 'x)')
            from {{ ref('stg_order_items') }} oi2
            join {{ ref('stg_products') }} pr2 on oi2.product_id = pr2.product_id
            where oi2.order_id = o.order_id
            for xml path('')
        ), 1, 2, '') as products_ordered,
        sum(oi.quantity) as total_items,
        count(distinct oi.product_id) as unique_products,
        -- Category breakdown
        stuff((
            select distinct ', ' + pr3.category
            from {{ ref('stg_order_items') }} oi3
            join {{ ref('stg_products') }} pr3 on oi3.product_id = pr3.product_id
            where oi3.order_id = o.order_id
            for xml path('')
        ), 1, 2, '') as categories
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
