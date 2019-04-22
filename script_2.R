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


shapes<-raw_shape%>% filter(NAME10 == "Springfield, MA--CT")

springfield2<-springfield2%>%filter(!is.na(latitude), !is.na(longitude))


springfield_locations <- st_as_sf(springfield2, 
                                  coords = c("longitude", "latitude"), 
                                  crs = 4326) 


ggplot(data= shapes)+ geom_sf()+geom_sf(data = springfield_locations)