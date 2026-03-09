SELECT
    channel_id,
    channel_name
FROM {{ source('omnichannel', 'raw_channels') }}
