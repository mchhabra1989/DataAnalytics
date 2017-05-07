library(shiny)
library(datasets)

# Define server logic required to summarize and view the selected
# dataset
function(input, output) {
  test <- reactive({
    #To do : testing with goal value, to be replaced with % funded predicted in iteration 1
    percent_funded <- as.numeric(input$goalslider)
    ifelse(percent_funded <= 1000,1,0)
  })

  output$text1 <- renderUI({
    # % funded less than 50% predicted
      if(test() == 1){
        tags$img(src='fail.png', align = 'right', width = 100, height = 100)
        #Suggest recommendations
      }
  })
  
  output$text2 <- renderUI({
    if(test() == 0){
      tags$img(src='Success.png', align = 'right', width = 100, height = 100)
    }
  })
}
