{{ config(materialized='table') }}

with green_tripdata as (
    select *, 
        'Green' as service_type
    from {{ ref('stg_green_tripdata') }}
), 
yellow_tripdata as (
    select *, 
        'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata') }}
), 
trips_unioned as (
    select * from green_tripdata
    union all 
    select * from yellow_tripdata
), 
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select
    t.trip_id, 
    t.vendor_id, 
    t.service_type,
    t.ratecode_id, 
    t.pu_loc_id, 
    pz.borough  as pu_borough, 
    pz.zone     as pu_zone, 
    t.do_loc_id,
    dz.borough  as do_borough, 
    dz.zone     as do_zone,  
    t.pu_datetime, 
    t.do_datetime, 
    t.store_and_fwd_flag, 
    t.passenger_count, 
    t.trip_distance, 
    t.trip_type, 
    t.fare_amount, 
    t.extra, 
    t.mta_tax, 
    t.tip_amount, 
    t.tolls_amount, 
    t.ehail_fee, 
    t.improvement_surcharge, 
    t.total_amount, 
    t.payment_type, 
    t.payment_type_desc
  from trips_unioned as t
 inner join dim_zones as pz
    on t.pu_loc_id = pz.locationid
 inner join dim_zones as dz
    on t.do_loc_id = dz.locationid