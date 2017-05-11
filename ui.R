library(shiny)
library(shinyjs)
# Define UI for dataset viewer application
fluidPage(
  
  # Application title
  titlePanel("Predict % funded for Kickstarter Project"),
  useShinyjs(),
  # Sidebar with controls to provide a caption, select a dataset,
  # and specify the number of observations to view. Note that
  # changes made to the caption in the textInput control are
  # updated in the output area immediately as you type
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        id = "navbar",
        # iteration 1
        tabPanel(title = "Initial iteration",
                 value = "Initial iteration",
                 h1("Initial iteration"),
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
        # iteration 2
        tabPanel(title = "Project in progress",
                 value = "Project in progress",
                 h1("Project in progress"),
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
      )
  ),  
    
    # Show the caption, a summary of the dataset and an HTML 
	 # table with the requested number of observations
   mainPanel(
     htmlOutput('text1'),
     htmlOutput('text2'),
     strong("Results"),
     p("Graph Plot:The expected % funded based on initial project details is"),
     plotOutput("percentplot"),
     conditionalPanel(
       condition = "input.caption.value > 50",
       img(src='Image3.png', align = 'right')
     )
    )
  )
)
