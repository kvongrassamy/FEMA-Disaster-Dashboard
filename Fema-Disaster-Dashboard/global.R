library(shinydashboard)
library(tidyverse)
library(DT)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(readxl)
library(ggplot2)


owner <- read_csv('https://www.fema.gov/api/open/v1/HousingAssistanceOwners.csv')
owner <- select(owner, -c(24,25))
names(owner) <- c('Disaster'	,'State'	,'County'	,'City'	,'Zip Code'	,'Valid Registrations'	,'Average FEMA Inspected Damage'	,'Total Inspected'	,'Total Damage'	,'No FEMA Inspected Damage'	,'FEMA Inspected Damage between $1 and $10,000'	,'FEMA Inspected Damage between $10,001 and $20,000'	,'FEMA Inspected Damage between $20,001 and $30,000'	,'FEMA Inspected Damage > $30,000'	,'Approved for FEMA Assistance'	,'Total Approved IHP Amount'	,'Repair/Replace Amount'	,'Rental Amount'	,'Other Needs Amount'	,'Approved between $1 and $10,000'	,'Approved between $10,001 and $25,000'	,'Approved between $25,001 and Max'	,'Total Max Grants')

names(owner) <- gsub(" ", "_", names(owner))
cr <- read_csv('data/DisasterCrosswalk_1.csv')
statell <- read_csv('data/stateslonglat.csv')
zipcode <- read_csv('data/zipcode.csv')
zipcode <- select(zipcode, -c(2,3,6))
colnames(zipcode)[1] <- "Zip_Code"
owner_zip <- merge(x=owner, y=zipcode, by = "Zip_Code") %>% 
  merge(y=statell, by = "State") %>% 
  inner_join(y=cr, by = c("Disaster", "State"))

historical <- read_excel('data/FIDA_20404_HA_Own_Rent_archived.xlsx', sheet = "Owners Export1539-1599") %>% 
    rbind(read_excel('data/FIDA_20404_HA_Own_Rent_archived.xlsx', sheet = "Owners Export 1603-1607")) %>% 
    rbind(read_excel('data/FIDA_20404_HA_Own_Rent_archived.xlsx', sheet = "Owners Export 1609-1705")) %>% 
    rbind(read_excel('data/FIDA_20404_HA_Own_Rent_archived.xlsx', sheet = "Owners Export 1708-1809")) %>% 
    rbind(read_excel('data/FIDA_20404_HA_Own_Rent_archived.xlsx', sheet = "Owners Export 1810-1981")) %>% 
    rbind(read_excel('data/FIDA_20404_HA_Own_Rent_archived.xlsx', sheet = "Owners Export1983-4101"))
names(historical) <- gsub(" ", "_", names(historical))
historical <- merge(x=historical, y=zipcode, by = "Zip_Code") %>% 
     merge(y=statell, by = "State")%>% 
    inner_join(y=cr, by = c("Disaster", "State"))

#renter_zip <- merge(x=renter, y=zipcode, by = "Zip_Code") %>% 
#  merge(y=statell, by = "State")%>% 
#  inner_join(y=cr, by = "Disaster")
#renter_zip <- select(renter_zip, -c(7,8))

#renter_zip['Owner/Renter'] <- "Renter"
#owner['Owner/Renter'] <- "Owner"


owner_zip <- rbind(owner_zip, historical)
US <- unique(owner_zip$State)



#ind <- read.csv('https://www.fema.gov/api/open/v1/IndividualAssistanceHousingRegistrantsLargeDisasters.csv')