{% snapshot snap_raw_orders %}

{{
    config(
        target_schema='snapshots',
        unique_key='id',
        strategy='timestamp',
        updated_at='_etl_loaded_at',
    )
}}

select *
from {{ source('jaffle_shop', 'raw_orders') }}

{% endsnapshot %}