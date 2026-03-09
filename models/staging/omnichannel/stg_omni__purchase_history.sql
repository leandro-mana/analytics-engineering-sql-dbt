SELECT
    customer_id,
    product_sku,
    channel_id,
    quantity,
    discount,
    CAST(order_date AS DATE) AS order_date
FROM {{ source('omnichannel', 'raw_purchase_history') }}
