
###############
# F1 Shiny App
###############

library(shiny)
source('dataPrep.R')
source('plotFunction.R')

ui <- fluidPage(sliderInput(inputId = "year",
                            label = "Select a season", 
                            value = 2020, min = 1950, max = 2020, step = 1, sep=""),
                sliderInput(inputId = "top",
                            label = "Select number of drivers\\teams to show", 
                            value = 5, min = 1, max = 10, step = 1, sep=""),
                radioButtons("charttype", label = "Driver or Constructor",
                             choices = list("Driver" = "A", "Constructor" = "B"), selected = "A"),
                plotOutput("graph"))

server <- function(input, output) {
  output$graph<-renderPlot({
    plot_f1(input$year, input$charttype, input$top)
  })
}

shinyApp(ui = ui, server = server)



