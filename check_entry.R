library(readxl)
library(dplyr)

covid1 <- read_xlsx("COVID19-Korea-2020-03-10.xlsx", sheet=1)
covid2 <- read_xlsx("COVID19-Korea-2020-03-10.xlsx", sheet=2)

all(covid2$positive + covid2$negative + covid2$unknown == covid2$`suspected cases`, na.rm=TRUE)

covid1_subset <- covid1 %>%
  filter(!grepl("s", age)) %>%
  mutate(age=as.numeric(age))

all(2019 <= covid1_subset$age + covid1_subset$year_of_birth & covid1_subset$age + covid1_subset$year_of_birth <= 2020, na.rm=TRUE)
