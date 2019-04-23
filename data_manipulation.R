library(ggplot2)
library(gganimate)
library(janitor)
library(tigris)
library(sf)
library(lubridate)
library(tidyverse)
library(gt)

# Read ShotSpotter data from csv
# http://justicetechlab.org/shotspotter-data/

raw_washington_dc <- read_csv("http://justicetechlab.org/wp-content/uploads/2018/05/washington_dc_2006to2017.csv",
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
  clean_names()%>%
  
  # A few points with very different latitudes and longitudes that would distort
  # map are removed
  
  filter(latitude > 30, longitude < -70) %>% 
  
  # This is a very large dataset and plotting each point on geom_sf takes a long
  # time, so we decided to only use data going back to 2014
  
  filter(year > 2014)

  # Converts original dataset into an sf. We now have the capability to graph
  # gunshot locations on the map of D.C.

washington_locations <- st_as_sf(raw_washington_dc, 
                                 coords = c("longitude", "latitude"), 
                                 crs = 4326)

# Writing a shape file. Instead of doing all of this in the shiny app server, we
# thought it would save processing time and create a file that we can read
# in and impliment directly into the Shiny app.

st_write(washington_locations, dsn = "./Shotspotter/washington_locations.shp")
