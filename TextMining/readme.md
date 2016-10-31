# Text mining

Code for text processing, plotting word frequencies and wordclouds in R

Custom-made for tweet text and instagram captions from Finland, but should work with any data table with text

***Note, use preferably R 3.3.1 or newer!***

These scripts are a work in progress, don't hesitate to raise an issue if you find something that is not working!

## Assumptions:
These tools assume you have a dataframe with at least two columns: One column with text, and one column with subregion name. With a little modification, you can also run the code without using the subregions. 

## Basic steps:

1. Creating a corpus (this step is currently included in the other scripts)
2. [Plotting wordclouds] (/TextMining/PlotWordClouds.R)
3. [Plotting most frequent words] (/TextMining/WordFrequencies_top10.R)

In order to run these scripts you need to first [read in your data..] (https://github.com/VuokkoH/R-scripts-for-spatial-data-processing/tree/master/ReadingDataIntoR)
