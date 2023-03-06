
{{ config(materialized="table") }}

with
    ftv_data as (select *, 'fhv' as service_type from {{ ref("stg_fhv_tripdata") }}),

    dim_zones as (select * from {{ ref("dim_zones") }} where borough != 'Unknown')


select
    ftv_data.tripid,
    ftv_data.pickup_datetime,
    ftv_data.dropoff_datetime,
    ftv_data.pickup_locationid,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    ftv_data.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
from ftv_data
inner join
    dim_zones as pickup_zone on ftv_data.pickup_locationid = pickup_zone.locationid
inner join
    dim_zones as dropoff_zone on ftv_data.dropoff_locationid = dropoff_zone.locationid
