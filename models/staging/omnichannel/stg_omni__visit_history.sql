SELECT
    customer_id,
    channel_id,
    CAST(visit_timestamp AS TIMESTAMP) AS visit_timestamp,
    CAST(bounce_timestamp AS TIMESTAMP) AS bounce_timestamp
FROM {{ source('omnichannel', 'raw_visit_history') }}
