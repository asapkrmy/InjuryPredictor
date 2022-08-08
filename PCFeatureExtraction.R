library(rio)
library(dplyr)
library(tibble)
library(readxl)

df <- read_excel("C:\\Users\\akram\\Desktop\\Dissertation\\Datasets\\FromClub\\CRFC Raw Data A Khan.xlsx")

sum(is.na(df$'Speed Exertion /min'))
