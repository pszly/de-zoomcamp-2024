{{ config(materialized="view") }}

select
    {{ dbt_utils.generate_surrogate_key(['vendor_id', 'tpep_pickup_datetime']) }} as trip_id
    -- 1dentifiers
    ,cast(vendor_id              as integer) as vendor_id
    ,cast(ratecode_id            as integer) as ratecode_id
    ,cast(pulocation_id          as integer) as pu_loc_id
    ,cast(dolocation_id          as integer) as do_loc_id
    -- timestamps
    ,cast(tpep_pickup_datetime  as timestamp) as pu_datetime
    ,cast(tpep_dropoff_datetime as timestamp) as do_datetime
    -- trip info
    ,store_and_fwd_flag
    ,cast(passenger_count       as integer) as passenger_count
    ,cast(trip_distance         as numeric) as trip_distance
    ,1                                      as trip_type
    -- payment info
    ,cast(fare_amount           as numeric) as fare_amount
    ,cast(extra                 as numeric) as extra
    ,cast(mta_tax               as numeric) as mta_tax
    ,cast(tip_amount            as numeric) as tip_amount
    ,cast(tolls_amount          as numeric) as tolls_amount
    ,0                                      as ehail_fee
    ,cast(improvement_surcharge as numeric) as improvement_surcharge
    ,cast(total_amount          as numeric) as total_amount
    ,cast(payment_type          as integer) as payment_type
    ,{{ get_payment_type_description('payment_type')}} as payment_type_desc
    ,cast(congestion_surcharge  as numeric) as congestion_surcharge
  from {{ source('staging','yellow_tripdata') }}
 where vendor_id is not null
 
-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}