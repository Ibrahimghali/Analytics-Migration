{{ config(materialized='view') }}

with source_data as (
    select
        order_id,
        customer_id,
        order_date,
        upper(trim(status)) as status,
        total_amount,
        trim(shipping_address) as shipping_address,
        created_at
    from {{ source('raw_data', 'orders') }}
)

select
    order_id,
    customer_id,
    order_date,
    cast(order_date as date) as order_date_only,
    datepart(year, order_date) as order_year,
    datepart(month, order_date) as order_month,
    datepart(day, order_date) as order_day,
    datename(weekday, order_date) as order_day_of_week,
    status,
    case
        when status = 'COMPLETED' then 'Fulfilled'
        when status = 'SHIPPED' then 'In Transit'
        when status = 'PROCESSING' then 'Being Prepared'
        when status = 'PENDING' then 'Awaiting Processing'
        else 'Other'
    end as status_friendly,
    total_amount,
    shipping_address,
    created_at
from source_data
