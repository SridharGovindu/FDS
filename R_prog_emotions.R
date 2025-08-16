# Load required libraries
library(syuzhet)
library(dplyr)
library(tidyr)
library(readr)
library(plotly)

# Read the CSV file containing YouTube comments (adjust the path as necessary)
data <- read_csv("C:/Users/sridh/fds dst.csv")

# Perform sentiment analysis using NRC lexicon
nrc_sentiment <- get_nrc_sentiment(data$Comments)

# Display the structure of nrc_sentiment to check if emotion columns are present
str(nrc_sentiment)

# Combine sentiment scores with the original data
results <- cbind(data, nrc_sentiment)

# Print column names to ensure the emotion columns are included
print(colnames(results))

# Summarize scores for the eight emotions
emotion_summary <- results %>%
  select(anger, anticipation, disgust, fear, joy, sadness, surprise, trust) %>%
  summarise(across(everything(), sum))

# Print the summarized emotion data for debugging
print(emotion_summary)

# Reshape the data for visualization
emotion_long <- emotion_summary %>%
  pivot_longer(cols = everything(), names_to = "emotion", values_to = "score")

# Create an interactive histogram for the eight emotions using Plotly
p <- plot_ly(emotion_long, 
             x = ~emotion, 
             y = ~score, 
             type = 'bar',
             text = ~score,
             hoverinfo = 'text',
             marker = list(color = 'coral',  # Color set to coral
                           line = list(color = 'rgba(8,48,107,1.0)', width = 1.5))) %>%
  layout(title = "Emotion Analysis: Eight Emotions",
         xaxis = list(title = "Emotion Category"),
         yaxis = list(title = "Total Score"),
         showlegend = FALSE)

# Display the interactive plot
p
