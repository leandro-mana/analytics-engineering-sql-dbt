WITH stg_channels AS (

    SELECT
        channel_id AS nk_channel_id,
        channel_name AS dsc_channel_name
    FROM {{ ref('stg_omni__channels') }}

)

SELECT
    {{ dbt_utils.generate_surrogate_key(['nk_channel_id']) }} AS sk_channel,
    nk_channel_id,
    dsc_channel_name
FROM stg_channels
