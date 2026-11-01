-- Cleaned data should contain no returns, zero prices, or negative revenue
select *
from {{ ref('clean_sales') }}
where QUANTITY <= 0 or UNITPRICE <= 0 or REVENUE <= 0