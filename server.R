library(shiny)
library(dplyr)
library(leaflet)
library(raster)
library(DT)
library(colourpicker)
# also need to run devtools::install_github('rstudio/DT@feature/editor')

## Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output, session) {
  
  bikes <- read.csv("bike_racks.csv", stringsAsFactors = F)

  colnames(bikes) <- c("Surface", "Number", "Type", "Capacity", "Nearest Building","x","y")

  buildings <- read.csv("buildings_occupancy.csv")
  colnames(buildings) <- c("Building", "Capacity")
  
  trees <- read.csv("tree_locations.csv")
  deciduous <- trees[trees$type == "Deciduous", 7:8]
  colnames(deciduous) <- c("x", "y")
  coniferous <- trees[trees$type == "Coniferous", 7:8]
  colnames(coniferous) <- c("x", "y")
  
  rack.proxy = dataTableProxy('bikeDatatable')
  building.proxy = dataTableProxy('buildingDatatable')
  

  bld_poly <- shapefile("buildings_nodouble.shp", verbose=TRUE)
  bld_poly$name[23] <- "Wilson Hall"
  
  buildings <- buildings[match(bld_poly$name, buildings$Building),]
  
  # observe({
  #   output$zoomLvl <- as.numeric(input$map_zoom)
  #   print(output$zoomLvl)
  #   # isolate({
  #   #   updateNumericInput(session, "newlat", value=event3$lat)
  #   #   updateNumericInput(session, "newlon", value=event3$lng)
  #   # })
  # })
 
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Static Functions
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  bikePopups <- function(x) paste(sep = "<br/>",
                           paste("Number of Racks: ", bikes$Number),
                           paste("Type of Rack: ", bikes$Type),
                           paste("Capacity: ", bikes$Capacity))
  mapUpdate <- function(x){
    leafletProxy("map") %>% clearShapes() %>% clearMarkers() %>%
      addCircles(lng=bikes$x, lat=bikes$y, 
                 radius=bikes$Capacity * input$radmult1, 
                 stroke=F, 
                 popup=bikePopups(), 
                 fillOpacity = input$alpha1, 
                 fillColor = rack.colors(), group = "Rack circles") %>%
      addPolygons(data = bld_poly, weight=buildings$Capacity/10 * input$radmult2,
                  popup=paste(sep = "<br/>",
                              buildings$Building,
                              paste("Capacity: ", buildings$Capacity)), 
                  color=input$bld.col,
                  fill=F, opacity=input$alpha2, group = "Building polygons") %>%
      addMarkers(lng=bikes$x, lat=bikes$y, icon=list(iconUrl="bike_rack_icon.gif", iconWidth=20,
                                                   iconHeight=13), group = "Rack icons", popup = bikePopups()) %>%
      addMarkers(lng=deciduous$x, lat=deciduous$y, icon=list(iconUrl="deciduous_icon.gif", iconWidth=12,
                                                             iconHeight=20), group = "Tree icons") %>%
      addMarkers(lng=coniferous$x, lat=coniferous$y, icon=list(iconUrl="coniferous_icon.gif", iconWidth=12,
                                                               iconHeight=20), group = "Tree icons") 
      
  }
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Reactive Functions
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  output$rack.single <- renderText({ input$rack.single })
  
  # output$map_zoom <- renderText({ str(input$map_zoom )})
  
  observe({
    event <- input$map_click
    if (is.null(event))
      return()
    
    isolate({
      updateNumericInput(session, "newlat", value=event$lat)
      updateNumericInput(session, "newlon", value=event$lng)
    })
  })
  
  observe({
    event2 <- input$map_shape_click
    if (is.null(event2))
      return()
    
    isolate({
      updateNumericInput(session, "newlat", value=event2$lat)
      updateNumericInput(session, "newlon", value=event2$lng)
    })
  })
  
  observe({
    event3 <- input$map_marker_click
    if (is.null(event3))
      return()
    
    isolate({
      updateNumericInput(session, "newlat", value=event3$lat)
      updateNumericInput(session, "newlon", value=event3$lng)
    })
  })


  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 1 - Data Table
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$bikeDatatable <- renderDataTable(bikes, options = list(paging=F))
    
  
  output$buildingDatatable <- renderDataTable(buildings, options = list(paging=F))
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 2 - Map
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  rack.colors <- function(x) {
  r.cols <- character(dim(bikes)[1])
  if(input$racksingle == F)
  {
    r.cols[bikes$Type=="Cora Other"] <- input$rack.col1
    r.cols[bikes$Type=="Cora Other|Old"] <- input$rack.col2
    r.cols[bikes$Type=="Old"] <- input$rack.col3
    r.cols[bikes$Type=="Spline"] <- input$rack.col4
    r.cols[bikes$Type=="U shaped"] <- input$rack.col5
    r.cols[bikes$Type=="New"] <- input$rack.col6
  }
  else
  {
    r.cols <- input$rack.col
  }
  return(r.cols)
  }
  
    
  output$map <- renderLeaflet({


                
    m <- leaflet(width=900, height=900) %>%
      # setView(lng = -111.0498, lat = 45.66715, zoom = 17) %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      # addProviderTiles("Stamen.Toner") %>%
      addMarkers(lng=bikes$x, lat=bikes$y, icon=list(iconUrl="bike_rack_icon.gif", iconWidth=20,
                 iconHeight=13), group = "Rack icons", popup = bikePopups()) %>%
      addMarkers(lng=deciduous$x, lat=deciduous$y, icon=list(iconUrl="deciduous_icon.gif", iconWidth=12,
                                                     iconHeight=20), group = "Tree icons") %>%
      addMarkers(lng=coniferous$x, lat=coniferous$y, icon=list(iconUrl="coniferous_icon.gif", iconWidth=12,
                                                             iconHeight=20), group = "Tree icons") %>%
      hideGroup("Tree icons") %>% hideGroup("Rack icons") %>%
      addCircles(lng=bikes$x, lat=bikes$y, 
                 radius=bikes$Capacity * input$radmult1, 
                 stroke=F, 
                 popup=bikePopups(), 
                 fillOpacity = input$alpha1, 
                 fillColor = rack.colors(), group = "Rack circles") %>%
      addPolygons(data = bld_poly, weight = buildings$Capacity/10 * 
                    input$radmult2,
                  popup=paste(sep = "<br/>",
                              buildings$Building,
                              paste("Capacity: ", buildings$Capacity)), 
                  color=input$bld.col,
                  fill=F, opacity=input$alpha2, group = "Building polygons") %>%
      mapOptions(zoomToLimits="first") %>% 
      addLayersControl(
        overlayGroups = c("Rack circles", "Building polygons", "Rack icons", "Tree icons"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      addLegend(position = "topright", 
                colors = c(input$rack.col1, 
                           input$rack.col2,
                           input$rack.col3,
                           input$rack.col4,
                           input$rack.col5,
                           input$rack.col6),
                labels = c("Cora Other", "Cora Other|Old", "Old", 
                           "Spline", "U shaped", "New")) 
      
    print(m)  # Print the map
    
   }) 
  
  # set zoom the first time around
  leafletProxy("map") %>% setView(lng = -111.049421969801, lat = 45.6672429506079, zoom = 17)
  
  observeEvent(input$bikeDatatable_cell_edit, {
    info = input$bikeDatatable_cell_edit
    str(info)
    i = info$row
    j = info$col
    v = info$value
    bikes[i, j] <<- DT:::coerceValue(v, bikes[i, j])
    replaceData(rack.proxy, bikes, resetPaging = F)

    mapUpdate()

  })
  
  observeEvent(input$buildingDatatable_cell_edit, {
    info = input$buildingDatatable_cell_edit
    str(info)
    i = info$row
    j = info$col
    v = info$value
    buildings[i, j] <<- DT:::coerceValue(v, buildings[i, j])
    replaceData(building.proxy, buildings, resetPaging = F)
    mapUpdate()

  })
  
  observeEvent(input$addrack, {
    new.rack <- c("",1,"New", input$newcap, "",input$newlon,input$newlat,"")
    bikes <- rbind(bikes,new.rack)
    
    # There's probably a better way, but this works
    bikes$Number <- as.integer(bikes$Number)
    bikes$Capacity <- as.integer(bikes$Capacity)
    bikes$x <- as.numeric(bikes$x)
    bikes$y <- as.numeric(bikes$y)
    
    # Let everybody else know
    bikes <<- bikes

    replaceData(rack.proxy, bikes, resetPaging = F)

    mapUpdate()


  })

 })


