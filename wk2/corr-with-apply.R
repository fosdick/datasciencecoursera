
complete <- function(directory,id = 1:332) {
  csvfiles <- sprintf("%s/%03d.csv", directory, id)
  nrows <- sapply( csvfiles, function(f) sum(complete.cases(read.csv(f)), na.rm=TRUE))
  rowlabels <- nrow(nrows)
  data.frame(id=sprintf('%3d', id), 
             nobs=sapply( csvfiles, function(f) sum(complete.cases(read.csv(f)), na.rm=TRUE)),
             row.names=rowlabels
  )
}

corr <- function(directory, threshold = 0) {
  #set the path
  path = directory
  
  #get the file List in that directory
  fileList = list.files(path)
  
  #extract the file names and store as numeric for comparison
  file.names = as.numeric(sub("\\.csv$","",fileList))
  
  rd <- function(f) {
    data <- read.csv(f)
    check <- sum(complete.cases(data), na.rm=TRUE)
    if (check > threshold) {
      cor(data$sulfate , data$nitrate, use="complete.obs")
    } else {
      F
    }
  }
  len <- length(fileList)
  tr <- numeric(len)
  for (i in 1:len) {
    d <- rd(file.path(path,fileList[i]))
    if (d) {
      tr[i] = d
    }
  }
  tr
  
}
