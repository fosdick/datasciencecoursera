d = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv')

head(d)

names = strsplit(names(d), "wgtp")
names[123]

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "c3/GDP.csv")
download.file(url, f)
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 190))

y <- sapply(dtGDP$X.4, function(x) { as.numeric(gsub(",", "", x)) })

mean(y)

grep("^United",dtGDP$X.3)


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
f <- file.path(getwd(), "GDP.csv")
download.file(url, f)
dtGDP <- data.table(read.csv(f, skip = 4, nrows = 215))
dtGDP <- dtGDP[X != ""]
dtGDP <- dtGDP[, list(X, X.1, X.3, X.4)]
setnames(dtGDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", 
                                               "Long.Name", "gdp"))
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f <- file.path(getwd(), "EDSTATS_Country.csv")
download.file(url, f)
dtEd <- data.table(read.csv(f))
dt <- merge(dtGDP, dtEd, all = TRUE, by = c("CountryCode"))

dt
names(dt)
head(dt)
length(grep(".*year.*end.*June",dt$Special.Notes))

install.packages('quantmod')
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
head(sampleTimes)

library(lubridate)

wday("2007-01-08", label=T)
wday("2007-01-08")

addmargins(table(year(sampleTimes), weekdays(sampleTimes)))
