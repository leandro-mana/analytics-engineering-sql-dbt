SELECT
    customer_id,
    name,
    date_birth,
    email_address,
    phone_number,
    country
FROM {{ source('omnichannel', 'raw_omni_customers') }}
