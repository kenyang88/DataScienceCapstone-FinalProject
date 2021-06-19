# 1_Load_sample.R
# Author: Ken Yang
# Date: 18 Jun, 2021
# Description: R program for loading sample
# Subject: Coursera - Data Science Capstone - Final Project
# GitHub: https://github.com/kenyang88/DataScienceCapstone-FinalProject

# Set the correct working directory
setwd("D:/D_drive/data/OnlineLearning/DataScientistSpecialization/R_Project/DataScienceCapstone-FinalProject/word-prediction-app/")

# Read the blogs and twitter files
source.blogs <- readLines("data/en_US.blogs.txt", encoding="UTF-8")
source.twitter <- readLines("data/en_US.twitter.txt", encoding="UTF-8")

# Read the news file. using binary mode as there are special characters in the text
con <- file("data/en_US.news.txt", open="rb")
source.news <- readLines(con, encoding="UTF-8")
close(con)
rm(con)

# set for reproducibility
set.seed(123456)

# Remove all non english characters as they cause issues down the road
source.blogs <- iconv(source.blogs, "latin1", "ASCII", sub="")
source.news <- iconv(source.news, "latin1", "ASCII", sub="")
source.twitter <- iconv(source.twitter, "latin1", "ASCII", sub="")

# Binomial sampling of the data and create the relevant files
sample.fun <- function(data, percent){
  return(data[as.logical(rbinom(length(data), 1, percent))])
}

# Set the desired sample percentage (we select 5% for speed)
sampleSize <- 0.05

# perform sampling over the data files
sample.blogs <- sample.fun(source.blogs, sampleSize)
sample.news <- sample.fun(source.news, sampleSize)
sample.twitter <- sample.fun(source.twitter, sampleSize)

# write sample text files to disk
dir.create("sample", showWarnings = FALSE)  # create the directory
write(sample.blogs, "sample/sample.blogs.txt")
write(sample.news, "sample/sample.news.txt")
write(sample.twitter, "sample/sample.twitter.txt")

# write combined sample file (Rdata) to disk
dir.create("rdata", showWarnings = FALSE)  # create the directory
save(sample.blogs, sample.news, sample.twitter, file="rdata//samples.Rdata")

# remove the specified objects
remove(source.blogs)
remove(source.news)
remove(source.twitter)

# removes all objects from the current workspace (R memory)
rm(list=ls())

# execute garbage collection, which automatically releases memory
# when an object is no longer used.
gc()