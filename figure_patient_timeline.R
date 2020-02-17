library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)
library(readxl)
source("color_palette.R")
source("theme.R")

covid1 <- read_xlsx("COVID19-Korea-2020-02-17.xlsx", sheet=1, na="NA")

covid1_subset <- covid1 %>%
  filter(!is.na(date_discharged)) %>%
  select(
    case, date_import, date_onset, date_confirm, date_discharged
  ) %>%
  mutate(
    case=factor(case, levels=rev(sort(unique(case))), 
                labels=paste0("Case ", rev(sort(unique(case)))))
  )

covid1_subset_gather <- covid1_subset %>%
  gather(key, value, -case) %>%
  mutate(
    key=factor(key, levels=c("date_import", "date_onset", "date_confirm", "date_discharged"),
               labels=c(
                 "Date imported",
                 "Date of symptom onset", 
                 "Date confirmed as a case",
                 "Date discharged"))
  )

covid1_subset2 <- covid1_subset %>%
  mutate(
    date_relevant=pmax(date_onset, date_import)
  )

g1 <- ggplot(covid1_subset_gather) +
  geom_segment(data=covid1_subset2, aes(x=date_relevant, xend=date_confirm, y=case, yend=case),
               col="#cc0066", size=5, alpha=0.5) +
  geom_segment(data=filter(covid1_subset, is.na(date_import)), aes(x=date_onset, xend=date_confirm, y=case, yend=case),
               col="#cc0066", size=5, alpha=0.5) +
  geom_segment(data=covid1_subset, aes(x=date_confirm, xend=date_discharged, y=case, yend=case),
               col="#ffcc00", size=5, alpha=0.5) +
  geom_point(aes(value, case, col=key), size=4) +
  scale_x_datetime(date_minor_breaks="1 day") +
  scale_color_manual(values=c("black", "#cc0066", "#ffcc00", "#66cccc")) +
  theme(
    legend.position = "top",
    legend.direction = "horizontal",
    legend.title = element_blank(),
    axis.title = element_blank()
  )

ggsave("figure_patient_timeline.png", g1, width=10, height=3)
