select
    cast(instant as integer) as day_id,
    cast(dteday as date) as rental_date,
    cast(season as integer) as season_code,
    cast(yr as integer) + 2011 as rental_year,
    cast(mnth as integer) as rental_month,
    cast(weekday as integer) as weekday_code,
    cast(holiday as integer) = 1 as is_holiday,
    cast(workingday as integer) = 1 as is_working_day,
    cast(weathersit as integer) as weather_code,
    cast(temp as double) as temperature_index,
    cast(atemp as double) as feels_like_index,
    cast(hum as double) * 100 as humidity_pct,
    cast(windspeed as double) as windspeed_index,
    cast(casual as integer) as casual_rentals,
    cast(registered as integer) as registered_rentals,
    cast(cnt as integer) as total_rentals
from {{ source('bike_sharing', 'daily') }}