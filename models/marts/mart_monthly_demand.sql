with monthly as (
    select
        month_start,
        count(*) as observed_days,
        sum(total_rentals) as total_rentals,
        sum(casual_rentals) as casual_rentals,
        sum(registered_rentals) as registered_rentals,
        avg(total_rentals) as avg_daily_rentals,
        100.0 * sum(registered_rentals)
            / nullif(sum(total_rentals), 0) as registered_share_pct
    from {{ ref('fct_daily_rentals') }}
    group by month_start
),

compared as (
    select
        current_month.*,
        previous_month.total_rentals as previous_month_rentals,
        previous_year.total_rentals as previous_year_month_rentals
    from monthly as current_month
    left join monthly as previous_month
        on previous_month.month_start =
            current_month.month_start - interval '1 month'
    left join monthly as previous_year
        on previous_year.month_start =
            current_month.month_start - interval '1 year'
)

select
    *,
    100.0 * (total_rentals - previous_month_rentals)
        / nullif(previous_month_rentals, 0) as mom_growth_pct,
    100.0 * (total_rentals - previous_year_month_rentals)
        / nullif(previous_year_month_rentals, 0) as yoy_growth_pct
from compared
