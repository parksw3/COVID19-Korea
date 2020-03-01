library(tidyr)
library(dplyr)
library(readxl)
library(ggplot2); theme_set(theme_bw())
library(directlabels)
source("../R/color_palette.R")
source("../R/theme.R")

covid5 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA", sheet=5) ## age

agecut <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 120)
agegroup <- c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+")

age_gather <- covid5 %>%
  gather(key, value, -date_report) %>%
  group_by(key) %>%
  arrange(key, date_report) %>%
  mutate(
    daily=diff(c(NA, value)),
    daily=ifelse(daily < 0, 0, daily)
  )


