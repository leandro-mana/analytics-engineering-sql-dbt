{% snapshot snap_orders %}

{{
    config(
        target_schema='snapshots',
        unique_key='id',
        strategy='check',
        check_cols=['status']
    )
}}

SELECT * FROM {{ source('jaffle_shop', 'raw_orders') }}

{% endsnapshot %}
