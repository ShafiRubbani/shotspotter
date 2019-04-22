library(tidyverse)
library(ggplot2)
library(gganimate)
library(janitor)
library(tigris)
library(sf)
library(lubridate)

raw_springfield <- read_csv("http://justicetechlab.org/wp-content/uploads/2019/04/springfield_ma.csv",
                        col_names = TRUE,
                        col_types = cols(
                          Date = col_character(),
                          `Time Range` = col_character(),
                          Latitude = col_character(),
                          Longitude = col_double(),
                          `Incident Type` = col_character()
                        )) %>% 
  clean_names()

springfield <- raw_springfield %>% 
  mutate(latitude = as.numeric(gsub("[^0-9.-]", "", latitude))) %>%
  filter(!is.na(latitude)) %>% 
  mutate(date = mdy(date)) %>% 
  
  
  
  #mutate(time_range_1 = substr(time_range, 1, 6)
           #substr(time_range, nchar(time_range) - 5, nchar(time_range)))
