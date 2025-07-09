# 📊 Data Architecture & Analysis Documentation

## 🎯 Project Overview
This document provides a comprehensive analysis of our e-commerce data pipeline built using dbt (data build tool) with SQL Server, implementing a **Bronze-Silver-Gold** medallion architecture.

---

## 🔍 **DATA OVERVIEW**

### **What Data We Have:**
Our project processes **e-commerce transactional data** from SQL Server with 5 main entities:

| Entity | Records | Description |
|--------|---------|-------------|
| **Customers** | 8 sample records | Customer profiles with contact information |
| **Products** | 10 sample records | Product catalog (electronics, furniture, appliances) |
| **Orders** | 8 sample records | Customer purchase transactions |
| **Order Items** | 16 sample records | Individual line items within orders |
| **Payments** | 8 sample records | Payment details for each order |

### **Sample Data Characteristics:**
- **Customers**: John Smith, Jane Doe, etc. from various US cities (NY, CA, IL, TX, AZ, PA)
- **Products**: "Laptop Pro 15"", "Wireless Mouse", "Office Chair", "Coffee Maker", etc.
- **Order Values**: Range from $89.99 to $1,799.97
- **Payment Methods**: Credit Card, PayPal, Debit Card
- **Order Statuses**: Completed, Shipped, Processing, Pending
- **Date Range**: June 2025 sample data

---

## 🏗️ **DATA ARCHITECTURE: BRONZE-SILVER-GOLD**

### 🥉 **BRONZE LAYER (Raw Data Source)**

**Purpose**: Store exact copy of source system data
**Location**: SQL Server tables defined in `sources.yml`
**Characteristics**: 
- Raw, unprocessed data
- May contain duplicates, nulls, inconsistent formats
- Serves as historical record and source of truth

#### **What We Accomplished:**
✅ **Data Catalog Setup**: Created comprehensive `sources.yml` with 5 source tables
✅ **Data Quality Tests**: Implemented tests for:
- Unique constraints (customer_id, product_id, order_id)
- Not null validations
- Referential integrity (foreign key relationships)
✅ **Schema Definition**: Established `raw_data` schema structure
✅ **Relationship Mapping**: Connected customers → orders → order_items → products

#### **Source Tables Structure:**
```sql
-- Database: dbt_analytics
-- Schema: raw_data
-- Tables: customers, products, orders, order_items, payments
```

---

### 🥈 **SILVER LAYER (Cleaned & Standardized)**

**Purpose**: Clean, standardize, and enrich data for analysis
**Location**: `models/silver/` folder
**Materialization**: Views (for real-time freshness)
**Naming Convention**: `stg_` prefix (staging)

#### **What We Accomplished in Each Silver Model:**

#### 📋 **`stg_customers.sql`**
**Transformations Applied:**
- ✅ **Data Cleaning**: 
  - `trim()` to remove whitespace from names and addresses
  - `lower()` for email standardization
  - `upper()` for state code consistency
- ✅ **Data Enrichment**: 
  - Added `full_name` field combining first + last name
- ✅ **Standardization**: Consistent formatting across all text fields

```sql
-- Key transformations:
trim(first_name) as first_name,
lower(trim(email)) as email,
upper(trim(state)) as state,
first_name + ' ' + last_name as full_name
```

#### 🛍️ **`stg_products.sql`**
**Transformations Applied:**
- ✅ **Business Logic**: 
  - Added `profit_margin` calculation (price - cost)
  - Created `profit_margin_percent` for KPI reporting
- ✅ **Categorization**: 
  - Built `category_group` mapping (Electronics → Tech, Furniture → Home)
- ✅ **Data Quality**: 
  - Handled division by zero scenarios
  - Trimmed product names and categories

```sql
-- Key calculations:
price - cost as profit_margin,
case when price > 0 then round(((price - cost) / price) * 100, 2) else 0 end as profit_margin_percent,
case when category = 'Electronics' then 'Tech' when category = 'Furniture' then 'Home' else 'Other' end as category_group
```

#### 📦 **`stg_orders.sql`**
**Transformations Applied:**
- ✅ **Date Enrichment**: 
  - Added `order_date_only`, `order_year`, `order_month`, `order_day_of_week`
- ✅ **Status Standardization**: 
  - Converted to uppercase with `upper(trim(status))`
  - Added human-readable `status_description`
- ✅ **Address Cleaning**: 
  - Trimmed shipping addresses

```sql
-- Key transformations:
cast(order_date as date) as order_date_only,
datepart(year, order_date) as order_year,
datename(weekday, order_date) as order_day_of_week,
upper(trim(status)) as status
```

