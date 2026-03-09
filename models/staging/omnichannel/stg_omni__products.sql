SELECT
    product_sku,
    product_name,
    unit_price
FROM {{ source('omnichannel', 'raw_products') }}
