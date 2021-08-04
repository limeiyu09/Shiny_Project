library(shiny)
library(dplyr)
library(ggplot2)
library(ECharts2Shiny)

crime1 <- read.csv("crime3.csv")

  
function(input, output, session){
  
  shoot <- filter(crime1, crime1$SHOOTING %in% c("Shooting", "No shooting")) 
  
  shoot_map <- filter(crime1, crime1$SHOOTING == "Shooting")
  
  top <- crime1 %>%
    group_by(DISTRICT) %>%
    summarise(Numbers=n()) %>%
    arrange(., desc(Numbers)) %>%
    mutate(Sort = row_number()) %>%
    relocate(Sort)
  
  week <- crime1 %>%
    group_by(DAY_OF_WEEK) %>%
    summarise(n=n()) %>%
    mutate(ratio = n/sum(n)) %>%
    select(DAY_OF_WEEK, ratio) %>%
    rename(name = DAY_OF_WEEK, value = ratio)
  
  
  Offense <- crime1 %>%
    filter(OFFENSE_CODE_GROUP != "") %>%
    group_by(OFFENSE_CODE_GROUP) %>%
    summarise(incidence = n()) %>%
    arrange(., desc(incidence)) %>%
    mutate(Sort = row_number()) %>%
    relocate(Sort)
  
  
  output$count <- renderPlot(
    crime1 %>%
      filter(YEAR == input$select_year) %>%
      group_by(SEASON) %>%
      count() %>%
      ggplot(aes(x = SEASON, y = n, fill = SEASON)) + 
      geom_col() +
      ggtitle("Number of Crime")
  )
  
  output$bar <- renderPlot(
    shoot %>%
      group_by(SHOOTING) %>%
      summarise(n=n()) %>%
      mutate(ratio = n/sum(n)) %>%
      ggplot(aes(x = SHOOTING, y = ratio, fill = SHOOTING)) +
      geom_bar(position = "dodge", stat="identity") +
      ggtitle("Ratio of Shooting")
  )
  
  br()
  
  output$top5 <- renderDataTable(top)
  
  br()
  
  output$pie <- renderPieChart(div_id = "pie", data = week)
  
  
  output$mymap <- renderLeaflet({
    leaflet(shoot_map) %>%
      addTiles() %>%  
      addCircles(lng=shoot_map$Long, lat=shoot_map$Lat, 
                 radius = 0.01, color = "#03F")
  })
  
  output$offense <- renderDataTable(Offense)
  
}