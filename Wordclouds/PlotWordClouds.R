

####################
# SOCIAL MEDIA
# WORDLCOUDS 
####################

# Code for plotting wordclouds from text
# Custom-made for tweet text and instagram captions from Helsinki, Finland

##--------------
## CREDITS
##-------------
# Building the wordclouds code is based on these sources: 
# - https://www.r-bloggers.com/building-wordclouds-in-r/
# - code from the course "IS 1: Online Social Media Analytics" at the Jyväskylä Summer School 2016
# - https://amueller.github.io/word_cloud/auto_examples/a_new_hope.html


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
#read in data with a bunch of text stored in a spesific column
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
for(j in seq(someCorpus))   
   {   
    someCorpus[[j]] <- gsub("#", " ", tweetCorpus[[j]])   
  } 

# Converting the corpus into plain text document 
someText <- tm_map(someCorpus, PlainTextDocument)

#removing punctuation
someText <- tm_map(someText, removePunctuation)

# Stemming the document (Works only for English words?)
#someText  <- tm_map(someText , stemDocument) #NOTE! this might not work corretly with finnish words..

# all characters to lower case
someText  <- tm_map(someText , content_transformer(tolower))

#-------------------
# REMOVE WORDS
#-------------------
# Removing english stopwords
someText <- tm_map(someText, removeWords, stopwords('english'))

#additional words can be removed by adding a vector of words within the tm_map-function after the removeWords-command
someText <- tm_map(someText, removeWords, stopwords('finnish'))

# You can also define additional words to be removed:

# Option 1: In addition to stopwords, remove general instagram-related words that are not relevant

#generate list(s) of words to be removed:
InstagramWords 	<- c("nofilter",
			"vscocam",
			"vsco",
			"finnishgirl",
			"selfie",
			"latergram",
			"instagood",
			"igfinland",
			"igmyshot")

#Save the list in a new variable:
# WordsToBeRemoved <- c(InstagramWords)

#You can generate several lists of words in order to manage which one you want to remove.
# you need to run file worldists_helsinki.R in order to get these wordlists below.

# Option 2: remove basic words in Finnish and English that have no special meaning 
WordsToBeRemoved <- c(Placenames1,InstagramWords, FinnishWords, EnglishWords) 

#Option 3: remove also references to all placenames that appear in the data(modify the list if needed)
WordsToBeRemoved <- c(Placenames1, Placenames2, InstagramWords, FinnishWords, EnglishWords)

#Option 4: remove also references to placenames, events and seasons (modify the list if needed)
WordsToBeRemoved <- c(Placenames1, Placenames2, InstagramWords, FinnishWords, EnglishWords, SeasonsEngl, SeasonsFin, Events)



# run the remove words -function: 		
someText <- tm_map(someText, removeWords, WordsToBeRemoved) 

#-----------------------
# PLOTTING THE WORDCLOUD
#-----------------------
wordcloud(someText, max.words = 100, random.order = FALSE, colors="darkgreen")


#----------------------------------
# Changing colors for the wordcloud
#----------------------------------

# Based on this example: https://www.r-bloggers.com/joy-to-the-world-and-also-anticipation-disgust-surprise/

# Color palette from RColorBrewer: http://www.sthda.com/sthda/RDoc/images/rcolorbrewer.png
# ColorBrewer palettes Documentation: http://127.0.0.1:19773/library/RColorBrewer/html/ColorBrewer.html


colorpalette = brewer.pal(9,"Greens")# get color codes from the "Greens" color palette
colorpalette <- colorpalette[-(1:4)] # take the darkest tones
wordcloud(someText, max.words = 100, random.order = FALSE, colors=colorpalette) # plot word cloud with colors


# Examine the wordcloud and remove additional words, if necessary and adjust the parameters for plotting the wordcloud.
# Done!
