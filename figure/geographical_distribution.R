library(tidyr)
library(dplyr)
library(readxl)
library(ggplot2); theme_set(theme_bw())
library(directlabels)
library(lme4)
library(glmmTMB)
library(lubridate)
source("../R/color_palette.R")
source("../R/theme.R")

covid3 <- read_xlsx("../COVID19-Korea-2020-03-11.xlsx", na="NA", sheet=3)

geo_gather <- covid3 %>%
  gather(key, value, -date_report, -time_report, -total) %>%
  group_by(date_report, key) %>%
  summarize(
    value=sum(value, na.rm=TRUE)
  ) %>%
  mutate(
    day=yday(date_report)
  ) %>%
  ungroup %>%
  mutate(
    day=day-min(day)
  )

geo_gather_sum <- geo_gather %>%
  group_by(key) %>%
  summarize(
    total=sum(value)
  ) %>%
  arrange(total)

geo_gather2 <- geo_gather %>%
  mutate(
    key=factor(key, levels=geo_gather_sum$key),
    value=ifelse(value < 0, 0, value)
  )

g1 <- ggplot(geo_gather2) +
  geom_bar(aes(date_report, value), fill=cpalette[6], stat="identity") +
  facet_wrap(~key, scale="free") +
  scale_x_datetime("Date reported", expand=c(0, 0)) +
  scale_y_continuous("Number of cases", expand=c(0,0), limits=c(0, NA)) +
  btheme +
  theme(
    strip.background = element_blank()
  )

ggsave("geographical_distribution.png", g1, width=12, height=12)
