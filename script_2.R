library(tidyverse)
library(sf)
library(fs) 
library(ggplot2)
library(lubridate)
library(dplyr)
library(ggthemes)
library(gifski)
library(png) 
library(gganimate)

raw_shape<- urban_areas(class = "sf")


shapes2<-raw_shape%>%filter(str_detect(NAME10, "Washington, DC--VA--MD"))


washington<-raw_washington_dc%>%filter(latitude>30, longitude< -70)


springfield_locations <- st_as_sf(springfield2, 
                                  coords = c("longitude", "latitude"), 
                                  crs = 4326) 


ggplot(data= shapes2)+ geom_sf()