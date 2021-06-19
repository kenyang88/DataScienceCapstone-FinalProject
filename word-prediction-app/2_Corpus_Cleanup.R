# 2_Corpus_Cleanup.R
# Author: Ken Yang
# Date: 18 Jun, 2021
# Description: R program for building corpus and cleaning data
# Subject: Coursera - Data Science Capstone - Final Project
# GitHub: https://github.com/kenyang88/DataScienceCapstone-FinalProject

# load packages
library(tm)
library(RWeka)
library(SnowballC)

# set working directory
setwd("D:/D_drive/data/OnlineLearning/DataScientistSpecialization/R_Project/DataScienceCapstone-FinalProject/word-prediction-app/")

# Reload datasets written with the function save
load("rdata/samples.Rdata")

# Combine Values into a Vector or List and then create a vector source
sample.corpus <- c(sample.blogs, sample.news, sample.twitter)
my.corpus <- Corpus(VectorSource(list(sample.corpus)))

# (1) covert to lower case
my.corpus <- tm_map(my.corpus, content_transformer(tolower))

# (2) remove Punctuation
my.corpus <- tm_map(my.corpus, removePunctuation)

# (3) remove numbers
my.corpus <- tm_map(my.corpus, removeNumbers)

# (4) remove english stop words
my.corpus <- tm_map(my.corpus, removeWords, stopwords("english"))

# (5) remove white space
my.corpus <- tm_map(my.corpus, stripWhitespace)

# write files to disk
writeCorpus(my.corpus, filenames="output/my.corpus.txt")
save(my.corpus, file="rdata/corpus.Rda")

# removes all objects from the current workspace (R memory)
rm(list=ls())

# execute garbage collection, which automatically releases memory
# when an object is no longer used.
gc()