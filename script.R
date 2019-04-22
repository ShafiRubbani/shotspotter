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
<<<<<<< HEAD
  mutate(date = mdy(date))%>%
  mutate(latitude = case_when(latitude = 42125 ~ 42.125,
                              latitude = 42122 ~ 42.122,
                              latitude = 42116 ~ 42.116,
                              latitude = 42108 ~ 42.116,
                              latitude = 42102 ~ 42.102,
                              latitude = 42101 ~ 42.101,
                              latitude = 42098 ~ 42.098,
                              latitude = 4209 ~ 42.090))
springfield2<-springfield%>%
  filter(latitude<45)




mutate(ager = case_when(ager == "18 to 34" ~ 26, 
                        ager == "35 to 49" ~ 42, 
                        ager == "50 to 64" ~ 57, 
                        ager == "65 and older"~ 75))
=======
  mutate(date = mdy(date)) %>% 
  
  
  
  #mutate(time_range_1 = substr(time_range, 1, 6)
           #substr(time_range, nchar(time_range) - 5, nchar(time_range)))
>>>>>>> 66b5627b8a6670fa8ffa76fd120a1f7aa6a21084
