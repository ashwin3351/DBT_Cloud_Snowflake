-- select
--     payment_id,
--     order_id,
--     payment_method,
--     amount_usd
-- from {{ ref('stg_payments') }}

{% set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

select
    payment_id,
    order_id,

    {% for method in payment_methods %}
    sum(
        case
            when payment_method = '{{ method }}'
            then amount_usd
            else 0
        end
    ) as {{ method }}_amount,

    {% endfor %}

    sum(amount_usd) as total_amount

from {{ ref('stg_payments') }}

group by 1,2