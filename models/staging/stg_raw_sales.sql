-- models/staging/stg_raw_sales.sql
-- This is your first dbt model!
-- It references RAW_SALES and does basic filtering

WITH source AS (
    -- ref() tells dbt where to get the data from
    SELECT * FROM {{ source('raw', 'RAW_SALES') }}
),

staged AS (
    SELECT
        INVOICENO,
        STOCKCODE,
        DESCRIPTION,
        QUANTITY::INTEGER AS QUANTITY,
        INVOICEDATE,
        UNITPRICE::FLOAT AS UNITPRICE,
        CUSTOMERID,
        COUNTRY,

        -- Add revenue column
        (QUANTITY::INTEGER * UNITPRICE::FLOAT) AS REVENUE,

        -- Add loaded timestamp
        CURRENT_TIMESTAMP AS LOADED_AT

    FROM source

    -- Basic filters
    WHERE CUSTOMERID IS NOT NULL
      AND QUANTITY > 0
      AND UNITPRICE > 0
      AND DESCRIPTION IS NOT NULL
      AND INVOICENO NOT LIKE 'C%'
)

SELECT * FROM staged