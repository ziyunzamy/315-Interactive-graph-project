library(shiny)
library(shinydashboard)
library(wordcloud2)
library(plotly)

shinyUI(dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("What happened over time?", tabName = "PartA", icon = icon("th")),
      menuItem("What are types of attacks?", tabName = "PartB", icon = icon("th")),
      menuItem("Deaths vs Wounds", tabName = "PartC", icon = icon("th")),
      menuItem("PartD", tabName = "PartD", icon = icon("th")),
      menuItem("World Map 1", tabName = "map1", icon = icon("th")),
      menuItem("World Map 2", tabName = "map2", icon = icon("th"))
      )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "PartA",
              tabsetPanel(
                tabPanel("Histogram of Total Attacks",
                
                fluidRow(
                box(plotOutput(outputId = "first_plot", height = 450),width="100%"),
                
                box(
                  title = "Controls",
                  selectInput(inputId = "n_breaks",
                              label = "Number of bins in the histogram",
                              choices = c(5,10,15),
                              selected = 15),
                  checkboxInput(inputId = "show_mean",
                                label = strong("Show mean of number of attacks"),
                                value = FALSE),
                  checkboxInput(inputId = "show_median",
                                label = strong("Show median of number of attack"),
                                value = FALSE),
                  checkboxInput(inputId = "density",
                                label = strong("Show density estimate"),
                                value = FALSE),
                  
                  # Display this only if the density is shown
                  conditionalPanel(condition = "input.density == true",
                                   sliderInput(inputId = "bw_adjust",
                                               label = "Bandwidth adjustment:",
                                               min = 0.2, max = 2, value = 1, step = 0.2))
                )
              )),
                tabPanel("Histogram of Attacks by Success and Suicide",
                         
                         fluidRow(
                           box(plotOutput(outputId = "third_plot", height = 450),width="100%"),
                           
                           box(
                             title = "Controls",
                             selectInput(inputId = "n_breaks_3",
                                         label = "Number of bins in the histogram",
                                         choices = c(5,10,15),
                                         selected = 15),
                             checkboxInput(inputId = "show_mean_3",
                                           label = strong("Show mean of number of attacks"),
                                           value = FALSE),
                             checkboxInput(inputId = "show_median_3",
                                           label = strong("Show median of number of attack"),
                                           value = FALSE),
                             checkboxInput(inputId = "density_3",
                                           label = strong("Show density estimate"),
                                           value = FALSE),
                             
                             # Display this only if the density is shown
                             conditionalPanel(condition = "input.density_3 == true",
                                              sliderInput(inputId = "bw_adjust",
                                                          label = "Bandwidth adjustment:",
                                                          min = 0.2, max = 2, value = 1, step = 0.2))
                           )
                         ))
              
              
              )),
      
      tabItem(tabName = "PartC", 
              fluidRow(
                tabPanel("Deaths vs Wounds", 
                         fluidRow(
                           box(plotOutput(outputId = "second_plot", height = 450),width="100%"),
                           box(
                             title = "Controls",
                             checkboxInput(inputId = "smoothLine",
                                           label = strong("Show Fitted Line"),
                                           value = FALSE),
                             conditionalPanel(condition = "input.smoothLine == true",
                                              checkboxInput(inputId = "se",
                                              label = strong("Show Standard Error of Fitted Line"),
                                              value = FALSE)),
                             sliderInput(inputId = "pointSize",
                                         label = strong("Point Size"),
                                         min = 0.1, max = 2, value = 1, step = 0.1)
                           )
                         ))
              )
      ),
      
      tabItem(tabName = "PartB", 
              tabsetPanel(
                tabPanel("Attacks by Attack Type", 
                         fluidRow(
                           box(plotOutput(outputId = "fourth_plot",
                                          height = 520),width = "100%"),
                           box(
                             title = "Controls",
                             checkboxInput(inputId = "show_num_4",
                                           label = strong("Show Number of Attacks"),
                                           value = FALSE)
                         ))),
                tabPanel("Attacks by Target Type", 
                         fluidRow(
                           box(plotOutput(outputId = "fifth_plot",
                                          height = 520),width = "100%"),
                           box(
                             title = "Controls",
                             checkboxInput(inputId = "show_num_5",
                                           label = strong("Show Number of Attacks"),
                                           value = FALSE)
                           )))
              )
      ),
      tabItem(tabName = "map1",
              fluidRow(plotlyOutput("map_plot1"))
      ),
      
      # Second tab content
      tabItem(tabName = "map2",
              fluidRow(plotlyOutput("map_plot2"))
      ),
      tabItem(tabName = "PartD",
        fluidRow(
          box(title = "Word Cloud of Attacks' Summary",
            wordcloud2Output("wordCloud1", width = "100%", height = 500),
            width = "100%")
        ),
        fluidRow(
          box(sliderInput("nR", "Font Size", 
                        min = 0.1, max = 1, value = 0.3, step = 0.1))
          )
        )
      ### end of interactive word cloud ###
    )
  )
  
  
))