select
    *,
    cast(date_trunc('month', rental_date) as date) as month_start,

    case season_code
        when 1 then 'winter'
        when 2 then 'spring'
        when 3 then 'summer'
        when 4 then 'fall'
    end as season,

    case weather_code
        when 1 then 'clear_or_partly_cloudy'
        when 2 then 'mist_or_cloudy'
        when 3 then 'light_rain_or_snow'
        when 4 then 'heavy_rain_or_snow'
    end as weather,

    case
        when is_working_day then 'working_day'
        else 'weekend_or_holiday'
    end as day_type,

    cast(registered_rentals as double)
        / nullif(total_rentals, 0) as registered_share

from {{ ref('stg_bike_daily') }}
