WITH stg_customers AS (

    SELECT
        customer_id AS nk_customer_id,
        name AS dsc_name,
        date_birth AS dt_date_birth,
        email_address AS dsc_email_address,
        phone_number AS dsc_phone_number,
        country AS dsc_country
    FROM {{ ref('stg_omni__customers') }}

)

SELECT
    {{ dbt_utils.generate_surrogate_key(['nk_customer_id']) }} AS sk_customer,
    nk_customer_id,
    dsc_name,
    dt_date_birth,
    dsc_email_address,
    dsc_phone_number,
    dsc_country
FROM stg_customers
