WITH stg_products AS (

    SELECT
        product_sku AS nk_product_sku,
        product_name AS dsc_product_name,
        unit_price AS mtr_unit_price
    FROM {{ ref('stg_omni__products') }}

)

SELECT
    {{ dbt_utils.generate_surrogate_key(['nk_product_sku']) }} AS sk_product,
    nk_product_sku,
    dsc_product_name,
    mtr_unit_price
FROM stg_products
