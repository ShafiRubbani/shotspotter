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


raw_shape%>%filter(str_detect(NAME10, "Washington"))


shape3<-shapes2%>%st_bbox(c(xmin = -77.1, xmax = -75.86, ymax = 39.03, ymin = 38.79), crs = st_crs(4326))

shapes3 <- shapes2 %>% 
  filter()


washington<-raw_washington_dc%>%filter(latitude>30, longitude< -70)


washington_locations <- st_as_sf(washington, 
                                  coords = c("longitude", "latitude"), 
                                  crs = 4326) %>% 
  filter(year > 2015)




ggplot(data = shapes2) + 
  geom_sf() +
  geom_sf(data = washington_locations)


ggplot(data = shape3) + 
  geom_sf()


shapes2$geometry
