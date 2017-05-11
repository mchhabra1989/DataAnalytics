library(shiny)
library(datasets)


#Singleton - load data, clean and model
library(readxl)
data_KS <- read_excel("Clean_Kickstarter.csv.xlsx")
data_KS <- na.omit(data_KS)
#Selecting only successful projects first
work_set <- data_KS[data_KS$state %in% c("successful"),]
data_KS$countname <- nchar(data_KS$name)
data_KS$countblurb <- nchar(data_KS$blurb)
#Fit from trained data
fit <- glm(Percent_funded ~  countname + goal + countblurb + Duration_in_days, data=data_KS)
captioncoef <- coef(fit)[2]
goalcoef <- coef(fit)[3]
blurbcoef <- coef(fit)[4]
dayscoef <- coef(fit)[5]
intercept <- coef(fit)[1]

#For failure cases - fit
fit.goal <- glm(goal ~ countname + countblurb + Duration_in_days, data=data_KS)
fit.caption <- glm(countname ~ goal + countblurb + Duration_in_days, data=data_KS)
fit.days <- glm(Duration_in_days ~ countname + goal + countblurb , data=data_KS)
fit.blurbcount <- glm(countblurb ~ countname + goal + countblurb + Duration_in_days, data=data_KS)


# Define server logic required to summarize and view the selected
# dataset
function(input, output) {
  observe({
    toggle(condition = input$foo, selector = "#navbar li a[data-value=Project in progress]")
  })
  test <- reactive({
    captioncount <- nchar(input$caption)
    blurbcount <- nchar(input$blurb)
    #To do : testing with goal value, to be replaced with % funded predicted in iteration 1
    percent_funded <- as.numeric(intercept+goalcoef*input$goalslider+captioncoef*captioncount
                                 +blurbcoef*blurbcount
                                 +dayscoef*input$durationslider)
    goal <- as.numeric(coef(fit.goal)[1]+coef(fit.goal)[2]*captioncount
                                 +coef(fit.goal)[3]*blurbcount
                                 +coef(fit.goal)[4]*input$durationslider)
    caption <- as.numeric(coef(fit.caption)[1]+coef(fit.caption)[2]*input$goalslider
                                 +coef(fit.caption)[3]*blurbcount
                                 +coef(fit.caption)[4]*input$durationslider)
    blurb <- as.numeric(coef(fit.blurbcount)[1]+coef(fit.blurbcount)[3]*input$goalslider+coef(fit.blurbcount)[2]*captioncount
                                +coef(fit.blurbcount)[4]*input$durationslider)
    duration <- as.numeric(coef(fit.days)[1]+coef(fit.days)[3]*input$goalslider+coef(fit.days)[2]*captioncount
                                 +coef(fit.days)[3]*blurbcount
                                 +coef(fit.days)[4]*input$durationslider)
    #add more graphs as necessary
    output$percentplot <-   renderPlot({
      barplot(c(goal,input$goalslider))
    })
    ifelse(percent_funded <= 1000,1,0)
  })
  
  output$text1 <- renderUI({
    # % funded less than 50% predicted
      if(test() == 1){
        tags$img(src='fail.png', align = 'right', width = 100, height = 100)
        #Show iteration 2 Tab
        #Suggest recommendations
      }
  })
  
  observe({
    toggle(condition = input$foo, selector = "#navbar li a[data-value=Project in progress]")
  })
  
  output$text2 <- renderUI({
    if(test() == 0){
      tags$img(src='Success.png', align = 'right', width = 100, height = 100)
    }
  })
}
