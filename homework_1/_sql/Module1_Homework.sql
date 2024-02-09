-- Q3
-- How many taxi trips were totally made on September 18th 2019?
-- Tip: started and finished on 2019-09-18.

select count(1)
  from ycab_rides
 where cast("lpep_pickup_datetime" as date) = to_date('2019-09-18', 'YYYY-MM-DD')
   and cast("lpep_pickup_datetime" as date) = cast("lpep_dropoff_datetime" as date)
;

-- Q4
-- Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.
-- Tip: For every trip on a single day, we only care about the trip with the longest distance.

select
	trip_date
  from (
  		select
			 max(trip_distance)										as longest_trip
			,cast("lpep_pickup_datetime" as date)					as trip_date
			,row_number() over (order by max(trip_distance) desc)	as rn
		  from ycab_rides
		 group by cast("lpep_pickup_datetime" as date)
  		) t
 where t.rn = 1
;

-- Q5
-- Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
-- Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?

select
	round(sum(total_amount))					as total_amount
	,z."Borough"							as borough
	,cast("lpep_pickup_datetime" as date)	as trip_date
  from ycab_rides r
  left join zones z on r."PULocationID" = z."LocationID"
  left join zones x on r."DOLocationID" = x."LocationID"
 where cast("lpep_pickup_datetime" as date) = to_date('2019-09-18', 'YYYY-MM-DD')
   and (z."Borough" <> 'Unknown' and x."Borough" <> 'Unknown')
 group by 2, 3
having sum(total_amount) > 50000
;

-- Q6
-- For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip? We want the name of the zone, not the id.
-- Note: it's not a typo, it's tip , not trip
with tmp as (
select
	 max("tip_amount")											as top_tip
	,"DOLocationID"												as drop_borough
	,date_trunc('month', cast("lpep_pickup_datetime" as date))	as trip_month
	,row_number() over (order by max("tip_amount") desc)		as rn
  from ycab_rides r
  left join zones z on r."PULocationID" = z."LocationID"
 where "Zone" = 'Astoria'
   and date_trunc('month', cast("lpep_pickup_datetime" as date)) = to_date('2019-09-01', 'YYYY-MM-DD')
group by 2,3
)

select "Zone"
  from zones
 where "LocationID" = (select drop_borough from tmp where rn = 1)