#!/usr/bin/env Rscript

# Main Execution Script for Hadoop Ecosystem R Project
# This script orchestrates the entire data pipeline:
# 1. Generate sample data
# 2. Process with Hive (data warehousing)
# 3. Store in HBase (NoSQL storage)
# 4. Create visualizations

cat("╔════════════════════════════════════════════════════════════════╗\n")
cat("║   E-Commerce Analytics using Hadoop Ecosystem with R          ║\n")
cat("║   Components: Apache Hive + Apache HBase                      ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

# Set working directory to script location
if (sys.nframe() == 0) {
  script_dir <- dirname(normalizePath(sys.frame(1)$ofile, mustWork = FALSE))
  if (script_dir != "") {
    setwd(script_dir)
  }
}

# Load required libraries
cat("Loading required libraries...\n")
suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})
cat("Libraries loaded successfully!\n\n")

# Source all modules
cat("Loading project modules...\n")
source("scripts/hive_processing.R")
source("scripts/hbase_storage.R")
source("scripts/visualization.R")
cat("Modules loaded successfully!\n\n")

#' Main execution function
main <- function() {
  
  # Step 1: Generate sample data
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("STEP 1: DATA GENERATION\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  
  # Check if data already exists
  data_file <- "data/sales_data.csv"
  
  if (file.exists(data_file)) {
    cat("Data file already exists. Loading existing data...\n")
    sales_data <- read.csv(data_file, stringsAsFactors = FALSE)
    sales_data$order_date <- as.Date(sales_data$order_date)
  } else {
    cat("Generating new sales data...\n")
    source("scripts/generate_data.R")
    sales_data <- read.csv(data_file, stringsAsFactors = FALSE)
    sales_data$order_date <- as.Date(sales_data$order_date)
  }
  
  cat(paste("\nDataset loaded:", nrow(sales_data), "records\n"))
  
  # Step 2: Process with Hive
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("STEP 2: HIVE DATA PROCESSING (Data Warehousing)\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  
  hive_results <- process_with_hive(data_file)
  
  # Step 3: Store in HBase
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("STEP 3: HBASE DATA STORAGE (NoSQL Storage)\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  
  hbase_results <- process_with_hbase(sales_data)
  
  # Step 4: Create visualizations
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("STEP 4: DATA VISUALIZATION\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  
  visualizations <- create_all_visualizations(hive_results, hbase_results)
  
  # Generate final report
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("EXECUTION SUMMARY\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  
  cat("\n✓ Data Generated:\n")
  cat(paste("  - Records processed:", nrow(sales_data), "\n"))
  cat(paste("  - Date range:", min(sales_data$order_date), "to", max(sales_data$order_date), "\n"))
  cat(paste("  - Total revenue: $", format(sum(sales_data$total_amount), big.mark = ","), "\n"))
  
  cat("\n✓ Hive Processing (Data Warehousing):\n")
  cat(paste("  - Category aggregations:", nrow(hive_results$category_sales), "categories\n"))
  cat(paste("  - Regional analysis:", nrow(hive_results$region_sales), "regions\n"))
  cat(paste("  - Monthly trends:", nrow(hive_results$monthly_sales), "months\n"))
  cat(paste("  - Payment methods:", nrow(hive_results$payment_analysis), "methods\n"))
  
  cat("\n✓ HBase Storage (NoSQL Database):\n")
  cat(paste("  - Customer profiles stored:", nrow(hbase_results$customer_data$profiles), "customers\n"))
  cat(paste("  - Product records stored:", nrow(hbase_results$product_data$inventory), "products\n"))
  cat(paste("  - Customer segments:", nrow(hbase_results$segments), "segments\n"))
  cat(paste("  - Total HBase records:", 
            hbase_results$customer_data$table$row_count + 
            hbase_results$product_data$table$row_count, "\n"))
  
  cat("\n✓ Visualizations Created:\n")
  cat("  - 8 individual plots generated\n")
  cat("  - 1 combined dashboard created\n")
  cat("  - Location: outputs/plots/\n")
  
  cat("\n✓ Output Files Generated:\n")
  output_files <- list.files("outputs", pattern = "\\.csv$", full.names = FALSE)
  for (file in output_files) {
    cat(paste("  - outputs/", file, "\n", sep = ""))
  }
  
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("PROJECT EXECUTION COMPLETED SUCCESSFULLY!\n")
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("\nTo view the visualizations, check the outputs/plots/ directory.\n")
  cat("To view the processed data, check the outputs/ directory.\n\n")
  
  # Return results for interactive use
  invisible(list(
    sales_data = sales_data,
    hive_results = hive_results,
    hbase_results = hbase_results,
    visualizations = visualizations
  ))
}

# Execute main function
if (sys.nframe() == 0) {
  tryCatch({
    results <- main()
  }, error = function(e) {
    cat("\n❌ ERROR during execution:\n")
    cat(paste("  ", e$message, "\n"))
    cat("\nPlease ensure all required packages are installed.\n")
    cat("Run: source('install_packages.R')\n\n")
  })
}
