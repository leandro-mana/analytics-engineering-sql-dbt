WITH order_payments AS (

    SELECT * FROM {{ ref('stg_stripe__payments') }}

)

SELECT
    order_id,
    SUM(
        CASE
            WHEN payment_type = 'cash' AND status = 'success'
                THEN amount
            ELSE 0
        END
    ) AS cash_amount,
    SUM(
        CASE
            WHEN payment_type = 'credit' AND status = 'success'
                THEN amount
            ELSE 0
        END
    ) AS credit_amount,
    SUM(
        CASE
            WHEN status = 'success'
                THEN amount
            ELSE 0
        END
    ) AS total_amount
FROM order_payments
GROUP BY order_id
