-- with customers as (

--     select
--         customer_id,
--         first_name,
--         last_name,
--         email,
--         city,
--         country
--     from {{ ref('raw_customer') }}

-- ),

-- orders as (

--     select
--         customer_id,
--         count(order_id) as total_orders,
--         min(order_date) as first_order_date,
--         max(order_date) as latest_order_date
--     from {{ ref('raw_orders') }}
--     group by customer_id

-- ),

-- payments as (

--     select
--         o.customer_id,
--         sum(p.amount) as total_payment_amount,
--         avg(p.amount) as avg_payment_amount
--     from {{ ref('raw_payments') }} p
--     join {{ ref('raw_orders') }} o
--         on p.order_id = o.order_id
--     group by o.customer_id

-- )

-- select

--     c.customer_id,
--     c.first_name,
--     c.last_name,
--     c.email,
--     c.city,
--     c.country,

--     o.total_orders,
--     o.first_order_date,
--     o.latest_order_date,

--     p.total_payment_amount,
--     p.avg_payment_amount

-- from customers c
-- left join orders o
--     on c.customer_id = o.customer_id

-- left join payments p
--     on c.customer_id = p.customer_id

with customers as (

    select
        id as customer_id,

        upper(trim(first_name)) as first_name,
        upper(trim(last_name)) as last_name,

        concat(
            upper(trim(first_name)),
            ' ',
            upper(trim(last_name))
        ) as full_name,

        -- lower(email) as email,

        -- initcap(city) as city,
        -- upper(country) as country,

        -- signup_date,

        -- case
        --     when country = 'india' then 'APAC'
        --     when country = 'usa' then 'NORTH_AMERICA'
        --     else 'OTHER'
        -- end as region

    from {{ ref('raw_customer') }}

),

orders as (

    select
        user_id as customer_id,

        count(id) as total_orders,

        -- sum(order_amount) as lifetime_order_value,

        -- avg(order_amount) as avg_order_value,

        min(order_date) as first_order_date,

        max(order_date) as latest_order_date,

       datediff(
                'month',
    max(order_date),
    current_date
) as months_since_last_order,

        case
            when count(id) >= 10 then 'VIP'
            when count(id) >= 5 then 'LOYAL'
            else 'REGULAR'
        end as customer_segment

    from {{ ref('raw_orders') }}

    group by customer_id

),

payments as (

    select
        o.user_id as customer_id,

        sum(p.amount) as total_payment_amount,

        avg(p.amount) as avg_payment_amount,

        max(p.amount) as highest_payment,

        min(p.amount) as lowest_payment,

        count(distinct payment_method) as unique_payment_methods,

        sum(
            case
                when payment_method = 'credit_card'
                then amount
                else 0
            end
        ) as credit_card_amount,

        sum(
            case
                when payment_method = 'coupon'
                then amount
                else 0
            end
        ) as coupon_amount

        -- sum(
        --     case
        --         when o.status = 'failed'
        --         then 1
        --         else 0
        --     end
        -- ) as failed_payment_count

    from {{ ref('raw_payments') }} p

    join {{ ref('raw_orders') }} o
        on p.order_id = o.id

    group by o.user_id

)

select

    c.customer_id,

    c.first_name,
    c.last_name,
    c.full_name,

    -- c.email,

    -- c.city,
    -- c.country,
    -- c.region,

    -- c.signup_date,

    o.total_orders,
    -- o.lifetime_order_value,
    -- round(o.avg_order_value, 2) as avg_order_value,

    o.first_order_date,
    o.latest_order_date,

    -- o.days_since_last_order,

    o.customer_segment,

    p.total_payment_amount,
    round(p.avg_payment_amount, 2) as avg_payment_amount,

    p.highest_payment,
    p.lowest_payment,

    p.unique_payment_methods,

    p.credit_card_amount,
    p.coupon_amount

    -- p.failed_payment_count,

    -- case
    --     when p.failed_payment_count > 3
    --     then 'HIGH_RISK'

    --     when o.lifetime_order_value > 5000
    --     then 'HIGH_VALUE'

    --     else 'NORMAL'
    -- end as customer_risk_category

from customers c

left join orders o
    on c.customer_id = o.customer_id

left join payments p
    on c.customer_id = p.customer_id