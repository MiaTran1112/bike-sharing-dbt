-- Grain: one row per year, season and day type.

with daily_rentals as (

    select *
    from {{ ref('fct_daily_rentals') }}

),

seasonal_summary as (

    select
        rental_year,
        season_code,
        season,
        day_type,
        count(*) as observed_days,
        sum(total_rentals) as total_rentals,
        sum(casual_rentals) as casual_rentals,
        sum(registered_rentals) as registered_rentals,
        avg(total_rentals) as avg_daily_rentals

    from daily_rentals
    group by
        rental_year,
        season_code,
        season,
        day_type

)

select *
from seasonal_summary
