{{ config(materialized='table') }}

with daily_sales as (
    select
        o.order_date_only,
        o.order_year,
        o.order_month,
        o.order_day_of_week,
        count(distinct o.order_id) as number_of_orders,
        count(distinct o.customer_id) as unique_customers,
        sum(o.total_amount) as total_revenue,
        avg(o.total_amount) as avg_order_value,
        sum(case when o.status = 'COMPLETED' then o.total_amount else 0 end) as completed_revenue,
        count(case when o.status = 'COMPLETED' then 1 end) as completed_orders,
        round(
            cast(count(case when o.status = 'COMPLETED' then 1 end) as float) / 
            cast(count(o.order_id) as float) * 100, 2
        ) as completion_rate_percent
    from {{ ref('stg_orders') }} o
    group by 
        o.order_date_only,
        o.order_year,
        o.order_month,
        o.order_day_of_week
),

sales_with_trends as (
    select
        *,
        lag(total_revenue, 1) over (order by order_date_only) as previous_day_revenue,
        case
            when lag(total_revenue, 1) over (order by order_date_only) is null then 0
            when lag(total_revenue, 1) over (order by order_date_only) = 0 then 0
            else round(
                (total_revenue - lag(total_revenue, 1) over (order by order_date_only)) /
                lag(total_revenue, 1) over (order by order_date_only) * 100, 2
            )
        end as revenue_growth_percent
    from daily_sales
)

select * from sales_with_trends
order by order_date_only desc
