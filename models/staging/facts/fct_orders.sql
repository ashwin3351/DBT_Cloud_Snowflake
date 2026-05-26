select
    order_id,
    customer_id,
    order_date,
    status
from {{ ref('stg_orders') }}