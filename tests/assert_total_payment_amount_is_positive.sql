-- Singular test: ensure no order has a negative total payment amount.
-- Returns failing rows (rows with total_amount < 0).
SELECT
    order_id,
    SUM(total_amount) AS total_amount
FROM {{ ref('int_payment_type_amount_per_order') }}
GROUP BY order_id
HAVING SUM(total_amount) < 0
