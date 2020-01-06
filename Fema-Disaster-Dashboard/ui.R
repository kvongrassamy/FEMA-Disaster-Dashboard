#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "IHP Approved Amt", min= min(owner_zip$Total_Approved_IHP_Amount),max= max(owner_zip$Total_Approved_IHP_Amount),
                            value = range(owner_zip$Total_Approved_IHP_Amount), step = 100
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
                plotOutput("scatterState", height = 250)
  )
)