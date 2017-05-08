library(shiny)
library(tidyverse)
library(forcats)
library(countrycode)

# https://www.kaggle.com/START-UMD/gtd

Sys.setlocale('LC_ALL','C') 

terr.clean = read.csv("terr_sample.csv")
terr.clean$extended = as.factor(terr.clean$extended)
terr.clean $extended <- fct_recode(terr.clean $extended,
                            "Incident Last More than 24 hr" = "1", 
                            "Incident Last Less than 24 hr" = "0")

terr.clean $country_code <- countrycode(terr.clean $country_txt, 'country.name', 'iso3c')

terr_by_country <- terr.clean  %>% 
  group_by(country_code, country_txt) %>% 
  summarize(total_kill = sum(nkill, na.rm = TRUE))

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
my_colors <- c("#000000", "#56B4E9", "#E69F00", "#F0E442", "#009E73", "#0072B2", 
               "#D55E00", "#CC7947")

function(input, output) {
  
  output$first_plot <- renderPlot({
    p1 <- ggplot(data = terr.clean, aes(x = iyear)) + 
      geom_histogram(aes(y=..density..), bins = as.numeric(input$n_breaks),
                     color = "black", fill="pink") +
      labs(title = "Distribution of Terrorist Attacks",
           x = "Year of Attacks", y = "Density")+
      group13_315_theme
    
    if (input$show_mean) {
      p1 <- p1 + geom_vline(aes(xintercept = mean(iyear, na.rm = TRUE)),
                          color = "blue", linetype = "dashed", size = 1.5)
    }
    
    if (input$show_median) {
      p1 <- p1 + geom_vline(aes(xintercept = median(iyear, na.rm = TRUE)),
                          color = "yellow", linetype = "dashed", size = 1.5)
    }
    
    if (input$density) {
      p1 <- p1 + geom_density(colour="red",
                            adjust=input$bw_adjust, size = 1)
    }
    print(p1)
  })
  
  output$second_plot <- renderPlot({
    p2 <- ggplot(data = terr.clean, aes(x = nkill, y = nwound)) + 
      geom_point(aes(color = doubtterr), size = input$pointSize) + 
      labs(x = "Number of Deaths",
           y = "Number of Wounds", color = "Is Terrorism") + 
      ggtitle("Deaths vs Wounds") +
      group13_315_theme
    
    if (input$smoothLine) {
      if (input$se) {
        p2 <- p2 + geom_smooth()
      }
      else p2 <- p2 + geom_smooth(se = FALSE)
    }

    print(p2)
  })
  
  output$third_plot <- renderPlot({
    p3 <- ggplot(data = terr.clean, aes(x = iyear)) + 
      geom_histogram(aes(y=..density..), bins = as.numeric(input$n_breaks_3),
                     color = "black", fill="pink") +
      facet_grid(success~suicide) +
      labs(title = "Distribution of Terrorist Attacks",
           x = "Year of Attacks", y = "Density")+
      group13_315_theme + theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    if (input$show_mean_3) {
      p3 <- p3 + geom_vline(aes(xintercept = mean(iyear, na.rm = TRUE)),
                            color = "blue", linetype = "dashed", size = 1.5)
    }
    
    if (input$show_median_3) {
      p3 <- p3 + geom_vline(aes(xintercept = median(iyear, na.rm = TRUE)),
                            color = "yellow", linetype = "dashed", size = 1.5)
    }
    
    if (input$density_3) {
      p3 <- p3 + geom_density(colour="red",
                              adjust=input$bw_adjust, size = 1)
    }
    print(p3)
  })
  
  output$fourth_plot <- renderPlot({
    p4 <- ggplot(data = terr.clean, aes(x = attacktype1_txt)) + 
      geom_bar(color = "black", fill="pink") +
      labs(title = "Distribution of Terrorist Attacks by Attack Type",
           x = "Type of Attacks", y = "Number of Attacks") +
      group13_315_theme + theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    if (input$show_num_4) {
      p4 <- p4 + geom_text(stat = "count",
                           aes(y = ..count.., label = ..count..), vjust = -.3)
    }
    print(p4)
  })
  
  output$fifth_plot <- renderPlot({
    p5 <- ggplot(data = terr.clean, aes(x = targtype1_txt)) + 
      geom_bar(color = "black", fill="pink") +
      labs(title = "Distribution of Terrorist Attacks by Target Type",
           x = "Type of Targets", y = "Number of Attacks") +
      group13_315_theme + theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    if (input$show_num_5) {
      p5 <- p5 + geom_text(stat = "count",
                           aes(y = ..count.., label = ..count..), vjust = -.3)
    }
    
    print(p5)
  })
  output$map_plot1 <- renderPlotly({
    
    # light grey boundaries
    l <- list(color = toRGB("grey"), width = 0.5)
    
    # specify map projection/options
    g <- list(
      scope = "world",
      showland = TRUE,
      showcoastlines = FALSE,
      showframe = FALSE,
      marker = list(line = l),
      landcolor = toRGB("gray85"),
      subunitwidth = 1,
      countrywidth = 1,
      subunitcolor = toRGB("white"),
      countrycolor = toRGB("white"),
      projection = list(type = 'Mercator')
    )
    
    plot_geo(terr.clean ) %>%
      add_markers(
        x = ~ longitude,
        y = ~ latitude, 
        color = ~ extended, 
        hoverinfo = "text",
        text = ~paste(city, ",", country_txt, "<br />", 
                      iyear, '-', imonth, '-', iday, "<br />"),
        size = I(3)
      )  %>% 
      layout(
        title = 'Global Terrorism Distribution',
        geo = g,
        legend = list(orientation = 'h')
      )
  })
  
  output$map_plot2 <- renderPlotly({
    
    # light grey boundaries
    l <- list(color = toRGB("grey"), width = 0.5)
    
    # specify map projection/options
    g <- list(
      showcoastlines = FALSE,
      showframe = FALSE,
      projection = list(type = 'Mercator')
    )
    
    geo <- list(
      showland = TRUE,
      showlakes = TRUE,
      showcountries = TRUE,
      showocean = TRUE,
      countrywidth = 0.5,
      landcolor = toRGB("grey90"),
      lakecolor = toRGB("white"),
      oceancolor = toRGB("white"),
      projection = list(
        type = 'orthographic',
        rotation = list(
          lon = -100,
          lat = 40,
          roll = 0
        )
      ),
      lonaxis = list(
        showgrid = TRUE,
        gridcolor = toRGB("gray90"),
        gridwidth = 0.5
      ),
      lataxis = list(
        showgrid = TRUE,
        gridcolor = toRGB("gray90"),
        gridwidth = 0.5
      )
    )
    
    plot_geo(terr_by_country) %>%
      add_trace(
        z = ~ total_kill,  
        color = ~ total_kill, 
        colors = 'Blues',
        text = ~paste(country_txt),
        locations = ~ country_code,
        marker = list(line = l)
      ) %>%
      colorbar(title = "Number of People Killed") %>% 
      layout(
        title = 'Global Terrorism Distribution',
        geo = geo
      )
  })
}












