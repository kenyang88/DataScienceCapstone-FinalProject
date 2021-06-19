# 4_Predict.R
# Author: Ken Yang
# Date: 18 Jun, 2021
# Description: R program for developing prediction algorithm
# Subject: Coursera - Data Science Capstone - Final Project
# GitHub: https://github.com/kenyang88/DataScienceCapstone-FinalProject

# load packages
library(stringr)

# set working directory
setwd("D:/D_drive/data/OnlineLearning/DataScientistSpecialization/R_Project/DataScienceCapstone-FinalProject/word-prediction-app/")

# Reload datasets written with the function save
load("rdata/ngrams.Rda")

# cause R to accept its input from the named file (or URL or connection or
# expressions) directly
source("sourceCode/ngram_tokenizer.R")

# Input String

inputString <- "in the"

if (length(inputString) > 0) {

  inputString <- tolower(inputString)
  unigram.tokenizer <- ngram_tokenizer(1)
  inputString.token <- unigram.tokenizer(inputString)

  #inputString.token <- inputString.token[!inputString.token %in% stopwords("english")]
  
  if (length(inputString.token) > 2) {
    
    inputString.token <- tail(inputString.token,2)
    prediction.df <- trigram.df[(trigram.df$word1==inputString.token[1] &
                                   trigram.df$word2==inputString.token[2]),]
    row.names(prediction.df) <- NULL
    
    prediction1 <- prediction.df$predicted[1]
    prediction2 <- prediction.df$predicted[2]
    prediction3 <- prediction.df$predicted[3]
    
  } else if (length(inputString.token) == 2) {
    
    prediction.df <- trigram.df[(trigram.df$word1==inputString.token[1] &
                                   trigram.df$word2==inputString.token[2]),]
    row.names(prediction.df) <- NULL
    
    prediction1 <- prediction.df$predicted[1]
    prediction2 <- prediction.df$predicted[2]
    prediction3 <- prediction.df$predicted[3]
    
  } else if (length(inputString.token) == 1) {
    
    prediction.df <- bigram.df[(bigram.df$word1==inputString.token[1]),]
    row.names(prediction.df) <- NULL
    
    prediction1 <- prediction.df$predicted[1]
    prediction2 <- prediction.df$predicted[2]
    prediction3 <- prediction.df$predicted[3]
    
  } else if (length(inputString.token) < 1) {
    
    prediction1 <- "Please enter one or more words"
    prediction2 <- ""
    prediction3 <- ""
    
  } # end of nested if-else function

} # end of if function

# removes all objects from the current workspace (R memory)
rm(list=ls())

# execute garbage collection, which automatically releases memory
# when an object is no longer used.
gc()