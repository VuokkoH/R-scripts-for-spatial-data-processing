
# Plot a very simple map with points and country borders
# handy code for a quick visualization of global point data
# Code is based on the blog post by Milano R user group http://www.milanor.net/blog/maps-in-r-plotting-data-points-on-a-map/ and help files

install.packages("rworldmap")
library(rworldmap)

# Load some point data with geographic coordinates stored in columns 'lon' and 'lat' as decimal degrees
somedata <- read.csv("Filename.csv")

# Generate a map object
newmap <- getMap(resolution = "low") 

#Plot the map object.
plot(newmap, xlim = c(-180, 180), ylim = c(-90, 90), asp = 1) # the whole world
#plot(newmap, xlim = c(10, 15), ylim = c(35, 50), asp = 1) # map centered in italy

#Plot points on the map
points(somedata$lon, somedata$lat, col = "red", cex = .5)


# Have a look at your map! If needed, change the point symbol color or size, map resolution or bounding box.


