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

urban_shapes <- urban_areas(class = "sf")

washington_shapes <- raw_shape %>%
  filter(str_detect(NAME10, "Washington, DC--VA--MD"))

washington <- raw_washington_dc %>%
  filter(latitude > 30, longitude < -70) %>% 
  filter(year > 2014)

washington_locations <- st_as_sf(washington, 
                                  coords = c("longitude", "latitude"), 
                                  crs = 4326)

ggplot(data = washington_shapes) + 
  geom_sf()

ggplot() +
  geom_sf(data = shapes2) +
  geom_sf(data = washington_locations)
