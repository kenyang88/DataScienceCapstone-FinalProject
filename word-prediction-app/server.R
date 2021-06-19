# server.R
# Author: Ken Yang
# Date: 18 Jun, 2021
# Description: Shiny Server
# Subject: Coursera - Data Science Capstone - Final Project
# GitHub: https://github.com/kenyang88/DataScienceCapstone-FinalProject

# load packages
library(shiny)
library(stringr)
library(tm)
library(NLP)

# Reload datasets written with the function save
load("rdata/ngrams.Rda")

# cause R to accept its input from the named file (or URL or connection or
# expressions) directly
source("sourceCode/ngram_tokenizer.R")

# cleanInput function, which is used to perform
# data cleaning for input text by users
cleanInput <- function(input) {
    
    # handle text input when it is null
    if (input=="" | is.na(input)) {
        return("")
    } # end if function
    
    # convert the input string to lower case 
    input <- tolower(input)
    
    # remove URL, email addresses, Twitter handles and hash tags
    input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, ignore.case=FALSE,
                  perl=TRUE)
    input <- gsub("\\S+[@]\\S+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("@[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("#[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    
    # remove ordinal numbers
    input <- gsub("[0-9](?:st|nd|rd|th)", "", input, ignore.case=FALSE,
                  perl=TRUE)
    
    # remove punctuation
    input <- gsub("[^\\p{L}'\\s]+", "", input, ignore.case=FALSE, perl=TRUE)
    
    # remove punctuation (leaving ')
    input <- gsub("[.\\-!]", " ", input, ignore.case = FALSE, perl = TRUE)
    
    # trim leading and trailing whitespace
    input <- gsub("^\\s+|\\s+$", "", input)
    input <- stripWhitespace(input)
    
    # split the elements of a character vector into substrings based on white
    # space & then convert that list to a single vector
    input <- unlist(strsplit(input, " "))
    
    # return the variable input as the output of the cleanInput function
    return(input)
    
} # end of cleanInput function


# prediction function
predict_fun <- function(inputString, unigram.df, bigram.df,
                        trigram.df, ngram_tokenizer) {
    
    # call the cleanInput function and initialize the variable input
    inputString <- cleanInput(inputString)
    
    # initialize variables
    unigram.tokenizer <- ngram_tokenizer(1)
    inputString.token <- unigram.tokenizer(inputString)
    #inputString.token <- inputString.token[!inputString.token %in% stopwords("english")]    
    
    ## if-else function for 4 conditions:
    ## (1) input text with more than 2 words   
    ## (2) input text with 2 words only
    ## (3) input text with 1 word only 
    ## (4) input text with less than 1 word, i.e. no input 
    
    # if-else function for 4 conditions:
    # condition 1 : input text with more than 2 words 
    if (length(inputString.token) > 2) {
        
        # initialize input text by getting the last two words of the user input
        inputString.token <- tail(inputString.token, 2)
        
        prediction.df <- trigram.df[(trigram.df$word1==inputString.token[1] &
                                         trigram.df$word2==inputString.token[2]),]
        row.names(prediction.df) <- NULL
        
        # assign three options of predicted word to variables
        prediction1 <- prediction.df$predicted[1]
        prediction2 <- prediction.df$predicted[2]
        prediction3 <- prediction.df$predicted[3]
        
        # nested if function - check if the variable prediction1 is null
        if (is.na(prediction1)) {
            
            prediction.df <- bigram.df[(bigram.df$word1==inputString.token[2]),]
            row.names(prediction.df) <- NULL
            
            # assign three options of predicted word to variables
            prediction1 <- prediction.df$predicted[1]
            prediction2 <- prediction.df$predicted[2]
            prediction3 <- prediction.df$predicted[3]
            
        } # end of nested if function 
        
    } # end of condition 1 for if-else function
    
    # if-else function for 4 conditions:
    # Condition 2 : input text with 2 words only
    else if (length(inputString.token) == 2) {
        
        prediction.df <- trigram.df[(trigram.df$word1==inputString.token[1] &
                                         trigram.df$word2==inputString.token[2]),]
        row.names(prediction.df) <- NULL
        
        # assign three options of predicted word to corresponding variables
        prediction1 <- prediction.df$predicted[1]
        prediction2 <- prediction.df$predicted[2]
        prediction3 <- prediction.df$predicted[3]
        
        # nested if function - check if the variable prediction1 is null
        if (is.na(prediction1)) {
            
            prediction.df <- bigram.df[(bigram.df$word1==inputString.token[2]),]
            row.names(prediction.df) <- NULL
            
            # assign three options of predicted word to corresponding variables
            prediction1 <- prediction.df$predicted[1]
            prediction2 <- prediction.df$predicted[2]
            prediction3 <- prediction.df$predicted[3]
            
        }  # end of nested if function 
        
    } # end of condition 2 for if-else function
    
    # if-else function for 4 conditions:
    # Condition 3 : input text with 1 word only 
    else if (length(inputString.token) == 1) {
        
        prediction.df <- bigram.df[(bigram.df$word1==inputString.token[1]),]
        row.names(prediction.df) <- NULL
        
        # assign three options of predicted word to corresponding variables
        prediction1 <- prediction.df$predicted[1]
        prediction2 <- prediction.df$predicted[2]
        prediction3 <- prediction.df$predicted[3]
        
    } # end of condition 3 for if-else function
    
    # if-else function for 4 conditions:
    # Condition 4 : input text with less than 1 word, i.e. no input 
    else if (length(inputString.token) < 1) {
        
        # assign three options of predicted word to corresponding variables
        prediction1 <- "Please enter one or more words"
        prediction2 <- "Ditto"
        prediction3 <- "Ditto"
        
    } # end of condition 4 for if-else function
    
    # return output to calling function
    return(c(prediction1,prediction2,prediction3))
    
}  # end of prediction function


# Shiny Server
shinyServer(function(input, output) {
    
    # reactive expression
    observe({
        
        if (input$goButton > 0) {
            
            param <- input$text
            prediction <- predict_fun(input$text, unigram.df, bigram.df,
                                      trigram.df, ngram_tokenizer)
            
            output$text1 <- renderText({ 
                paste("Top Prediction: ", prediction[1])
            })
            
            output$text2 <- renderText({
                paste("Second Prediction: ", prediction[2])
            }) 
            
            output$text3 <- renderText({ 
                paste("Third Prediction: ", prediction[3])
            }) 
            
        }  # end of if function 
        
    })  # end of observe expression
    
})  # end of shinyServer function
