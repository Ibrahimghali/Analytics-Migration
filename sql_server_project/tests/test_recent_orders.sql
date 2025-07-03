-- Test that we have orders from the last 7 days
select count(*) as recent_orders
from {{ source('raw_data', 'orders') }}
where order_date >= DATEADD(day, -7, GETDATE())
having count(*) = 0  -- Fail if no recent orders