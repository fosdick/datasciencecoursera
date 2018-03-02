##find best hopital
rankhospital <- function(state, outcome, num = "best") {
  r <- read.csv("a3-data/outcome-of-care-measures.csv", colClasses = "character")
  
  ##get by state Abbr
  a = r[r$State == state,]
  if (nrow(a) == 0) {
    print("invalid state")
    stop("invalid state")
  }
  if (num == "best") {
    num = 1
  }
  # needed columns
  #11 Heart.Attack
  #17 Heart.Failure
  #23 Pneumonia
  if (outcome == "heart attack") {
    x <- data.frame(a[2], lapply(a[11], as.numeric))
  } else if (outcome == "heart failure") {
    x <- data.frame(a[2], lapply(a[17], as.numeric))
  } else if (outcome == "pneumonia") {
    x <- data.frame(a[2], lapply(a[23], as.numeric))
  } else {
    print("invalid outcome")
    stop("invalid outcome");
  }
  
  c = complete.cases(x[2])
  f = x[c,]
  f = f[order(f[2],f[1]),]
  if (is.numeric(num)) {
    print(f[num,1])
  } else if (num == "worst") {
    print(f[nrow(f),1])
  } else if (num > nrow(f)) {
    print("NA")
  }
  
  # return(f)
}