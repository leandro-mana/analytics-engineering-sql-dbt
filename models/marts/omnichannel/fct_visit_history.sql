WITH stg_visits AS (

    SELECT
        customer_id AS nk_customer_id,
        channel_id AS nk_channel_id,
        CAST(visit_timestamp AS DATE) AS sk_date_visit,
        CAST(bounce_timestamp AS DATE) AS sk_date_bounce,
        visit_timestamp AS dt_visit_timestamp,
        bounce_timestamp AS dt_bounce_timestamp
    FROM {{ ref('stg_omni__visit_history') }}

)

SELECT
    COALESCE(dcust.sk_customer, '-1') AS sk_customer,
    COALESCE(dchan.sk_channel, '-1') AS sk_channel,
    fct.sk_date_visit,
    fct.sk_date_bounce,
    fct.dt_visit_timestamp,
    fct.dt_bounce_timestamp,
    EXTRACT(EPOCH FROM (fct.dt_bounce_timestamp - fct.dt_visit_timestamp)) / 60.0
        AS mtr_length_of_stay_minutes
FROM stg_visits AS fct
LEFT JOIN {{ ref('dim_omni_customers') }} AS dcust
    ON fct.nk_customer_id = dcust.nk_customer_id
LEFT JOIN {{ ref('dim_omni_channels') }} AS dchan
    ON fct.nk_channel_id = dchan.nk_channel_id
