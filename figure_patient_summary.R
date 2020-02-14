library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)
library(readxl)
source("color_palette.R")
source("theme.R")

covid1 <- read_xlsx("COVID19-Korea-2020-02-14.xlsx", sheet=1)

symptom_by_p <- covid1$symptoms %>%
  sapply(function(x) strsplit(x, ",")) %>%
  lapply(trimws) %>%
  unname %>%
  lapply(as.data.frame) %>%
  bind_rows(.id="case") %>%
  setNames(c("case", "symptoms"))

sympdata <- symptom_by_p %>%
  group_by(symptoms) %>%
  summarize(
    prop=length(symptoms)/nrow(covid1),
    text=paste0(length(symptoms), "/", nrow(covid1))
  ) %>%
  mutate(
    type=1,
    type=ifelse(symptoms=="symptomatic", 2, type),
    type=ifelse(symptoms=="none before confirmation", 3, type),
    type=factor(type, levels=c(1, 2, 3))
  ) %>%
  arrange(type) %>%
  group_by(type) %>%
  arrange(type, -prop) %>%
  ungroup %>%
  mutate(
    symptoms=factor(symptoms, level=symptoms)
  )

agegroup <- c("20-29", "30-39", "40-49", "50-59", "60-69", "70+")
agebreak <- c(20, 30, 40, 50, 60, 70, 100)

covid_age <- covid1 %>%
  mutate(
    age2=cut(age, breaks=agebreak, include.lowest = TRUE, right=FALSE),
    age2=factor(age2, label=agegroup)
  )

g1 <- ggplot(covid_age) +
  geom_bar(aes(age2, fill=sex), position = position_dodge2(width = 0.9, preserve = "single")) +
  scale_fill_manual(values=cpalette[c(4, 7)]) +
  xlab("Age group") +
  scale_y_continuous("Number of cases", limits=c(0, NA), expand=c(0, 0)) +
  ggtitle("Age and sex") +
  btheme +
  theme(
    legend.title = element_blank(),
    legend.position = c(0.9, 0.9),
    plot.margin = margin(5.5, 5.5, 59, 5.5, "pt")
  )

g2 <- ggplot(sympdata) +
  geom_bar(aes(symptoms, prop, fill=type), stat="identity") +
  geom_text(aes(symptoms, prop+0.04, label=text)) +
  scale_y_continuous("Proportions", limits=c(0, 1), expand=c(0, 0)) +
  scale_fill_manual(values=cpalette) +
  ggtitle("Symptoms") +
  btheme +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_blank(),
        legend.position = "none")

gtot <- arrangeGrob(g1, g2, nrow=1)

ggsave("figure_patient_summary.png", gtot, width=10, height=5)
