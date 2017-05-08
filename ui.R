library(shiny)

# Define UI for dataset viewer application
fluidPage(
  
  # Application title
  titlePanel("Reactivity"),
  
  # Sidebar with controls to provide a caption, select a dataset,
  # and specify the number of observations to view. Note that
  # changes made to the caption in the textInput control are
  # updated in the output area immediately as you type
  sidebarLayout(
    sidebarPanel(
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
    
    
    # Show the caption, a summary of the dataset and an HTML 
	 # table with the requested number of observations
   mainPanel(
     htmlOutput('text1'),
     htmlOutput('text2'),
     strong("Results"),
     p("Graph Plot:The expected % funded based on initial project details is"),
     plotOutput("percentplot"),
     
     #textInput("caption", "Test:", "100"),
     #checkboxInput("smooth", "Smooth"),
     conditionalPanel(
      condition = "input.caption.value > 50",
      img(src='Image3.png', align = 'right')
     )
    
    )
  )
)
