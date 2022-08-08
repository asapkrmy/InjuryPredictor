library(rio)
library(dplyr)
library(tibble)
library(readxl)
library(TTR)

athletes <- c("AC", "AL", "AM", "AO", "AQ", "AR", "AW", "AX", "AZ", "BA", "BD", "BE", "BI", "BJ", "BN", "BO", "BS", "BT", "BU", "BV", "BW", "BY", "CA", "CK", "CM", "CN", "CO", "CP", "CQ", "CR", "CV", "CW", "CZ", "DA", "D", "E", "H", "I", "J", "Q", "Y")

GPSdata <- read_excel("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\NewData.xlsx")
weeks <- read_excel("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\Weeks.xlsx")
inj <- read_excel("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\NewInjuries.xlsx")

subset <- merge(x = GPSdata, y = weeks, by = 'Week Commencing', all.x = TRUE)

len <- length(athletes)
names <- vector(mode = "list", length = len)

a <- 1
for (j in athletes) {
  names[a] <- paste("Athlete", j, sep = " ")
  a <- a+1
}
subset$A
subset <- filter(subset, subset$`Player Name` %in% names)
subset <- subset %>%
  select(Week, Date, `Player Name`, `Total Distance`, `Meterage Per Minute`, HSR, `Speed - Max`, `SPRINT METRES (>7.5M/S)`,`ACCEL METRES >2M.S.S`,
         `Total Acceleration Load`, `Acceleration Density`, `Acceleration Density Index`,`RHIE Efforts Per Bout - Mean`)

colnames(subset) <- c("Week", "CalendarDate", "PlayerName", "Distance", "RunningDistance/Min", "HSR", "MaxSpeed",
                    "SprintMetres", "AccelMetres", "AccelLoadTotal", "AccelLoadDensity",
                    "AccelLoadDensityIndex", "RHIEfforts/Bout")


#Removing rows with NA values
subset <- subset[-c(112,113),]

df <- data.frame()

for (z in athletes) {
  player <- paste("Athlete", z, sep = " ")
  subs <- filter(subset, subset$PlayerName == player) 
  
  subs$EWMA_Distance <- TTR::EMA(x = subs$Distance, n =5)
  subs$'EWMA_RunningDistance/Min' <- TTR::EMA(x = subs$`RunningDistance/Min`, n =5)
  subs$EWMA_HSR <- TTR::EMA(x = subs$HSR, n =5)
  subs$EWMA_MaxSpeed <- TTR::EMA(x = subs$`MaxSpeed`, n =5)
  subs$EWMA_SprintMetres <- TTR::EMA(x = subs$`SprintMetres`, n =5)
  subs$EWMA_AccelMetres <- TTR::EMA(x = subs$`AccelMetres` , n =5)
  subs$EWMA_AccelLoadTotal <- TTR::EMA(x = subs$`AccelLoadTotal`, n =5)
  subs$EWMA_AccelLoadDensity <- TTR::EMA(x = subs$`AccelLoadDensity`, n =5)
  subs$EWMA_AccelLoadDensityIndex <- TTR::EMA(x = subs$`AccelLoadDensityIndex`, n =5)
  subs$'EWMA_RHIEfforts/Bout' <- TTR::EMA(x = subs$`RHIEfforts/Bout`, n =5)
  
  subs$InjuredNextTrainingSession <- 0
  
  # Remove rows containing NAs for EWMA entries
  subs <- subs[-c(1:4), ]
  
  colnames(subs) <- c("Week", "CalendarDate", "PlayerName", "Distance", "RunningDistance/Min", "HSR", "MaxSpeed",
                      "SprintMetres", "AccelMetres", "AccelLoadTotal", "AccelLoadDensity",
                      "AccelLoadDensityIndex",  "RHIEfforts/Bout", "EWMA_Distance", "EWMA_RunningDistance/Min",
                      "EWMA_HSR", "EWMA_MaxSpeed",
                      "EWMA_SprintMetres", "EWMA_AccelMetres", "EWMA_AccelLoadTotal", "EWMA_AccelLoadDensity",
                      "EWMA_AccelLoadDensityIndex", "EWMA_RHIEfforts/Bout", "InjuredNextTrainingSession")
  
  df <- rbind(df,subs)
} 

export(df,'PredApproach1.csv')

cf <- aggregate(df[,4:24], list(PlayerName = df$PlayerName,Week = df$Week), mean)
export(cf,'PredApproach2.csv')
