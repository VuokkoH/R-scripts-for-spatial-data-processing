#####################
# Read Shapefile to R
#####################
#
# R script for reading in shapefile attributes for further processing
# Inspired by eg: https://www.r-bloggers.com/things-i-forget-reading-a-shapefile-in-r-with-readogr/

##----------------
## PACKAGES
##---------------

#Install rgdal if needed and required dependencies
#install.packages("rgdal")

#Load rgdal
library(rgdal)

##------------------
## WORKING DIRECTORY
##------------------
#set working directory
setwd("C:/.../") #insert path here

#get working directory
getwd()

#list files in the working directory
dir()

##-----------------
## READ SHAPEFILE USING readOGR()
##-----------------
#Parameters
	#dsn is the directory where the file is located. 
		#for working directory, you can set dsn="."
	#layer is the name of the shapefile WITHOUT the ".shp" suffix

#read data with readOGR() from the working directory
shape <-readOGR(dsn=".", layer="shapefilename")

#check shape properties
dim(shape)
head(shape)
names(shape)
summary(shape)
str(shape)

#Quick visualization:
plot(shape)

# Now you are ready to make further processing and analysis with the shapefile!
data <- shape # pass the data over over to other R-scripts..



