{{ config(materialized='table') }}

with customer_metrics as (
    select
        c.customer_id,
        c.full_name,
        c.email,
        c.city,
        c.state,
        count(o.order_id) as total_orders,
        coalesce(sum(o.total_amount), 0) as total_spent,
        coalesce(avg(o.total_amount), 0) as avg_order_value,
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date,
        case
            when count(o.order_id) = 0 then 'No Orders'
            when count(o.order_id) = 1 then 'One-Time'
            when count(o.order_id) between 2 and 5 then 'Regular'
            else 'High Value'
        end as customer_segment,
        case
            when max(o.order_date) >= dateadd(day, -30, getdate()) then 'Active'
            when max(o.order_date) >= dateadd(day, -90, getdate()) then 'At Risk'
            else 'Churned'
        end as customer_status
    from {{ ref('stg_customers') }} c
    left join {{ ref('stg_orders') }} o on c.customer_id = o.customer_id
    group by 
        c.customer_id, 
        c.full_name, 
        c.email, 
        c.city, 
        c.state
)

select * from customer_metrics
