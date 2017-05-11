library(shiny)
library(shinyjs)
ui <- fluidPage(
  titlePanel("Predict % funded for Kickstarter Project"),
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(id = "tabset",
                  tabPanel("Uniform",
                           textInput("blurb", "Blurb:", "Blurb"),
                           textInput("caption", "Name:", "Name"),
                           selectInput("dataset", "Choose a Genre:", 
                                       choices = c("url", "color", "parent_id")),
                           sliderInput("goalslider",
                                       "goal amount:",
                                       min = 1,
                                       max = 50000,
                                       value = 1000),
                           sliderInput("durationslider",
                                       "Duration:",
                                       min = 1,
                                       max = 100,
                                       value = 10)
                  ),
                  tabPanel("Normal",
                           textInput("blurb1", "Blurb:", "Blurb"),
                           textInput("caption1", "Name:", "Name"),
                           sliderInput("goalslider1",
                                       "goal amount:",
                                       min = 0,
                                       max = 5000,
                                       value = 0),
                           sliderInput("pledgeslider1",
                                       "Amount Pledge:",
                                       min = 0,
                                       max = 2000,
                                       value = 0),
                           sliderInput("backersslider1",
                                       "Number of backers:",
                                       min = 0,
                                       max = 500,
                                       value = 0),
                           sliderInput("Number_day_passedslider",
                                       "Days passed:",
                                       min = 0,
                                       max = 200,
                                       value = 0),
                           sliderInput("durationslider1",
                                       "Duration:",
                                       min = 0,
                                       max = 200,
                                       value = 0)
                  )
                  
      ),
      actionButton("go", "Plot")
    ),
    mainPanel(
      htmlOutput('text1'),
      htmlOutput('text2'),
      
      strong("Results"),
      strong(textOutput("text") ),
      strong(textOutput("text3") ),
      plotOutput("plot"),
      conditionalPanel(
        condition = "input.caption.value > 50",
        img(src='Image3.png', align = 'right')
      )
      
    )
  )
)
