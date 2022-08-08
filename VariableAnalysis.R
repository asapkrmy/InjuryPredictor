library(rio)
library(dplyr)
library(tibble)
library(readxl)
library(ggplot2)

athletes <- c("AC", "AE", "AF", "AG", "AL", "AM", "AO", "AQ", "AS", "AW", "AX", "AY", "AZ", "B", "BA", "BB", "BD", "BE", 
              "BG", "BI", "BJ", "BO", "BQ", "BS", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", 
              "O", "P", "Q", "R", "S", "T", "U", "V", "W", "Y", "Z")

my_df <- read.csv("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\Players\\Athlete_AB.csv")

for (x in athletes) {
  directory <- paste("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\Players\\Athlete_", x, sep = "")
  directoryy <- paste(directory, ".csv", sep = "")
  my_df2 <- read.csv(directoryy)
  
  my_df <- rbind(my_df, my_df2)
}

# export(my_df, "CompleteDatasetZero.csv")

# relatedcols <- c("Distance", "RunningDistance/Min", "HSR", "HSRDistance/Min", "MaxSpeed",
#                 "SpeedExertion", "SpeedExertion/Min", "SprintMetres", "AccelMetres", "AccelLoadTotal", "AccelLoadDensity",
#                 "AccelLoadDensityIndex", "HardAccelDecel", "RHIEfforts/Bout", "EWMA_Distance", "EWMA_RunningDistance/Min",
#                 "EWMA_HSR", "EWMA_HSRDistance/Min", "EWMA_MaxSpeed", "EWMA_SpeedExertion", "EWMA_SpeedExertion/Min",
#                 "EWMA_SprintMetres", "EWMA_AccelMetres", "EWMA_AccelLoadTotal", "EWMA_AccelLoadDensity",
#                 "EWMA_AccelLoadDensityIndex", "EWMA_HardAccelDecel", "EWMA_RHIEfforts/Bout", "PreviousInjury")

yi <- my_df$InjuredNextTrainingSession

#for (i in 4:32) {
#  xi <- my_df[ ,i]
#  plot(xi, yi,
#       ylab = colnames(my_df)[i],
#       pch = 4)
#}

#for (j in 4:32) {
#    k = 14
#    xu <- my_df[ ,j]
#    yu <- my_df[ ,k]
    
#    plot(xu, yu,
#         xlab = colnames(my_df)[j],
#         ylab = colnames(my_df)[k],
#         pch = 4)
#         lines(lowess(xu, yu), col = "green")
#}

my_df = my_df[ ,-c(13, 27)]
export(my_df, "CompleteDataset.csv")
