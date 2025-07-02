{{ config(materialized='view') }}

with source_data as (
    select
        customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        lower(trim(email)) as email,
        phone,
        trim(address) as address,
        trim(city) as city,
        upper(trim(state)) as state,
        zip_code,
        created_at
    from {{ source('raw_data', 'customers') }}
)

select
    customer_id,
    first_name,
    last_name,
    first_name + ' ' + last_name as full_name,
    email,
    phone,
    address,
    city,
    state,
    zip_code,
    created_at
from source_data
