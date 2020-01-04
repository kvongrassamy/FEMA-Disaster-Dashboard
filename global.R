library(shinydashboard)
library(tidyverse)
library(DT)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

renter <- read_csv('data/Housing_Assistance_Data_12.20.19_Renters.csv')
names(renter) <- gsub(" ", "_", names(renter))
owner <- read_csv('data/Housing_Assistance_Data_12.20.19_Owners.csv')
owner <- owner[1:(length(owner)-4)]
zipcode <- read_csv('data/zipcode.csv')
zipcode <- select(zipcode, -c(2,3,6))
colnames(zipcode)[1] <- "Zip_Code"
renter_zip <- merge(x=renter, y=zipcode, by = "Zip_Code")
renter_zip$Total_Approved_IHP_Amount <- as.numeric(renter_zip$Total_Approved_IHP_Amount)
#ind <- read.csv('https://www.fema.gov/api/open/v1/IndividualAssistanceHousingRegistrantsLargeDisasters.csv')