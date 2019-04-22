library(tidyverse)
library(ggplot2)
library(gganimate)
library(janitor)
library(tigris)
library(sf)


raw_shape<- urban_areas(class = "sf")


shapes<-raw_shape%>% filter(NAME10 == "Springfield, MA--CT")

springfield<-springfield%>%filter(!is.na(latitude), !is.na(longitude))


springfield_locations <- st_as_sf(springfield, 
                                  coords = c("longitude", "latitude"), 
                                  crs = 4326) 


ggplot(data= shapes)+ geom_sf()