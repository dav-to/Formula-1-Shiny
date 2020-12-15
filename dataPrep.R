##################################
# Data Preparation for Seasons Tab
##################################

# Packages

library(ggplot2)
library(tidyr)
library(dplyr)

# Loading Data
# driver standings 
driver_data<-read.csv("driver_standings.csv", header = TRUE, col.names = c("driverStandingsId", "raceId", "driverId", "points", "position", "positionText", "wins") )
# drivers
drivers<-read.csv("drivers.csv", header = TRUE, col.names = c("driverId", "driverRef", " number", "code", "forename", "surname", "dob", "nationality", "url"))
# constructors standings
constructor_data<-read.csv("constructor_standings.csv", header = TRUE, col.names = c( "constructorStandingsId", "raceId", "constructorId", "points", "position", "positionText", "wins"))
# constructors 
constructors<-read.csv("constructors.csv", header = TRUE, col.names = c("constructorId", "constructorRef", "name", "nationality", "url"))
# races
races<-read.csv("races.csv", header = TRUE, col.names = c("raceId", "year", "round", "circuitId", "name", "name", "time", "url"))

# Combining data 
constructor_data<-merge(constructor_data, races, by.x = "raceId", by.y = "raceId")
constructor_data<-merge(constructor_data, constructors, by.x = "constructorId", by.y = "constructorId")

# Only need a subset of constructor_data
constructor_data<-constructor_data[, c( "constructorStandingsId", "raceId", "constructorId", "points", "wins", "year", "round", "name.y")]

# Set the column with the names of constructors to Name
names(constructor_data)[names(constructor_data)=="name.y"]="Name"

# Creating a similar data set for drivers
driver_data<-merge(driver_data, races, by.x = "raceId", by.y = "raceId")
driver_data<-merge(driver_data, drivers, by.x = "driverId", by.y = "driverId")
driver_data<-driver_data[, c("driverId", "raceId", "driverStandingsId", "points", "wins", "year", "round", "forename", "surname")]

# Paste together forename and surname 
driver_data <- driver_data %>% unite("Name", forename, surname, sep = " ")

# Fixing some characters in the names
driver_data[, "Name"]<-gsub("Ã¶", "ö", driver_data[,"Name"])
driver_data[, "Name"]<-gsub("Ã¤", "ä", driver_data[,"Name"])
driver_data[, "Name"]<-gsub("Ã©", "é", driver_data[,"Name"])
driver_data[, "Name"]<-gsub("Ã¼", "ü", driver_data[,"Name"])








