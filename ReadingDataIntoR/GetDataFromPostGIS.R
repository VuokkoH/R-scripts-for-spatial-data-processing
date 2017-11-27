#####################
# Read PostGIS data to R
#####################
#
# R script for reading PostGIS data for further processing
# Ideas and info from:
# - https://github.com/mablab/rpostgis
# - https://cran.r-project.org/web/packages/rpostgis/rpostgis.pdf
# - https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf
# - https://cran.r-project.org/web/packages/sp/sp.pdf

##----------------
## PACKAGES
##----------------

#Install rpostgis and sp if needed and required dependencies
#install.packages("rpostgis", "sp")

#Load rpostgis
library(rpostgis)

#Load sp (Classes and Methods for Spatial Data)
library(sp)


##---------------
## CONNECT TO POSTGIS DATABASE
##---------------

# Create connection (in the example you have a PostgreSQL server running on localhost and it has the database with the name osmtm)
#Parameters
#drv should be string "PostgreSQL"
#dbname is name of the database
#host is the DNS name of the host that runs the PostgreSQL server
#port is the port where the PostgreSQL server is listening in
#user is the username that has access to the database
#password is the password for the user
conn <- dbConnect("PostgreSQL",dbname='osmtm',host='localhost',port='5432',user='postgres',password='postgres')

##---------------
## READ DATA FROM THE POSTGIS DATABASE
##---------------

#read data with pgGetGeom from the database
#Parameters
#conn is the connection created above
#name is a vector that has the schema name and table name elements
#geom is the name of the geometry column in the table
#other.cols is a vector that contains names of table columns to retrieve besides the geometry column
tasks <- pgGetGeom(conn, name=c("public","task"), geom = "geometry", other.cols=c("project_id","date"))

#view tasks as a string:
str(tasks)

#Quick visualization:
plot(tasks)

##---------------
## DISCONNECT FROM THE POSTGIS DATABASE
##---------------

dbDisconnect(conn)
