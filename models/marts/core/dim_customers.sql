WITH customers AS (

    SELECT * FROM {{ ref('stg_jaffle_shop__customers') }}

),

orders AS (

    SELECT * FROM {{ ref('fct_orders') }}

),

customer_orders AS (

    SELECT
        customer_id,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        COUNT(*) AS number_of_orders,
        SUM(total_amount) AS lifetime_value
    FROM orders
    GROUP BY customer_id

)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    co.first_order_date,
    co.last_order_date,
    COALESCE(co.number_of_orders, 0) AS number_of_orders,
    COALESCE(co.lifetime_value, 0) AS lifetime_value
FROM customers AS c
LEFT JOIN customer_orders AS co ON c.customer_id = co.customer_id
