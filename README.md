
# dbt SQL Server Analytics Platform on Windows

## Overview

Complete dbt analytics platform successfully configured to connect to Microsoft SQL Server on Windows using Python 3.13. Implements a Bronze-Silver-Gold data architecture with comprehensive business intelligence transformations for retail analytics.

## Environment Details

* **OS**: Windows 11
* **Python**: 3.13.3
* **dbt Core**: 1.10.2
* **dbt SQL Server Adapter**: 1.9.0
* **ODBC Driver**: ODBC Driver 17 for SQL Server
* **Authentication**: Windows Authentication

## Installed Packages (requirements.txt)

The following packages were installed and tested to work together:

```
dbt-core==1.10.2
dbt-sqlserver==1.9.0
dbt-fabric==1.9.3
pyodbc==5.2.0
azure-identity==1.21.0
azure-keyvault-secrets==4.9.0
azure-storage-blob==12.24.0
```

## Key Configuration

### profiles.yml

Located at: `C:\Users\Ibrahim\.dbt\profiles.yml`

```yaml
sql_server_project:
  outputs:
    dev:
      database: analytics_migration
      driver: 'ODBC Driver 17 for SQL Server'
      host: localhost
      port: 1433
      schema: dbo
      threads: 1
      type: sqlserver
      windows_login: true
      encrypt: false
      trust_cert: true
  target: dev
```

### Critical Settings for Local SQL Server

* `windows_login: true` - Use Windows Authentication
* `encrypt: false` - Disable SSL encryption for local connections
* `trust_cert: true` - Trust the server certificate
* `database: dbt_analytics` - Analytics database with Bronze-Silver-Gold architecture

## Setup Process

### 1. Python Environment

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

### 2. Package Installation

```powershell
pip install pyodbc==5.2.0
pip install dbt-core==1.10.2
pip install dbt-sqlserver==1.9.0
pip install dbt-fabric==1.9.3
pip install azure-identity==1.21.0
pip install azure-keyvault-secrets==4.9.0
pip install azure-storage-blob==12.24.0
```

### 3. Database Creation

```sql
-- Create analytics database with proper schema structure
sqlcmd -E -S localhost -Q "CREATE DATABASE dbt_analytics;"
sqlcmd -E -S localhost -d dbt_analytics -Q "CREATE SCHEMA raw_data;"
sqlcmd -E -S localhost -d dbt_analytics -Q "CREATE SCHEMA silver;"
sqlcmd -E -S localhost -d dbt_analytics -Q "CREATE SCHEMA gold;"
sqlcmd -E -S localhost -d dbt_analytics -Q "CREATE SCHEMA snapshots;"
```

### 4. dbt Project Initialization

```powershell
dbt init sql_server_project
```

### 5. Source Data Setup

```powershell
# Run SQL Server initialization scripts
# Execute scripts in sql_server_init/ folder:
# - 00_create_database.sql
# - 01_create_source_tables.sql  
# - 02_insert_sample_data.sql
```

## Troubleshooting Issues Resolved

### 1. Python 3.13 Compatibility

* **Issue**: `pyodbc` build errors with Python 3.13
* **Solution**: Install `pyodbc==5.2.0` (compatible version)

### 2. SSL Certificate Errors

* **Issue**: Certificate chain not trusted
* **Solution**: Set `encrypt: false` and `trust_cert: true`

### 3. Database Access

* **Issue**: Database "dbt_analytics" didn't exist
* **Solution**: Created database with proper schema structure using `sqlcmd`

### 4. Windows Authentication

* **Issue**: Initial connection failures
* **Solution**: Use `windows_login: true` instead of username/password

## Verification Commands

### Test Connection

```powershell
dbt debug
```

### Compile Project

```powershell
dbt compile
```

### Run Models

```powershell
# Run all models (Silver views + Gold tables)
dbt run

# Run specific layers
dbt run --select silver.*    # Only Silver layer views
dbt run --select gold.*     # Only Gold layer tables

# Run snapshots (Slowly Changing Dimensions)
dbt snapshot

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

## Project Architecture

### Bronze-Silver-Gold Data Architecture

```
dbt_analytics (Database)
├── raw_data (Bronze Layer) - Source Tables
│   ├── customers           # Customer master data
│   ├── products            # Product catalog
│   ├── orders              # Order headers
│   └── order_items         # Order line items
│
├── silver (Silver Layer) - Views (Data Cleaning)
│   ├── stg_customers       # Cleaned customer data + full_name
│   ├── stg_products        # Cleaned products + profit margins + categories
│   ├── stg_orders          # Cleaned orders + date parsing + status mapping
│   └── stg_order_items     # Cleaned order items + total price calculations
│
├── gold (Gold Layer) - Tables (Business Intelligence)
│   ├── customer_analytics      # Customer segmentation & lifetime value
│   ├── product_performance     # Product sales & profitability analysis
│   ├── daily_sales_summary     # Time-series sales metrics & trends
│   └── order_details_enhanced  # Comprehensive order analysis
│
└── snapshots (SCD Tables) - Historical Tracking
    ├── orders_snapshot      # Order change history
    └── products_snapshot    # Product change history
