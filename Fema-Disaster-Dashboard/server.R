#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    # Reactive expression for the data subsetted to what the user selected
    filteredData <- reactive({
        renter_zip[(renter_zip$Total_Approved_IHP_Amount >= input$range[1]) & (renter_zip$Total_Approved_IHP_Amount <= input$range[2]) & (renter_zip$State == input$state),] 
            
    })
    
    # This reactive expression represents the palette function,
     #which changes as the user makes selections in UI.
    colorpal <- reactive({
        colorNumeric(input$colors, renter_zip$Total_Approved_IHP_Amount)
    })
    
    output$map <- renderLeaflet({
        # Use leaflet() here, and only include aspects of the map that
        # won't need to change dynamically (at least, not unless the
        # entire map is being torn down and recreated).
        leaflet(renter_zip) %>% addTiles() %>%
            fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude))
    })
    
    # Incremental changes to the map (in this case, replacing the
    # circles when a new color is chosen) should be performed in
    # an observer. Each independent set of things that can change
    # should be managed in its own observer.
    observe({
        pal <- colorpal()
        
        leafletProxy("map", data = filteredData()) %>%
            addTiles(
                urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
            ) %>% 
            setView(lng = -93.85, lat = 37.45, zoom = 4) %>% 
            clearShapes() %>%
            addCircles(lng=~Longitude, lat=~Latitude,radius = ~(sqrt(Total_Approved_IHP_Amount)*100)/3, weight = 1, color = "#777777",
                       fillColor = ~pal(Total_Approved_IHP_Amount), fillOpacity = 0.9, popup = ~paste(Total_Approved_IHP_Amount)
            )
    })
    
    # Use a separate observer to recreate the legend as needed.
    observe({
        proxy <- leafletProxy("map", data = renter_zip)
        
        # Remove any existing legend, and only if the legend is
        # enabled, create a new one.
        proxy %>% clearControls()
        if (input$legend) {
            pal <- colorpal()
            proxy %>% addLegend(position = "bottomright",
                                 pal=pal, values = ~Total_Approved_IHP_Amount
            )
        }
    })
}
