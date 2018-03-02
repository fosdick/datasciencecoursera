ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")

result <- dbGetQuery(ucscDb, "show databases;")

dbDisconnect(ucscDb)


hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")

allTables <- dbListTables(hg19)

allTables[1:5]

dbListFields(hg19, "affyU133Plus2")

dbGetQuery(hg19, "select count(*) from affyU133Plus2")

affyData <- dbReadTable(hg19, "affyU133Plus2")

head(affyData)

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affMis <- fetch(query)
quantile(affMis$misMatches)

affMisSmall <- fetch(query, n=10)
dbClearResult(query)

dim(affMisSmall)

dbDisconnect(hg19)

######## lecture 2
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
created = h5createFile("example.h5")
created

created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")


A = matrix(1:10,nr=5,nc=2)
A
h5write(A, "example.h5", "foo/A")

B = array(seq(0.1, 2.0, by=0.1), dim = c(5,2,2))

attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

df = data.frame(1L:5L, seq(0,1, length.out = 5),
                c("ab", "cde", "fghi", "a", "s"), stringsAsFactors = FALSE)

h5write(df, "example.h5", "df")
h5ls("example.h5")

readA = h5read("example.h5", "foo/A")
readB = h5read("example.h5", "foo/foobaa/B")
readdf = h5read("example.h5", "df")
readA

h5write(c(12,13,14), "example.h5", "foo/A", index=list(1:3,1))
h5read("example.h5", "foo/A")

h5read("example.h5", "foo/A", index=list(1:3,1))

######## lecture 3 web scrapping
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode


library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
url = "https://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes = T)

v = xpathSApply(html, "//title", xmlValue)

xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

library(httr)
html2 = GET(url)
content2 = content(html2,as="text")
parseHTML = htmlParse(content2, asText = T)
xpathSApply(parseHTML, "//title", xmlValue)

pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1

pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user", "passwd"))
pg2

names(pg2)

google = handle("http://google.com")
pg1 = GET(handle=google, path="/")
pg2 = GET(handle=google, path="search")


myapp = oauth_app("twitter", 
                  key="exurXHW1rJK83To01QQ7EL1GZ", secret = "dzBadNuD5cPK2PJpk5N2D3ZkDcEkOJuHtZptS6wK8GVP9afyKs")
sig = sign_oauth1.0(myapp,
                    token = "964604918014255104-KUR37T5sm1oICMUQyTGZC6Xg5EbMNai",
                    token_secret = "N7gsPtqDkdKQoR8JZgemkC2dhxXRZKruamWBFIt93FQpd")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)

json1 = content(homeTL)
json2 = jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]

library(jsonlite)
