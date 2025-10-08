# Movie Review Dashboard - Setup & Usage Guide

This guide will help you set up and run the Movie Review Analysis Dashboard on your Linux (or Windows/macOS) machine. The project consists of only two files:

- `movie_review_dashboard.R` (the Shiny dashboard)
- `movie_reviews.csv` (the dataset)

---

## 1. Prerequisites

- **R** (version 4.0 or higher)
- **RStudio** (optional, but recommended for ease of use)
- **Internet connection** (for installing R packages)

### Install R (Linux)

```bash
sudo apt update
sudo apt install -y r-base
```

### Install R (macOS)
- Download from https://cran.r-project.org/bin/macosx/

### Install R (Windows)
- Download from https://cran.r-project.org/bin/windows/base/

---

## 2. Install Required R Packages

Open a terminal and run R, or use RStudio. Then run:

```r
install.packages(c("shiny", "ggplot2", "dplyr", "plotly", "DT", "tidyr", "stringr"))
```

This will install all the packages needed for the dashboard.

---

## 3. Place the Files

Ensure both `movie_review_dashboard.R` and `movie_reviews.csv` are in the **same directory**.

---

## 4. Run the Dashboard

### Option 1: Using RStudio
1. Open RStudio.
2. Go to `File > Open File...` and select `movie_review_dashboard.R`.
3. Click the **Run App** button at the top right of the script editor.

### Option 2: Using R Console/Terminal
1. Open a terminal and navigate to the project directory:
   ```bash
   cd /path/to/your/project
   ```
2. Start R:
   ```bash
   R
   ```
3. Run the dashboard script:
   ```r
   shiny::runApp("movie_review_dashboard.R")
   # or
   source("movie_review_dashboard.R")
   ```

### Option 3: Using Rscript (opens in browser)
```bash
Rscript -e "shiny::runApp('movie_review_dashboard.R', launch.browser=TRUE)"
```

---

## 5. Using the Dashboard
- The dashboard will open in your default web browser.
- Use the sidebar to filter by movie, genre, platform, sentiment, date range, and minimum rating.
- Explore the various tabs for summary tables, sentiment analysis, rating distributions, genre insights, timelines, top movies, reviewer insights, and more.

---

## 6. Troubleshooting
- **Error: package 'XYZ' is not installed**
  - Run `install.packages("XYZ")` in R to install the missing package.
- **File not found: 'movie_reviews.csv'**
  - Make sure the CSV file is in the same directory as the R script.
- **Dashboard does not open in browser**
  - Copy and paste the local URL (e.g., `http://127.0.0.1:xxxx`) from the R console into your browser.
- **Performance issues**
  - The dataset is large (25,000 reviews). If your machine is slow, try filtering to a single movie or genre.

---

## 7. Customization
- You can edit `movie_review_dashboard.R` to change the UI, add new plots, or modify filters.
- You can replace `movie_reviews.csv` with your own dataset (ensure the column names match).

---

## 8. Stopping the Dashboard
- In RStudio: Click the red stop button in the console.
- In terminal: Press `Ctrl+C` in the terminal window running the app.

---

## 9. References
- [Shiny Documentation](https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
- [dplyr Documentation](https://dplyr.tidyverse.org/)

---

Enjoy exploring and analyzing movie reviews interactively!