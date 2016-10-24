library(leaflet)
library(colourpicker)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Application title
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  headerPanel("Bike Data"),

  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Sidebar Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sidebarPanel(
      
    # wellPanel(
      checkboxInput("ss", HTML("<b>SHAPE SETTINGS</b>"), FALSE),
      conditionalPanel(
        condition = "input.ss == true",
        wellPanel(
        sliderInput("alpha1", "Rack Alpha:",
                    min = 0, max = 1, step = 0.1, value = c(0.2)),
        helpText("These set the bike rack color transparencies"),
        sliderInput("alpha2", "Occupancy Alpha:",
                    min = 0, max = 1, step = 0.1, value = c(0.2)),
        helpText("These set the building color transparencies"),
        sliderInput("radmult1", "Radius size (racks):",
                    min = 0.1, max = 2, step = .1, value = .4),
        sliderInput("radmult2", "Radius size (buildings):",
                    min = 0.1, max = 1, step = .1, value = .4)
      )
      ),
      
      checkboxInput("cs", HTML("<b>COLOR SETTINGS</b>"), FALSE),
      conditionalPanel(
        condition = "input.cs == true",
    wellPanel(
      colourInput("bld.col", "Occupancy Color", "#FF3333",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide"),
    checkboxInput("racksingle", "One color for racks", FALSE),
                
    conditionalPanel(
      condition = "input.racksingle == true",
      colourInput("rack.col", "Rack Color", "black",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide")
    ),
    
    conditionalPanel(
      condition = "input.racksingle == false",
      colourInput("rack.col1", "Cora Other", "black",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide"),
      colourInput("rack.col2", "Cora Other|Old", "blue",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide"),
      colourInput("rack.col3", "Old", "green",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide"),
      colourInput("rack.col4", "Spline", "brown",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide"),
      colourInput("rack.col5", "U shaped", "orange",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide"),
      colourInput("rack.col6", "New", "#1FACF2",
                  showColour = "both", palette="square",
                  allowTransparent = TRUE, transparentText = "Hide")
    ),
    width = 3
    )
    ),
    
    checkboxInput("ar", HTML("<b>ADD RACKS</b>"), FALSE),
    conditionalPanel(
      condition = "input.ar == true",
      wellPanel(
        numericInput("newlat", label="Latitude:", 45.66715, min=-90, max=90),
        numericInput("newlon", label="Longitude:", -111.0498, min=-180, max=180),
        numericInput("newcap", "Capacity:", 10),
        actionButton("addrack", "Add Rack")
      ))

    
  ),
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Main Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  mainPanel(
    tabsetPanel(

      ## Core tabs
      tabPanel("Map", leafletOutput("map", width=800, height=800)),
      tabPanel("Instructions", includeMarkdown("docs/introduction.md")),
      tabPanel("Racks", dataTableOutput("bikeDatatable")), 
      tabPanel("Buildings", dataTableOutput("buildingDatatable"))

    ) 
  )
  
))