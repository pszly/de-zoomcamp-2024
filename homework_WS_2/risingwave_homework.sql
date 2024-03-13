-- Q1
create materialized view avg_min_max as
with t as (
select
     p.Zone      as pickup_zone
    ,d.Zone      as dropoff_zone
    ,avg(tpep_dropoff_datetime - tpep_pickup_datetime) as avg_dur
    ,min(tpep_dropoff_datetime - tpep_pickup_datetime) as min_dur
    ,max(tpep_dropoff_datetime - tpep_pickup_datetime) as max_dur
  from trip_data as t
  join taxi_zone as p
    on t.PULocationID = p.location_id
  join taxi_zone as d
    on t.DOLocationID = d.location_id
 group by 1,2
)

select avg_dur as max_avg_dur
    ,pickup_zone
    ,dropoff_zone
  from t
 where avg_dur = (select max(avg_dur) from t)
;

-- Q1 - R E S U L T
select * from avg_min_max;