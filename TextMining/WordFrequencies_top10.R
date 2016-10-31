
####################################################
# PROCESSING TEXT IN R:
# MOST FREQUENT WORDS IN SOCIAL MEDIA BY REGION
###################################################

# Code for text processing and plotting word frequencies 
# Custom-made for tweet text and instagram captions from Finland, but should work with any data table with text
# Note, use preferably R 3.3.1 or newer!

#-----------------
# Structure
#--------------------
#
# The code consists of these steps
#
# 1. CREATE FUNCTION FOR CREATING A CORPUS FROM THE TEXTS
# 2. CREATE FUNCTION FOR PLOTTING MOST FREQUENT WORDS
# 3. PLOT TOP 10 MOST POPULAR WORDS FOR ALL SUBREGIONS (using steps 1 and 2)
#
# a section for plotting word clouds can be added to the code (now in a separate script file)
#
##--------------
## CREDITS
##-------------
# AUTHOR:
# - This code has been put together by Vuokko Heikinheimo (PhD student at the Department of Geosciences and Geography, University of Helsinki)
# for the project Social Media Data in Conservation science 
# - Code is based on examples from the Online Social Media Analytics -course in Jyväskylä Summer Shool 2016 and existing online tutorials, see below: 

# TEXT PROCESSING AND WORD FREQUENCIES:
# - Basic text mining in R: https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html
# - code from the course "IS 1: Online Social Media Analytics" at the Jyväskylä Summer School 2016

# TEXT PROCESSING AND WORDCLOUDS (see separate code):
# - https://www.r-bloggers.com/building-wordclouds-in-r/
# - https://amueller.github.io/word_cloud/auto_examples/a_new_hope.html
# - code from the course "IS 1: Online Social Media Analytics" at the Jyväskylä Summer School 2016

##----------------
## DISCLAIMER
##---------------
# this is a work in progress, feel free to comment and discuss the code with me! I am planning eg to test topic modeling as an extention to this code.

##----------------
## PACKAGES
##---------------
# If problems with installing packages, you can reset library path
.libPaths("...")
.libPaths()

#if necessary, install needed packages
#install.packages("tm", SnowballC = TRUE)
#install.packages("wordcloud", dependencies = TRUE)
#install.packages("tm", dependencies = TRUE)
#install.packages("ggplot2")
#install.packages("grid")

#load packages
library(tm)
library(SnowballC)
library(wordcloud)
library(grid)
library(ggplot2) 

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
#Option 1: from a text-file
#somedata <- read.csv("Filename.csv")

#Option 2: from a database
# see separate code for getting data from PostgreSQL or MSAccess

#Word cloud for the whole data 
somedata <- data

#Run this line in case there are unused factor levels in the column you plan to subdivide the data with!
#data$NP <- factor(data$NP)

##------------------
## DATA SUBSETS
##------------------
# subset data based on attributes if needed
#somedata <- subset(data, loc_name=="Pallastunturi")
#somedata <- subset(somedata, NP=="Nuuksion kansallispuisto")
#somedata <- subset(data, InsidePark==0)

##------------------
## CHECK THE DATA
##------------------

head(somedata) #first rows
str(somedata) #structure
dim(somedata) #dimensions: number of rows and columns
names(somedata) # column names
summary(somedata) # summary of all columns


#------------------------------------------------
###################################################
# 1. CREATE FUNCTION FOR CREATING A CORPUS FROM THE TEXTS
#######################################################
# Uncomment line below if you want to skip using the function..
#someCorpus = Corpus(VectorSource(somedata$text_))

# Run code until the end of function definition:
createcorpus <- function(somedata){

##########################################
# Creating a corpus from the text column
##########################################

	somedata <- as.data.frame(somedata$text_)

	#Generating rownames
	N.docs<-(nrow(somedata))

	#rownames(somedata) <- paste0("post", c(1:N.docs))
	my.docs <- DataframeSource(somedata)
	my.docs$Names <- c(rownames(somedata))

	# corpus:
	someCorpus <- Corpus(my.docs)

	#Check content for one document..
	writeLines(as.character(someCorpus[[1]]))

	##-------------------
	## CLEANING THE TEXT
	##-------------------

	# Using a loop to replace a character (here #) with whitespace for each document in the corpus
	for(j in seq(someCorpus))   {   
    		someCorpus[[j]] <- gsub("#", " ", someCorpus[[j]])   
  	} 

	#Check content for one document..
	writeLines(as.character(someCorpus[[1]]))

	# Converting the corpus into plain text document 
	someText <- tm_map(someCorpus, PlainTextDocument)

	#Check content for one document..
	writeLines(as.character(someText[[1]]))

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
	InstagramWords 	<- c( "finland",
				"nofilter",
				"vscocam",
				"vscofinland",
				"vscohelsinki",
				"vsco",
				"finnishgirl",
				"selfie",
				"latergram",
				"instagood",
				"igfinland",
				"igmyshot",
				"igfinland",
				"igeuropa",
				"igeurope",
				"igspecialist",
				"photooftheday")

	#Save the list in a new variable:
	WordsToBeRemoved <- c(InstagramWords)

	#OPTIONAL: You can generate several lists of words in order to manage which one you want to remove.
	# see separate script for additional word lists for Helsinki and Pallas-Yllas
	# you need to run file worldists_*.R in order to get these wordlists below.

	#WordsToBeRemoved <- c(InstagramWords, FinnishWords, EnglishWords)
	#WordsToBeRemoved <- c(LaplandWords ,InstagramWords, LappiPlacenames, FinnishWords, EnglishWords)

	## ALWAYS RUN THIS LINE BEFORE PLOTTING THE WORDCLOUD
	# run the remove words -function: 		
	FinalText <- tm_map(someText, removeWords, WordsToBeRemoved) 

	#FinalText <- someText # run this line if nothing was removed

	FinalText <- tm_map(FinalText, PlainTextDocument)
	
	#Check content for one document in FinalText
	#summary(FinalText) #check the contents of FinalText
	writeLines(as.character(FinalText[[1]]))
	
	#Return the cleaned corpus:
	return(FinalText)

} # end of function definition for createcorpus()