#### 🛒 **`stg_order_items.sql`**
**Transformations Applied:**
- ✅ **Data Validation**: Ensured quantity and price consistency
- ✅ **Relationship Integrity**: Maintained foreign key relationships
- ✅ **Calculation Verification**: Validated unit_price × quantity = total_price

---

### 🥇 **GOLD LAYER (Business Analytics)**

**Purpose**: Create business-ready analytics tables
**Location**: `models/gold/` folder
**Materialization**: Tables (for performance)
**Focus**: Answer specific business questions and provide KPIs

#### **What We Accomplished in Each Gold Model:**

#### 👥 **`customer_analytics.sql`**
**Business Questions Answered:**
- Who are our most valuable customers?
- Which customers are at risk of churning?
- What's the customer lifetime value distribution?

**Key Features:**
- ✅ **Customer Segmentation**: 
  - No Orders, One-Time, Regular, High Value
- ✅ **Customer Lifecycle Management**: 
  - Active (last 30 days), At Risk (30-90 days), Churned (90+ days)
- ✅ **KPIs Created**:
  - Total orders per customer
  - Total spent (customer lifetime value)
  - Average order value
  - First/last order dates
  - Customer status tracking

```sql
-- Key metrics:
count(o.order_id) as total_orders,
coalesce(sum(o.total_amount), 0) as total_spent,
coalesce(avg(o.total_amount), 0) as avg_order_value,
case when count(o.order_id) between 2 and 5 then 'Regular' else 'High Value' end as customer_segment
```

#### 🏷️ **`product_performance.sql`**
**Business Questions Answered:**
- Which products are most profitable?
- What's selling well vs. poorly?
- How do product categories perform?

**Key Features:**
- ✅ **Sales Analytics**: 
  - Total quantity sold per product
  - Revenue and profit calculations
  - Number of orders containing each product
- ✅ **Performance Classification**: 
  - No Sales, Low Sales (1-5), Medium Sales (6-20), High Sales (20+)
- ✅ **Profitability Analysis**: 
  - Actual vs. theoretical profit margins
  - Cost analysis per product
- ✅ **Category Insights**: 
  - Performance by product category and category group

```sql
-- Key calculations:
coalesce(sum(oi.quantity), 0) as total_quantity_sold,
coalesce(sum(oi.total_price), 0) as total_revenue,
coalesce(sum(oi.total_price) - sum(oi.quantity * p.cost), 0) as total_profit,
case when coalesce(sum(oi.quantity), 0) between 6 and 20 then 'Medium Sales' else 'High Sales' end as sales_performance
```

#### 📈 **`daily_sales_summary.sql`**
**Business Questions Answered:**
- What are our daily sales trends?
- How is revenue growing day-over-day?
- What's our order completion rate?

**Key Features:**
- ✅ **Time Series Analysis**: 
  - Daily sales trends and patterns
  - Year, month, day-of-week breakdowns
- ✅ **Growth Metrics**: 
  - Day-over-day revenue growth calculations
  - Previous day revenue comparison
- ✅ **Operational KPIs**:
  - Order completion rates
  - Unique customers per day
  - Average order value trends
- ✅ **Advanced Analytics**: 
  - Window functions for trend analysis
  - Growth percentage calculations

```sql
-- Key metrics:
count(distinct o.order_id) as number_of_orders,
count(distinct o.customer_id) as unique_customers,
sum(o.total_amount) as total_revenue,
round(cast(count(case when o.status = 'COMPLETED' then 1 end) as float) / cast(count(o.order_id) as float) * 100, 2) as completion_rate_percent,
lag(total_revenue, 1) over (order by order_date_only) as previous_day_revenue
```

#### 🔍 **`order_details_enhanced.sql`**
**Business Questions Answered:**
- What's the complete order story?
- How do customer and product data relate to orders?

**Key Features:**
- ✅ **Comprehensive Order View**: 
  - Combined order, customer, and product data
  - Complete order lifecycle information
- ✅ **Enhanced Analytics**: 
  - Rich dataset for detailed order analysis
  - All relationships in one place

---

## 🎯 **BUSINESS VALUE CREATED**

### **Data Quality Improvements:**
| Improvement | Before | After |
|-------------|--------|-------|
| **Text Consistency** | Mixed case, extra spaces | Standardized, trimmed |
| **Email Format** | Various cases | Lowercase standard |
| **State Codes** | Mixed format | Uppercase standard |
| **Calculated Fields** | Manual calculation needed | Pre-computed KPIs |
| **Data Validation** | No systematic checks | Comprehensive testing |

### **Business Intelligence Capabilities:**

