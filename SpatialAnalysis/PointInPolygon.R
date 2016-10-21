#------------------------------------------------
# Author: Vuokko H. (With a little help from google)
# Last edited: 21.10.2016
#
# Worked using:
	# R version 3.3.1 (2016-06-21) -- "Bug in Your Hair"
	# Copyright (C) 2016 The R Foundation for Statistical Computing
	# Platform: x86_64-w64-mingw32/x64 (64-bit)

# Code for joining attributes from polygon to intersecting points (point-in-polygon)
# using sp over
# This script has been succesfully used with these datasets:
	# Polygons: world country data or national park borders 
	# Points: geotagged social media data (Twitter or Instagram)

##################
## PACKAGES
##################
#some packages needed for the spatial analysis
install.packages("sp")
library(sp)
install.packages("rgdal")
library(rgdal)


##################
## INPUT POLYGONS
##################
#--------------------------------
# OPTION 1: WORLD COUNTRIES
# Administrative borderds of countries in the world as a shapefile
# data originally downloaded from http://www.gadm.org/ and converted to shapefile from ESRI Geodatabase feature class -format
world <- readOGR(dsn="." layer="GADM_adm0")

# dropping unnecessary columns
#world <- world[,1:5] # country identifiers

#pass data over for the point-in-polygon analysis
polygons <- world

#---------------------------------------
#OPTION 2: FINNISH NATIONAL PARKS
dir="C:/../"
# Original data from SYKE [add details]
Parks <- readOGR(dsn=dir, layer="NationalParks_Finland")

# dropping unnecessary columns
Parks <- Parks[,4] # Column with national park names

#check data properties
names(Parks)
head(Parks$Nimi)
summary(Parks$Nimi)
plot(Parks)

#pass data over for the point-in-polygon analysis
polygons <- Parks

##################
## INPUT POINTS
##################
# Read in data from a shapefile, csv-file, database.. (see other scripts for this purpose)
#pass data over for the point-in-polygon analysis
point_data <- data 

### FOR TEXT FILES, OR EG TWITTER DATA WITH ONLY PLACE TAGS
# we need to make the layer into a spatial point dataframe by indicating which columns contain coordinates
#coordinates(point_data) <- ~ place_lon + place_lat

###########################
## Projections
###########################
# Project data to an identical CRS
polygons <- spTransform(polygons, CRS("+proj=longlat +datum=WGS84"))
point_data <- spTransform(point_data, CRS("+proj=longlat +datum=WGS84"))

#Double check if the CRS definitions match (proj4string should be the same)
summary(polygons)
summary(point_data)

# If needed you can brute-force fix the crs definition to be identical in the two layer 
# Be sure of what you are doing here, otherwise you might mess up the data..
#proj4string(ParksWGS84) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

###########################
## POINT-IN-POLYGON
###########################

#joining polygon info to points based on a point-in-polygon analysis:
point_in_polygon <- over(point_data, polygons)
summary(point_in_polygon)

#The resulting table should be the same length as the original data
nrow(point_data)
nrow(point_in_polygon)

#note, the result table is non-spatial and is lacking the attributes from the points.

#######################################
# JOIN ATTRIBUTES TO SPATIAL POINT DATA 
#######################################
# Credits for this step go to this blog:
# http://gis.stackexchange.com/questions/137621/join-spatial-point-data-to-polygons-in-r/137629#13762

# in this case we add the name of the national park to the point data
data$NP = point_in_polygon$Nimi

# this results in a table which has all the points, and info on the intersecting polygon

##########################
# WRITE SHAPEFILE TO DISK 
##########################
#Give a name for the output file WITHOUT the .shp extension
Outputfile = "pointsWithInfo"

#SYNTAX: writeOGR(obj, dsn, layer, driver, dataset_options = NULL, layer_options=NULL, verbose = FALSE, check_exists=NULL, overwrite_layer=FALSE, delete_dsn=FALSE, morphToESRI=NULL, encoding=NULL)
writeOGR(data, ".", Outputfile, driver="ESRI Shapefile")

#you can check if the file appeared ok in your working directory
dir()





