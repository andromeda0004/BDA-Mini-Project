# Generate sample e-commerce sales dataset
# This script creates a realistic sales dataset for analysis

set.seed(123)  # For reproducibility

# Generate data
n_records <- 1000

# Create sample data
sales_data <- data.frame(
  order_id = 1:n_records,
  customer_id = sample(1:200, n_records, replace = TRUE),
  product_category = sample(c("Electronics", "Clothing", "Home & Garden", "Books", "Sports", "Toys"), 
                           n_records, replace = TRUE, 
                           prob = c(0.25, 0.20, 0.15, 0.15, 0.15, 0.10)),
  product_name = paste("Product", sample(1:500, n_records, replace = TRUE)),
  quantity = sample(1:10, n_records, replace = TRUE),
  unit_price = round(runif(n_records, 10, 500), 2),
  region = sample(c("North", "South", "East", "West", "Central"), 
                 n_records, replace = TRUE),
  payment_method = sample(c("Credit Card", "Debit Card", "PayPal", "Cash"), 
                         n_records, replace = TRUE),
  order_date = sample(seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"), 
                     n_records, replace = TRUE),
  shipping_cost = round(runif(n_records, 5, 25), 2),
  discount_percentage = sample(c(0, 5, 10, 15, 20), n_records, replace = TRUE, 
                               prob = c(0.4, 0.25, 0.20, 0.10, 0.05))
)

# Calculate total amount
sales_data$total_amount <- round(
  sales_data$quantity * sales_data$unit_price * (1 - sales_data$discount_percentage / 100) + 
  sales_data$shipping_cost, 
  2
)

# Add some realistic variations
sales_data$customer_satisfaction <- sample(1:5, n_records, replace = TRUE, 
                                          prob = c(0.05, 0.10, 0.20, 0.35, 0.30))

# Save to CSV
output_file <- "data/sales_data.csv"
write.csv(sales_data, output_file, row.names = FALSE)

cat("Dataset generated successfully!\n")
cat(paste("Number of records:", nrow(sales_data), "\n"))
cat(paste("Saved to:", output_file, "\n"))
cat("\nFirst few records:\n")
print(head(sales_data))

cat("\nSummary statistics:\n")
cat(paste("Total sales amount: $", format(sum(sales_data$total_amount), big.mark = ","), "\n"))
cat(paste("Average order value: $", round(mean(sales_data$total_amount), 2), "\n"))
cat(paste("Date range:", min(sales_data$order_date), "to", max(sales_data$order_date), "\n"))