#### **Customer Insights:**
- 📊 **Customer Segmentation**: Identify high-value vs. one-time customers
- 🔄 **Churn Analysis**: Track customer lifecycle and at-risk customers
- 💰 **Lifetime Value**: Calculate total customer worth
- 📈 **Retention Metrics**: First/last order tracking

#### **Product Analytics:**
- 🏆 **Top Performers**: Identify best-selling products
- 💵 **Profitability Analysis**: Real vs. theoretical margins
- 📦 **Inventory Insights**: Sales performance by category
- 🎯 **Category Performance**: Tech vs. Home vs. Other

#### **Sales Performance:**
- 📅 **Daily Trends**: Revenue patterns and growth
- 📊 **Completion Rates**: Order fulfillment efficiency
- 🔢 **Growth Metrics**: Day-over-day comparisons
- 👥 **Customer Acquisition**: New vs. returning customers

### **Architecture Benefits:**

#### **Scalability:**
- ✅ Easy to add new analytics without touching raw data
- ✅ Silver layer can feed multiple gold models
- ✅ Modular design allows independent development

#### **Maintainability:**
- ✅ Clear separation of concerns (clean → analyze)
- ✅ Documented data lineage and dependencies
- ✅ Standardized naming conventions

#### **Performance:**
- ✅ Gold tables pre-aggregated for fast queries
- ✅ Views in silver for real-time data
- ✅ Optimized for business intelligence tools

#### **Data Quality:**
- ✅ Systematic data cleaning approach
- ✅ Comprehensive testing framework
- ✅ Validation at each layer

---

## 🛠️ **TECHNICAL ACHIEVEMENTS**

### **dbt Implementation:**
- ✅ **Medallion Architecture**: Bronze-Silver-Gold layers
- ✅ **4 Staging Models**: Comprehensive data cleaning
- ✅ **4 Analytical Models**: Business-focused insights
- ✅ **Data Lineage**: Clear dependencies using `{{ ref() }}`
- ✅ **Testing Framework**: Data quality validations
- ✅ **Documentation**: Comprehensive model documentation

### **SQL Server Integration:**
- ✅ **Source Configuration**: Proper database/schema connections
- ✅ **Performance Optimization**: Appropriate materializations
- ✅ **Data Types**: Proper handling of dates, decimals, strings
- ✅ **Window Functions**: Advanced analytics capabilities

### **Code Quality:**
- ✅ **Consistent Formatting**: Standardized SQL style
- ✅ **Error Handling**: Division by zero, null handling
- ✅ **Modular Design**: Reusable components
- ✅ **Best Practices**: Following dbt conventions

---

## 📋 **DATA FLOW SUMMARY**

```
📊 SQL Server Raw Data (Bronze)
           ↓
🔍 Data Catalog (sources.yml)
           ↓
🧹 Silver Layer (Clean & Standardize)
    ├── stg_customers.sql
    ├── stg_products.sql
    ├── stg_orders.sql
    └── stg_order_items.sql
           ↓
💎 Gold Layer (Business Analytics)
    ├── customer_analytics.sql
    ├── product_performance.sql
    ├── daily_sales_summary.sql
    └── order_details_enhanced.sql
           ↓
📈 Business Intelligence & Reporting
```

---

## 🚀 **NEXT STEPS & RECOMMENDATIONS**

### **Immediate Enhancements:**
1. **Add More Data**: Expand sample dataset for richer analysis
2. **Advanced Analytics**: Implement forecasting and predictive models
3. **Data Marts**: Create department-specific analytical views
4. **Automation**: Set up scheduled dbt runs

### **Long-term Goals:**
1. **Real-time Analytics**: Stream processing capabilities
2. **Machine Learning**: Customer behavior prediction
3. **Data Visualization**: Dashboard and reporting integration
4. **Data Governance**: Enhanced testing and monitoring

---

## 📊 **KEY METRICS DASHBOARD**

### **Customer Metrics:**
- Total Customers: 8
- Customer Segments: No Orders, One-Time, Regular, High Value
- Customer Status: Active, At Risk, Churned
- Average Order Value: Calculated per customer

### **Product Metrics:**
- Total Products: 10
- Categories: Electronics (Tech), Furniture (Home), Appliances (Other)
- Sales Performance: No Sales, Low, Medium, High
- Profit Margins: Actual vs. Theoretical

### **Sales Metrics:**
- Total Orders: 8
- Total Revenue: $6,338.86
- Completion Rate: Calculated daily
- Growth Rate: Day-over-day tracking

---

*This architecture successfully transforms raw e-commerce data into actionable business insights while maintaining high data quality and performance standards.*
