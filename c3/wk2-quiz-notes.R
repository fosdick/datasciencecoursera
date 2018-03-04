install.packages("jsonlite")
library('jsonlite')
install.packages("httpuv")
library(httpuv)
install.packages('httr')
library('httr')

oauth_endpoints("github")

myapp <- oauth_app("github",
                   "",
                   secret = "")


gtoken <- config(token = github_token)

req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)



# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/repos", "created_at"] 

gitDF



BROWSE("https://api.github.com/users/ppant/repos",authenticate("","x-oauth-basic","basic"))

# OR:
gtoken <- ""
req <- with_config(gtoken, GET("https://api.github.com/users/ppant/repos"))

stop_for_status(req)

content(req)



###
####
####
####   THIS IS WHAT WORKED

git = handle("https://api.github.com/?access_token=")
pg1 = GET(handle=git, path="users/jtleek/repos")
json1 = content(pg1)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

gitDF[gitDF$name == "datasharing",]$created_at

#######
#QUESTION 2
install.packages("sqldf")
library(sqldf)
acs = read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
sqldf("select pwgtp1 from acs where AGEP < 50", user="jarvisfosdick", password="****Shellman3")


con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)

nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])

f = read.fwf("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
summary(f)
head(f)

library(rnoaa)


sstData <- read.fwf("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", widths=c(10,5,4,4,5,4,5,4,4,5,4,4,5), skip=4)
sstData[,9]

sstData <- read.fwf("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", widths=c(10,5,4,4,5,4), skip=4)
sumCol4 <- sum(sstData$V6)