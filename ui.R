library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("PartA", tabName = "PartA", icon = icon("th")),
      menuItem("PartB", tabName = "PartB", icon = icon("th"))
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
                tabPanel("Plot1", 
                         fluidRow(
                           box(plotOutput(outputId = "first_plot", height = "300px")),
                           box(
                             title = "Controls",
                             checkboxInput(inputId = "smooth.line",
                                           label = strong("Show Fitted Line"),
                                           value = FALSE),
                             sliderInput(inputId = "point.size",
                                         label = "point size:",
                                         min = 1, max = 10, value = 5, step = 1)
                           )
                         )),
                tabPanel("Plot2", fluidRow(
                  box(plotOutput(outputId = "countour", height = "300px")),
                  box(
                    title = "Controls",
                    checkboxInput(inputId = "points.visible",
                                  label = strong("Show Points"),
                                  value = FALSE))
                ))
              )
      )
    )
  )
  
  
))