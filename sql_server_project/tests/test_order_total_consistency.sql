-- Test that order totals match the sum of order items
select 
    o.order_id,
    o.total_amount as order_total,
    sum(oi.quantity * oi.unit_price) as calculated_total
from {{ source('raw_data', 'orders') }} o
join {{ source('raw_data', 'order_items') }} oi
    on o.order_id = oi.order_id
group by o.order_id, o.total_amount
having abs(o.total_amount - sum(oi.quantity * oi.unit_price)) > 0.01