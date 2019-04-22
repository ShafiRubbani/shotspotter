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

<<<<<<< HEAD
# springfield <- raw_springfield %>% 
#   mutate(latitude = as.numeric(gsub("[^0-9.-]", "", latitude))) %>%
#   filter(!is.na(latitude)) %>% 
#   mutate(date = mdy(date))
=======
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
  
  
>>>>>>> 53a0ff3d9d28656dc0cc5a6fc48284cdcd8d5e95
  
#mutate(time_range_1 = substr(time_range, 1, 6)
           #substr(time_range, nchar(time_range) - 5, nchar(time_range)))
>>>>>>> 66b5627b8a6670fa8ffa76fd120a1f7aa6a21084
