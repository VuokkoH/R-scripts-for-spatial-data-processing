# 2016-09-15
# Vuokko H /
#

#--------------------------------
# GET DATA FROM MS ACCESS TO R
#--------------------------------

# For some [stupid] reason, you might have data in MS Access that you want to handle in R.
# In most cases, it is easier to export the data from Access to Excel or other formats and proceed from there.
# However, sometimes you might want to read the data directly from Access (for example to ensure that text columns are imported correctly)

# As input, you give the path to the MS access database (either .accdb or .mdb) 
# As output you get a dataframe object for further processing in R. 
# You can save the output for example to a PostgreSQL database...

# This code works with Microsoft Office 2013 Access, and R 3.3.1 (32-bit).

# NOTE! Fetching data from an access database apparently works ONLY with a 32-bit version of R
# This is the R version I used when testing the script:
#
# R version 3.3.1 (2016-06-21) -- "Bug in Your Hair"
# Copyright (C) 2016 The R Foundation for Statistical Computing
# Platform: i386-w64-mingw32/i386 (32-bit)

#---------------------
# CREDITS:
#---------------------
# Code is based on these sources:
# http://rprogramming.net/connect-to-ms-access-in-r/
# http://127.0.0.1:16645/library/RODBC/html/sqlQuery.html

#-------------------
# PACKAGES
#-------------------
install.packages("RODBC") # install, if needed
library(RODBC) # load the package

#---------------------------------
# ESTABLISH CONNECTION TO ACCESS
#----------------------------------

#Open connection to the Access database
DBpath <- "Databasename.accdb" # insert here the name (or full path) of your database. 
channel <- odbcConnectAccess2007(DBpath)

#List all tables in the database
sqlTables(channel)

#------------------------------------
# MAKE AN SQL QUERY AND GET THE DATA
#------------------------------------

#Build your query
fields = "*" # The asterix would return all fields. Be careful, R might crash when running the query with all columns!
fields = " lat, lon, Location, text_ " # specify columns for the SQL query
tablename = "mytable" # insert here the name of the table you want to get

query <- paste(" select ",fields, " from ", tablename)

# Run the sql query and get the data
# NOTE! R crashes easily!! Pay attention to the type of data you are trying to read and leave out any problematic fields.
data <- sqlQuery( channel , query)

# Alternative function for getting data from the database. R might crash when running this line, depending on the content of the table..
#sqlFetch(channel, "Insta_2015_Viher_kaikki", rownames=FALSE)

#-------------------
#Check the output
#-------------------
nrow(data) #number of rows
dim(data) # dimensions 
summary(data) #summary
names(data) #column names
str(data) # structure