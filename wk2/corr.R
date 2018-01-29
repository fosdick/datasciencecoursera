source("complete.R")
corr <- function(directory, threshold = 0) {
  #set the path
  path = directory
  c <- complete(path)
  good <- c$nobs > threshold
  set <- c$id[good]
  #get the file List in that directory
  fileList = list.files(path)
  len <- length(set)
  tr <- numeric(len)
  cnt <- 1
  for (i in set) {
    n <- paste(gsub(" ", "0", i), ".csv", sep="")
    data <- read.csv(file.path(path,n))
    tr[cnt] <- cor(data$sulfate , data$nitrate, use="complete.obs")
    cnt <- cnt + 1
  }
  tr
}