library(shiny)
library(shinydashboard)

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
              tabsetPanel(
                tabPanel("Plot1",
                
                fluidRow(
                box(plotOutput(outputId = "first_plot", height = "250")),
                
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
                tabPanel("Plot2",
                         
                         fluidRow(
                           box(plotOutput(outputId = "third_plot", height = "250")),
                           
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
              
      tabItem(tabName = "PartB", 
              tabsetPanel(
                tabPanel("Plot1", 
                         fluidRow(
                           box(plotOutput(outputId = "second_plot", height = "300px")),
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
      
      tabItem(tabName = "PartC", 
              tabsetPanel(
                tabPanel("Plot1", 
                         fluidRow(
                           box(plotOutput(outputId = "fourth_plot",
                                          height = "300px")),
                           box(
                             title = "Controls",
                             checkboxInput(inputId = "show_num_4",
                                           label = strong("Show Number of Attacks"),
                                           value = FALSE)
                         ))),
                tabPanel("Plot2", 
                         fluidRow(
                           box(plotOutput(outputId = "fifth_plot",
                                          height = "300px")),
                           box(
                             title = "Controls",
                             checkboxInput(inputId = "show_num_5",
                                           label = strong("Show Number of Attacks"),
                                           value = FALSE)
                           )))
              )
      )
    )
  )
  
  
))