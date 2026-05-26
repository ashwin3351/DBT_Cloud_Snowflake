select
    payment_id,
    order_id,
    payment_method,
    amount_usd
from {{ ref('stg_payments') }}