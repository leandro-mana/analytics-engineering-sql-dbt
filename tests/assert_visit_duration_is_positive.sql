-- Singular test: ensure no visit has a negative duration.
SELECT
    sk_customer,
    sk_channel,
    SUM(mtr_length_of_stay_minutes) AS mtr_length_of_stay_minutes
FROM {{ ref('fct_visit_history') }}
GROUP BY sk_customer, sk_channel
HAVING SUM(mtr_length_of_stay_minutes) < 0
