# Canadian Plan: ShinyApp

================
Debora Oliveira

Overview
--------

This app introduces a brief comparative of living costs in Canada. It does not contain data about all Canadian cities, although, it can be easily add in a near future. A few names/titles are in the original client language (portuguese).

## 1. Requirements


To run this project I used the following libraries:

``` r
library(shiny)
library(shinydashboard)
library(readr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(reshape)
```
As we see above, apart from the RColorBrewer used to improve aesthetics in some graphs, all libraries are quite popular.

### i) RColorBrewer library

An example of the RColorBrewer library in this project:

``` r
  coul <- brewer.pal(3, "Set2")
    
    barplot(
      height = vector_bar,
      names = c("Máximo", input$n, "Média"),
      col = coul,
      xlab = "",
      ylab = "values",
      main = "Salário Minimo por hora (CAD)", #translation: Minimun wage per hour
      ylim = c(0, 20)
    )
```

It sets a better pallet of colours.

## 2. Code organization

This project has two main files: ui and server. The first parte of server contains a few tables and data mining. 

## 3. Improvements to be done

This project can be improved in the future:
- translations (from original to English and vice-versa);
- better hipotheses to be tested (at this point the main questions were life spends and rent prices);
- the dolar value could be automatically updated;
- instead of a csv file with data, we could get it all online.


# Final Result

https://dsoliver.shinyapps.io/CanadianPlan/



  
