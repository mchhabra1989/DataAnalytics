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
                           textInput("blurb", "Blurb:", "Blurb"),
                           textInput("caption", "Name:", "Name"),
                           sliderInput("goalslider",
                                       "goal amount:",
                                       min = 1,
                                       max = 50000,
                                       value = 1000),
                           sliderInput("pledgeslider",
                                       "Amount Pledge:",
                                       min = 1,
                                       max = 100,
                                       value = 10),
                           sliderInput("backersslider",
                                       "Number of backers:",
                                       min = 1,
                                       max = 100,
                                       value = 10),
                           sliderInput("Number_day_passedslider",
                                       "Days passed:",
                                       min = 1,
                                       max = 100,
                                       value = 10),
                           sliderInput("durationslider",
                                       "Duration:",
                                       min = 1,
                                       max = 100,
                                       value = 10)
                  )
                  
      ),
      actionButton("go", "Plot")
    ),
    mainPanel(
      # htmlOutput('text1'),
      #htmlOutput('text2'),
      strong("Results"),
      p("Graph Plot:The expected % funded based on initial project details is"),
      plotOutput("plot"),
      conditionalPanel(
        condition = "input.caption.value > 50",
        img(src='Image3.png', align = 'right')
      )
    )
  )
)