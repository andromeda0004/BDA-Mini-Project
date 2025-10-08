# Data Visualization Module
# Creates comprehensive visualizations from Hive and HBase results

library(ggplot2)
library(dplyr)
library(gridExtra)
library(scales)

cat("=== DATA VISUALIZATION MODULE ===\n\n")

#' Create visualizations from Hive results
create_hive_visualizations <- function(hive_results, output_dir = "outputs") {
  cat("Creating visualizations from Hive results...\n")
  
  plots <- list()
  
  # Plot 1: Sales by Product Category
  cat("1. Creating category sales bar chart...\n")
  p1 <- ggplot(hive_results$category_sales, 
               aes(x = reorder(product_category, -total_sales), y = total_sales)) +
    geom_bar(stat = "identity", fill = "#2E86AB") +
    geom_text(aes(label = paste0("$", format(round(total_sales), big.mark = ","))), 
              vjust = -0.5, size = 3) +
    labs(title = "Total Sales by Product Category",
         subtitle = "Hive Aggregation Results",
         x = "Product Category",
         y = "Total Sales ($)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "bold", size = 14),
          plot.subtitle = element_text(color = "gray40")) +
    scale_y_continuous(labels = dollar_format())
  
  plots$category_sales <- p1
  
  # Plot 2: Regional Sales Distribution
  cat("2. Creating regional sales pie chart...\n")
  p2 <- ggplot(hive_results$region_sales, 
               aes(x = "", y = total_sales, fill = region)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y", start = 0) +
    geom_text(aes(label = paste0(region, "\n$", 
                                 format(round(total_sales), big.mark = ","))),
              position = position_stack(vjust = 0.5), size = 3) +
    labs(title = "Sales Distribution by Region",
         subtitle = "Hive Aggregation Results") +
    theme_void() +
    theme(plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
          plot.subtitle = element_text(color = "gray40", hjust = 0.5),
          legend.position = "right") +
    scale_fill_brewer(palette = "Set2")
  
  plots$region_sales <- p2
  
  # Plot 3: Monthly Sales Trend
  cat("3. Creating monthly sales trend line chart...\n")
  p3 <- ggplot(hive_results$monthly_sales, 
               aes(x = month, y = total_sales, group = 1)) +
    geom_line(color = "#A23B72", size = 1.2) +
    geom_point(color = "#A23B72", size = 3) +
    geom_smooth(method = "loess", se = TRUE, color = "#F18F01", linetype = "dashed") +
    labs(title = "Monthly Sales Trend",
         subtitle = "Hive Time-Series Analysis",
         x = "Month",
         y = "Total Sales ($)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "bold", size = 14),
          plot.subtitle = element_text(color = "gray40")) +
    scale_y_continuous(labels = dollar_format())
  
  plots$monthly_trend <- p3
  
  # Plot 4: Payment Method Analysis
  cat("4. Creating payment method comparison...\n")
  p4 <- ggplot(hive_results$payment_analysis, 
               aes(x = reorder(payment_method, -total_orders), y = total_orders)) +
    geom_bar(stat = "identity", fill = "#06A77D") +
    geom_text(aes(label = paste0(round(percentage_of_orders, 1), "%")), 
              vjust = -0.5, size = 3.5, fontface = "bold") +
    labs(title = "Payment Method Preferences",
         subtitle = "Order Count and Percentage Distribution",
         x = "Payment Method",
         y = "Number of Orders") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "bold", size = 14),
          plot.subtitle = element_text(color = "gray40"))
  
  plots$payment_methods <- p4
  
  # Plot 5: Customer Satisfaction by Category
  cat("5. Creating satisfaction analysis chart...\n")
  p5 <- ggplot(hive_results$satisfaction_analysis, 
               aes(x = reorder(product_category, -avg_satisfaction), 
                   y = avg_satisfaction)) +
    geom_bar(stat = "identity", fill = "#FF6B35") +
    geom_hline(yintercept = mean(hive_results$satisfaction_analysis$avg_satisfaction),
               linetype = "dashed", color = "red", size = 1) +
    geom_text(aes(label = round(avg_satisfaction, 2)), 
              vjust = -0.5, size = 3) +
    labs(title = "Average Customer Satisfaction by Category",
         subtitle = "Red line indicates overall average",
         x = "Product Category",
         y = "Average Satisfaction Score (1-5)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "bold", size = 14),
          plot.subtitle = element_text(color = "gray40")) +
    ylim(0, 5)
  
  plots$satisfaction <- p5
  
  return(plots)
}

