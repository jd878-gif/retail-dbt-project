-- Every customer in clean_sales must appear exactly once in customer_segments
with fact as (select count(distinct CUSTOMERID) as n from {{ ref('clean_sales') }}),
     seg  as (select count(*) as n from {{ ref('customer_segments') }})
select fact.n, seg.n
from fact, seg
where fact.n <> seg.n