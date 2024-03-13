-- Q1. Highest average trip time
create materialized view avg_min_max as
select
     min(PULocationID) as pu_loc_id
    ,min(DOLocationID) as do_loc_id
    ,p.Zone         as pickup_zone
    ,d.Zone         as dropoff_zone
    ,avg(tpep_dropoff_datetime - tpep_pickup_datetime) as avg_dur
    ,min(tpep_dropoff_datetime - tpep_pickup_datetime) as min_dur
    ,max(tpep_dropoff_datetime - tpep_pickup_datetime) as max_dur
  from trip_data as t
  join taxi_zone as p
    on t.PULocationID = p.location_id
  join taxi_zone as d
    on t.DOLocationID = d.location_id
 group by p.Zone, d.Zone
;

create materialized view avg_max as
select avg_dur as max_avg_dur
    ,pu_loc_id
    ,do_loc_id
    ,pickup_zone
    ,dropoff_zone
  from avg_min_max
 where avg_dur = (select max(avg_dur) from avg_min_max)
;

-- A1.
select * from avg_max
;




-- Q2. Number of trips
create materialized view avg_cnt as
select count(1) as total_trip
    ,pickup_zone
    ,dropoff_zone
  from trip_data as td
  join avg_max   as am
    on td.PULocationID = am.pu_loc_id
   and td.DOLocationID = am.do_loc_id
 where max_avg_dur = (select max(max_avg_dur) from avg_max)
 group by pickup_zone, dropoff_zone
;

-- A2.
select * from avg_cnt
;




-- Q3. Top 3 busiest zones
create materialized view top_3 as
with t as (
select
     count(1) as trip_total
    ,p.Zone
  from trip_data as t
  join taxi_zone as p
    on t.PULocationID = p.location_id
 where tpep_pickup_datetime >= (select max(tpep_pickup_datetime) - interval '17 hours' from trip_data)
 group by p.Zone
)

select *
  from t
 order by 1 desc
 limit 3
;

-- A3.
select * from top_3
;
