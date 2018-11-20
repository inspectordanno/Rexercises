# Download boston neighborhood shape file from
# https://data.cityofboston.gov/City-Services/Boston-Neighborhood-Shapefiles/af56-j7tb
# load shapefile


library(rgdal)
bos <- readOGR(dsn="data/bos_tracts/", layer="bos_tracts", stringsAsFactors = F)
plot(bos)
plot(bos, col = c("lightgreen"), bg = "lightblue", lwd = 0.5)


#explore the data contained in the shape file
summary(bos)          # the summary - mean coord, areas etc.
bos@data              # the data frame of attributes of each polygon @ is the operator to access "slots" - part of a class
bos@data$Name         # access columns in names of the neighborhoods
bos@bbox              # bounding box - these are not lat/lon coordinates, but the massachusetts state coordinate system, NAD83
bos@proj4string       # projection string

# plot shapefile with ggplot
# first, we need to convert the shapefile so that we can use it in ggplot, result is a data frame
library(ggplot2)
bos.f <- fortify(bos)

#now plot it as polygons (try without group!)
g <- ggplot() + 
  geom_polygon(data = bos.f, aes(x = long, y = lat, group=group), 
               color='black',fill="#222244", size = 0.3) 
g

# add a constraint for 1:1 aspect ratio
g <- g + coord_fixed(ratio = 1.3)
g

# set limits
g <- g + lims(y = c(42.25,42.4), x = c(-71.2,-70.9))

# set white background, no axes
g + theme_void()
g <- g + theme_minimal()
g

# now lets load additional data and display it
cc <- read.csv(file="data/citizensconnect_latlon.csv")

g <- g + geom_point(data=cc, aes(x=lon, y=lat, color = service_name), size = 2, alpha = 0.7)
g

# use qualitative palette from brewer color
g <- g + scale_color_brewer(type="qual")
g

# we can save the data as a shapefile
# then we convert this new data frame into a spatial data frame
# missing values are not allowed here! filter them out first
# coordinates command overwrites the original, so we need to make a copy first
cc2 <- cc
coordinates(cc2)<- c("lon", "lat")

# we can save this spatial data frame now as a shapefile, which we can open in cartoDB or GIS software
writeOGR(cc2, driver = "ESRI Shapefile",  layer = "ccpoints", dsn = "data/cc")


# interactive maps with leaflet
# consult http://rstudio.github.io/leaflet 

library(leaflet)

map <- leaflet()

map %>% addPolygons(data=bos, color = "red", weight = 0.5) 

pal <- colorNumeric(palette = "plasma", domain = bos@data$AREA_ACRES)
p2 <- colorFactor(palette = "Set1", domain = cc$service_name)

map %>% 
  addPolygons(data=bos, color = ~pal(bos@data$AREA_ACRES), weight = 0.5, opacity = 0.7) %>% 
  addCircleMarkers(data=cc,radius = 2, weight = 4, popup=~service_name,  color=~p2(cc$service_name))


map %>% 
  addProviderTiles("Esri.WorldImagery", options = providerTileOptions(opacity = 0.4, minZoom = 10, maxZoom = 17)) %>%
  addPolygons(data=bos, color = ~pal(bos@data$AREA_ACRES), weight = 0.5, opacity = 0.7) %>% 
  addCircleMarkers(data=cc,lat = ~lat, lng = ~lon, radius = 2, weight = 4, popup=~service_name,  color=~p2(cc$service_name))


# further ideas for working with projections
# http://rpsychologist.com/working-with-shapefiles-projections-and-world-maps-in-ggplot