#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


ui <- bootstrapPage(title="FEMA Disaster Relief",
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "IHP Approved Amt", min= min(owner_zip$Total_Approved_IHP_Amount),max= max(owner_zip$Total_Approved_IHP_Amount),
                            value = range(owner_zip$Total_Approved_IHP_Amount), step = 100
                ),
                sliderInput("hpirange", "Hosing Price Index Range", min= min(owner_zip$HPI),max= max(owner_zip$HPI),
                            value = range(owner_zip$HPI), step = 10
                ),
                selectInput("state", "State Abbreviation",
                            unique(owner_zip$State), selected = "CA"
                ),
                selectInput("incident", "Incedent ",
                            unique(owner_zip$incidentType), selected = "Fire"
                ),
                selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                checkboxInput("legend", "Show legend", TRUE),
                selectInput('dateRange',
                               label = 'Year of Disaster Occurance:',
                            sort(unique(owner_zip$year), decreasing = TRUE), selected = "2018"),
                # plotOutput("barplotState", height = 250,width = 250)
                tableOutput("view")
                # tableOutput("hpi")
  )
  #sidebarPanel(bottom=10, left=10, plotOutput("barplotState", height = 250))
)