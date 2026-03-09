WITH orders AS (

    SELECT * FROM {{ ref('stg_jaffle_shop__orders') }}

),

payment_type_orders AS (

    SELECT * FROM {{ ref('int_payment_type_amount_per_order') }}

)

SELECT
    ord.order_id,
    ord.customer_id,
    ord.order_date,
    ord.status,
    pto.cash_amount,
    pto.credit_amount,
    pto.total_amount,
    CASE
        WHEN ord.status = 'completed'
            THEN 1
        ELSE 0
    END AS is_order_completed
FROM orders AS ord
LEFT JOIN payment_type_orders AS pto ON ord.order_id = pto.order_id
