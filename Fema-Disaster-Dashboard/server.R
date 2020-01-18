#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
v <- c(
  "Annual_Change"	= "Annual Change",
  "HPI" = "Housing Price Index"
  
)

server <-  function(input, output, session) {
    
    # Reactive expression for the data subsetted to what the user selected
    filteredData <- reactive({
        owner_zip[(owner_zip$Total_Approved_IHP_Amount >= input$range[1]) & (owner_zip$Total_Approved_IHP_Amount <= input$range[2]) &
                    (owner_zip$HPI >= input$hpirange[1]) & (owner_zip$HPI <= input$hpirange[2])
                   & (owner_zip$State %in% input$state) & (owner_zip$incidentType %in% input$incident) & 
                    (owner_zip$year == input$dateRange),]
            
    })
    
    
    colorpal <- reactive({
        colorNumeric(input$colors, owner_zip$Total_Approved_IHP_Amount)
    })
    
    output$map <- renderLeaflet({
        
        leaflet(owner_zip) %>% addTiles() %>%
            fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude))
    })
    
    # Overall map in background
    observe({
        pal <- colorpal()
        
        leafletProxy("map", data = filteredData()) %>%
            addTiles() %>% 
            clearShapes() %>%
            addWMSTiles(
                "https://mesonet.agron.iastate.edu/cgi-bin/wms/hrrr/refd.cgi",
                layers = "refd_0000",
                options = WMSTileOptions(format = "image/png", transparent = TRUE),
                attribution = "Weather data © 2012 IEM Nexrad"
            ) %>%  
            addCircles(lng=~Longitude, lat=~Latitude,radius = ~(Average_FEMA_Inspected_Damage)/5, weight = 1, color = "#777777",
                       fillColor = ~pal(Average_FEMA_Inspected_Damage), fillOpacity = .6, popup = ~(paste("Area: ", City, ", ", State, " ", "<br>",
                                                                                                     "Average FEMA Inspected Damage:", dollar(Average_FEMA_Inspected_Damage), "<br>",
                                                                                                     "Approved by FEMA: ", dollar(Total_Approved_IHP_Amount), "<br>",
                                                                                                     "Total Cost of Damages: ", dollar(Total_Damage), "<br>",
                                                                                                     "Number of FEMA Assistance:", Approved_for_FEMA_Assistance, "<br>",
                                                                                                     "Date of Disaster: ", incidentBeginDate))
            ) %>% 
          addCircles(lng=~Longitude, lat=~Latitude,radius = ~(HPI*100)/6, weight = 1, color = "#7c5295",
                      fillOpacity = .4, popup = ~(paste("Area: ", City, ", ", State, " ", "<br>",
                                                                                                    "House Price Index: ", HPI, "<br>",
                                                                                                    "Annual Percentage Change: ", Annual_Change))
          )
    })
    
    
    # map interactions
    observe({
        proxy <- leafletProxy("map", data = owner_zip)
        
        # Remove any existing legend, and only if the legend is
        
        # enabled, create a new one.
        proxy %>% clearControls()
        if (input$legend) {
            pal <- colorpal()
            proxy %>% addLegend(position = "bottomleft", title = "FEMA Inspected Avg Damages",
                                 pal=pal, values = ~Total_Approved_IHP_Amount
            )
        }
        
        
        sel_site <- statell[statell$State == input$state, ]
        isolate({
            new_zoom <- 6
            if(!is.null(input$map_zoom)) new_zoom <- input$map_zoom
            leafletProxy('map') %>%
                setView(lng = sel_site$state_long, lat = sel_site$state_lat, zoom = new_zoom)
            
        })
        
    })
    
    # output$barplotState <- renderPlot({
    #   
    #   d <- owner_zip[(owner_zip$State %in% input$state) & (owner_zip$year %in% input$dateRange) , ]
    #   #pal <- colorpal()
    #   print(barplot(table(d$incidentType), ylab="Total Count of Disasters", xlab="Disaster", col=c("#99CCFF", "#6699CC", "#669999", "#66CCCC")))
    # })
    output$view <- renderTable({
      d <- owner_zip[(owner_zip$State %in% input$state) & (owner_zip$year %in% input$dateRange) , ]
      table(unlist(d$incidentType), dnn='Disaster')
      #names(d) <- 'Disaster'
      #table(Disaster)
        
    })
    # output$hpi <- renderTable({
    #   d <- owner_zip[(owner_zip$State %in% input$state) & (owner_zip$year %in% input$dateRange) , ]
    #   table(d$HPI, dnn='HPI')
    #   #names(d) <- 'Disaster'
    #   #table(Disaster)
    #   
    # })
    
    
}



