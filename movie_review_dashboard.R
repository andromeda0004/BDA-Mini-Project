# Movie Review Analysis Dashboard
# A Shiny dashboard for analyzing movie reviews with sentiment analysis and visualizations

# Step 1: Install and Load Necessary Packages
# Uncomment the line below to install packages if you haven't already
# install.packages(c("shiny", "ggplot2", "dplyr", "plotly", "DT", "tidyr", "stringr"))

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(DT)
library(tidyr)
library(stringr)

# Step 2: Load and Prepare the Dataset
movie_data <- read.csv("movie_reviews.csv", stringsAsFactors = FALSE)

# Convert review_date to Date type
movie_data$review_date <- as.Date(movie_data$review_date, format="%Y-%m-%d")

# Step 3: Define the UI for the Shiny Dashboard
ui <- fluidPage(
  titlePanel("🎬 Movie Review Analysis Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      # Dropdown for selecting a movie
      selectInput("movie", "Select Movie:", 
                  choices = c("All Movies", unique(movie_data$title)),
                  selected = "All Movies"),
      
      # Dropdown for selecting genre
      selectInput("genre", "Select Genre:", 
                  choices = c("All Genres", unique(movie_data$genre)),
                  selected = "All Genres"),
      
      # Dropdown for selecting platform
      selectInput("platform", "Select Platform:", 
                  choices = c("All Platforms", unique(movie_data$platform)),
                  selected = "All Platforms"),
      
      # Dropdown for selecting sentiment
      selectInput("sentiment", "Select Sentiment:", 
                  choices = c("All", "Positive", "Neutral", "Negative"),
                  selected = "All"),
      
      # Date range filter
      dateRangeInput("date_range", "Select Date Range:", 
                     start = min(movie_data$review_date),
                     end = max(movie_data$review_date)),
      
      # Slider for minimum rating
      sliderInput("min_rating", "Minimum Movie Rating:", 
                  min = 0, max = 10, value = 0, step = 0.1)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("📊 Summary Table", DTOutput("summary_table")),
        
        tabPanel("📈 Sentiment Distribution", 
                 plotlyOutput("sentiment_pie"),
                 br(),
                 plotlyOutput("sentiment_bar")
        ),
        
        tabPanel("⭐ Rating Analysis", 
                 plotlyOutput("rating_distribution"),
                 br(),
                 plotlyOutput("rating_vs_score")
        ),
        
        tabPanel("🎭 Genre Analysis", 
                 plotlyOutput("genre_sentiment"),
                 br(),
                 plotlyOutput("genre_reviews")
        ),
        
        tabPanel("📅 Timeline", 
                 plotlyOutput("reviews_timeline"),
                 br(),
                 plotlyOutput("sentiment_timeline")
        ),
        
        tabPanel("🏆 Top Movies", 
                 fluidRow(
                   column(6, plotlyOutput("top_rated_movies")),
                   column(6, plotlyOutput("most_reviewed_movies"))
                 )
        ),
        
        tabPanel("👥 Reviewer Insights", 
                 plotlyOutput("platform_distribution"),
                 br(),
                 plotlyOutput("verified_vs_unverified")
        ),
        
        tabPanel("💬 Review Scores", 
                 plotlyOutput("score_distribution"),
                 br(),
                 plotlyOutput("helpful_votes_analysis")
        )
      )
    )
  )
)

