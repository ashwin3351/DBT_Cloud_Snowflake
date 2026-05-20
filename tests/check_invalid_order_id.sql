select *
from {{ ref('stg_orders') }}
where order_id <= 0
   or order_id is null