library(readxl)

covid2 <- read_xlsx("COVID19-Korea-2020-02-14.xlsx", sheet=2)

which(covid2$positive + covid2$negative + covid2$unknown != covid2$`suspected cases`)
