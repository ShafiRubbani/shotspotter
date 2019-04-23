library(tidyverse)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(gifski)
library(png) 
library(gganimate)

#for our second tab of total shots, we wanted to make it an animated line graph.
#To do so we created a gif in this script and saved in in the shiny app folder
#"Shotspotter" so we can display it on our app.

#dataset created from Data Manipulations script. 

raw_washington_dc%>% 
  
filter(!is.na(numshots))%>%

#analyzing by hour  
  
  group_by(hour)%>%
  
 #instead of just counting incidents, we wanted the actual number of shots taken
 #at each hour.
  
  mutate(total_shots = sum(numshots))%>%
  
  #creates the plot
  
  ggplot(aes(x=hour, y=total_shots)) +
  
  #using geom_line to see the trend over time
  
  geom_line(col = "red")+
  
  #wanted to be able to see total shots at each hour.
  
  scale_x_continuous(breaks = seq(0,23,1)) +
  
  #easier to tell total shots with this scale adjustment. 
  
  scale_y_continuous(breaks = seq(0,8000,1000)) +
  
  #informative labels and titles. 
  
  labs(x="Hour", y= "Total Gunshots", 
       title= "Total Number of Gunshots by Hour in Washington, DC",
       subtitle = "The Number of Shots Spike During the Late Hours of the Night")+
  
  #more aesthetically pleasing than normal white background.
  
  theme_dark()+
  
  #transition which moves the geom_line stopping at each hour.  
  
  transition_reveal(hour)

  #enables to access the gif in the shiny app. 

anim_save("./Shotspotter/gunshots.gif", animation = last_animation())