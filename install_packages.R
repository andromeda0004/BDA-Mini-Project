# Install required R packages for Hadoop Ecosystem Project
# Run this script first before running the main project

cat("Installing required R packages...\n")

# List of required packages
required_packages <- c(
  "ggplot2",      # For data visualization
  "dplyr",        # For data manipulation
  "DBI",          # Database interface
  "RJDBC",        # JDBC connectivity for Hive
  "rhbase",       # HBase interface (optional, may need manual setup)
  "tidyr",        # Data tidying
  "scales",       # For plot formatting
  "gridExtra"     # For multiple plots
)

# Function to install packages if not already installed
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE)) {
    cat(paste("Installing", package, "...\n"))
    install.packages(package, dependencies = TRUE, repos = "https://cran.r-project.org")
    library(package, character.only = TRUE)
  } else {
    cat(paste(package, "is already installed.\n"))
  }
}

# Install all required packages
for (pkg in required_packages) {
  tryCatch({
    install_if_missing(pkg)
  }, error = function(e) {
    cat(paste("Warning: Could not install", pkg, ":", e$message, "\n"))
  })
}

cat("\nPackage installation complete!\n")
cat("Note: For HBase connectivity, you may need additional Java libraries.\n")
