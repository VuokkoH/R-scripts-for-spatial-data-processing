

####################
# SOCIAL MEDIA
# WORDLCOUDS 
####################

# Code for plotting wordclouds from text
# Custom-made for tweet text and instagram captions from Helsinki, Finland

##--------------
## CREDITS
##-------------
# Building the wordclouds code is based on this tutorial: https://www.r-bloggers.com/building-wordclouds-in-r/
# And code from the course "IS 1: Online Social Media Analytics" at the Jyväskylä Summer School 2016

##----------------
## PACKAGES
##---------------
# If problems with installing packages, you can reset library path
#.libPaths("C:/.../")

#if necessary, install needed packages
install.packages("")

#load packages
library(tm)
library(SnowballC)
library(wordcloud)

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
## READ IN DATA
##-----------------
somedata <- read.csv("Filename.csv")

##------------------
## CHECK THE DATA
##------------------

head(somedata) #first rows
str(somedata) #structure
dim(somedata) #dimensions: number of rows and columns
names(somedata) # column names
summary(somedata) # summary of all columns

##-------------------
## CLEANING THE TEXT
##-------------------

# Creating a corpus from the text column
someCorpus = Corpus(VectorSource(somedata$text_))

# Using a loop to replace a character (here #) with whitespace for each document in the corpus
for(j in seq(tweetCorpus))   
   {   
    someCorpus[[j]] <- gsub("#", " ", tweetCorpus[[j]])   
  } 

# Converting the corpus into plain text document 
someText <- tm_map(someCorpus, PlainTextDocument)

#removing punctuation
someText <- tm_map(someText, removePunctuation)

# Removing english stopwords
someText <- tm_map(someText, removeWords, stopwords('english'))

# Stemming the document (Works only for English words?)
someText  <- tm_map(someText , stemDocument)

# all characters to lower case
someText  <- tm_map(someText , content_transformer(tolower))

#additional words can be removed by adding a vector of words within the tm_map-function after the removeWords-command
someText <- tm_map(someText, removeWords, c('helsinki', stopwords('finnish')))

#alternatively, you can generate separate lists for the words to be removed:

#generate list(s) of words:
InstagramWords 	<- c("nofilter",
			"vscocam",
			"vsco",
			"finnishgirl",
			"selfie",
			"latergram",
			"instagood",
			"igfinland",
			"igmyshot")


#combine the lists (different combinations can be made:
WordsToBeRemoved <- c(Placenames1, Placenames2, InstagramWords, FinnishWords, EnglishWords, SeasonsEngl, SeasonsFin, Events)

# run the remove words -function: 		
someText <- tm_map(someText, removeWords, WordsToBeRemoved) 

# Plot the wordcloud
wordcloud(someText, max.words = 100, random.order = FALSE)


# Examine the wordcloud and remove additional words, if necessary.
# Done!
