-- Analysis: Top 10 most valuable customers by total paid amount (completed orders only).
-- Run with: dbt compile, then execute the compiled SQL.
WITH fct_orders AS (

    SELECT * FROM {{ ref('fct_orders') }}

),

dim_customers AS (

    SELECT * FROM {{ ref('dim_customers') }}

)

SELECT
    cust.customer_id,
    cust.first_name,
    cust.last_name,
    SUM(ord.total_amount) AS global_paid_amount
FROM fct_orders AS ord
LEFT JOIN dim_customers AS cust ON ord.customer_id = cust.customer_id
WHERE ord.is_order_completed = 1
GROUP BY cust.customer_id, cust.first_name, cust.last_name
ORDER BY global_paid_amount DESC
LIMIT 10
