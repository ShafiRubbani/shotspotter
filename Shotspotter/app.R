#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(ggplot2)
library(lubridate)
library(ggthemes)
library(tidyverse)

raw_washington_dc <- read_csv("washington_dc_2006to2017.csv",
                              col_names = TRUE,
                              col_types = cols(
                                incidentid = col_double(),
                                latitude = col_double(),
                                longitude = col_double(),
                                year = col_double(),
                                month = col_double(),
                                day = col_double(),
                                hour = col_double(),
                                minute = col_double(),
                                second = col_double(),
                                numshots = col_double(),
                                type = col_character()
                              )) %>% 
  clean_names()

urban_shapes <- urban_areas(class = "sf")

washington_shapes <- raw_shape %>%
  filter(str_detect(NAME10, "Washington, DC--VA--MD"))

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Gunshots in Washington DC by the Hour"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("hour",
                     "Hour",
                     min = 0,
                     max = 23,
                     value = 12)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("shotPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  washington_dc <-raw_washington_dc %>%
    filter(latitude > 30, longitude < -70) %>% 
    filter(year > 2014)
  
  washington_locations <- st_as_sf(washington_dc, 
                                   coords = c("longitude", "latitude"), 
                                   crs = 4326)
  
  
washington_shapes <- raw_shape %>%
    filter(str_detect(NAME10, "Washington, DC--VA--MD"))

gunshot_locations<- reactive({washington_locations%>%filter(hour == input$hour)})

  output$shotPlot <- renderPlot({
    ggplot(data = washington_shapes)+ geom_sf()+
      geom_sf(data = gunshot_locations(), aes(group = input$hour, alpha= 0.2))
  })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

