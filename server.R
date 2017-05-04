library(shiny)
library(tidyverse)

survey = read.csv("~/Desktop/36-315/Interactive Graphic Project/responses.csv")
# https://www.kaggle.com/START-UMD/gtd
terr = read.csv("~/Desktop/36-315/Interactive Graphic Project/terr.csv")
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
  output$first_plot <- renderPlot({
    p <- ggplot(data = survey, aes(x = Happiness.in.life)) + 
      geom_bar(aes(fill = Gender)) +
      labs(title = "Happiness in Life", x = "Scale") +
      group13_315_theme
    print(p)
  })
  
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
}