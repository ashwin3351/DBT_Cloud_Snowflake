select *
from {{ source('jaffle_shop', 'raw_orders') }}
where order_date >= '{{ var("start_date") }}'