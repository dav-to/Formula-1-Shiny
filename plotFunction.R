########################
# Function for Plotting
########################

# Packages

library(ggplot2)
library(tidyr)
library(dplyr)

# Disclaimer caption 

cap<-"Data source 
ergast.com/mrd"

# Function for Plotting

plot_f1<-function(year_val, d, top){
  if (d == "A"){
    dataset <- driver_data
    labelname <- "Driver"
  } else {
    dataset <- constructor_data
    labelname <- "Constructor"
  }
  
  #Subbsetting the year we want to plot
  c_plot_data<-subset(dataset, year==year_val)
  # sorting after final result 
  subdata<-c_plot_data %>% filter(round == max(round))
  subdata<-arrange(subdata, desc(points))
  topnames<-subdata[1:top,"Name"]
  c_plot_data<-c_plot_data %>% filter(Name %in% topnames)
  #c_plot_data<-subset(c_plot_data, Name == topnames)
  plot1<-ggplot(c_plot_data, aes(x=round, y =points, color=Name,
                                 linetype = Name)) + geom_line(size=1.3) + theme_light() + 
    ggtitle(year_val) + labs(x="Race", caption = cap, colour = labelname, linetype =labelname )
  return(plot1)
}
