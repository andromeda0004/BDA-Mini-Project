# HBase Data Storage Module
# This script simulates HBase operations using R for NoSQL-style data storage
# In production, this would connect to actual HBase

library(dplyr)

cat("=== HBASE DATA STORAGE MODULE ===\n\n")

# Configuration
HBASE_SIMULATED <- TRUE  # Set to FALSE if you have actual HBase connection

#' HBase Table Class (Simulated)
#' Simulates basic HBase operations: PUT, GET, SCAN
HBaseTable <- list()

#' Initialize simulated HBase table
init_hbase_table <- function(table_name) {
  cat(paste("Initializing HBase table:", table_name, "\n"))
  
  if (HBASE_SIMULATED) {
    # Simulated in-memory table
    table <- list(
      name = table_name,
      data = data.frame(),
      row_count = 0
    )
    cat("HBase table initialized (simulated)\n")
  } else {
    # Actual HBase connection code
    # library(rhbase)
    # hb.init()
    # table <- hb.new.table(table_name)
  }
  
  return(table)
}

#' PUT operation - Insert data into HBase
hbase_put <- function(table, row_key, column_family, column, value) {
  # In real HBase, this would use row key, column family:qualifier structure
  new_row <- data.frame(
    row_key = row_key,
    column_family = column_family,
    column = column,
    value = value,
    timestamp = Sys.time(),
    stringsAsFactors = FALSE
  )
  
  table$data <- rbind(table$data, new_row)
  table$row_count <- table$row_count + 1
  
  return(table)
}

#' GET operation - Retrieve data from HBase by row key
hbase_get <- function(table, row_key) {
  result <- table$data[table$data$row_key == row_key, ]
  return(result)
}

#' SCAN operation - Scan range of rows
hbase_scan <- function(table, start_row = NULL, end_row = NULL) {
  if (is.null(start_row) && is.null(end_row)) {
    return(table$data)
  }
  
  # Simple scan implementation
  result <- table$data
  if (!is.null(start_row)) {
    result <- result[result$row_key >= start_row, ]
  }
  if (!is.null(end_row)) {
    result <- result[result$row_key <= end_row, ]
  }
  
  return(result)
}

#' Store customer profiles in HBase
store_customer_profiles <- function(sales_data) {
  cat("\n--- Storing Customer Profiles in HBase ---\n")
  
  # Create customer profile table
  customer_table <- init_hbase_table("customer_profiles")
  
  # Aggregate customer data
  customer_profiles <- sales_data %>%
    group_by(customer_id) %>%
    summarise(
      total_orders = n(),
      total_spent = sum(total_amount),
      avg_order_value = mean(total_amount),
      favorite_category = names(sort(table(product_category), decreasing = TRUE))[1],
      avg_satisfaction = mean(customer_satisfaction),
      preferred_payment = names(sort(table(payment_method), decreasing = TRUE))[1],
      first_order_date = min(order_date),
      last_order_date = max(order_date)
    )
  
  cat(paste("Processing", nrow(customer_profiles), "customer profiles...\n"))
  
  # Store each customer profile in HBase
  for (i in 1:nrow(customer_profiles)) {
    customer <- customer_profiles[i, ]
    row_key <- paste0("customer_", sprintf("%05d", customer$customer_id))
    
    # Store profile information (column family: profile)
    customer_table <- hbase_put(customer_table, row_key, "profile", "total_orders", 
                                customer$total_orders)
    customer_table <- hbase_put(customer_table, row_key, "profile", "total_spent", 
                                customer$total_spent)
    customer_table <- hbase_put(customer_table, row_key, "profile", "avg_order_value", 
                                customer$avg_order_value)
    
    # Store preferences (column family: preferences)
    customer_table <- hbase_put(customer_table, row_key, "preferences", "favorite_category", 
                                customer$favorite_category)
    customer_table <- hbase_put(customer_table, row_key, "preferences", "preferred_payment", 
                                customer$preferred_payment)
    
    # Store metrics (column family: metrics)
    customer_table <- hbase_put(customer_table, row_key, "metrics", "avg_satisfaction", 
                                customer$avg_satisfaction)
    customer_table <- hbase_put(customer_table, row_key, "metrics", "first_order_date", 
                                as.character(customer$first_order_date))
    customer_table <- hbase_put(customer_table, row_key, "metrics", "last_order_date", 
                                as.character(customer$last_order_date))
  }
  
  cat(paste("Stored", customer_table$row_count, "records in HBase\n"))
  
  return(list(
    table = customer_table,
    profiles = customer_profiles
  ))
}

