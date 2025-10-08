# Project Architecture and Technical Details

## Overview

This document provides detailed technical information about the project architecture, design decisions, and implementation details.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                          main.R                                 │
│                    (Orchestration Layer)                        │
└────────────┬─────────────┬─────────────┬────────────────────────┘
             │             │             │
             ▼             ▼             ▼
    ┌────────────┐  ┌─────────────┐  ┌──────────────┐
    │   Hive     │  │   HBase     │  │Visualization │
    │ Processing │  │  Storage    │  │   Module     │
    └──────┬─────┘  └──────┬──────┘  └──────┬───────┘
           │               │                │
           ▼               ▼                ▼
    ┌────────────────────────────────────────────┐
    │          Data Layer (CSV Files)            │
    │  - sales_data.csv                          │
    │  - Hive aggregation results                │
    │  - HBase storage results                   │
    └────────────────────────────────────────────┘
```

## Component Details

### 1. Data Generation Module (`generate_data.R`)

**Purpose**: Create realistic e-commerce sales dataset

**Key Features**:
- Generates 1000 sales records
- 13 fields per record including customer, product, pricing, and satisfaction data
- Uses reproducible random seed for consistency
- Date range: Full year 2024

**Data Schema**:
```
Sales Data Schema:
├── order_id (integer): Unique order identifier
├── customer_id (integer): Customer reference (1-200)
├── product_category (factor): 6 categories
├── product_name (string): Product identifier
├── quantity (integer): Items ordered (1-10)
├── unit_price (numeric): Price per item ($10-$500)
├── region (factor): Geographic region
├── payment_method (factor): Payment type
├── order_date (date): Order timestamp
├── shipping_cost (numeric): Shipping fee
├── discount_percentage (integer): Discount applied (0-20%)
├── total_amount (numeric): Calculated total
└── customer_satisfaction (integer): Rating (1-5)
```

**Statistical Properties**:
- Category distribution weighted by popularity
- Price distribution: Uniform($10, $500)
- Seasonal patterns in order dates
- Customer repeat purchase behavior

### 2. Hive Processing Module (`hive_processing.R`)

**Purpose**: Simulate Apache Hive data warehousing operations

**Architecture**:
```
Hive Module
├── Data Loading Layer
│   └── load_hive_data()
├── Query Execution Layer
│   ├── Category Aggregation
│   ├── Regional Analysis
│   ├── Time-Series Processing
│   ├── Payment Analytics
│   └── Satisfaction Metrics
└── Result Storage Layer
    └── save_hive_results()
```

**Hive Operations Simulated**:
1. **GROUP BY Aggregations**:
   ```sql
   SELECT category, SUM(total_amount), COUNT(*), AVG(total_amount)
   FROM sales_data
   GROUP BY category
   ```

2. **Time-Series Analysis**:
   ```sql
   SELECT DATE_FORMAT(order_date, '%Y-%m'), SUM(total_amount)
   FROM sales_data
   GROUP BY DATE_FORMAT(order_date, '%Y-%m')
   ```

3. **Multi-Dimensional Analytics**:
   - Cross-tabulation
   - Percentage calculations
   - Statistical aggregations

**Output Files**:
- `hive_category_sales.csv`: Category-level metrics
- `hive_region_sales.csv`: Regional performance
- `hive_monthly_sales.csv`: Time-series data
- `hive_payment_analysis.csv`: Payment preferences
- `hive_satisfaction_analysis.csv`: Quality metrics

**Real Hive Connection** (Production):
```r
library(RJDBC)
drv <- JDBC("org.apache.hive.jdbc.HiveDriver", 
            "/path/to/hive-jdbc-x.x.x.jar")
conn <- dbConnect(drv, 
                  "jdbc:hive2://hive-server:10000/default",
                  "username", "password")
