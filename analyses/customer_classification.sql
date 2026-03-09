-- Analysis: Classify customers by total paid amount using seed ranges.
-- Categories: Regular, Bronze, Silver, Gold.
WITH fct_orders AS (

    SELECT * FROM {{ ref('fct_orders') }}

),

dim_customers AS (

    SELECT * FROM {{ ref('dim_customers') }}

),

total_per_customer AS (

    SELECT
        cust.customer_id,
        cust.first_name,
        cust.last_name,
        SUM(ord.total_amount) AS global_paid_amount
    FROM fct_orders AS ord
    LEFT JOIN dim_customers AS cust ON ord.customer_id = cust.customer_id
    WHERE ord.is_order_completed = 1
    GROUP BY cust.customer_id, cust.first_name, cust.last_name

),

ranges AS (

    SELECT * FROM {{ ref('customer_range_per_paid_amount') }}

)

SELECT
    tpc.customer_id,
    tpc.first_name,
    tpc.last_name,
    tpc.global_paid_amount,
    r.classification
FROM total_per_customer AS tpc
LEFT JOIN ranges AS r
    ON tpc.global_paid_amount >= r.min_range
    AND tpc.global_paid_amount <= r.max_range
ORDER BY tpc.global_paid_amount DESC
