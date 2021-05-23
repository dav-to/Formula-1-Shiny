################################################################
# This Script Prepares the Data for the Drivers Information Tab
################################################################

# Packages
library(ggplot2)
library(tidyr)
library(dplyr)

# drivers
drivers_stat<-read.csv("drivers.csv", header = TRUE, col.names = c("driverId", "driverRef", " number", "code", "forename", "surname", "dob", "nationality", "url"))
# qualifying data
qualifying_stat<-read.csv("qualifying.csv", header = TRUE, col.names = c("qualifyId", "raceId", "driverId", "constructorId", "number", "positionQ", "q1", "q2", "q3"))
# driver standings
driver_standings_stat<-read.csv("driver_standings.csv", header = TRUE, col.names = c("driverStandingsId", "raceId", "driverId", "points", "position", "positionText", "wins"))
# races 
races_stat<-read.csv("races.csv", header = TRUE, col.names = c("raceId", "year", "round", "circuitId", "name", "date", "time", "url"))
# results 
race_results<-read.csv("results.csv", header = TRUE, col.names = c("resultId", "raceId", "driverId", "constructorId", "number", "grid", "position", "positionText", "positionOrder", "points", "laps", "time", "milliseconds", "fastestLap", "rank", "fastestLapTime", "fastestLapSpeed" , "statusId"))
 
# combining data
driver_stat<-merge(drivers_stat, driver_standings_stat, by.x = "driverId", by.y = "driverId", all.x = TRUE, all.y = TRUE)
driver_stat<-merge(driver_stat, qualifying_stat, by.x = c("driverId", "raceId"), by.y = c("driverId","raceId"), all.x = TRUE, all.y = TRUE)
driver_stat<-merge(driver_stat, races_stat, by.x = "raceId", by.y = "raceId", all.x = TRUE)

# only need a subset of constructor_data
driver_stat<-driver_stat[, c( "driverId", "raceId", "forename", "surname", "dob", "nationality", "positionQ", "position", "wins", "year", "round")]

# Paste together forename and surname 
driver_stat <- driver_stat %>% unite("Name", forename, surname, sep = " ")

# fixing some characters in the names
driver_stat[, "Name"]<-gsub("Ã¶", "ö", driver_stat[,"Name"])
driver_stat[, "Name"]<-gsub("Ã¤", "ä", driver_stat[,"Name"])
driver_stat[, "Name"]<-gsub("Ã©", "é", driver_stat[,"Name"])
driver_stat[, "Name"]<-gsub("Ã¼", "ü", driver_stat[,"Name"])

driver_stat$positionQ[is.na(driver_stat$positionQ)]<-0

# number of grand prix wins 
gpWins <- driver_stat %>% group_by(driverId) %>% group_by(year) %>% filter(round==max(round))
gpWins<-gpWins %>% group_by(driverId) %>% summarise(WINS = sum(wins))
# second places
secondPlaces <- race_results %>% group_by(driverId) %>% filter(position == 2) %>% summarise(second = n())
# third places
thirdPlaces <- race_results %>% group_by(driverId) %>% filter(position == 3) %>% summarise(third = n())



# number of poles
poles <- driver_stat %>% group_by(driverId) %>% filter(positionQ==1) %>% summarise(poles=sum(positionQ))

# number of championships (note that the current leader counts as champion here, change later)
championships1 <- driver_stat %>% group_by(driverId) %>% group_by(year) %>% filter(round==max(round)) %>% filter(position==1)
championships <- championships1 %>% group_by(driverId) %>% summarise(championships=sum(position))

# now we need name nationality and date of birth 
driver_data_stat <- driver_stat[,c("driverId","Name", "dob", "nationality")]

# merge with above statistics
drivers_summary<-merge(driver_data_stat, gpWins, by.x = "driverId", by.y = "driverId", all.x = TRUE)
drivers_summary<-merge(drivers_summary, poles, by.x = "driverId", by.y = "driverId", all.x = TRUE)
drivers_summary<-merge(drivers_summary, championships, by.x = "driverId", by.y = "driverId", all.x = TRUE)
drivers_summary<-merge(drivers_summary, secondPlaces, by.x = "driverId", by.y = "driverId", all.x = TRUE)
drivers_summary<-merge(drivers_summary, thirdPlaces, by.x = "driverId", by.y = "driverId", all.x = TRUE)
# only keep unique rows
drivers_summary <- distinct(drivers_summary)

# replace NA with 0
drivers_summary$poles[is.na(drivers_summary$poles)]<-0
drivers_summary$championships[is.na(drivers_summary$championships)]<-0
drivers_summary$WINS[is.na(drivers_summary$WINS)]<-0
drivers_summary$dob<-as.character(drivers_summary$dob)
drivers_summary$nationality<-as.character(drivers_summary$nationality)

# some NAs produced 
drivers_summary<-na.omit(drivers_summary)

# drivers_summary is the data needed for the tab














