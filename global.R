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
names(owner) <- gsub(" ", "_", names(owner
                                     ))
zipcode <- read_csv('data/zipcode.csv')
zipcode <- select(zipcode, -c(2,3,6))
colnames(zipcode)[1] <- "Zip_Code"
renter_zip <- merge(x=renter, y=zipcode, by = "Zip_Code")
renter_zip['Owner/Renter'] <- "Renter"
owner['Owner/Renter'] <- "Owner"
owner_zip <- merge(x=owner, y=zipcode, by = "Zip_Code")
total_zip <- merge(x=renter_zip, y=owner_zip, on =c("Disaster",	"Latitude", "Longitude",	"Zip Code"))
#ind <- read.csv('https://www.fema.gov/api/open/v1/IndividualAssistanceHousingRegistrantsLargeDisasters.csv')