-- create external table based on GCS parquet file
CREATE EXTERNAL TABLE `heroic-artifact-412919.module_3_dwh_bq.green_ext`
  OPTIONS (
    format ="PARQUET",
    uris = ['gs://module_3_homework/green_taxi_data/8ab50e584d774ca7a27d44f28eeff880-0.parquet']
    );

-- create BigQuery table based on external table

CREATE OR REPLACE TABLE  `heroic-artifact-412919.module_3_dwh_bq.green_non_part` AS
SELECT
   TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 as int64)) as casted_lpep_pickup_datetime
  ,TIMESTAMP_MICROS(CAST(lpep_dropoff_datetime / 1000 as int64)) as casted_lpep_dropoff_datetime
  ,*
  FROM `heroic-artifact-412919.module_3_dwh_bq.green_ext`
;

-- create partitioned BigQuery table based on external table
CREATE OR REPLACE TABLE  `heroic-artifact-412919.module_3_dwh_bq.green_part` 
PARTITION BY DATE(casted_lpep_pickup_datetime)
CLUSTER BY pulocation_id AS
SELECT
   TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 as int64)) as casted_lpep_pickup_datetime
  ,TIMESTAMP_MICROS(CAST(lpep_dropoff_datetime / 1000 as int64)) as casted_lpep_dropoff_datetime
  ,*
  FROM `heroic-artifact-412919.module_3_dwh_bq.green_ext`
;


---------------------------------------------------------------------------------------------------------------

-- distinct number of PULocationIDs
select count(distinct pulocation_id) from `heroic-artifact-412919.module_3_dwh_bq.green_ext`; -- 0
select count(distinct pulocation_id) from `heroic-artifact-412919.module_3_dwh_bq.green_non_part`; -- 6,41 MB


-- number of fare_amount = 0
select count(1) from `heroic-artifact-412919.module_3_dwh_bq.green_non_part` where fare_amount = 0; -- 1622


-- distinct number of PULocationIDs between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
select count(distinct pulocation_id)
  from `heroic-artifact-412919.module_3_dwh_bq.green_part`
 where date(casted_lpep_pickup_datetime) between date "2022-06-01" and date "2022-06-30"; -- 1.12 MB

select count(distinct pulocation_id)
  from `heroic-artifact-412919.module_3_dwh_bq.green_non_part`
 where date(casted_lpep_pickup_datetime) between date "2022-06-01" and date "2022-06-30"; -- 12.82 MB