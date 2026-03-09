SELECT
    id AS payment_id,
    order_id,
    payment_method,
    CASE
        WHEN payment_method IN ('credit_card', 'paypal', 'gift_card')
            THEN 'credit'
        ELSE 'cash'
    END AS payment_type,
    status,
    -- Amount is stored in cents, convert to dollars
    ROUND(amount / 100.0, 2) AS amount,
    CASE
        WHEN status = 'success'
            THEN TRUE
        ELSE FALSE
    END AS is_completed_payment,
    created AS created_date
FROM {{ source('stripe', 'raw_payments') }}
