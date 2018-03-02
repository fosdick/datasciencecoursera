### Week 3 Course 3

x[,1] ## first column
x[1:2,'VAL']
###sub set is row, col
#[1,] row one
#[]
X[which(X$var2 > 8)]
## which allows selection and removes NA's

sort(X$var1, decreaseing = TRUE)

sort(X$v, na.last=TRUE)

X[order(X$var1),] ##sort by row on column var1
X[order(X$var1,X$v2),] ##sorts by v1 then v2

#using plyr
arrange(X,var1)
##sim to order
arrange(X,desc(var1))#desc order
#adding column
X$var4 <- rnorm(y) #y is equal to number of rows in data frame
Y <- cbind(X, rnorm(5))
#cbind


####Lecture 2 summarying data
##useful commands
head()
tail()
summary()
str()


quantile(data$col, na.rm=TRUE, probs=c(0.5,0.75,0.9))


table(data$zipCode, useNA="ifany") #use NA if any
##number of values for each value
## 2 dim table
table(d$col1, d$col2)

sum(is.na(data$col))
#if sum = 0 no missing values
any(is.na(d$col))
#if False no na's
all(data$col > 0)
#if false not all > 0
colSum(is.na(resData))
all(colSum(is.na(resData))) #confirm no missing values

table(data$col %in% c('v', 'v2'))

table[data$col %in% c('v1', 'v2'),] #only rows


#cross tabs
data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt

warpbreaks$relicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data=warpbreaks)
xt

ftable(xt)

object.size(xt)
print(object.size(xt), units="Mb")


##lectyure 3
s1 <- seq(1,10, by = 2)
s1

x <- c(1,3,8,25,100)
seq(along = x)


res = data$col %in% c("cap hill", "city park")
table(res)

data$isWrong = ifelse(data$zip < 0, TRUE, FALSE)
table(data$isWrong, data$zip < 0)

res$zipGroups = cut(resData$zip, breaks = quantile(resData$zip))
table(res$zipGroups)

table(resData$zipGroups, resData$zipCode)

#easier way
library(Hmisc)
reaData$zipGroups = cut2(d$col, g=4) #4 groops in quantiles

resData$zcf = factor(d$col)
##create factor

yesno = sample(c("y", "n", size=10, replace=T))
fac = factor(yesno, levels=c("y", "n"))
relevel(fac,ref="y")
as.numeric(fac)

library(Hmisc)
library(plyr)
d2 = mutate(d1, zipGroups=cut2(zipCode, g=4))
table(d2$zipGroups)

#lec 4 reshape for tidy 

library(reshape2)
head(mtcars)

mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars=c("mpg", "hp"))
head(carMelt,n=3)


cylData <- dcast(carMelt, cyl ~ variable)
cylData

cylData <- dcast(carMelt, cyl ~ variable, mean)

head(InsectSprays)

tapply(InsectSprays$count, InsectSprays$spray, sum)
##same as above but with split and apply
spIns = split(InsectSprays$count, InsectSprays$spray)
sprC = lapply(spIns, sum)
sprC
unlist(sprC)
sapply(spIns,sum)

##using plyr
ddply(InsectSprays, .(spray), summarize, sum(sum(count)))

sSums = ddply(InsectSprays, .(spray), summarize, sum=(ave(count, FUN=sum)))
dim(sSums)

##other commands acast, arrange, mutate
#dplyr
# arrange, filter, select, mutate, rename
#1 obs per row, each col a var or measure or char
#allows for verbs and is fast as it's in C++
library(dplyr)
##dplyr functions always take data.frame as 1st arg
%>% #pipeline operator |
chicago <- readRDS("chicago.rds")

#merge commands "joins" data frames
mD = merge(d1, d2, by.x="col_id", by.y="id", all=T)

#join in plyr package, faster but less full featured.