##################################################
# 2. CREATE FUNCTION FOR PLOTTING MOST FREQUENT WORDS
#######################################################

#run code until the end of fuction definition:
plotwordfreq <- function(FinalText, park) {

	#Create a term document matrix
	dtm <- DocumentTermMatrix(FinalText)
	#inspect(dtm) #wont probably work if there is a lot of data!
	#inspect(dtm[1:5, 1:20]) 
	#dim(dtm)

	#tdm <- TermDocumentMatrix(docs) 

	#################
	#Word frequency:
	##################

	freq <- colSums(as.matrix(dtm))  

	#dtms <- removeSparseTerms(dtm, 0.1)
	#inspect(dtms)

	#rownames(dtm) <- my.docs$Names

	length(freq)
	#Optional codes for accessing the data
		#ord <- order(freq)
		#freq[tail(ord)]
		#head(table(freq), 20) 
		#dtm_matrix = as.matrix(dtm)
		#dim(dtm_matrix)
		#top_set_words = sort(colSums(dtm_matrix), decreasing=TRUE)

	# Collect frequencies into a data frame 
	wf <- data.frame(word=names(freq), freq=freq)

	#order most frequent
	wf <- wf[order(-freq),]

	#take the 10 most frequent words
	wf <- wf[1:10, ] 


#------------------------------
# PLOTTING THE WORD OCCURRENCIES
#-------------------------------

#-----------------------------------------------
# Plot top 10 words, excluding words that appear only once
# Alter y-axis depending on the max frequency


if ( max(wf$freq) <  50){
	p <- ggplot(subset(wf, freq>1), aes(reorder(word,-freq), freq))    
	p <- p + geom_bar(stat="identity")   
	p <- p + theme(axis.text.x=element_text(angle=45, hjust=1, size=15))
	p <- p + coord_cartesian(ylim=c(0,50))
	p <- p + ggtitle(paste(park, " - Top 10 Words")) + ylab("Frequency") + xlab("")      
	p
	} 

if (max(wf$freq)>= 50 & max(wf$freq)<100){
	p <- ggplot(wf, aes(reorder(word,-freq), freq))    
	p <- p + geom_bar(stat="identity")   
	p <- p + theme(axis.text.x=element_text(angle=45, hjust=1, size=15))   
	p <- p + coord_cartesian(ylim=c(0,100)) 
	p <- p + ggtitle(paste(park, " - Top 10 Words")) + ylab("Frequency") + xlab("")  
	p
	} 

if (max(wf$freq)>= 100){
	p <- ggplot(wf, aes(reorder(word,-freq), freq))    
	p <- p + geom_bar(stat="identity")   
	p <- p + theme(axis.text.x=element_text(angle=45, hjust=1, size=15))
	p <- p + coord_cartesian(ylim=c(0,max(wf$freq)))
	p <- p + ggtitle(paste(park, " - Top 10 Words")) + ylab("Frequency") + xlab("") 
	p
	} 
} end of function definition for plotwordfreq()

#################################################################

#######################################################
## 3. PLOT TOP 10 MOST POPULAR WORDS FOR ALL SUBREGIONS
#######################################################

# Function for running the whole process
# NOTE! assumes that subregion info is stored in column "NP" and that text is stored in column "text_". Change these if needed.

#Check where you are about to store the output figures:
getwd()

#set a new working directory if you don't want to use the current!
setwd("C:/HY-Data/VUOKKHEI/documents/TEMP/testplots")

# specify the factors wor based on which separate plots will be generated:
subregions = levels(data$loc_name)
subregion = subregions[414]

for (subregion in subregions){ 
	print(subregion)
	somedata <- subset(data, loc_name==subregion)
	
	pngname = paste("Top10_words_", subregion, ".png", sep="")

	#Create corpus for the subset
	somecorpus = createcorpus(somedata)

	#plot barchart for top 10 words 
	# note! problems might occur if the subset has more than 8000 rows..
	plotwordfreq(somecorpus, subregion) 
	
	#save image png(will be saved to working directory)
	ggsave(pngname, device = "png")
}

# Now you should have a png in your working directory with top 10 words!