# Step 4: Define the Server Logic for the Shiny Dashboard
server <- function(input, output) {
  
  # Filter data based on user selections
  filtered_data <- reactive({
    data <- movie_data %>%
      filter(review_date >= input$date_range[1] & review_date <= input$date_range[2],
             rating >= input$min_rating)
    
    if (input$movie != "All Movies") {
      data <- data %>% filter(title == input$movie)
    }
    
    if (input$genre != "All Genres") {
      data <- data %>% filter(genre == input$genre)
    }
    
    if (input$platform != "All Platforms") {
      data <- data %>% filter(platform == input$platform)
    }
    
    if (input$sentiment != "All") {
      data <- data %>% filter(sentiment == input$sentiment)
    }
    
    return(data)
  })
  
  # 1. Summary Table of Reviews
  output$summary_table <- renderDT({
    data <- filtered_data() %>%
      select(title, genre, director, rating, sentiment, review_score, 
             reviewer_name, review_date, platform, review_text)
    datatable(data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  # 2. Sentiment Pie Chart
  output$sentiment_pie <- renderPlotly({
    data <- filtered_data() %>%
      group_by(sentiment) %>%
      summarize(count = n())
    
    colors <- c("Positive" = "#2ecc71", "Neutral" = "#f39c12", "Negative" = "#e74c3c")
    
    plot_ly(data, labels = ~sentiment, values = ~count, type = 'pie',
            marker = list(colors = colors[data$sentiment]),
            textinfo = 'label+percent',
            insidetextorientation = 'radial') %>%
      layout(title = "Sentiment Distribution of Reviews")
  })
  
  # 3. Sentiment Bar Chart
  output$sentiment_bar <- renderPlotly({
    data <- filtered_data() %>%
      group_by(sentiment) %>%
      summarize(count = n(), avg_score = mean(review_score, na.rm = TRUE))
    
    p <- ggplot(data, aes(x = sentiment, y = count, fill = sentiment)) +
      geom_col() +
      geom_text(aes(label = count), vjust = -0.5) +
      scale_fill_manual(values = c("Positive" = "#2ecc71", 
                                   "Neutral" = "#f39c12", 
                                   "Negative" = "#e74c3c")) +
      labs(title = "Review Count by Sentiment",
           x = "Sentiment", y = "Number of Reviews") +
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(p)
  })
  
  # 4. Rating Distribution
  output$rating_distribution <- renderPlotly({
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = rating)) +
      geom_histogram(fill = "#3498db", bins = 20, color = "white") +
      labs(title = "Movie Rating Distribution",
           x = "Movie Rating", y = "Count") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # 5. Rating vs Review Score
  output$rating_vs_score <- renderPlotly({
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = rating, y = review_score, color = sentiment)) +
      geom_point(alpha = 0.6, size = 3) +
      geom_smooth(method = "lm", se = FALSE, color = "black", linetype = "dashed") +
      scale_color_manual(values = c("Positive" = "#2ecc71", 
                                    "Neutral" = "#f39c12", 
                                    "Negative" = "#e74c3c")) +
      labs(title = "Movie Rating vs Review Score",
           x = "Movie Rating", y = "Review Score", color = "Sentiment") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # 6. Genre Sentiment Analysis
  output$genre_sentiment <- renderPlotly({
    data <- filtered_data() %>%
      group_by(genre, sentiment) %>%
      summarize(count = n(), .groups = "drop")
    
    p <- ggplot(data, aes(x = genre, y = count, fill = sentiment)) +
      geom_col(position = "dodge") +
      scale_fill_manual(values = c("Positive" = "#2ecc71", 
                                   "Neutral" = "#f39c12", 
                                   "Negative" = "#e74c3c")) +
      labs(title = "Sentiment Distribution by Genre",
           x = "Genre", y = "Number of Reviews", fill = "Sentiment") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
  
  # 7. Genre Review Count
  output$genre_reviews <- renderPlotly({
    data <- filtered_data() %>%
      group_by(genre) %>%
      summarize(count = n(), avg_rating = mean(rating, na.rm = TRUE))
    
    p <- ggplot(data, aes(x = reorder(genre, -count), y = count, fill = avg_rating)) +
      geom_col() +
      geom_text(aes(label = count), vjust = -0.5, size = 3) +
      scale_fill_gradient(low = "#e74c3c", high = "#2ecc71") +
      labs(title = "Reviews by Genre",
           x = "Genre", y = "Number of Reviews", fill = "Avg Rating") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
  
  # 8. Reviews Timeline
  output$reviews_timeline <- renderPlotly({
    data <- filtered_data() %>%
      group_by(review_date) %>%
      summarize(count = n())
    
    p <- ggplot(data, aes(x = review_date, y = count)) +
      geom_line(color = "#3498db", size = 1) +
      geom_point(color = "#2c3e50", size = 2) +
      labs(title = "Reviews Over Time",
           x = "Date", y = "Number of Reviews") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # 9. Sentiment Timeline
  output$sentiment_timeline <- renderPlotly({
    data <- filtered_data() %>%
      group_by(review_date, sentiment) %>%
      summarize(count = n(), .groups = "drop")
    
    p <- ggplot(data, aes(x = review_date, y = count, color = sentiment, group = sentiment)) +
      geom_line(size = 1) +
      geom_point(size = 2) +
      scale_color_manual(values = c("Positive" = "#2ecc71", 
                                    "Neutral" = "#f39c12", 
                                    "Negative" = "#e74c3c")) +
      labs(title = "Sentiment Trends Over Time",
           x = "Date", y = "Number of Reviews", color = "Sentiment") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # 10. Top Rated Movies
  output$top_rated_movies <- renderPlotly({
    data <- filtered_data() %>%
      group_by(title) %>%
      summarize(avg_rating = mean(rating, na.rm = TRUE),
                review_count = n()) %>%
      filter(review_count >= 2) %>%
      arrange(desc(avg_rating)) %>%
      head(10)
    
    p <- ggplot(data, aes(x = reorder(title, avg_rating), y = avg_rating)) +
      geom_col(fill = "#f39c12") +
      geom_text(aes(label = round(avg_rating, 1)), hjust = -0.2, size = 3) +
      coord_flip() +
      labs(title = "Top 10 Highest Rated Movies",
           x = "Movie Title", y = "Average Rating") +
      theme_minimal() +
      ylim(0, 10)
    
    ggplotly(p)
  })
  
  # 11. Most Reviewed Movies
  output$most_reviewed_movies <- renderPlotly({
    data <- filtered_data() %>%
      group_by(title) %>%
      summarize(review_count = n()) %>%
      arrange(desc(review_count)) %>%
      head(10)
    
    p <- ggplot(data, aes(x = reorder(title, review_count), y = review_count)) +
      geom_col(fill = "#9b59b6") +
      geom_text(aes(label = review_count), hjust = -0.2, size = 3) +
      coord_flip() +
      labs(title = "Top 10 Most Reviewed Movies",
           x = "Movie Title", y = "Number of Reviews") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # 12. Platform Distribution
  output$platform_distribution <- renderPlotly({
    data <- filtered_data() %>%
      group_by(platform) %>%
      summarize(count = n(), avg_score = mean(review_score, na.rm = TRUE))
    
    p <- ggplot(data, aes(x = reorder(platform, -count), y = count, fill = platform)) +
      geom_col() +
      geom_text(aes(label = count), vjust = -0.5) +
      labs(title = "Reviews by Platform",
           x = "Platform", y = "Number of Reviews") +
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(p)
  })
  
  # 13. Verified vs Unverified Reviews
  output$verified_vs_unverified <- renderPlotly({
    data <- filtered_data() %>%
      group_by(verified_purchase, sentiment) %>%
      summarize(count = n(), avg_score = mean(review_score, na.rm = TRUE), .groups = "drop")
    
    p <- ggplot(data, aes(x = verified_purchase, y = count, fill = sentiment)) +
      geom_col(position = "dodge") +
      scale_fill_manual(values = c("Positive" = "#2ecc71", 
                                   "Neutral" = "#f39c12", 
                                   "Negative" = "#e74c3c")) +
      labs(title = "Verified vs Unverified Reviews by Sentiment",
           x = "Verified Purchase", y = "Number of Reviews", fill = "Sentiment") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # 14. Review Score Distribution
  output$score_distribution <- renderPlotly({
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = factor(review_score), fill = sentiment)) +
      geom_bar() +
      scale_fill_manual(values = c("Positive" = "#2ecc71", 
                                   "Neutral" = "#f39c12", 
                                   "Negative" = "#e74c3c")) +
      labs(title = "Review Score Distribution",
           x = "Review Score (1-10)", y = "Count", fill = "Sentiment") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # 15. Helpful Votes Analysis
  output$helpful_votes_analysis <- renderPlotly({
    data <- filtered_data()
    
    p <- ggplot(data, aes(x = review_score, y = helpful_votes, color = sentiment)) +
      geom_point(alpha = 0.6, size = 3) +
      geom_smooth(method = "lm", se = TRUE) +
      scale_color_manual(values = c("Positive" = "#2ecc71", 
                                    "Neutral" = "#f39c12", 
                                    "Negative" = "#e74c3c")) +
      labs(title = "Helpful Votes vs Review Score",
           x = "Review Score", y = "Helpful Votes", color = "Sentiment") +
      theme_minimal()
    
    ggplotly(p)
  })
}

# Step 5: Run the Shiny App
shinyApp(ui = ui, server = server)
