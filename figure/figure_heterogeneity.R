library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)
library(readxl)
library(lubridate)
source("../R/color_palette.R")
source("../R/theme.R")

covid2 <- read_xlsx("../COVID19-Korea-2020-03-13.xlsx", na="NA", sheet=2)
covid8 <- read_xlsx("../COVID19-Korea-2020-03-13.xlsx", na="NA", sheet=7)

covid2_diff <- covid2 %>%
  mutate(
    time_report=hour(time_report)
  ) %>%
  filter(is.na(time_report) | time_report != 16) %>%
  mutate(sum=positive+negative,
         sum=diff(c(0, sum)),
         positive=diff(c(0, positive)),
         negative=diff(c(0, negative)))


covid8[is.na(covid8)] <- 0
covid8$`Cheongdo Daenam Hospital`[6] <- NA

covid8_diff <- covid8 %>%
  select(-`Cheonan-si and other gyms (Chungcheongnam-do)`) %>%
  mutate(
    time_report=hour(time_report),
    Shincheonji=diff(c(0, Shincheonji)),
    `Cheongdo Daenam Hospital`=diff(c(0, `Cheongdo Daenam Hospital`)),
    `Guro call center`=diff(c(0, `Guro call center`)),
    `Ministry of Oceans and Fisheries`=diff(c(0, `Ministry of Oceans and Fisheries`))
  )

covid8_diff[is.na(covid8_diff)] <- 0

mm <- merge(covid2_diff, covid8_diff) %>%
  select(-time_report, -`suspected cases`, -negative, -discharged, -unknown, -death,
         -`date_accessed (based on Korean time)`,
         -`KCDC_no (https://www.cdc.go.kr/board/board.es?mid=a20501000000&bid=0015)`,
         -sum,
         -`Oncheon Church`) %>%
  mutate(Other=positive-Shincheonji-`Cheongdo Daenam Hospital`-`Guro call center`-`Ministry of Oceans and Fisheries`) %>%
  gather(key, value, -positive, -date_report) %>%
  mutate(
    value=ifelse(value < 0, 0, value),
    key=factor(key, levels=c("Other", "Shincheonji", "Cheongdo Daenam Hospital", "Guro call center", "Ministry of Oceans and Fisheries"))
  )

g1 <- ggplot(mm) +
  geom_bar(aes(date_report, value, fill=key), stat="identity") +
  scale_x_datetime("Date reported") +
  scale_y_continuous("Number of cases", expand=c(0, 0), limits=c(0, 1000)) +
  scale_fill_manual(values=cpalette) +
  btheme +
  theme(
    legend.title = element_blank(),
    legend.position = c(0.2, 0.8)
  )

g2 <- ggplot(mm) +
  geom_bar(aes(date_report, value, fill=key), stat="identity") +
  scale_x_datetime("Date reported") +
  scale_y_continuous("Number of cases", expand=c(0, 0), limits=c(0, NA)) +
  scale_fill_manual(values=cpalette) +
  btheme +
  facet_wrap(~key, ncol=1, scale="free") +
  theme(
    legend.position = "none",
    strip.background = element_blank()
  )

gtot <- arrangeGrob(g1, g2, nrow=1)

ggsave("figure_heterogeneity.png", gtot, width=12, height=6)
