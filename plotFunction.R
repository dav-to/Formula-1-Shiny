########################
# Function for Plotting
########################

# Packages
library(ggplot2)
library(ggthemes)
library(tidyr)
library(dplyr)

# Function for Plotting

plot_f1<-function(year_val, d, top){
  if (d == "A"){
    dataset <- driver_data
    labelname <- "Driver"
  } else {
    dataset <- constructor_data
    labelname <- "Team"
  }
  
  #Subbsetting the year we want 
  c_plot_data<-subset(dataset, year==year_val)
  # sorting after final result 
  subdata<-c_plot_data %>% filter(round == max(round))
  subdata<-arrange(subdata, desc(points))
  topnames<-subdata[1:top,"Name"]
  c_plot_data<-c_plot_data %>% filter(Name %in% topnames)
  #c_plot_data<-subset(c_plot_data, Name == topnames)
  plot1<-ggplot(c_plot_data, aes(x=round, y =points, color=Name,
                                 linetype = Name)) + geom_line(size=1.3, linetype="solid") + geom_point(size=3) + theme_solarized_2(light = FALSE) +
    ggtitle(year_val) + labs(x="Race", colour = labelname, linetype =labelname )
  return(plot1)
}



