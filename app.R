###############
# F1 Shiny App
###############

library(shiny)
library(shinyWidgets)
library(shinydashboard)
source('dataPrep.R')
source('plotFunction.R')
source('driversDataPrep.R')

# page for season statistics
seasonpage_drivers <- fluidPage(fluidRow(column(9,plotOutput("graph"))),
              fluidRow(column(8,offset = 0, wellPanel(sliderInput(inputId = "year1",
              label = "Season", value = 2020, min = 1950, max = 2020, step = 1, sep=""),
              sliderInput(inputId = "top", label = "Number of Drivers to Show", 
              value = 5, min = 1, max = 10, step = 1, sep=""), style="font-size: 12px;padding: 0px;margin: 0px;color:#839496;background-color:#002b36;border-color:#002b36;"))))

# and for teams
seasonpage_teams <- fluidPage(fluidRow(column(9,plotOutput("graph2"))),
                      fluidRow(column(8,offset = 0, wellPanel(sliderInput(inputId = "year2",
                      label = "Season", value = 2020, min = 1958, max = 2020, step = 1, sep=""),
                      sliderInput(inputId = "top2", label = "Number of Teams to Show", 
                      value = 5, min = 1, max = 10, step = 1, sep=""), style="font-size: 12px;padding: 0px;margin: 0px;color:#839496;background-color:#002b36;border-color:#002b36;"))))

# drivers information  page 
driverspage <- fluidPage(fluidRow(column(5, selectizeInput("selected_driver", "Select a Driver", choices = drivers_summary$Name, options = list(maxoptions=5)))),
               fluidRow(column(5, textOutput("nationality_driver_out"))),
               fluidRow(column(5, textOutput("date_driver_out"))),
               fluidRow(column(5, textOutput("championships_driver_out"))),
               fluidRow(column(5, textOutput("gp_driver_out"))),
               fluidRow(column(5, textOutput("second_driver_out"))),
               fluidRow(column(5, textOutput("third_driver_out")))
               ,class ="about")

# about page
aboutpage <- tags$div(class = "about",tags$h3("About this App"),
             tags$p("This site shows some formula one data. The Season Standings tab shows how the standings 
                    in the champinship developed over time for a selected season. The Driver Information tab shows information
                    about a selected driver."), tags$br(),tags$p("Data used are from", tags$a(href="http://ergast.com/mrd/", "http://ergast.com/mrd/")))

# creating the user interface
ui<-dashboardPage(
  dashboardHeader(title="Formula One Data"),
  dashboardSidebar(sidebarMenu(
    menuItem("Season Standings", icon = icon("chart-line"),
             menuSubItem("Drivers", tabName = "season_drivers", icon = icon("user")),
             menuSubItem("Teams", tabName = "season_teams", icon = icon("users"))),
    menuItem("Driver Information", tabName = "driver", icon = icon("user")),
    menuItem("About", tabName = "about", icon = icon("info"))
  )),
  dashboardBody(
    tags$head(
      tags$link(rel="stylesheet", type="text/css", href ="custom.css")),
    tabItems(tabItem(tabName = "season_drivers", seasonpage_drivers
      
    ),tabItem(tabName = "season_teams", seasonpage_teams
                       
    ),tabItem(tabName = "driver", driverspage), tabItem(tabName = "about",aboutpage)
    
    )
  ))


# server function
server <- function(input, output) {
  output$graph<-renderPlot({
    plot_f1(input$year1, "A", input$top)
  }, bg="#002b36", execOnResize = TRUE)
  output$graph2<-renderPlot({
    plot_f1(input$year2, "B", input$top2)
  }, bg="#002b36", execOnResize = TRUE)
  output$date_driver_out<-renderText({
    paste("Date of Birth:", (drivers_summary %>% filter(Name==input$selected_driver))[3])
  })
  output$championships_driver_out<-renderText({
    paste("World Championship Titles:", (drivers_summary %>% filter(Name==input$selected_driver))[7])
  })
  output$gp_driver_out<-renderText({
    paste("Grand Prix Wins:", (drivers_summary %>% filter(Name==input$selected_driver))[5])
  })
  output$second_driver_out<-renderText({
    paste("Second Places:", (drivers_summary %>% filter(Name==input$selected_driver))[8])
  })
  output$third_driver_out<-renderText({
    paste("Third Places:", (drivers_summary %>% filter(Name==input$selected_driver))[9])
  })
  output$nationality_driver_out<-renderText({
    paste("Nationality:", (drivers_summary %>% filter(Name==input$selected_driver))[4])
  })
  
}

# running the app
shinyApp(ui = ui, server = server)