result <- dbGetQuery(conn, "SELECT * FROM sales_data WHERE category='Electronics'")
dbDisconnect(conn)
```

### 3. HBase Storage Module (`hbase_storage.R`)

**Purpose**: Simulate Apache HBase NoSQL operations

**Architecture**:
```
HBase Module
├── Table Management
│   ├── init_hbase_table()
│   └── HBaseTable object
├── CRUD Operations
│   ├── hbase_put() - Insert
│   ├── hbase_get() - Retrieve
│   └── hbase_scan() - Range scan
├── Data Models
│   ├── Customer Profiles Table
│   └── Product Inventory Table
└── Analytics Layer
    └── query_hbase_data()
```

**HBase Table Design**:

**Table 1: customer_profiles**
```
Row Key: customer_XXXXX (zero-padded customer ID)

Column Families:
┌─────────────────────────────────────────────────────────┐
│ profile:                                                │
│   - total_orders                                        │
│   - total_spent                                         │
│   - avg_order_value                                     │
├─────────────────────────────────────────────────────────┤
│ preferences:                                            │
│   - favorite_category                                   │
│   - preferred_payment                                   │
├─────────────────────────────────────────────────────────┤
│ metrics:                                                │
│   - avg_satisfaction                                    │
│   - first_order_date                                    │
│   - last_order_date                                     │
└─────────────────────────────────────────────────────────┘
```

**Table 2: product_inventory**
```
Row Key: product_XXXXX (sequential product ID)

Column Families:
┌─────────────────────────────────────────────────────────┐
│ info:                                                   │
│   - category                                            │
│   - name                                                │
├─────────────────────────────────────────────────────────┤
│ sales:                                                  │
│   - times_sold                                          │
│   - total_quantity                                      │
│   - revenue                                             │
│   - avg_price                                           │
│   - avg_satisfaction                                    │
└─────────────────────────────────────────────────────────┘
```

**HBase Operations**:
1. **PUT**: Store key-value pairs with column families
2. **GET**: Retrieve row by key
3. **SCAN**: Iterate over key ranges

**Design Patterns**:
- Row key design for efficient scans
- Column family organization for query patterns
- Denormalization for read performance
- Time-series data handling

**Real HBase Connection** (Production):
```r
library(rhbase)
hb.init()

# Create table
hb.new.table("customer_profiles", "profile", "preferences", "metrics")

# Put operation
hb.put("customer_profiles", "customer_00001", "profile", "total_orders", "15")

# Get operation
result <- hb.get("customer_profiles", "customer_00001")

# Scan operation
scan_result <- hb.scan("customer_profiles", 
                       start="customer_00001", 
                       end="customer_00100")
```

### 4. Visualization Module (`visualization.R`)

**Purpose**: Create publication-quality data visualizations

**Architecture**:
```
Visualization Module
├── Hive Visualizations
│   ├── Category Sales (Bar Chart)
│   ├── Regional Distribution (Pie Chart)
│   ├── Monthly Trends (Line Chart)
│   ├── Payment Methods (Bar Chart)
│   └── Satisfaction Analysis (Bar Chart)
├── HBase Visualizations
│   ├── Customer Segments (Bar Chart)
│   ├── Top Products (Bar Chart)
│   └── Customer Behavior (Scatter Plot)
└── Dashboard Creation
    └── Combined Multi-Plot Layout
```

**Plot Specifications**:
- Resolution: 300 DPI (publication quality)
- Format: PNG
- Color schemes: ColorBrewer palettes
- Theme: Minimal, clean design
- Labels: Formatted with scales package

**Visualization Types**:

1. **Bar Charts**: Categorical comparisons
2. **Pie Charts**: Proportion visualization
3. **Line Charts**: Time-series trends
4. **Scatter Plots**: Correlation analysis
5. **Dashboards**: Multi-plot layouts

**ggplot2 Layers**:
```r
ggplot(data, aes(x, y)) +          # Data + aesthetics
  geom_*() +                        # Geometric objects
  labs() +                          # Labels
  theme_*() +                       # Theme
  scale_*()                         # Scale transformations
```

## Data Flow

```
1. Data Generation
   ↓
   sales_data.csv (1000 records)
   ↓
2. Parallel Processing
   ├─→ Hive Processing ─→ Aggregations (CSV)
   └─→ HBase Storage ─→ Profiles (CSV)
   ↓
