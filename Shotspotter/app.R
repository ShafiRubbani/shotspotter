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

# Read in sf file I created from manipulating data from ShotSpotter
# http://justicetechlab.org/shotspotter-data/

washington_location<-st_read("washington_locations.shp")

# Download shapefiles for urban areas

urban_shapes <- urban_areas(class = "sf")

# Save Washington DC shapfiles

washington_shapes <- urban_shapes %>%
  filter(str_detect(NAME10, "Washington, DC--VA--MD"))

# Define UI for ShotSpotter App. Creating tabs for viewrs to click through. The
# app has three panels: a plot showing gunshots on a map, an animated plot
# showing the distribution of gunshots by hour, and an about page

ui <- fluidPage(tabsetPanel(
  
#name first tab 
  
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
      
  #displays map and table created in the server in middle of the Map tab.  
  
      mainPanel(
        plotOutput("shotPlot"),
        tableOutput("table")
        ))
),

#other two tabs 

#we had trouble animating the geom_line within the server. Thus decided to
#create the graphic outside of the app and render the Gif

tabPanel("Total Shots", imageOutput("animated_graph")),

#displays text giving thanks and our Github

tabPanel("About", textOutput("message"))
))


# Define server logic

server <- function(input, output) {
  

  
  # Filter gunshot locations by hour
  
  gunshot_locations <- reactive({washington_location %>%
      filter(hour == input$hour)})

  # Render gunshot map
  
  output$shotPlot <- renderPlot({
    ggplot() +
      
      # Plot Washington DC map
      
      geom_sf(data = washington_shapes) +
      
      # Plot gunshot locations, coloring by the number of shots
      
      geom_sf(data = gunshot_locations(), aes(color = numshots), alpha = 0.2) +
      
      # Zoom into relevant area. The only map from tigris was of the greater
      # Washington, D.C. Area making it seem like all of the data is aggregated
      # in one small section of the map when only the city of Washington, D.C.
      # is within these limits.
      
      coord_sf(xlim = c(-77.11979522, -76.867218), ylim = c(38.79164435, 39.031386)) +
      labs(title = "Gunshot Locations by the Hour",
        color = "Number of Shots") +
      
     # takes away axis tick marks and lats and lngs.
      
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
      
      #creates more readible and aesthetically pleasing percentages
      
      fmt_percent(columns = vars(percentage), decimals = 1) %>%
      
      #fixes column titles
      
      cols_label(types = "Type of Gunshot",
                 incidents = "Incidents",
                 percentage = "Percentage") 
  }) 
  
  
  #displays gif created of total gunshots.
  
  output$animated_graph <- renderImage({
    list(src = "gunshots.gif",
         contentType = 'image/gif')
  },
  deleteFile = FALSE)
  
  #creates about page where we give thanks and share our repo.
  
  output$message <- renderText("This project was a collaboration between Diego Martinez 
                    and Shafi Rubbani. Our code can be found at 
                    https://github.com/ShafiRubbani/shotspotter. We give thanks to
                    Justice Tech Lab for their excellent work on the 
                    ShotSpotter project: http://justicetechlab.org/shotspotter-data/.")
   
}

# Run the application 
shinyApp(ui = ui, server = server)

