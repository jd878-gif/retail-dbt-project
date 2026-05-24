
WITH clean AS (
    SELECT * FROM {{ ref('clean_sales') }}
),

max_date AS (
    SELECT MAX(INVOICE_DATE_ONLY) AS MAX_DATE FROM clean
),

rfm AS (
    SELECT
        c.CUSTOMERID,
        DATEDIFF('day', MAX(c.INVOICE_DATE_ONLY), m.MAX_DATE) AS RECENCY,
        COUNT(DISTINCT c.INVOICENO)                            AS FREQUENCY,
        SUM(c.REVENUE)                                         AS MONETARY
    FROM clean c
    CROSS JOIN max_date m
    GROUP BY c.CUSTOMERID, m.MAX_DATE
),

scored AS (
    SELECT
        CUSTOMERID,
        RECENCY,
        FREQUENCY,
        MONETARY,
        CASE
            WHEN RECENCY <= 30  THEN 4
            WHEN RECENCY <= 90  THEN 3
            WHEN RECENCY <= 180 THEN 2
            ELSE 1
        END AS R_SCORE,
        CASE
            WHEN FREQUENCY >= 10 THEN 4
            WHEN FREQUENCY >= 5  THEN 3
            WHEN FREQUENCY >= 2  THEN 2
            ELSE 1
        END AS F_SCORE,
        CASE
            WHEN MONETARY >= 1000 THEN 4
            WHEN MONETARY >= 500  THEN 3
            WHEN MONETARY >= 100  THEN 2
            ELSE 1
        END AS M_SCORE
    FROM rfm
),

segmented AS (
    SELECT
        *,
        R_SCORE + F_SCORE + M_SCORE AS RFM_SCORE,
        CASE
            WHEN R_SCORE + F_SCORE + M_SCORE >= 10 THEN 'VIP'
            WHEN R_SCORE + F_SCORE + M_SCORE >= 7  THEN 'LOYAL'
            WHEN R_SCORE + F_SCORE + M_SCORE >= 5  THEN 'AT_RISK'
            ELSE 'DORMANT'
        END AS SEGMENT
    FROM scored
)

SELECT * FROM segmented