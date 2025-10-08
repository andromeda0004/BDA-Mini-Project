# E-Commerce Analytics using Hadoop Ecosystem with R

A comprehensive Big Data Analytics project that demonstrates the integration of **Apache Hive** and **Apache HBase** (two key Hadoop ecosystem components) with **R programming** for data processing, storage, and visualization.

## 📋 Project Overview

This project simulates a complete big data analytics pipeline for e-commerce sales data:

1. **Data Generation**: Creates a realistic e-commerce sales dataset (1000 records)
2. **Hive Processing**: Performs SQL-like data warehousing operations for analytics
3. **HBase Storage**: Implements NoSQL storage for customer profiles and product inventory
4. **Data Visualization**: Creates 8 publication-quality plots using ggplot2

### Hadoop Ecosystem Components Used

1. **Apache Hive** - Data warehousing and SQL-like queries
   - Category-wise sales aggregation
   - Regional sales analysis
   - Monthly trends analysis
   - Payment method distribution
   - Customer satisfaction metrics

2. **Apache HBase** - NoSQL columnar database
   - Customer profile storage (column families: profile, preferences, metrics)
   - Product inventory management
   - Customer segmentation
   - Key-value operations (PUT, GET, SCAN)

## 🏗️ Project Structure

```
BDA-Mini-Project/
│
├── main.R                      # Main execution script
├── install_packages.R          # Package installation script
│
├── scripts/
│   ├── generate_data.R         # Data generation script
│   ├── hive_processing.R       # Hive operations module
│   ├── hbase_storage.R         # HBase operations module
│   └── visualization.R         # Visualization module
│
├── data/
│   └── sales_data.csv          # Generated sales dataset
│
├── outputs/
│   ├── hive_*.csv              # Hive query results
│   ├── hbase_*.csv             # HBase storage results
│   └── plots/                  # Generated visualizations
│       ├── 0_dashboard.png     # Combined dashboard
│       ├── 1_category_sales.png
│       ├── 2_region_sales.png
│       ├── 3_monthly_trend.png
│       ├── 4_payment_methods.png
│       ├── 5_satisfaction.png
│       ├── 6_customer_segments.png
│       ├── 7_top_products.png
│       └── 8_customer_behavior.png
│
└── README.md                   # This file
```

## 🔧 Prerequisites

### System Requirements

- **Operating System**: Linux, macOS, or Windows
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: At least 500MB free space

### Software Requirements

1. **R** (version 4.0.0 or higher)
2. **RStudio** (optional, but recommended for interactive development)

## 📦 Installation Instructions

### Step 1: Install R

#### On Ubuntu/Debian Linux:
```bash
# Update package list
sudo apt update

# Install R
sudo apt install -y r-base r-base-dev

# Verify installation
R --version
```

#### On CentOS/RHEL/Fedora Linux:
```bash
# Install EPEL repository (CentOS/RHEL)
sudo yum install -y epel-release

# Install R
sudo yum install -y R

# Verify installation
R --version
```

#### On macOS:
```bash
# Using Homebrew
brew install r

# Or download from: https://cran.r-project.org/bin/macosx/
```

#### On Windows:
1. Download R from: https://cran.r-project.org/bin/windows/base/
2. Run the installer
3. Add R to PATH during installation

### Step 2: Install RStudio (Optional)
Download from: https://posit.co/download/rstudio-desktop/

### Step 3: Clone/Download the Project

```bash
# If using Git
git clone <repository-url>
cd BDA-Mini-Project

# Or download and extract the ZIP file
```

### Step 4: Install Required R Packages

```bash
# Run the package installation script
Rscript install_packages.R
```

This will automatically install all required packages:
- `dplyr` - Data manipulation
- `ggplot2` - Data visualization
- `tidyr` - Data tidying
- `scales` - Scale formatting
- `gridExtra` - Multiple plots
- `DBI` - Database interface
- `RJDBC` - JDBC connectivity (for actual Hive connection)

## 🚀 Running the Project

### Method 1: Command Line (Recommended)

```bash
# Navigate to project directory
cd BDA-Mini-Project

# Run the main script
Rscript main.R
```

### Method 2: RStudio

