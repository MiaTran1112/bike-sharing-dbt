select
    rental_year,
    weather_code,
    weather,
    day_type,
    count(*) as observed_days,
    sum(total_rentals) as total_rentals,
    avg(total_rentals) as avg_daily_rentals,
    avg(casual_rentals) as avg_daily_casual_rentals,
    avg(registered_rentals) as avg_daily_registered_rentals
from {{ ref('fct_daily_rentals') }}
group by
    rental_year,
    weather_code,
    weather,
    day_type
