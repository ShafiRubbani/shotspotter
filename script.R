library(tidyverse)
library(ggplot2)
library(gganimate)
library(janitor)
library(tigris)
library(sf)

springfield <- read_csv("http://justicetechlab.org/wp-content/uploads/2019/04/springfield_ma.csv",
                        col_names = TRUE,
                        col_types = cols(
                          Date = col_character(),
                          `Time Range` = col_character(),
                          Latitude = col_character(),
                          Longitude = col_double(),
                          `Incident Type` = col_character()
                        ))