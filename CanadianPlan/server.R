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
library(reshape)

rm(list=ls())
#controls the layout and appearance of app

cities <- read.csv("trip_canada.csv")
#cities <- read_csv("CanadianPlan/trip_canada.csv")


cities <- cities %>% 
  mutate_all(function(x) gsub('\\$','',x)) %>%
  mutate_all(function(x) gsub(',','',x))


resume <- cities %>% slice(73:76) %>% select(-X) %>%
  mutate_if(is.character, as.integer)

#calculating minimum wage per hour
wage <- cities %>% slice(68) %>% select(-X) %>%
  mutate_if(is.character, as.numeric) 

wage <- wage %>% mutate(Mean = rowMeans(wage)) %>%
  mutate(Max = max(wage))



#RENT IN YOUR MAIN CITY
rent <- cities %>% slice(57:60) %>%  select(-X) 
  
rent[,1:18] <- rent %>% mutate_if(is.character, as.numeric)
rent$Rent <- c("Ap 1 bedroom in Centre", "Ap 1 bedroom out of Centre", "Ap 3 bedrooms in Centre", "Ap 3 bedrooms out of Centre")


#
#comparing life quality
#
conditions <- c("Alimentação", "Transporte", "Água&Eletricidade", "Aluguel")
 lifecosts <- cities %>% slice(73:76) %>%
   select(-X) 
    lifecosts <-  lifecosts %>% mutate_if(is.character, as.numeric)
   lifecosts$Spend <- conditions 
  
  
  
#CUSTO DE VIDA NAS CIDADES ESCOLHIDAS

    expensive <- cities %>% slice(77) %>% 
      mutate_all(function(x) gsub('\\$','',x)) %>%
      mutate_all(function(x) gsub(',','',x)) %>% 
      select(-X)
    
    expensive <-  expensive %>% mutate_if(is.character, as.numeric)
    expensive$Gastos <- "Gastos por mes" 
    
    
#  
# #head(resume)
#TAB SAVINGS

spent_monthly <- cities %>% slice(77) %>% mutate_if(is.character, as.numeric)
spent_annualy <- cities %>% slice(78) %>% mutate_if(is.character, as.numeric)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #source('global.R', local = TRUE)
  
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
            xlab = "",
            ylab="values", 
            main="Salário Minimo por hora (CAD)", 
            ylim=c(0,20))
  })
  # 
  # MOST EXPENSIVE CITY
  # 
  #  dataframe <- reactive({
  #    expensive_cities<- as.numeric() 
  #    expensive_cities<- c(expensive[,input$compare[1]], expensive[,input$compare[2]], expensive[,input$n])
  #    # 
  # })
   output$expensive <- renderPlot ({
     
    expensive_cities<- as.numeric()
   expensive_cities<- c(expensive[,input$compare[1]], expensive[,input$compare[2]], expensive[,input$n])
  #
   coul <- brewer.pal(3, "Set2")
   # 
   # 
   # barplot(height=dataframe, names =  c(input$compare[1],input$compare[2], input$n),
   #          col= coul,
   #          xlab = "",
   #          ylab="values", 
   #          main="Gastos por mês", 
   #          ylim=c(800,1600))
   #print(input$compare[2])
   
   ggplot(data=expensive, aes(x=Gastos, y=expensive_citites)) +
     geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
     coord_flip() +
     xlab("") +
     theme_bw()
   
  
  
   })
  
  #rent in your main city
  output$rent <- renderPlot ({
    
    Aluguel_CAD<- rent[,input$n]
    
    
    ggplot(data=rent, aes(x=Rent, y=Aluguel_CAD)) +
      geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
      coord_flip() +
      xlab("") +
      theme_bw()
    
  })
  
  # output$cost <- renderPlot ({
  #    
  #    try_values<- lifecosts[,input$compare]
  #    try_cities <- rep(c(input$compare),4)
  #    conditions_1 <- rep(c("Alimentação, Transporte, Água&Eletricidade, Aluguel"),size(input$compare))
  #   lifecosts_resume <- data.frame(try_cities,conditions,try_values)
  #   # 
  #   # #as.data.frame(lifecosts)
  #    ggplot(lifecosts_resume, aes(fill=conditions, y=try_values, x=try_cities)) + 
  #      geom_bar(position="stack", stat="identity")
  # })
  
  
  #TAB SAVINGS
  #
  output$savings <- renderInfoBox({

  saved <- as.numeric(paste(input$savings))

  Total_saved_CAD <- round((saved/3.2),2)

  infoBox(
  "Sua Poupança em CAD", paste0(Total_saved_CAD, " CAD$"), icon=icon("fas fa-piggy-bank"),
  color="orange")
  })
  
  output$monthly <- renderInfoBox({
    
    month<- spent_monthly[,input$n]
    
    infoBox(paste0("Gastos por mês em ",input$n), paste0(month, " CAD$"), icon=icon("far fa-wallet"),
      color="purple")

  })
  
  output$annualy <- renderInfoBox({
    
    annual<- spent_annualy[,input$n]
    
    infoBox(paste0("Gastos por ano em ",input$n), paste0(annual, " CAD$"), icon=icon("far fa-coins"),
            color="blue")
    
  })
  
  output$work <- renderInfoBox({
    
    saved <- as.numeric(paste(input$savings))
    
    Total_saved_CAD <- round((saved/3.2),2)
    
    month<- spent_monthly[,input$n]
    
    survival_month <- round((Total_saved_CAD/month),0)
    
    infoBox(paste0("Meses sem trabalhar ",input$n), paste0(survival_month, " meses"), icon=icon("far fa-calendar-alt"),
            color="fuchsia")
    
  })


  # output$savings <- renderText ({
  #   
  #   
  #   
  #   month<- spent_monthly[,input$n]
  #   
  #   total_month <- round((month*12),2)
  #   
  #   annual <-spent_annualy[,input$n]
  #   
  #   survival_month <- round((Total_saved_CAD/month),0)
  #   
  #   paste("Com o dólar CAD a R$ 3.2 você tem em CAD", Total_saved_CAD,". Em ", input$n, 
  #         "você precisará de", month, "por mês. O seu valor de poupança te permite viver por",
  #         survival_month, "meses em ", input$n, " sem trabalhar.")
  #   
  # })


  
})
