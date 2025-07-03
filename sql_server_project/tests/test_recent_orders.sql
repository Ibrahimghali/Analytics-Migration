-- Test that we have orders from the last 30 days (more realistic for historical data)
select count(*) as recent_orders
from {{ source('raw_data', 'orders') }}
where order_date >= DATEADD(day, -30, GETDATE())
having count(*) = 0  -- Fail if no recent orders