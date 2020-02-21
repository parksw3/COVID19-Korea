library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)
library(readxl)
source("color_palette.R")
source("theme.R")

covid2 <- read_xlsx("COVID19-Korea-2020-02-21.xlsx", sheet=2)
covid3 <- read_xlsx("COVID19-Korea-2020-02-21.xlsx", sheet=3)

covid2_gather <- covid2 %>%
  select(-discharged, -death) %>%
  gather(key, value, -date_report, -`KCDC_no (https://www.cdc.go.kr/board/board.es?mid=a20501000000&bid=0015)`,
         -`date_accessed (based on Korean time)`, -`suspected cases`, -note) %>%
  mutate(
    key=factor(key, levels=c("unknown", "negative", "positive"))
  )

covid2_gather_diff <- covid2_gather %>%
  group_by(key) %>%
  mutate(
    value=diff(c(0, value))
  ) %>%
  ungroup %>%
  mutate(
    key=factor(key, levels=c("unknown", "negative", "positive"))
  )

g1 <- ggplot(covid2_gather) +
  geom_bar(aes(date_report, value, fill=key), stat="identity") +
  scale_x_datetime("Date reported") +
  scale_y_continuous("Cumulative number of cases", expand=c(0, 0)) +
  scale_fill_manual(values=cpalette) +
  btheme +
  theme(
    legend.title=element_blank(),
    legend.position="top"
  )

g1_sub <- (g1 %+% filter(covid2_gather, key=="positive")) +
  theme(legend.position="none",
        axis.text = element_text(size=5),
        axis.title = element_text(size=8))  +
  scale_fill_manual(values=cpalette[3]) 

g2 <- ggplot(covid2_gather_diff) +
  geom_hline(yintercept=0, lty=2) +
  geom_bar(aes(date_report, value, fill=key), stat="identity", position="dodge") +
  scale_x_datetime("Date reported") +
  scale_y_continuous("Daily number of cases", expand=c(0, 0)) +
  scale_fill_manual(values=cpalette)  +
  btheme +
  theme(
    legend.title=element_blank(),
    legend.position="top"
  )

g2_sub <- (g2 %+% filter(covid2_gather_diff, key=="positive")) +
  theme(legend.position="none",
        axis.text = element_text(size=5),
        axis.title = element_text(size=8)) +
  scale_fill_manual(values=cpalette[3]) 

g3 <- g1 + annotation_custom(ggplotGrob(g1_sub), xmin = as.POSIXct("2020-01-18"), xmax = as.POSIXct("2020-02-05"), 
                  ymin = 6640, ymax = 14400)

covid_text <- covid3[c(1, 3, 7, 8),] %>%
  mutate(
    esumm=c("Reported the\nfirst case",
            "Expanded the\ncase definition",
            "Expanded the\ncase definition",
            "Increased testing\nfacilities")
  )

g4 <- g2 + annotation_custom(ggplotGrob(g2_sub), xmin = as.POSIXct("2020-01-18"), xmax = as.POSIXct("2020-02-05"), 
                             ymin = 500, ymax = 1500) +
  geom_text(data=covid_text, aes(date, c(-110, -110, -110, -250), label=esumm), size=2.2,
            lineheight=0.85) +
  geom_segment(data=covid_text, aes(date, xend=date, y=0, yend=-80), lty=3, size=0.2)

gtot <- arrangeGrob(g3, g4, nrow=1)

# ggsave("figure_epidemic.pdf", gtot, width=10, height=5)
ggsave("figure_epidemic.png", gtot, width=12, height=5)
# ggsave("figure_epidemic2.png", g4, width=6, height=5)
