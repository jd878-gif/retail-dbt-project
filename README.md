# Retail Analytics — dbt Project

dbt transformation layer for the Retail Analytics Pipeline.
Transforms raw Snowflake data into clean, tested, and documented
analytics-ready tables.Companion to the [Retail Analytics Pipeline](https://github.com/jd878-gif/retail-analytics-pipeline), which built the original version in Snowpark Python.



![dbt](https://img.shields.io/badge/dbt-1.11-FF694B)
![Snowflake](https://img.shields.io/badge/Snowflake-Data_Warehouse-29B5E8)
![Tests](https://img.shields.io/badge/Tests-52_Passing-2ecc71)

---

## Project Overview

| Layer | Models | Description |
|---|---|---|
| Staging | stg_raw_sales | Raw data filtered and typed |
| Transform | clean_sales | Fully cleaned with timestamps |
| Analytics | monthly_revenue | Revenue by month |
| Analytics | top_products | Top 10 products |
| Analytics | country_revenue | Revenue by country |
| Analytics | customer_segments | RFM segmentation |

---

## Data Flow

```
RAW.RAW_SALES (541,909 rows)
↓
stg_raw_sales (view)
↓
clean_sales (table — 397,880 rows)
↓
┌─────────────────────────────────┐
│ monthly_revenue  (13 months)    │
│ top_products     (top 10)       │
│ country_revenue  (37 countries) │
│ customer_segments (4,338 users) │
└─────────────────────────────────┘
```
---

## Tech Stack

| Tool | Purpose |
|---|---|
| dbt Core 1.11 | Data transformation |
| Snowflake | Cloud data warehouse |
| SQL + Jinja | Transformation language |

---

## Data Quality

- **57 tests passing** across all models
- not_null tests on every column
- unique tests on key columns
- accepted_values tests on RFM scores and segments
- Reconciliation tests: monthly and country revenue must add up to the cleaned fact table
- Relationship test: every segmented customer exists in clean_sales
- Range test: no zero or negative quantities, prices, or revenue

---

## Getting Started

### Prerequisites
- Python 3.8+
- dbt-snowflake installed
- Snowflake account

### Installation

```bash
# Clone the repo
git clone https://github.com/jd878-gif/retail-dbt-project.git
cd retail-dbt-project

# Install dbt
pip install dbt-snowflake

# Setup your profile
# Create ~/.dbt/profiles.yml with your Snowflake credentials
# See profiles_example.yml for reference
```

### profiles_example.yml

```yaml
retail_dbt_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account
      user: your_username
      password: your_password
      role: ACCOUNTADMIN
      warehouse: RETAIL_WH
      database: RETAIL_DB
      schema: DBT_TRANSFORM
      threads: 1
```

### Running the Project

```bash
dbt debug

dbt run

dbt test

dbt build

dbt docs generate
dbt docs serve
```

---

## Project Structure
retail_dbt_project/
│
├── models/
│   ├── staging/
│   │   ├── sources.yml
│   │   ├── stg_raw_sales.sql
│   │   └── stg_raw_sales.yml
│   │
│   ├── transform/
│   │   ├── clean_sales.sql
│   │   └── clean_sales.yml
│   │
│   └── analytics/
│       ├── monthly_revenue.sql
│       ├── top_products.sql
│       ├── country_revenue.sql
│       ├── customer_segments.sql
│       └── analytics.yml
│
├── dbt_project.yml
├── tests/
│   ├── assert_monthly_revenue_reconciles.sql
│   ├── assert_country_revenue_reconciles.sql
│   ├── assert_every_customer_segmented.sql
│   └── assert_positive_quantity_and_price.sql
└── README.md

---

## Author

**Jeet Dave**
- LinkedIn: [linkedin.com/in/jeetdave11](https://linkedin.com/in/jeetdave11)
- Portfolio: https://portfolio-eight-ebon-obwtjca8m8.vercel.app/
- Email: jeetd6220@gmail.com
