-- Grain: one row per calendar date.
select *
from {{ ref('int_bike_daily') }}
