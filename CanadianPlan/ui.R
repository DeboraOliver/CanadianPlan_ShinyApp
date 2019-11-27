#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#    
#    I used rsconnect package and then deployApp()
#

library(shiny)
library(shinydashboard)
library(readr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Define UI for application
dashboardPage(
  skin = "red",
  
  dashboardHeader(titleWidth = 450, title = "Comparação de custos de vida no Canadá"),
  dashboardSidebar(
    #a prefered city
    selectInput(
      inputId = "n",
      label = "Cidade Principal",
      choices = c("Brandon",
        "Calgary",
        "Edmonton",
        "Fredericton",
        "Guelph",
        "Halifax",
        "Hamilton",
        "Kitchener",
        "Mississauga",
        "Moncton",
        "Ottawa",
        "Regina",
        "Saint.John",
        "Saskatoon",
        "Victoria",
        "Waterloo",
        "Winnipeg"
      )
    ),
    
    #what to compare
    radioButtons(
      inputId = "thing",
      label = "Comparar",
      choices = c("Aluguel", "Água&Eletricidade", "Alimentação")
    ),
    
    #family members
    sliderInput(
      inputId = "family",
      label = "Quantas pessoas",
      min = 1,
      max = 5,
      value = 2
    ),
    
    #money matters
    #radioButtons(inputId = "money", label = "Valores em",
    #                            choices = c("Real (BRL)", "Dólar (CAD)")),
    #saving
    textInput(
      inputId = "savings",
      label = "Sua poupança em BRL",
      width = NULL
    ),
    
    #comparing diferent cities
    selectInput(
      inputId = "compare",
      label = "Comparar cidades",
      choices = c(
        "Brandon",
        "Calgary",
        "Edmonton",
        "Fredericton",
        "Guelph",
        "Halifax",
        "Hamilton",
        "Kitchener",
        "Mississauga",
        "Moncton",
        "Ottawa",
        "Regina",
        "Saint John",
        "Saskatoon",
        "Victoria",
        "Waterloo",
        "Winnipeg"
      ),
      multiple = TRUE,
      selected = c("Calgary", "Halifax")
    ),
    #submitButton("Forecast"),
    #br(),
    # img(src = "Canada_Flag.png", height = 144, width = 144),
    img(src = "Canada_Flag.png"),
    br(),
    br(),
    "Developed by ",
    span("Débora Oliveira", style = "color:blue")
    #br(),
    # h6("Data sources: ",
    #    a(href = "https://www.gov.uk/government/statistics/bis-prices-and-cost-indices", "cost"),
    # ),
    # h6("Code: ", a(href = "https://github.com/DeboraOliver/CanadianPlan_ShinyApp.git", "Github"))
    #
  ),
  
  
  
  
  dashboardBody(tabsetPanel(
    type = "tab",
    #title = "Sua cidade preferida",
    #id = "tabset1", height = "250px",
    tabPanel(
      "Sua cidade em relação as demais",
      textOutput("Esta aba mostra a comparação da sua cidade com a média canadense"),
      fluidRow(column(
        width = 10,
        offset = 0,
        box(
          title = "Principais Gastos",
          #background = "red",
          status = "danger",
          #use "primary" for blue title or sucess(green)/info(light blue)/warning(light orange)
          solidHeader = TRUE,
          collapsible = TRUE,
          plotOutput(outputId = "pie")
        ),
        
        box(
          title = "Salário Mínimo nesta cidade",
          #background = "red",
          status = "danger",
          solidHeader = TRUE,
          collapsible = TRUE,
          plotOutput(outputId = "wage")
        ),
        
        box(
          title = "Aluguel na sua cidade",
          #background = "red",
          status = "danger",
          solidHeader = TRUE,
          collapsible = TRUE,
          plotOutput(outputId = "rent")
        )
        
        # box(
        #   title = "Custo de ",
        #   #background = "red",
        #   status = "danger",
        #   solidHeader = TRUE, collapsible = TRUE,
        #   plotOutput(outputId = "cost"))
        
        
        
      ))
    ),
    
    tabPanel("Comparar várias cidades"
             #          textOutput("Esta aba compara suas 03 cidades favoritas"),
             #          fluidRow(
             #            column(width = 10, offset = 0,
             #          box(
             #            title = "Aluguel na sua cidade",
             #            #background = "red",
             #            status = "danger",
             #            solidHeader = TRUE, collapsible = TRUE,
             #            plotOutput(outputId = "rent"))
             #
             # ))
          
             ),
             
    tabPanel("Sua Poupança",
               textOutput("Esta aba é sobre suas finanças"),
               fluidRow(column(
                 width = 10,
                 offset = 0,
                 box(
                   title = "Sua Poupança em CAD",
                   #background = "red",
                   status = "danger",
                   solidHeader = TRUE,
                   collapsible = TRUE,
                   textOutput(outputId = "savings")
                 )
               ))
             )
    ))
  )
  