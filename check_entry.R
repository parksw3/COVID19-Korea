library(readxl)

covid1 <- read_xlsx("COVID19-Korea-2020-02-14.xlsx", sheet=1)
covid2 <- read_xlsx("COVID19-Korea-2020-02-14.xlsx", sheet=2)

all(covid2$positive + covid2$negative + covid2$unknown == covid2$`suspected cases`, na.rm=TRUE)

all(2019 <= covid1$age + covid1$year_of_birth & covid1$age + covid1$year_of_birth <= 2020)
