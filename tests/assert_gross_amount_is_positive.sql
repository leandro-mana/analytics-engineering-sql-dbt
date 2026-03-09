-- Singular test: ensure no purchase has a negative gross amount.
SELECT
    sk_customer,
    sk_channel,
    sk_product,
    SUM(mtr_total_amount_gross) AS mtr_total_amount_gross
FROM {{ ref('fct_purchase_history') }}
GROUP BY sk_customer, sk_channel, sk_product
HAVING SUM(mtr_total_amount_gross) < 0