#' Store product inventory in HBase
store_product_inventory <- function(sales_data) {
  cat("\n--- Storing Product Inventory in HBase ---\n")
  
  # Create product inventory table
  product_table <- init_hbase_table("product_inventory")
  
  # Aggregate product data
  product_inventory <- sales_data %>%
    group_by(product_category, product_name) %>%
    summarise(
      times_sold = n(),
      total_quantity_sold = sum(quantity),
      total_revenue = sum(total_amount),
      avg_price = mean(unit_price),
      avg_satisfaction = mean(customer_satisfaction)
    ) %>%
    arrange(desc(total_revenue))
  
  cat(paste("Processing", nrow(product_inventory), "product records...\n"))
  
  # Store top 100 products in HBase
  top_products <- head(product_inventory, 100)
  
  for (i in 1:nrow(top_products)) {
    product <- top_products[i, ]
    row_key <- paste0("product_", sprintf("%05d", i))
    
    # Store product info (column family: info)
    product_table <- hbase_put(product_table, row_key, "info", "category", 
                               product$product_category)
    product_table <- hbase_put(product_table, row_key, "info", "name", 
                               product$product_name)
    
    # Store sales data (column family: sales)
    product_table <- hbase_put(product_table, row_key, "sales", "times_sold", 
                               product$times_sold)
    product_table <- hbase_put(product_table, row_key, "sales", "total_quantity", 
                               product$total_quantity_sold)
    product_table <- hbase_put(product_table, row_key, "sales", "revenue", 
                               product$total_revenue)
    product_table <- hbase_put(product_table, row_key, "sales", "avg_price", 
                               product$avg_price)
    product_table <- hbase_put(product_table, row_key, "sales", "avg_satisfaction", 
                               product$avg_satisfaction)
  }
  
  cat(paste("Stored", product_table$row_count, "records in HBase\n"))
  
  return(list(
    table = product_table,
    inventory = product_inventory
  ))
}

#' Query HBase data
query_hbase_data <- function(customer_data, product_data) {
  cat("\n--- Querying HBase Data ---\n")
  
  # Example GET operation
  cat("\nExample GET operation - Retrieving customer_00001:\n")
  customer_record <- hbase_get(customer_data$table, "customer_00001")
  if (nrow(customer_record) > 0) {
    print(head(customer_record))
  }
  
  # Example SCAN operation
  cat("\nExample SCAN operation - First 5 products:\n")
  product_scan <- hbase_scan(product_data$table)
  if (nrow(product_scan) > 0) {
    print(head(product_scan, 10))
  }
  
  # Customer segmentation based on HBase data
  cat("\n--- Customer Segmentation from HBase ---\n")
  customer_segments <- customer_data$profiles %>%
    mutate(
      segment = case_when(
        total_spent >= quantile(total_spent, 0.75) ~ "Premium",
        total_spent >= quantile(total_spent, 0.25) ~ "Regular",
        TRUE ~ "Occasional"
      )
    ) %>%
    group_by(segment) %>%
    summarise(
      customer_count = n(),
      avg_total_spent = mean(total_spent),
      avg_orders = mean(total_orders),
      avg_satisfaction = mean(avg_satisfaction)
    )
  
  print(customer_segments)
  
  return(customer_segments)
}

#' Save HBase results
save_hbase_results <- function(customer_data, product_data, segments, output_dir = "outputs") {
  cat("\n--- Saving HBase Results ---\n")
  
  # Save customer profiles
  write.csv(customer_data$profiles, 
            file.path(output_dir, "hbase_customer_profiles.csv"), 
            row.names = FALSE)
  cat("Saved customer profiles to hbase_customer_profiles.csv\n")
  
  # Save product inventory
  write.csv(product_data$inventory, 
            file.path(output_dir, "hbase_product_inventory.csv"), 
            row.names = FALSE)
  cat("Saved product inventory to hbase_product_inventory.csv\n")
  
  # Save customer segments
  write.csv(segments, 
            file.path(output_dir, "hbase_customer_segments.csv"), 
            row.names = FALSE)
  cat("Saved customer segments to hbase_customer_segments.csv\n")
  
  # Save raw HBase table data (for inspection)
  write.csv(customer_data$table$data, 
            file.path(output_dir, "hbase_customer_table_raw.csv"), 
            row.names = FALSE)
  write.csv(product_data$table$data, 
            file.path(output_dir, "hbase_product_table_raw.csv"), 
            row.names = FALSE)
  cat("Saved raw HBase table data\n")
}

#' Main HBase processing function
process_with_hbase <- function(sales_data) {
  cat("Starting HBase data storage and retrieval...\n\n")
  
  # Store customer profiles
  customer_data <- store_customer_profiles(sales_data)
  
  # Store product inventory
  product_data <- store_product_inventory(sales_data)
  
  # Query and analyze HBase data
  segments <- query_hbase_data(customer_data, product_data)
  
  # Save results
  save_hbase_results(customer_data, product_data, segments)
  
  cat("\nHBase processing complete!\n")
  
  results <- list(
    customer_data = customer_data,
    product_data = product_data,
    segments = segments
  )
  
  return(results)
}

# Note: This script is designed to be sourced by main.R
# To run standalone, uncomment the following:
# sales_data <- read.csv("data/sales_data.csv")
# results <- process_with_hbase(sales_data)
