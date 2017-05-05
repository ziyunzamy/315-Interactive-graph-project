library(shiny)
library(tidyverse)
library(d3wordcloud)
library(dplyr)
# survey = read.csv("~/Desktop/36-315/Interactive Graphic Project/responses.csv")
# https://www.kaggle.com/START-UMD/gtd
terr = read.csv("terr.csv")
word_freq = read.csv("foo.csv")
group13_315_theme <-  theme_bw() +  
  theme(
    plot.title = element_text(size = 16, color = "navy",face="bold"),
    plot.subtitle = element_text(size = 11, color = "navy",face="bold"),
    axis.title = element_text(size = 14, color = "navy",face="bold"),
    axis.text = element_text(size = 12, color = "#AF1E2D",face="bold"),
    legend.background = element_rect(fill = "white"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white")
  )

function(input, output) {
  
  output$second_plot <- renderPlot({
    p <- ggplot(data = terr, aes(x = iyear)) + 
      geom_histogram(aes(y=..density..), bins = as.numeric(input$n_breaks),
                     color = "black") +
      labs(title = "Age of Young People", x = "Age", y = "Density")+
      group13_315_theme
    
    if (input$show_mean) {
      p <- p + geom_vline(aes(xintercept = mean(iyear, na.rm = TRUE)),
                          color = "blue", linetype = "dashed", size = 1.5)
    }
    
    if (input$show_median) {
      p <- p + geom_vline(aes(xintercept = median(iyear, na.rm = TRUE)),
                          color = "yellow", linetype = "dashed", size = 1.5)
    }
    
    if (input$density) {
      p <- p + geom_density(colour="red",
                            adjust=input$bw_adjust, size = 1)
    }
    print(p)
  })
  ### interactive word cloud ###
  output$wordCloud <- renderD3wordcloud({
    sample_n <- sample(1:500, input$n_words)
    word_freq_sample <- word_freq[sample_n,]
    d3wordcloud(word_freq_sample$clean_NA_v1,word_freq_sample$freqs)
  })
  ### end of interactive word cloud ###
}