#' Create visualizations from HBase results
create_hbase_visualizations <- function(hbase_results, output_dir = "outputs") {
  cat("\nCreating visualizations from HBase results...\n")
  
  plots <- list()
  
  # Plot 6: Customer Segmentation
  cat("6. Creating customer segmentation chart...\n")
  p6 <- ggplot(hbase_results$segments, 
               aes(x = segment, y = customer_count, fill = segment)) +
    geom_bar(stat = "identity", width = 0.7) +
    geom_text(aes(label = paste0(customer_count, " customers\n",
                                 "$", format(round(avg_total_spent), big.mark = ","), " avg")),
              vjust = -0.2, size = 3.5) +
    labs(title = "Customer Segmentation",
         subtitle = "HBase Customer Profile Analysis",
         x = "Customer Segment",
         y = "Number of Customers") +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 14),
          plot.subtitle = element_text(color = "gray40"),
          legend.position = "none") +
    scale_fill_manual(values = c("Premium" = "#FFD700", 
                                 "Regular" = "#C0C0C0", 
                                 "Occasional" = "#CD7F32"))
  
  plots$segments <- p6
  
  # Plot 7: Top Products by Revenue
  cat("7. Creating top products chart...\n")
  top_products <- head(hbase_results$product_data$inventory, 10)
  
  p7 <- ggplot(top_products, 
               aes(x = reorder(paste0(substr(product_name, 1, 15), "..."), 
                              -total_revenue), 
                   y = total_revenue, fill = product_category)) +
    geom_bar(stat = "identity") +
    labs(title = "Top 10 Products by Revenue",
         subtitle = "HBase Product Inventory Analysis",
         x = "Product",
         y = "Total Revenue ($)",
         fill = "Category") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "bold", size = 14),
          plot.subtitle = element_text(color = "gray40")) +
    scale_y_continuous(labels = dollar_format()) +
    scale_fill_brewer(palette = "Set3")
  
  plots$top_products <- p7
  
  # Plot 8: Customer Spending vs Orders
  cat("8. Creating customer behavior scatter plot...\n")
  customer_sample <- hbase_results$customer_data$profiles
  
  p8 <- ggplot(customer_sample, 
               aes(x = total_orders, y = total_spent, color = avg_satisfaction)) +
    geom_point(alpha = 0.6, size = 3) +
    geom_smooth(method = "lm", se = TRUE, color = "blue", linetype = "dashed") +
    labs(title = "Customer Spending Behavior",
         subtitle = "HBase Customer Profile Analysis",
         x = "Total Orders",
         y = "Total Spent ($)",
         color = "Avg Satisfaction") +
    theme_minimal() +
    theme(plot.title = element_text(face = "bold", size = 14),
          plot.subtitle = element_text(color = "gray40")) +
    scale_y_continuous(labels = dollar_format()) +
    scale_color_gradient(low = "#FFA07A", high = "#20B2AA")
  
  plots$customer_behavior <- p8
  
  return(plots)
}

#' Save all plots
save_visualizations <- function(hive_plots, hbase_plots, output_dir = "outputs") {
  cat("\n--- Saving Visualizations ---\n")
  
  # Create plots directory
  plots_dir <- file.path(output_dir, "plots")
  if (!dir.exists(plots_dir)) {
    dir.create(plots_dir, recursive = TRUE)
  }
  
  # Save Hive plots
  ggsave(file.path(plots_dir, "1_category_sales.png"), 
         hive_plots$category_sales, width = 10, height = 6, dpi = 300)
  cat("Saved: 1_category_sales.png\n")
  
  ggsave(file.path(plots_dir, "2_region_sales.png"), 
         hive_plots$region_sales, width = 8, height = 6, dpi = 300)
  cat("Saved: 2_region_sales.png\n")
  
  ggsave(file.path(plots_dir, "3_monthly_trend.png"), 
         hive_plots$monthly_trend, width = 12, height = 6, dpi = 300)
  cat("Saved: 3_monthly_trend.png\n")
  
  ggsave(file.path(plots_dir, "4_payment_methods.png"), 
         hive_plots$payment_methods, width = 8, height = 6, dpi = 300)
  cat("Saved: 4_payment_methods.png\n")
  
  ggsave(file.path(plots_dir, "5_satisfaction.png"), 
         hive_plots$satisfaction, width = 10, height = 6, dpi = 300)
  cat("Saved: 5_satisfaction.png\n")
  
  # Save HBase plots
  ggsave(file.path(plots_dir, "6_customer_segments.png"), 
         hbase_plots$segments, width = 8, height = 6, dpi = 300)
  cat("Saved: 6_customer_segments.png\n")
  
  ggsave(file.path(plots_dir, "7_top_products.png"), 
         hbase_plots$top_products, width = 10, height = 6, dpi = 300)
  cat("Saved: 7_top_products.png\n")
  
  ggsave(file.path(plots_dir, "8_customer_behavior.png"), 
         hbase_plots$customer_behavior, width = 10, height = 6, dpi = 300)
  cat("Saved: 8_customer_behavior.png\n")
  
  # Create a combined dashboard
  cat("\nCreating combined dashboard...\n")
  dashboard <- grid.arrange(
    hive_plots$category_sales,
    hive_plots$region_sales,
    hbase_plots$segments,
    hbase_plots$customer_behavior,
    ncol = 2,
    top = "E-Commerce Analytics Dashboard\nHadoop Ecosystem (Hive + HBase) with R"
  )
  
  ggsave(file.path(plots_dir, "0_dashboard.png"), 
         dashboard, width = 16, height = 12, dpi = 300)
  cat("Saved: 0_dashboard.png\n")
  
  cat(paste("\nAll visualizations saved to:", plots_dir, "\n"))
}

#' Main visualization function
create_all_visualizations <- function(hive_results, hbase_results, output_dir = "outputs") {
  cat("Starting visualization creation...\n\n")
  
  # Create Hive visualizations
  hive_plots <- create_hive_visualizations(hive_results, output_dir)
  
  # Create HBase visualizations
  hbase_plots <- create_hbase_visualizations(hbase_results, output_dir)
  
  # Save all plots
  save_visualizations(hive_plots, hbase_plots, output_dir)
  
  cat("\nVisualization creation complete!\n")
  
  return(list(
    hive_plots = hive_plots,
    hbase_plots = hbase_plots
  ))
}

# Note: This script is designed to be sourced by main.R
