complete <- function(directory,id = 1:332) {
  csvfiles <- sprintf("%s/%03d.csv", directory, id)
  nrows <- sapply( csvfiles, function(f) sum(complete.cases(read.csv(f)), na.rm=TRUE))
  rowlabels <- nrow(nrows)
  data.frame(id=sprintf('%3d', id), 
             nobs=sapply( csvfiles, function(f) sum(complete.cases(read.csv(f)), na.rm=TRUE)),
             row.names=rowlabels
  )
}
