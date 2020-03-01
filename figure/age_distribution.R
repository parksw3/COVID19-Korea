library(tidyr)
library(dplyr)
library(readxl)
library(ggplot2); theme_set(theme_bw())
library(directlabels)
library(gridExtra)
source("../R/color_palette.R")
source("../R/theme.R")

covid1 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA")
covid2 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA", sheet=2)
covid3 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA", sheet=3)
covid5 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA", sheet=5) ## age
covid6 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA", sheet=6) %>% ## death
  mutate(
    age=ifelse(is.na(age), 2020-year_of_birth-1, age)
  )

covid7 <- read_xlsx("../COVID19-Korea-2020-03-01.xlsx", na="NA", sheet=7) %>% ## discharged
  mutate(
    age=ifelse(is.na(age), 2020-year_of_birth-1, age)
  )

covid7_discharged <- covid7 %>%
  filter(is.na(date_rehospitalized))

covid7_rehospitalized <- covid7 %>%
  filter(!is.na(date_rehospitalized))

agecut <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 120)
agegroup <- c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+")

age_gather <- tail(covid5, -4) %>%
  setNames(c("date_report", agegroup)) %>%
  gather(key, value, -date_report) %>%
  group_by(key)

agedata <- tibble(
  agegroup=agegroup,
  count=unname(unlist(tail(covid5,1)[,-1]))
) %>%
  mutate(
    total=sum(count)
  ) %>%
  group_by(agegroup) %>%
  mutate(
    prop=count/total,
    lwr=binom.test(count, total)[[4]][[1]],
    upr=binom.test(count, total)[[4]][[2]]
  )

cfrdata <- tibble(
  agegroup=agegroup,
  total=unname(unlist(tail(covid5,1)[,-1])),
  death=unname(c(table(cut(covid6$age, agecut, include.lowest = TRUE, right=FALSE)))),
  discharged=unname(c(table(cut(covid7_discharged$age, agecut, include.lowest = TRUE, right=FALSE)))),
  rehospitalized=unname(c(table(cut(covid7_rehospitalized$age, agecut, include.lowest = TRUE, right=FALSE)))),
  unknown=total-death-discharged-rehospitalized
) %>%
  group_by(agegroup) %>%
  mutate(
    death=death/total,
    discharged=discharged/total,
    rehospitalized=rehospitalized/total,
    unknown=unknown/total
  ) %>%
  ungroup %>%
  gather(key, value, -agegroup, -total) %>%
  mutate(
    key=factor(key, levels=c("unknown", "rehospitalized", "discharged", "death"))
  )

g1 <- ggplot(age_gather) +
  geom_line(aes(date_report, value, group=key, col=key,
                lty=key)) +
  geom_point(aes(date_report, value, group=key, col=key,
                shape=key)) +
  scale_x_datetime("Date reported", limits=as.POSIXct(c("2020-02-22", "2020-03-01"))+15*3600, expand=c(0, 0)) +
  scale_y_log10("Cumulative number of confirmed cases", expand=c(0, 0),
                limits=c(1, 1500)) +
  ggtitle("A. Don't fit exponential growth curves to cumulative cases") +
  scale_shape_manual(values=1:9) +
  btheme

g1_2 <- direct.label(g1, list(dl.trans(x=x+0.15), "last.bumpup"))

g2 <- ggplot(agedata) +
  geom_bar(aes(agegroup, prop, fill=agegroup), stat="identity", col=1) +
  geom_errorbar(aes(agegroup, ymin=lwr, ymax=upr), width=0) +
  scale_x_discrete("Age group") +
  scale_y_continuous("Proportion of confirmed cases", expand=c(0, 0), limits=c(0, 0.35)) +
  ggtitle("B. Age distribution") +
  btheme +
  theme(
    legend.position = "none"
  )

g3 <- ggplot(filter(cfrdata, key!="unknown")) +
  geom_bar(aes(agegroup, value, fill=key), stat="identity") +
  scale_fill_manual(values=c(cpalette[2:3], "black")) +
  scale_x_discrete("Age group") +
  scale_y_continuous("Proportion of confirmed cases", expand=c(0, 0), limits=c(0, 0.06)) +
  ggtitle("C. (Un)known outcomes") +
  btheme +
  theme(
    legend.title = element_blank(),
    legend.position = c(0.15, 0.9)
  )

gtot <- arrangeGrob(g1_2, g2, g3, nrow=1)

ggsave("age_distribution.png", gtot, width=16, height=6)
