# Plot points on a map from selected area with google maps on the bacground 
# Code based on Milano R blogpost: http://www.milanor.net/blog/maps-in-r-plotting-data-points-on-a-map/ and relevant help-files

# This example is customized for data from Helsinki, Finland

#install packages if necessary
install.packages("ggmap")
#load packages
library(ggmap)


# Read in data which has geographic coordinates in stored in columns 'lon' and 'lat'.
# somedata <- read.csv(filename.csv)

#Create the map object
#?get_map # run this line for details on the parameters (for example you can try location="Finland)
map <- get_map(location = 'Helsinki', zoom = 12)

#Plot the bacground map
#plot(map)  # or just type in 'map' in the console
ggmap(map)	# here you can add more options for plotting a ggmap object

#Plot points on the map
mapAndPoints <- ggmap(map) + geom_point(aes(x = lon, y = lat), data = somedata, alpha = .5)
plot(mapAndPoints) # or just type in "mapAndPoints" in the console

