library(shiny)
library(shinydashboard)
library(wordcloud2)
shinyUI(dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("PartA", tabName = "PartA", icon = icon("th")),
      menuItem("PartB", tabName = "PartB", icon = icon("th")),
      menuItem("PartC", tabName = "PartC", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "PartA",
              fluidRow(
                box(plotOutput(outputId = "second_plot", height = "250")),
                
                box(
                  title = "Controls",
                  selectInput(inputId = "n_breaks",
                              label = "Number of bins in the histogram",
                              choices = c(5,10,15),
                              selected = 15),
                  checkboxInput(inputId = "show_mean",
                                label = strong("Show mean of age"),
                                value = FALSE),
                  checkboxInput(inputId = "show_median",
                                label = strong("Show median of age"),
                                value = FALSE),
                  checkboxInput(inputId = "density",
                                label = strong("Show density estimate"),
                                value = FALSE),
                  
                  # Display this only if the density is shown
                  conditionalPanel(condition = "input.density == true",
                                   sliderInput(inputId = "bw_adjust",
                                               label = "Bandwidth adjustment:",
                                               min = 0.2, max = 2, value = 1.2, step = 0.2))
                )
              )),
      tabItem(tabName = "PartB", 
              tabsetPanel(
                tabPanel("Plot1"),
                tabPanel("Plot2")
              )
      ),
      ### interactive word cloud ###
      tabItem(tabName = "PartC", 
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