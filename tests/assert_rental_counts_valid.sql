select *
from {{ ref('stg_bike_daily') }}
where total_rentals <> casual_rentals + registered_rentals
   or total_rentals < 0
   or casual_rentals < 0
   or registered_rentals < 0