1. Open RStudio
2. Set working directory: `Session > Set Working Directory > Choose Directory`
3. Navigate to the project folder
4. Open `main.R`
5. Click "Source" or press `Ctrl+Shift+S` (Windows/Linux) or `Cmd+Shift+S` (macOS)

### Method 3: R Console

```r
# Start R
R

# Set working directory
setwd("/path/to/BDA-Mini-Project")

# Run main script
source("main.R")
```

### Method 4: Run Individual Components

```r
# Generate data only
source("scripts/generate_data.R")

# Process with Hive
source("scripts/hive_processing.R")
results <- process_with_hive("data/sales_data.csv")

# Store in HBase
source("scripts/hbase_storage.R")
sales_data <- read.csv("data/sales_data.csv")
hbase_results <- process_with_hbase(sales_data)

# Create visualizations
source("scripts/visualization.R")
create_all_visualizations(results, hbase_results)
```

## 📊 Expected Output

When you run the project, you will see:

1. **Console Output**:
   - Step-by-step execution logs
   - Data statistics and summaries
   - Processing confirmations
   - Final execution summary

2. **Generated Files**:
   - **data/sales_data.csv**: 1000 sales records
   - **outputs/hive_*.csv**: 5 Hive aggregation results
   - **outputs/hbase_*.csv**: 5 HBase storage results
   - **outputs/plots/*.png**: 9 visualization files

3. **Visualizations**:
   - Sales by product category (bar chart)
   - Regional sales distribution (pie chart)
   - Monthly sales trends (line chart)
   - Payment method preferences (bar chart)
   - Customer satisfaction analysis (bar chart)
   - Customer segmentation (bar chart)
   - Top products by revenue (bar chart)
   - Customer spending behavior (scatter plot)
   - Combined dashboard (grid layout)

## 🔍 Understanding the Components

### 1. Hive Processing (`hive_processing.R`)

Simulates Apache Hive data warehousing operations:

- **What it does**: Performs SQL-like aggregations and analytics
- **Real-world equivalent**: In production, this would connect to a Hive server using RJDBC
- **Operations demonstrated**:
  - GROUP BY aggregations
  - Time-series analysis
  - Statistical calculations
  - Multi-dimensional analytics

**To connect to actual Hive** (requires Hive server):
```r
library(RJDBC)
drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/path/to/hive-jdbc.jar")
conn <- dbConnect(drv, "jdbc:hive2://localhost:10000/default")
data <- dbGetQuery(conn, "SELECT * FROM sales_data")
```

### 2. HBase Storage (`hbase_storage.R`)

Simulates Apache HBase NoSQL operations:

- **What it does**: Implements key-value storage with column families
- **Real-world equivalent**: In production, this would connect to HBase using rhbase or REST API
- **Operations demonstrated**:
  - PUT: Insert data with row key and column families
  - GET: Retrieve specific row by key
  - SCAN: Scan range of rows
  - Column family structure

**HBase Table Structure**:
```
customer_profiles table:
  Row Key: customer_00001
  Column Families:
    - profile: total_orders, total_spent, avg_order_value
    - preferences: favorite_category, preferred_payment
    - metrics: avg_satisfaction, first_order_date, last_order_date

product_inventory table:
  Row Key: product_00001
  Column Families:
    - info: category, name
    - sales: times_sold, total_quantity, revenue, avg_price, avg_satisfaction
```

### 3. Visualization (`visualization.R`)

Creates professional data visualizations using ggplot2:

- 8 individual plot types
- Combined dashboard
- Publication-quality graphics (300 DPI)
- Color-coded by category/segment

## 🌐 Running on Different Machines

### For Other Users to Run Your Project

1. **Share the Project**:
   ```bash
   # Create a ZIP of the project (excluding outputs)
   zip -r BDA-Mini-Project.zip BDA-Mini-Project/ -x "*/outputs/*" "*.git*"
   ```

2. **Recipient Instructions**:
   - Install R (see Installation Instructions above)
   - Extract the ZIP file
   - Navigate to project directory
   - Run: `Rscript install_packages.R`
   - Run: `Rscript main.R`

### Docker Deployment (Optional)

Create a `Dockerfile`:
```dockerfile
FROM r-base:4.3.0

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Copy project files
COPY . /app

# Install R packages
RUN Rscript install_packages.R

# Run the project
CMD ["Rscript", "main.R"]
```

Build and run:
```bash
docker build -t hadoop-r-project .
docker run -v $(pwd)/outputs:/app/outputs hadoop-r-project
```

## 🐛 Troubleshooting

### Issue: "Rscript: command not found"
**Solution**: R is not installed or not in PATH. Install R and add to PATH.

### Issue: Package installation fails
**Solution**: 
```bash
# Install system dependencies (Ubuntu/Debian)
sudo apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev

# Then retry package installation
Rscript install_packages.R
```

### Issue: "Cannot open file 'main.R'"
**Solution**: Ensure you're in the correct directory:
```bash
pwd  # Should show /path/to/BDA-Mini-Project
ls   # Should show main.R and other files
```

### Issue: Plots not generated
**Solution**: Check if the outputs/plots directory exists and has write permissions:
```bash
mkdir -p outputs/plots
chmod 755 outputs/plots
```

### Issue: Memory error with large datasets
**Solution**: Increase R memory limit:
```r
# At the beginning of main.R
memory.limit(size = 8000)  # Windows
# Or use smaller dataset
```

## 📚 Key Concepts Demonstrated

1. **Data Warehousing (Hive)**:
   - OLAP operations
   - Dimensional modeling
   - Aggregation functions
   - Time-series analysis

2. **NoSQL Storage (HBase)**:
   - Row-key design
   - Column family structure
   - Key-value operations
   - Denormalization strategies

3. **Data Visualization**:
   - Grammar of graphics (ggplot2)
   - Multiple plot types
   - Dashboard creation
   - Data storytelling

4. **R Programming**:
   - Modular code structure
   - Function composition
   - Data pipeline orchestration
   - Error handling

## 📝 Sample Output

After running `Rscript main.R`, you'll see:

```
╔════════════════════════════════════════════════════════════════╗
║   E-Commerce Analytics using Hadoop Ecosystem with R          ║
║   Components: Apache Hive + Apache HBase                      ║
╚════════════════════════════════════════════════════════════════╝

Loading required libraries...
Libraries loaded successfully!

Loading project modules...
Modules loaded successfully!

═══════════════════════════════════════════════════════════════
STEP 1: DATA GENERATION
═══════════════════════════════════════════════════════════════
Dataset generated successfully!
Number of records: 1000

═══════════════════════════════════════════════════════════════
STEP 2: HIVE DATA PROCESSING (Data Warehousing)
═══════════════════════════════════════════════════════════════
Performing Hive Aggregations...
[... processing logs ...]

═══════════════════════════════════════════════════════════════
STEP 3: HBASE DATA STORAGE (NoSQL Storage)
═══════════════════════════════════════════════════════════════
Storing Customer Profiles in HBase...
[... storage logs ...]

═══════════════════════════════════════════════════════════════
STEP 4: DATA VISUALIZATION
═══════════════════════════════════════════════════════════════
Creating visualizations...
[... visualization logs ...]

═══════════════════════════════════════════════════════════════
PROJECT EXECUTION COMPLETED SUCCESSFULLY!
═══════════════════════════════════════════════════════════════
```

## 🎓 Learning Outcomes

By running and studying this project, you'll understand:

- How Hive provides SQL-like interface for big data analytics
- How HBase stores data in a columnar NoSQL format
- Integration of Hadoop ecosystem with R
- Real-world data pipeline architecture
- Data visualization best practices

## 📖 References

- [Apache Hive Documentation](https://hive.apache.org/)
- [Apache HBase Documentation](https://hbase.apache.org/)
- [R for Data Science](https://r4ds.had.co.nz/)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)

## 👥 Author

Created as a demonstration of Hadoop ecosystem integration with R for Big Data Analytics.

## 📄 License

This project is for educational purposes.

---

**Note**: This project simulates Hive and HBase operations. For production use with actual Hadoop clusters, you would need:
- RJDBC package and Hive JDBC driver for Hive connectivity
- rhbase package or REST API for HBase connectivity
- Proper cluster configuration and authentication
