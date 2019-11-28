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

rm(list=ls())
#controls the layout and appearance of app

cities <- read.csv("trip_canada.csv")

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

#creating a new data.frame with canadian average

# average_canadian <- resume %>% 
#   mutate(Mean = rowMeans(wage)) %>%
#   mutate(Max = max(wage)
#   )

#rent
rent <- cities %>% slice(57:60) %>%
  rename(Rent = X) 
rownames(rent) <- rent$Rent
rent[,1:18] <- rent %>% mutate_if(is.character, as.numeric)
rent$Rent <- rownames(rent)
rownames(rent) <- NULL 
# 
# rent_mean <- rent %>% select(-Rent) #types of rent
# 
# rent[] <- lapply(rent, as.numeric)
# 
# # rent_mean <- as.data.frame(rent_mean)
# # rent_mean <- colMeans(rent_mean)
# # rent_mean$city <- rownames(rent_mean)
# 
#  #Canadian_avg_rent <- rowMeans(rent_mean) #Average canadian rent
#  Avg_by_prov <- as.data.frame(Avg_by_prov)
#  Avg_by_prov <- colMeans(rent_mean)   #Average rent by province
#  
#  Avg_by_prov$city <- rownames(Avg_by_prov)
#  
#  Avg_by_prov$city <- c("Fredericton","Halifax","Winnipeg","Moncton","Ottawa","Saint.John","Saskatoon","Calgary","Brandon","Victoria","Edmonton","Kitchener","Waterloo","Mississauga","Guelph","Regina","Hamilton")
# rownames(Avg_by_prov) <- NULL
#   
# #comparing life quality
# #
# new_rowname <- c("Alimentação", "Transporte", "Água&Eletricidade", "Aluguel")
#  lifecosts <- cities %>% slice(73:76) %>% 
#    select(-X) %>%  
#    mutate_if(is.character, as.numeric)
#  rownames(lifecosts) <- new_rowname
#  
#  spending<- as.data.frame(spending)
#  #try<-c("Brandon", "Halifax")
#  #spending <- lifecosts["Aluguel",]
#  #spending$teste <- rownames(spending)
#  #rownames(spending) <- NULL
#  
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
    
    Aluguel_CAD<- rent[,input$n]
    
    
    ggplot(data=rent, aes(x=Rent, y=Aluguel_CAD)) +
      geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
      coord_flip() +
      xlab("") +
      theme_bw()
    
  })
  
  
  
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
