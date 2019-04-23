#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Download relevant libraries

library(shiny)
library(sf)
library(tigris)
library(janitor)
library(ggplot2)
library(ggthemes)
library(tidyverse)
library(gt)

# Read ShotSpotter data from csv
# http://justicetechlab.org/shotspotter-data/

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

# Download shapefiles for urban areas

urban_shapes <- urban_areas(class = "sf")

# Save Washington DC shapfiles

washington_shapes <- urban_shapes %>%
  filter(str_detect(NAME10, "Washington, DC--VA--MD"))

# Define UI for ShotSpotter App

ui <- fluidPage(tabsetPanel(
  
  tabPanel("Map",
   
   # Application title
  
   titlePanel("Distribution of Gunshots in Washington DC, 2015-2017"),
   
   # Sidebar with a slider input for the hour of day
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("hour",
                     "Hour",
                     min = 0,
                     max = 23,
                     value = 12)
      ),
      
    # The app has three panels: a plot showing gunshots on a map, a plot showing
    # the distribution of gunshots by hour, and an about page
      
      mainPanel(
        plotOutput("shotPlot"),
        tableOutput("table")
        ))
),
tabPanel("Total Gunshots", plotOutput("linePlot")),
tabPanel("About", textOutput("message")
)))


# Define server logic

server <- function(input, output) {
  
  # Filter recent data in the right region
  
  washington_dc <- raw_washington_dc %>%
    filter(latitude > 30, longitude < -70) %>% 
    filter(year > 2014)
  
  # Parse coordinates as a shapefile
  
  washington_locations <- st_as_sf(washington_dc, 
                                   coords = c("longitude", "latitude"), 
                                   crs = 4326)

  # Filter gunshot locations by hour
  
  gunshot_locations <- reactive({washington_locations %>%
      filter(hour == input$hour)})

  # Render gunshot map
  
  output$shotPlot <- renderPlot({
    ggplot() +
      
      # Plot Washington DC map
      
      geom_sf(data = washington_shapes) +
      
      # Plot gunshot locations, coloring by the number of shots
      
      geom_sf(data = gunshot_locations(), aes(color = numshots), alpha = 0.2) +
      
      # Zoom into relevant area
      
      coord_sf(xlim = c(-77.11979522, -76.867218), ylim = c(38.79164435, 39.031386)) +
      labs(title = "Gunshot Locations by the Hour",
        color = "Number of Shots") +
      theme_map()
  })
  
  output$table <- render_gt({gunshot_locations() %>%
      
      # Filter uncounted shots
      
      filter(!is.na(type)) %>%
      
      # Rename types
      
      mutate(types = fct_collapse(type, "Single" = "Single_Gunshot",
                                          "Multiple" = "Multiple_Gunshots",
                                          "Gunshot or Firecracker" = "Gunshot_or_Firecracker")) %>% 
      
      # Relevel types
      
      mutate(types = fct_relevel(types, "Single", "Multiple", "Gunshot or Firecracker")) %>%
      
      # In order to show the distribution of different types of gunshot
      # incidents, we compare both the raw counts and the percentages
      
      mutate(total = n()) %>% 
      group_by(types) %>%
      summarize(incidents = n(), percentage = n()/mean(total)) %>% 
      ungroup() %>%
      as.data.frame() %>% 
      select(-geometry) %>%
      
      # Format as gt table
      
      gt() %>%
      tab_header(title = "Types of Gunshot Incidents") %>% 
      fmt_percent(columns = vars(percentage), decimals = 1) %>%
      cols_label(types = "Type of Gunshot",
                 incidents = "Incidents",
                 percentage = "Percentage") 
  })

  output$linePlot<- renderPlot({washington_dc %>% 
      
      # Filter out uncounted shots
        
      filter(!is.na(numshots)) %>%
      
      # Count gunshots by hour
      
      group_by(hour) %>%
      summarize(total_shots = sum(numshots))%>%
      
      # Show trends over time via line plot
      
      ggplot(aes(x = hour, y = total_shots)) + 
      geom_line(col = "red") +
      
      # Scale axes appropriately
      
      scale_x_continuous(breaks = seq(0,23,1)) +
      scale_y_continuous(breaks = seq(0,8000,1000)) +
      labs(x ="Hour",
           y = "Total Gunshots", 
           title = "Number of Gunshots by Hour in Washington DC, 2015-2017",
           subtitle = "The Number of Shots Spikes During the Late Hours of the Night") +
      theme_fivethirtyeight()
    
  })
  
  output$message <- renderText("This project was a collaboration between Diego Martinez 
                    and Shafi Rubbani. Our code can be found at 
                    https://github.com/ShafiRubbani/shotspotter. We give thanks to
                    Justice Tech Lab for their excellent work on the 
                    ShotSpotter project: http://justicetechlab.org/shotspotter-data/.")
   
}

# Run the application 
shinyApp(ui = ui, server = server)

