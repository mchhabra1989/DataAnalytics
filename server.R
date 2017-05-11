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


#Iteration 2

fit2 <-lm(Percent_funded~Duration_in_days+backers_count+goal+countname+countblurb,data=data_KS )
backers.fit <-lm(backers_count~Duration_in_days+Percent_funded+goal, data=data_KS)

# blurbcoef2 <- coef(fit2)[6]
# namecoef2 <- coef(fit2)[5]
# goalcoef2 <- coef(fit2)[4]
# backerscoef2 <- coef(fit2)[3]
# dayscoef2 <- coef(fit2)[2]
# intercept2 <- coef(fit2)[1]

blurbcoef2 = -0.223649590
namecoef2 = 6.839059764
goalcoef2 = -0.008159742
backerscoef2 = 0.216369623
dayscoef2 = -0.343436786
intercept2 = 96.466223061
#For failure cases - fit
fit.goal <- glm(goal ~ countname + countblurb + Duration_in_days, data=data_KS)
fit.caption <- glm(countname ~ goal + countblurb + Duration_in_days, data=data_KS)
fit.days <- glm(Duration_in_days ~ countname + goal + countblurb , data=data_KS)
fit.blurbcount <- glm(countblurb ~ countname + goal + countblurb + Duration_in_days, data=data_KS)


# Define server logic required to summarize and view the selected
# dataset
function(input, output) {
  
  
  
  
  v <- reactiveValues(doPlot = FALSE)
  
  observeEvent(input$go, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v$doPlot <- input$go
  })
  
  observeEvent(input$tabset, {
    v$doPlot <- FALSE
  })  
  
  output$plot <- renderPlot({
    if (v$doPlot == FALSE) return()
    
    isolate({
      data <- if (input$tabset == "Uniform") {
        captioncount <- nchar(input$caption)
        blurbcount <- nchar(input$blurb)
        #To do : testing with goal value, to be replaced with % funded predicted in iteration 1
        percent_funded1 <- as.numeric(intercept+goalcoef*input$goalslider+captioncoef*captioncount
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
        
        
        barplot(c(goal,input$goalslider),col=c("darkblue","red"))
        
        output$text <- renderText({ 
          if(percent_funded1 > 100){
            "Your KickStarter Project will be Successfull"
          } 
        })
        output$text1 <- renderUI({
          if(percent_funded1 < 100 ){
            tags$img(src='fail.png', align = 'right', width = 100, height = 100)
            
          }
        })
        
        output$text2 <- renderUI({
          if(percent_funded1 >=100  ){
            tags$img(src='Success.png', align = 'right', width = 100, height = 100)
          }
        })
        
        
      } else {
        
          captioncount1 <- nchar(as.character( input$caption1) )
          blurbcount1 <- nchar(as.character(input$caption1) )
          pldege <- input$pledgeslider1
          backers <- input$backersslider1
          DaysPassed <- input$Number_day_passedslider
          if(backers > 0 && pldege >0 && DaysPassed > 0){ 
            percent_funded <- as.numeric(intercept2+ goalcoef2*input$pledgeslider1 + namecoef2*captioncount1+blurbcoef2*blurbcount1+ backerscoef2*backers+DaysPassed*dayscoef2)
            #pred_backers <- as.numeric(coef(backers.fit)[1]+coef(backers.fit)[2]*input$Number_day_passedslider+coef(backers.fit)[3]*percent_funded)
            pred_backers  <- as.numeric(150-intercept2-goalcoef2*input$goalslider1-namecoef2*captioncount1-blurbcoef2*blurbcount1-input$durationslider1*dayscoef2)
            
            if((input$pledgeslider1 < input$goalslider1) & (input$Number_day_passedslider > input$durationslider1) )   {
              checkSuccess <- FALSE
              output$plot <-   renderPlot( {
                barplot(c(pred_backers,input$backersslider1),col=c("darkblue","red"),main = "The Number of Backers required vs Actual Number",names.arg = c("Predicted Backers", "Actua Number"),ylab ="The number of backers")
                
              })  
            }
            else if(input$pledgeslider1 >= input$goalslider1 |  pred_backers <= input$backersslider1 ){
              checkSuccess <- TRUE
              output$plot <-   renderPlot( {
                
              })
              
            }
            else {
                if(percent_funded < 150  ){
                  checkSuccess <- FALSE
                  
                  output$plot <-renderPlot( {
                    barplot(c(pred_backers,input$backersslider1),col=c("darkblue","red"),main = "The Number of Backers required vs Actual Number",names.arg = c("Predicted Backers", "Actua Number"),ylab ="The number of backers")
                  })
                }
                if(percent_funded > 150    ){
                  checkSuccess <- TRUE
                  output$plot <- renderPlot( {
                  
                  })
                }
            }
                  output$text <- renderText({  
                      if(checkSuccess == TRUE){
                        "Your KickStarter Project will be Successfull !!! "  
                      }  
                      
              })
                  output$text3 <- renderText({  
                    if(checkSuccess == FALSE & input$Number_day_passedslider < input$durationslider1){
                       
                      paste("To make it a success the number of backers needed : ", round( pred_backers-input$backersslider1,0) )
                      #paste("The Amount of Funding needed : ",  input$goalslider-input$pledgeslider1 )
                     # " And get a minimum Funding of " + input$backersslider1 - input$pledgeslider1 +"in the next " +input$durationslider1-input$Number_day_passedslider  + "days"
                    }  
                    else if(checkSuccess == FALSE){
                      "Your Project has Failed !!! " 
                    }
                    
                  })
            
            output$text1 <- renderUI({
              if(checkSuccess == FALSE ){
                tags$img(src='fail.png', align = 'right', width = 100, height = 100)
               
              }
            })
            
            output$text2 <- renderUI({
              if(checkSuccess == TRUE){
                tags$img(src='Success.png', align = 'right', width = 100, height = 100)
              }
            })
          }
      }
      
      #hist(data)
    })
  })
  
  
}
