# 🏆 Bronze-Silver-Gold Data Architecture

## 📁 Project Structure

```
sql_server_project/
├── models/
│   ├── sources.yml           # 📋 Data catalog (defines Bronze layer)
│   ├── bronze/              # 🥉 BRONZE: Raw data (empty - using sources.yml)
│   ├── silver/              # 🥈 SILVER: Cleaned, standardized data
│   │   ├── stg_customers.sql     # Clean customer data
│   │   ├── stg_products.sql      # Clean product data  
│   │   ├── stg_orders.sql        # Clean order data
│   │   ├── stg_order_items.sql   # Clean order items data
│   │   └── stg_payments.sql      # Clean payment data
│   └── gold/                # 🥇 GOLD: Business-ready analytics
│       ├── customer_analytics.sql    # Customer insights
│       ├── product_performance.sql   # Product analysis
│       ├── daily_sales_summary.sql   # Daily sales trends
│       └── order_details_enhanced.sql # Enhanced order details
```

## 🥉 BRONZE Layer (Raw Data)
- **Source**: SQL Server tables (customers, products, orders, order_items, payments)
- **Defined in**: `sources.yml`
- **Characteristics**: 
  - Exact copy of source system data
  - No transformations
  - May contain duplicates, nulls, inconsistent formats
  - Serves as historical record

## 🥈 SILVER Layer (Cleaned Data)
- **Location**: `models/silver/` folder
- **File prefix**: `stg_` (staging)
- **Materialization**: Views (for performance and freshness)
- **Purpose**: 
  - Clean and standardize data
  - Apply business rules
  - Remove duplicates
  - Handle data quality issues
  - Add useful calculated fields

### Silver Layer Transformations:
- **Data Cleaning**: `trim()` to remove spaces, `upper()`/`lower()` for consistency
- **Data Validation**: Check price calculations, validate relationships
- **Enrichment**: Add `full_name`, `profit_margin`, `stock_status` fields
- **Standardization**: Consistent date formats, status codes

## 🥇 GOLD Layer (Business Analytics)
- **Location**: `models/gold/` folder
- **Materialization**: Tables (for performance)
- **Purpose**:
  - Answer specific business questions
  - Aggregate data for reporting
  - Calculate KPIs and metrics
  - Create analysis-ready datasets

### Gold Layer Business Value:
- **customer_analytics**: Customer segmentation, lifetime value, churn analysis
- **product_performance**: Sales analytics, profitability, inventory insights  
- **daily_sales_summary**: Revenue trends, growth metrics, completion rates
- **order_details_enhanced**: Comprehensive order analysis

## 🔄 Data Flow

```
SQL Server (Bronze) 
       ↓ 
   sources.yml (catalog)
       ↓
Silver Layer (clean) 
       ↓ 
Gold Layer (analytics)
       ↓
Business Intelligence Tools
```

## 🎯 Benefits of This Architecture

1. **Separation of Concerns**: Each layer has a clear purpose
2. **Reusability**: Silver layer can feed multiple gold tables
3. **Debugging**: Easy to identify where issues occur
4. **Performance**: Gold tables are pre-aggregated for fast queries
5. **Flexibility**: Can add new analytics without changing cleaning logic
6. **Data Quality**: Systematic approach to improving data quality

## 🚀 Running the Models

```bash
# Run all models
dbt run

# Run only silver layer
dbt run --select silver.*

# Run only gold layer  
dbt run --select gold.*

# Run specific model
dbt run --select customer_analytics
```
