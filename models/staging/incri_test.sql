{{
    config(
        materialized='incremental',
        unique_key  = 'user_id',
        merge_update_columns = ['order_id', 'order_date'],
    )
}}

select
 id as order_id, 
 order_date,
 user_id,
 _etl_loaded_at from {{ ref('raw_orders') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses > to include records whose timestamp occurred since the last run of this model)
  where _etl_loaded_at >= (select max(_etl_loaded_at) from {{ this }})
{% endif %}