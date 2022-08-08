library(rio)
library(dplyr)
library(tibble)
library(readxl)
library(TTR)

athletes <- c("AB", "AC", "AE", "AF", "AG", "AL", "AM", "AO", "AQ", "AS", "AW", "AX", "AY", "AZ", "B", "BA", "BB", "BD", "BE", 
              "BG", "BI", "BJ", "BO", "BQ", "BS", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", 
              "O", "P", "Q", "R", "S", "T", "U", "V", "W", "Y", "Z")

GPSdata <- read_excel("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\CRFC Raw Data A Khan.xlsx")
weeks <- read_excel("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\Weeks.xlsx")
inj <- read_excel("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\Injuries.xlsx")

subset <- merge(x = GPSdata, y = weeks, by = 'WeekCommencing', all.x = TRUE)

len <- length(athletes)
names <- vector(mode = "list", length = len)

a <- 1
for (j in athletes) {
  names[a] <- paste("Athlete", j, sep = " ")
  a <- a+1
}

subset <- filter(subset, subset$`Player Name` %in% names) 
subset <- subset[c("Week", "CalendarDate", "Player Name", "Distance", "Running Distance / Minute", "HSR",
                   "Speed - Max", "SPRINT METRES (>7.5M/S)", "ACCEL METRES >2M.S.S", 
                   "Accel Load - Total", "Accel Load - Density", "Accel Load - Density Index", "HARD ACCEL/DECEL EFFORTS",
                   "RHIE Efforts per Bout - Mean")]

# Removing the three NA observations
subset <- subset[-c(1747, 1773, 1774), ]

# Removing the Week NAs
subset <- subset[-c(4036:4440), ]

df <- data.frame()

for (z in athletes) {
  player <- paste("Athlete", z, sep = " ")
  subs <- filter(subset, subset$`Player Name` == player) 
  
  subs$EWMA_Distance <- TTR::EMA(x = subs$Distance, n =5)
  subs$'EWMA_RunningDistance/Min' <- TTR::EMA(x = subs$`Running Distance / Minute`, n =5)
  subs$EWMA_HSR <- TTR::EMA(x = subs$HSR, n =5)
  subs$EWMA_MaxSpeed <- TTR::EMA(x = subs$`Speed - Max`, n =5)
  subs$EWMA_SprintMetres <- TTR::EMA(x = subs$`SPRINT METRES (>7.5M/S)`, n =5)
  subs$EWMA_AccelMetres <- TTR::EMA(x = subs$`ACCEL METRES >2M.S.S` , n =5)
  subs$EWMA_AccelLoadTotal <- TTR::EMA(x = subs$`Accel Load - Total`, n =5)
  subs$EWMA_AccelLoadDensity <- TTR::EMA(x = subs$`Accel Load - Density`, n =5)
  subs$EWMA_AccelLoadDensityIndex <- TTR::EMA(x = subs$`Accel Load - Density Index`, n =5)
  subs$EWMA_HardAccelDecel <- TTR::EMA(x = subs$`HARD ACCEL/DECEL EFFORTS`, n =5)
  subs$'EWMA_RHIEfforts/Bout' <- TTR::EMA(x = subs$`RHIE Efforts per Bout - Mean`, n =5)
  
  subs$InjuredNextTrainingSession <- 0
  
  # Remove rows containing NAs for EWMA entries
  subs <- subs[-c(1:4), ]
  
  colnames(subs) <- c("Week", "CalendarDate", "PlayerName", "Distance", "RunningDistance/Min", "HSR", "MaxSpeed",
                      "SprintMetres", "AccelMetres", "AccelLoadTotal", "AccelLoadDensity",
                      "AccelLoadDensityIndex", "HardAccelDecel", "RHIEfforts/Bout", "EWMA_Distance", "EWMA_RunningDistance/Min",
                      "EWMA_HSR", "EWMA_MaxSpeed",
                      "EWMA_SprintMetres", "EWMA_AccelMetres", "EWMA_AccelLoadTotal", "EWMA_AccelLoadDensity",
                      "EWMA_AccelLoadDensityIndex", "EWMA_HardAccelDecel", "EWMA_RHIEfforts/Bout", "InjuredNextWeek")
  
  df <- rbind(df,subs)
} 

export(df,'CompleteDataset.csv')