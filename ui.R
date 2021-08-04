library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)
library(ECharts2Shiny)

crime1 <- read.csv("crime3.csv")


fluidPage(
  loadEChartsLibrary(),
  h1("Violations in Boston"),
  img(src = 'boston.jpg'),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      selectizeInput(inputId= 'select_year',
                     label = 'Year',
                     choices = unique(crime1$YEAR)),
    
      actionButton("shoot", label = "Shoot"),
      
      ),
    mainPanel(plotOutput("count"),
              plotOutput("bar"),
              dataTableOutput("top5"),
              tags$div(id="pie", style="width:90%;height:400px;"),
              deliverChart(div_id = "pie"),
              dataTableOutput("offense"))
  ),
  br(),
  br(),
  
  leafletOutput("mymap"),
  

)