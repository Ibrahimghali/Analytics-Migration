{{ config(materialized='table') }}

with product_performance as (
    select
        p.product_id,
        p.product_name,
        p.category,
        p.price,
        p.cost,
        p.profit_margin,
        p.profit_margin_percent,
        p.stock_quantity,
        p.stock_status,
        coalesce(sum(oi.quantity), 0) as total_quantity_sold,
        coalesce(sum(oi.total_price), 0) as total_revenue,
        coalesce(sum(oi.quantity * p.cost), 0) as total_cost,
        coalesce(sum(oi.total_price) - sum(oi.quantity * p.cost), 0) as total_profit,
        count(distinct oi.order_id) as number_of_orders,
        case
            when coalesce(sum(oi.quantity), 0) = 0 then 'No Sales'
            when coalesce(sum(oi.quantity), 0) between 1 and 5 then 'Low Sales'
            when coalesce(sum(oi.quantity), 0) between 6 and 20 then 'Medium Sales'
            else 'High Sales'
        end as sales_performance,
        case
            when coalesce(sum(oi.total_price), 0) = 0 then 0
            else round(coalesce(sum(oi.total_price) - sum(oi.quantity * p.cost), 0) / sum(oi.total_price) * 100, 2)
        end as actual_profit_margin_percent
    from {{ ref('stg_products') }} p
    left join {{ ref('stg_order_items') }} oi on p.product_id = oi.product_id
    group by
        p.product_id,
        p.product_name,
        p.category,
        p.price,
        p.cost,
        p.profit_margin,
        p.profit_margin_percent,
        p.stock_quantity,
        p.stock_status
)

select * from product_performance
order by total_revenue desc
