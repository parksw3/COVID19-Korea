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

covid3 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA", sheet=3)

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
    key=factor(key, levels=geo_gather_sum$key)
  )

g1 <- ggplot(geo_gather2) +
  geom_line(aes(day, value), col="red") +
  geom_point(aes(day, value), col="red") +
  facet_wrap(~key, scale="free") +
  scale_x_continuous("Days since Feb 18", breaks=0:6*2) +
  scale_y_continuous("Daily number of reported cases") +
  btheme +
  theme(
    strip.background = element_blank()
  )

ggsave("geographical_distribution.png", g1, width=9, height=9)
