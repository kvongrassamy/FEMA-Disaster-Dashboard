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
                sliderInput("Total_Approved_IHP_Amount", "Approved Amt", min= min(renter_zip$Total_Approved_IHP_Amount),max= max(renter_zip$Total_Approved_IHP_Amount),
                            value = range(renter_zip$Total_Approved_IHP_Amount), step = 0.1
                ),
                selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                checkboxInput("legend", "Show legend", TRUE)
  )
)