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
          actionButton("word1Click", "", width = 200),
          actionButton("word2Click", "", width = 200),
          actionButton("word3Click", "", width = 200))
    )
  )
  
  # Dummy Function to generate three words
  generateWords <- function(wordList){
    if(length(wordList) >= 3){
      return(c("one", "two","three"))
    } else if(length(wordList) == 2) {
      return(c("one", "two","one"))
    } else {
      return(c("one", "one","one"))
    }
  }
  
  server <- function(input, output, session) {
    
    threeWords <- reactiveValues()
    
    # Observe Button 1 Click
    observeEvent(input$word1Click, {
      word1 <- threeWords$currentValue[1]
      
      # This will change the value of input$inText, based on word1 Action Button
      updateTextAreaInput(session, "inText", value = paste(input$inText, word1))
    })
    
    # Observe Button 2 Click
    observeEvent(input$word2Click, {
      word2 <- threeWords$currentValue[2]
      
      # This will change the value of input$inText, based on word3 Action Button
      updateTextAreaInput(session, "inText", value = paste(input$inText, word2))
    })
    
    # Observe Button 3 Click
    observeEvent(input$word3Click, {
      word3 <- threeWords$currentValue[3]
      
      # This will change the value of input$inText, based on word3 Action Button
      updateTextAreaInput(session, "inText", value = paste(input$inText, word3))
    })
    
    #Observe Text Area
    observeEvent(input$inText, {
      inputText <- input$inText
      
      
      if(inputText != ""){
        #Get Vector of Words 
        words <- unlist(strsplit(inputText, " "))
        
        threeWords$currentValue <- generateWords(words)
        
        updateActionButton(session = session, inputId = "word1Click", label = threeWords$currentValue[1])
        updateActionButton(session = session, inputId = "word2Click", label = threeWords$currentValue[2])
        updateActionButton(session = session, inputId = "word3Click", label = threeWords$currentValue[3])
      }
      
    })
  }
  
  shinyApp(ui, server)
}

