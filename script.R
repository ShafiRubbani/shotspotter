library(ggplot2)
library(gganimate)
library(janitor)
library(tigris)
library(sf)
library(lubridate)
library(tidyverse)

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
  clean_names()

# washington_dc <- raw_washington_dc %>% 
#   mutate(latitude = as.numeric(gsub("[^0-9.-]", "", latitude))) %>%
#   filter(!is.na(latitude)) %>%
#   mutate(date = mdy(date))

# mutate(ager = case_when(ager == "18 to 34" ~ 26, 
#                         ager == "35 to 49" ~ 42, 
#                         ager == "50 to 64" ~ 57, 
#                         ager == "65 and older"~ 75))
#   mutate(date = mdy(date)) %>% 
  
#mutate(time_range_1 = substr(time_range, 1, 6)
           #substr(time_range, nchar(time_range) - 5, nchar(time_range)))
