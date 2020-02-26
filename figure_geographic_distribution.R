library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw(base_size=16))
library(gridExtra)
library(readxl)
library(lubridate)
library(lme4)
source("color_palette.R")
source("theme.R")

covid1 <- read_xlsx("COVID19-Korea-2020-02-26.xlsx", sheet=3, na="NA")

covid1_geo_all <- covid1 %>%
  gather(key, value, -date_report, -time_report, -total) %>%
  group_by(key) %>%
  summarize(
    cases=sum(value, na.rm=TRUE)
  ) %>%
  arrange(cases)

covid1_geo <- covid1 %>%
  gather(key, value, -date_report, -time_report, -total) %>%
  group_by(date_report, key) %>%
  summarize(
    cases=sum(value, na.rm=TRUE)
  ) %>%
  mutate(
    key=factor(key, levels=covid1_geo_all$key),
    day=yday(date_report)
  ) %>%
  ungroup %>%
  mutate(
    day=day-min(day)
  )

int_breaks <- function(x, n = 6) pretty(x*2, n)[pretty(x*2, n) %% 1 == 0] 

datelabel <- c("Feb 19", "Feb 21", "Feb 23", "Feb 25")

g1 <- ggplot(covid1_geo) +
  geom_line(aes(day, cases)) +
  scale_y_continuous("Daily number of confirmed cases", breaks=int_breaks) +
  scale_x_continuous("Date reported",
                     breaks=c(1, 3, 5, 7),
                     labels=datelabel) +
  facet_wrap(~key, scale="free") +
  btheme +
  theme(
    strip.background = element_blank()
  )

ggsave("figure_geographic_distribution.png", g1, width=16, height=8)
