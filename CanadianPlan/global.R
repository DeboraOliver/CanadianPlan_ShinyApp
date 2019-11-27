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

