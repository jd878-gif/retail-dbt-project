-- Monthly totals must add up to the cleaned fact table
with fact as (select sum(REVENUE) as total from {{ ref('clean_sales') }}),
     agg  as (select sum(TOTAL_REVENUE) as total from {{ ref('monthly_revenue') }})
select fact.total, agg.total
from fact, agg
where abs(fact.total - agg.total) > 0.01