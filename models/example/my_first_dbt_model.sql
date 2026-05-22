
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

-- {{ config(materialized='table') }}

{{
    config(
        materialized='table',
        pre_hook="create table if not exists test_log (id int)",
        post_hook="insert into test_log values (1)"
    )
}}

with source_data as (

    select 1 as id
    union all
    select 2 as id

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
