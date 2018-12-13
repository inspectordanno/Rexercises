#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(rgdal)
bos <- readOGR(dsn="./data/bos_tracts/", layer="bos_tracts", stringsAsFactors = F)

bos@data$POP100_RE <- as.numeric(bos@data$POP100_RE)
bos@data$HU100_RE <- as.numeric(bos@data$HU100_RE)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Shiny"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("var",
                     "variable to display", choices = c("AREA_SQFT","POP100_RE","HU100_RE"), 
                     selected = "HU100_RE"
                     )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         leafletOutput("leaflet")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$leaflet <- renderLeaflet({
     sel <- input$var
     pal <- colorNumeric(palette = "plasma", domain = bos@data[,sel])
     
     map <- leaflet()
     map %>% addProviderTiles("Esri.WorldImagery", options = providerTileOptions(minZoom = 10, maxZoom = 17)) %>%
       addPolygons(data=bos, color = ~pal(bos@data[,sel]), weight = 0.5, opacity = 0.8) 
        })
}

# Run the application 
shinyApp(ui = ui, server = server)

