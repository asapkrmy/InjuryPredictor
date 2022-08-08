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

subset <- merge(x = GPSdata, y = weeks, by = 'WeekCommencing', all.x = TRUE)

len <- length(athletes)
names <- vector(mode = "list", length = len)

a <- 1
for (j in athletes) {
  names[a] <- paste("Athlete", j, sep = " ")
  a <- a+1
}

subset <- filter(subset, subset$`Player Name` %in% names) 
subset <- subset[c("Week", "CalendarDate", "Player Name", "Distance", "Running Distance / Minute", "HSR", "High Speed Running Distance / Minute",
                   "Speed - Max", "Speed Exertion", "Speed Exertion /min", "SPRINT METRES (>7.5M/S)", "ACCEL METRES >2M.S.S", 
                   "Accel Load - Total", "Accel Load - Density", "Accel Load - Density Index", "HARD ACCEL/DECEL EFFORTS",
                   "RHIE Efforts per Bout - Mean")]

# Looking for where NAs are
#subset[is.na(subset$Week), ]

# Removing the three NA observations
subset <- subset[-c(1747, 1773, 1774), ]

# Removing the Week NAs
subset <- subset[-c(4036:4440), ]
subset[is.na(subset$Week), ]
tail(subset)



