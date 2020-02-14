library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)
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
  arrange(-prop) %>%
  mutate(symptoms=factor(symptoms, level=symptoms))

g1 <- ggplot(sympdata) +
  geom_bar(aes(symptoms, prop), stat="identity", fill=NA, col="black") +
  geom_text(aes(symptoms, prop+0.04, label=text)) +
  scale_y_continuous("Proportions", limits=c(0, 1), expand=c(0, 0)) +
  btheme +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_blank())

ggsave("figure_symptoms.png", g1, width=10, height=5)
