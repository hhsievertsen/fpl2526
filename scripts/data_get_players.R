#install.packages("devtools")
#devtools::install_github("ewenme/fplr")
#install.packages("taskscheduleR")
#library(taskscheduleR)
library("fplr")
setwd("C:\\Users\\Administrator\\Documents\\players")

filename = paste("players_",gsub(":", "-", Sys.time()),".csv",sep="")
players<-fpl_get_player_all()
players$time<-Sys.time()

write.csv(players,filename)

getwd()