3. Visualization
   ↓
   8 Plots + 1 Dashboard (PNG)
```

## Performance Characteristics

### Data Processing
- **Data Generation**: O(n) - Linear in number of records
- **Hive Aggregations**: O(n log n) - Due to sorting operations
- **HBase Storage**: O(n*m) - n records, m attributes per record
- **Visualizations**: O(n) - Linear in data points

### Memory Usage
- **Small Dataset (1000 records)**: ~5 MB
- **Medium Dataset (10,000 records)**: ~50 MB
- **Large Dataset (100,000 records)**: ~500 MB

### Execution Time (Approximate)
- Data Generation: 1-2 seconds
- Hive Processing: 2-3 seconds
- HBase Storage: 3-5 seconds
- Visualizations: 10-15 seconds
- **Total**: 30-60 seconds

## Scalability Considerations

### Current Implementation (Simulated)
- ✅ Works with in-memory data frames
- ✅ Fast for datasets up to 100K records
- ❌ Limited by R memory constraints

### Production Implementation (Real Hadoop)
- ✅ Scales to billions of records
- ✅ Distributed processing across cluster
- ✅ Fault tolerance and replication
- ✅ Parallel query execution

## Extension Points

### Adding More Hadoop Components

1. **HDFS Integration**:
```r
library(rhdfs)
hdfs.init()
hdfs.put("local_file.csv", "/hadoop/path/file.csv")
```

2. **Spark Integration**:
```r
library(SparkR)
sparkR.session()
df <- read.df("sales_data.csv", "csv", header="true")
```

3. **Pig Integration**:
```r
# Execute Pig scripts via system calls
system("pig -f analysis.pig")
```

### Custom Analytics

Add new modules in `scripts/` directory:
- `scripts/custom_analysis.R`
- Source in `main.R`
- Follow existing module patterns

## Testing Strategy

### Unit Testing
```r
# Test individual functions
source("scripts/hive_processing.R")
test_data <- data.frame(...)
result <- perform_hive_aggregations(test_data)
stopifnot(nrow(result) > 0)
```

### Integration Testing
```r
# Test full pipeline
source("main.R")
results <- main()
stopifnot(file.exists("outputs/plots/0_dashboard.png"))
```

## Error Handling

Each module includes:
- Input validation
- Try-catch blocks for external operations
- Informative error messages
- Graceful degradation

Example:
```r
tryCatch({
  result <- risky_operation()
}, error = function(e) {
  cat("Error:", e$message, "\n")
  return(default_value)
})
```

## Dependencies

### R Packages
- **Core**: dplyr, tidyr (data manipulation)
- **Visualization**: ggplot2, scales, gridExtra
- **Database**: DBI, RJDBC (optional for real Hive)
- **HBase**: rhbase (optional for real HBase)

### System Requirements
- R >= 4.0.0
- RAM: 4GB minimum, 8GB recommended
- Storage: 500MB for project + outputs

## Best Practices Implemented

1. **Modular Design**: Separate files for each component
2. **DRY Principle**: Reusable functions
3. **Documentation**: Inline comments and README files
4. **Version Control**: Git-friendly structure
5. **Reproducibility**: Fixed random seeds
6. **Error Handling**: Robust error checking
7. **Clean Code**: Consistent formatting and naming

## Future Enhancements

1. **Real Hadoop Integration**:
   - RJDBC connection to Hive
   - rhbase connection to HBase
   - HDFS file operations

2. **Interactive Dashboard**:
   - Shiny web application
   - Real-time data updates
   - User-driven filters

3. **Machine Learning**:
   - Customer segmentation with clustering
   - Sales forecasting with time-series models
   - Product recommendations

4. **Performance Optimization**:
   - Parallel processing with foreach
   - Data.table for faster operations
   - Caching intermediate results

## References

- [Hadoop Documentation](https://hadoop.apache.org/docs/)
- [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual)
- [HBase Book](https://hbase.apache.org/book.html)
- [R for Data Science](https://r4ds.had.co.nz/)
- [ggplot2 Book](https://ggplot2-book.org/)
