#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinydashboard)
library(readr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)




# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  source('global.R', local = TRUE)
  
  output$pie <- renderPlot({
    
    myPalette <- brewer.pal(4, "Set2") 
    
    pie(resume[,input$n] , labels = c("Alimentação","Transporte","Agua&Eletricidade","Aluguel"), 
        border="white", col=myPalette,
        main= input$n)})
  
  #minimum wage plot
  output$wage <- renderPlot ({
    
    vector_bar <- as.numeric()
    vector_bar <- c(wage[,"Max"], wage[,input$n], wage[,"Mean"])
    
    coul <- brewer.pal(3, "Set2")
    
    barplot(height=vector_bar, names=c("Máximo",input$n, "Média"), 
            col= coul,
            xlab = "teste",
            ylab="values", 
            main="Salário Minimo por hora (CAD)", 
            ylim=c(0,20))
  })
  # 
  # output$cost <- renderPlot ({
  #   # try<- as.numeric()
  #   # try<-c(lifecosts[input$thing,input$n], lifecosts[input$thing,input$compare])
  #   # spending <- lifecosts[input$thing,try]
  #   # 
  #   as.data.frame(lifecosts)
  #   ggplot(data=lifecosts, aes(x=input$thing, y=input$compare)) +
  #     geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  #     coord_flip() +
  #     xlab("") +
  #    theme_bw()
  # })
  
  #rent in your main city
  output$rent <- renderPlot ({
    
    foda<- as.character(paste(input$n))
    
    
    ggplot(data=rent, aes(x=Rent, y=foda)) +
      geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
      coord_flip() +
      xlab("") +
      theme_bw()
    
  })
  
  
  
  #TAB SAVINGS
  #
  output$savings <- renderText ({
    
    saved <- as.numeric(paste(input$savings))
    Total_saved_CAD <- round((saved/3.2),2)
    
    month<- spent_monthly[,input$n]
    
    total_month <- round((month*12),2)
    
    annual <-spent_annualy[,input$n]
    
    survival_month <- round((Total_saved_CAD/month),0)
    
    paste("Com o dólar CAD a R$ 3.2 você tem em CAD", Total_saved_CAD,". Em ", input$n, 
          "você precisará de", month, "por mês. O seu valor de poupança te permite viver por",
          survival_month, "meses em ", input$n, " sem trabalhar.")
    
  })


  
})
