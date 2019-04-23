library(tidyverse)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(gifski)
library(png) 
library(gganimate)

# For our second tab, total shots, we wanted to make an animated line graph.
# To do so we created a gif in this script and saved it in the shiny app folder,
# "Shotspotter," so we can display it on our app.

# Dataset created from Data Manipulations script. 

raw_washington_dc %>% 
  
  filter(!is.na(numshots)) %>%

  # Analyzing by hour  
  
  group_by(hour) %>%
  
  # Instead of just counting incidents, we wanted the actual number of shots taken
  # at each hour.
  
  mutate(total_shots = sum(numshots)) %>%
  
  # Creates the plot
  
  ggplot(aes(x=hour, y=total_shots)) +
  
  # Using geom_line to see the trend over time
  
  geom_line(col = "red") +
  
  # We wanted to be able to see total shots each hour.
  
  scale_x_continuous(breaks = seq(0,23,1)) +
  
  # It's easier to tell total shots with this scale adjustment. 
  
  scale_y_continuous(breaks = seq(0,8000,1000)) +
  
  # Informative labels and titles. 
  
  labs(x ="Hour", y = "Total Gunshots", 
       title = "Total Number of Gunshots by Hour in Washington, DC",
       subtitle = "The Number of Shots Spike During the Late Hours of the Night")+
  
  # More aesthetically pleasing than normal white background.
  
  theme_dark() +
  
  # Transition which moves the geom_line stopping at each hour.  
  
  transition_reveal(hour)

  # Enables to access the gif in the shiny app. 

anim_save("./Shotspotter/gunshots.gif", animation = last_animation())

