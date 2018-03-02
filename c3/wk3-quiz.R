acs = read.csv('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv')
head(acs, 3)

nrow(acs[which(acs$ACR == 3),])

nrow(acs[acs$AGS == 6,])

nrow(acs[acs$ACR == 3 & acs$AGS == 6,])

nrow(acs)

x = acs[which(acs$ACR == 3),]

y = x[which(x$AGS == 6),]
nrow(y)

any(is.na(acs$ACR))

any(is.na(acs$AGS))


agricultureLogical = as.vector(acs[which(acs$ACR == 3 & acs$AGS == 6),])
nrow(agricultureLogical)
summary(agricultureLogical)

head(ss, 3)


acs$match = ifelse(acs$ACR == 3 & acs$AGS == 6, TRUE, FALSE)
agricultureLogical = as.vector(acs$match)
which(agricultureLogical)

#q2
install.packages('jpeg')
library('jpeg')

furl = "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(furl, destfile="./img2.jpeg", method="curl")

img <- readJPEG("./img2.jpeg", native=TRUE)
 quantile(img)
 quantile(img, probs = c(0.3, 0.8))
 
 
 ##q3
 library(dplyr)
 
 cn = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip=4)
 
 ed = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
 
 names(cn)
 names(ed)
 head(ed,3)
 head(cn, 3)

 cn <- rename(cn,CountryCode=X, ranking=X.1,name=X.3, value=X.4 )
cnty = subset(cn, select=c(CountryCode, ranking, name, value))
head(cnty,3)

ed[ed$CountryCode == 'USA',]

m = merge(ed, cnty, by.x = "CountryCode", by.y = "CountryCode", y.all = F)

m = merge(cnty,ed, by.x = "CountryCode", by.y = "CountryCode", y.all = F, x.all=T)

summary(m)
m
names(m)
x <- data.frame(m[5], m[6], lapply(m[4], function(x) { as.numeric(gsub(",", "", x)); print( gsub(",", "", as.character(x)))} ))

x$value <- as.numeric(as.character(x$value))
x
summary(x)
library(data.table)

y = arrange(x,-value)
head(y)
sapply(y, class)

tail(y,30)
a = y[1:198,]
tail(a,13)
head(a,13)

a[a==""] <- NA
y
a
c = complete.cases(y[2])
f = y[c,]

sorted <- f %>% 
  mutate(rank=row_number())
print.data.frame(sorted)
summary(sorted)

sorted

types = group_by(sorted, Income.Group)

dt = data.table(sorted)
dt[,list(mean=mean(rank)),by=Income.Group]

dt
quantile(types$rank, na.rm=TRUE, probs=c(0.1,0.25,0.5,0.75,0.9))
summarise(types,col=quantile(sorted$rank, na.rm=TRUE, probs=c(0.1,0.25,0.5,0.75,0.9)))

breaks <- quantile(dt$rank, probs = seq(0, 1, 0.2), na.rm = TRUE)
dt$quantileGDP <- cut(dt$rank, breaks = breaks)
dt[Income.Group == "Lower middle income", .N, by = c("Income.Group", "quantileGDP")]


tail(m,3)
ncol(ed)
m[order(m$value),]
mm = arrange(m,desc(value))
tail(mm)
head(mm,3)
nrow(cnty)
nrow(m)
mm[1,]
str(mm)
x <- data.frame(mm[2], lapply(mm[34], function(x) { as.numeric(gsub(",", "", x)); print( gsub(",", "", as.character(x)))} ))
y = arrange(x,value)
tail(y,30)
a = y[1:198,]
tail(a,13)
head(a,13)
nrow(y)
y[100:120,]
head(x,1)
summary(x)
head(y,30)
mm[,34]
head(mm)
y = sort(x$value, decreasing = TRUE)

y = x[rev(order(x$value)),]

sort(x$value, na.last=F)


tail(y,5)
tail(x,5)
summary(y)
y
str(x)
sapply(x, class)

x$value <- as.numeric(as.character(x$value))



dt <- merge(cn, ed, all = TRUE, by = c("CountryCode"))
sum(!is.na(unique(dt$rankingGDP)))