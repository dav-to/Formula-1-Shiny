
###############
# F1 Shiny App
###############

library(shiny)
library(shinyWidgets)
source('dataPrep.R')
source('plotFunction.R')


ui <- fluidPage(fluidRow(column(1, offset = 4, tags$br(), tags$img(height=50, width = 100, src = "checker-1648337_640.png")),
                         column(5,tags$br(),tags$h1("Formula 1 Standings", style="color:#cc0000;", style="font-family:Impact"))
                ), fluidRow(tags$br(),tags$br(),tags$br()), fluidRow(column(4, tags$br(), wellPanel(sliderInput(inputId = "year",
                            label = "Select a season", 
                            value = 2020, min = 1950, max = 2020, step = 1, sep=""),
                sliderInput(inputId = "top",
                            label = "Select number of drivers\\constructors to show", 
                            value = 5, min = 1, max = 10, step = 1, sep=""),
                radioButtons("charttype", label = "Driver or Constructor",
                             choices = list("Driver" = "A", "Constructor" = "B"), selected = "A"),
                              style="background: #ffffff")),
               column(6,plotOutput("graph"))), setBackgroundColor("#cccccc"))


server <- function(input, output) {
  output$graph<-renderPlot({
    plot_f1(input$year, input$charttype, input$top)
  })
}

shinyApp(ui = ui, server = server)



