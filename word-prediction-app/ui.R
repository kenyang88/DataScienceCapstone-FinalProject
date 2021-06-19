# ui.R
# Author: Ken Yang
# Date: 19 Jun, 2021
# Description: Shiny User Interface
# Subject: Coursera - Data Science Capstone - Final Project
# GitHub: https://github.com/kenyang88/DataScienceCapstone-FinalProject

library(shiny)
library(shinythemes)

shinyUI(
    navbarPage("Word Prediction",
               
               theme = shinytheme("spacelab"),
               
               tabPanel("Home",
                        fluidPage(
                            titlePanel("Word Prediction App"),
                            sidebarLayout(
                                sidebarPanel(
                                    textInput("text", label=h5("Please type your
                                                           text below:
                                                           (characters only)")),
                                    actionButton("goButton", "Predict")
                                ),  # end of sidebarPanel
                                mainPanel(
                                    h3('Best Next Word Prediction: (3 options)'),
                                    textOutput("text1"),
                                    textOutput("text2"),
                                    textOutput("text3")
                                )  # end of mainPanel
                            )  # end of sidebarLayout
                        )  # end of fluidPage 
               ),  # end of tabPanel
               
               tabPanel("About",
                        
                        h3("About Word Prediction Application"),
                        div("Word Prediction Application is a Shiny app that 
                          uses text prediction algorithms to predict the most
                          likely next word, based on the word/phase entered
                          by a user.",
                            br(),
                            "This app allows users to enter their chosen
                          word/phase in the textbox as an input for the next
                          word prediction.",
                            br(),
                            "Three options of predicted word will be displayed
                          after you entered the word/phase."
                        ),  # end of div
                        br(),
                        
                        h3("Instruction"),
                        div("(1) Enter text into the input textbox (by user).",
                            br(),
                            "(2) Click the button 'Predict'.",
                            br(),
                            "(3) Wait a second to allow for the output to appear
                          The top prediction will be shown up followed by the 
                          second and third ones.",
                            br(),
                            "(3) When the user continues to type text, new text 
                          word prediction will be shown up automatically after
                          finished typing the word one by one."
                        ),  # end of div
                        br(),
                        
                        h3("Input Explanation"),
                        div("You can type any text in the input box. But, the text
                          should not be numeric, special characters or space(s).",
                            br(),
                            br(),
                            "Taking the consideration of performance issue, there
                          is a limitation that the next work prediction is only
                          based on a single word or the last two words entered.
                          It means that:",
                            br(),
                            "(i) If there is no user input, the output will
                          display 'NA'.",                          
                            "(ii) If you only input one word, the algorithm
                          will make a prediction only based on that word only.",
                            br(),
                            "(iii) If you input two words, the algorithm will make
                          a prediction only based on that two words.",
                            br(),
                            "(iv) If the text consists of more than 2 words, the
                          algorithm will extract the last two words and make a
                          prediction based on that last two words.",
                            br(),
                            "So, some of the predictions might not make sense
                          when you input long sentence(s)."
                        ),  # end of div
                        br(),
                        
                        h3("Output Explanation"),
                        div("The prediction algorithm calculates the probabilities
                          of the next word occuring and presents three options
                          of word that have the highest probability to be most 
                          likley next word based on the user input."
                        ),  # end of div
                        br(),
                        
                        h3("Databases Used"),
                        div("To make prediction the application uses a combined 
                          sample of news, blogs and twitter text, which has
                          been manipulated to facilitate the prediction
                          process."
                        ),  # end of div
                        br(),
                        
                        h3("Link"),
                        div("The source code for this application can be found
                            on GitHub:",
                            br(),
                            br(),
                            img(src="github.png"),
                            a(target="_blank", href="https://github.com/kenyang88/DataScienceCapstone-FinalProject",
                              "Word Prediction App")
                        ),  # end of div
                        br()
               )  # end of tabPanel
               
    )  # end of navbarPage
    
)  #  end of shinyUI
