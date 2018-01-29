pollutantmean <- function(directory, pollutant, idRange) {
  
  meanByID <- function(id) {
    if (id < 10) {
      id <- paste("00", id, sep="")
    } else if (id < 100 && id > 9) {
      id <- paste("0", id, sep="")
    }
    pathStr <- paste( "wk2/",directory,"/",id,".csv", sep="")
    data <- getData(pathStr)
    colMean(data[[pollutant]])
  }
  n <- length(idRange)
  means <- numeric(n)
  for (i in 1:n) {
    means[i] <- meanByID(idRange[i])
  }
  mean(means)
}

getData <- function(filePath) {
  f <- read.csv(filePath)
}

colMean <- function(colData, removeNA = TRUE) {
   mean(colData, na.rm = removeNA)
}

pollutantmeanStack <- function(directory, pollutant, id = 1:332) {
  #set the path
  path = directory
  
  #get the file List in that directory
  fileList = list.files(path)
  
  #extract the file names and store as numeric for comparison
  file.names = as.numeric(sub("\\.csv$","",fileList))
  
  #select files to be imported based on the user input or default
  selected.files = fileList[match(id,file.names)]
  
  #import data
  Data = lapply(file.path(path,selected.files),read.csv)
  
  #convert into data frame
  Data = do.call(rbind.data.frame,Data)
  
  #calculate mean
  mean(Data[,pollutant],na.rm=TRUE)
  
}
