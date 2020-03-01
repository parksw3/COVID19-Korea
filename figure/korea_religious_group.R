library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)
library(readxl)
source("../R/color_palette.R")
source("../R/theme.R")

rr <- read_xlsx("../korea_religious_group.xlsx", skip=1)

rr_gather <- rr %>%
  gather(key, value, -연령별, -`행정구역별(시군구)`, -성별, -계) %>%
  group_by(key) %>%
  mutate(
    value=ifelse(value=="-", 0, value),
    value=as.numeric(value),
    prop=value/sum(value)
  ) %>%
  filter(
    !(key %in% c("종교없음-계", "종교있음-계"))
  ) %>%
  mutate(
    연령별=gsub("세.*", "", 연령별),
    연령별=ifelse(연령별=="85", "85+", 연령별)
  )

g1 <- ggplot(rr_gather) +
  geom_line(aes(연령별, prop, col=key, group=key, lty=key)) +
  geom_point(aes(연령별, prop, col=key, group=key)) +
  scale_x_discrete("Age group") +
  scale_y_continuous("Proportion") +
  btheme +
  ggtitle("Age distributions among religious groups in Korea, 2015") +
  theme(
    legend.position = "none"
  )

ggsave("korea_religious_group.png", g1, width=16, height=8)