```

### Data Transformation Flow

```
Raw Data (Bronze)           Silver Layer (Cleaning)         Gold Layer (Analytics)
━━━━━━━━━━━━━━━            ━━━━━━━━━━━━━━━━━━━━━━━            ━━━━━━━━━━━━━━━━━━━━
customers                → stg_customers + enrichment    → customer_analytics
products                 → stg_products + calculations   → product_performance  
orders                   → stg_orders + parsing         → daily_sales_summary
order_items              → stg_order_items + totals     → order_details_enhanced
```

## Status

COMPLETE: Full Bronze-Silver-Gold analytics platform operational
TESTED: All models, tests, and snapshots successfully running
BUSINESS READY: Executive dashboards and analytics available
DOCUMENTED: Comprehensive transformation logic and data lineage
REPRODUCIBLE: Complete environment and setup documentation

## Business Intelligence Capabilities

### Available Analytics

1. Customer Segmentation: RFM analysis, lifecycle status, geographic insights
2. Product Analytics: Profitability analysis, sales performance, category trends
3. Sales Performance: Daily trends, growth analysis, operational KPIs
4. Order Intelligence: Composition analysis, complexity metrics, size classification

### Key Business Metrics

* Customer Lifetime Value (CLV) and retention analysis
* Product profitability and margin analysis
* Sales growth trends and operational efficiency
* Order completion rates and fulfillment metrics

### Reporting Capabilities

* Executive Dashboards: High-level KPIs and trends
* Operational Reports: Daily sales, completion rates, customer activity
* Strategic Analysis: Customer segmentation, product performance, growth analysis
* Historical Tracking: Slowly changing dimensions for trend analysis

## Next Steps & Recommendations

### Immediate Actions

1. Connect BI Tools: Power BI, Tableau, or Excel to Gold layer tables
2. Set Up Scheduling: Implement automated daily/hourly dbt runs
3. Create Alerts: Monitor data quality and business KPIs
4. User Training: Educate business users on available analytics

### Advanced Features

1. Real-time Analytics: Consider streaming data integration
2. Machine Learning: Customer churn prediction, demand forecasting
3. Advanced Segmentation: Implement more sophisticated RFM analysis
4. Data Governance: Add data lineage documentation and data cataloging

### Production Deployment

1. CI/CD Pipeline: Automated testing and deployment
2. Environment Management: Dev, Test, Production environments
3. Monitoring: Data quality monitoring and alerting
4. Security: Role-based access control and data encryption

## Silver Layer Transformations

### Data Cleaning & Standardization

* Text Normalization: `TRIM()`, `UPPER()`, `LOWER()` for consistent formatting
* Email Standardization: Lowercase + trimmed email addresses
* Address Cleaning: Trimmed and standardized address components
* Status Mapping: Raw status codes → business-friendly descriptions

### Data Enrichment

* Customer Enhancement: `first_name + ' ' + last_name as full_name`
* Product Calculations: `price - cost as profit_margin`, profit percentages
* Date Parsing: Extract year, month, day, day-of-week from dates
* Category Grouping: Electronics → Tech, Furniture → Home

### Business Logic

* Safe Calculations: Division by zero protection in profit margin calculations
* Data Validation: Price consistency checks and validation flags
* Status Standardization: PENDING → Awaiting Processing, COMPLETED → Fulfilled

## Gold Layer Analytics

### Customer Intelligence (`customer_analytics`)

* Behavioral Metrics: Total orders, lifetime value, average order value
* Segmentation: No Orders, One-Time, Regular, High Value customers
* Lifecycle Status: Active (30 days), At Risk (90 days), Churned
* Geographic Analysis: Performance by city and state

### Product Performance (`product_performance`)

* Sales Metrics: Units sold, revenue, order frequency
* Profitability: Total cost, profit, actual vs. theoretical margins
* Performance Tiers: No Sales, Low, Medium, High performance categories
* Category Analysis: Performance by product category groups

### Sales Analytics (`daily_sales_summary`)

* Time-Series Metrics: Daily revenue, order volume, customer reach
* Operational KPIs: Order completion rates and fulfillment efficiency
* Growth Analysis: Day-over-day revenue growth calculations
* Trend Analysis: Previous period comparisons using window functions

### Order Intelligence (`order_details_enhanced`)

* Order Composition: Concatenated product lists with quantities
* Complexity Metrics: Total items, unique products, category diversity
* Order Classification: Small, Medium, Large, Very Large order categories
* Advanced SQL: String aggregation using `STUFF()` and `FOR XML PATH`

## Testing & Quality Assurance

### Custom Macros

* `test_positive_values`: Ensures numeric fields contain only positive values
* `test_email_format`: Validates email address formats

### Data Tests

* Source Tests: Unique keys, not null constraints, referential integrity
* Business Logic Tests: Order total consistency, recent orders validation
* Custom Tests: Email format validation, positive value checks

## Slowly Changing Dimensions (Snapshots)

### Historical Tracking

* Orders Snapshot: Track changes in order status and amounts over time
* Products Snapshot: Monitor product price changes and catalog updates
* SCD Type 2: Full history with valid_from/valid_to timestamps
* Change Detection: Automatic detection of changes using `check` strategy
