select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,

    p.payment_id,
    p.payment_method,
    p.amount

from {{ ref('stg_orders') }} o
left join {{ ref('stg_payments') }} p
    on o.order_id = p.order_id