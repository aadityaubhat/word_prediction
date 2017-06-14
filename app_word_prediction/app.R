#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
if (interactive()) {
  
  ui <- fluidPage(
    
    # Application title
    titlePanel("Word Prediction using Markov Chains"),
    
    # Sidebar with a slider input for number of bins 
    verticalLayout(
      textAreaInput("inText", "Add your text", value = "", width = 600, height = 100,
                    cols = NULL, rows = NULL, placeholder = NULL, resize = NULL),
      div(style="display: inline-block;vertical-align:top; width: 650px;", 
          actionButton("word1Click", "Hi", width = 200),
          actionButton("word2Click", "Hey", width = 200),
          actionButton("word3Click", "Hello", width = 200))
    )
  )
  
  server <- function(input, output, session) {
    
    threeWords <- c("Hi", "Hey", "Hello")
    
    # Observe Button 1 Click
    observeEvent(input$word1Click, {
      word1Label <- threeWords[1]
      
      # This will change the value of input$inText, based on word1 Action Button
      updateTextAreaInput(session, "inText", value = paste(input$inText, word1Label))
    })
    
    # Observe Button 2 Click
    observeEvent(input$word2Click, {
      word2Label <- threeWords[2]
      
      # This will change the value of input$inText, based on word3 Action Button
      updateTextAreaInput(session, "inText", value = paste(input$inText, word2Label))
    })
    
    # Observe Button 3 Click
    observeEvent(input$word3Click, {
      word3Label <- threeWords[3]
      
      # This will change the value of input$inText, based on word3 Action Button
      updateTextAreaInput(session, "inText", value = paste(input$inText, word3Label))
    })
    
    #Observe Text Area
    observeEvent(input$inText, {
      inputText <- input$inText
      
      
      if(inputText != ""){
        #Get Vector of Words 
        words <- unlist(strsplit(inputText, " "))
        
        #Last word 
        lastWord <- words[length(words)]
        
        
        updateActionButton(session = session, inputId = "word2Click", label = lastWord)
        threeWords[2] <- lastWord 
      }
      
    })
  }
  
  shinyApp(ui, server)
}

