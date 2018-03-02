##find best hopital
rankall <- function(outcome, num = "best") {
  r <- read.csv("a3-data/outcome-of-care-measures.csv", colClasses = "character")
  if (num == "best") {
    num = 1
  }
  
  # sorted <- r %>% 
  #   arrange(State, r[11]) %>%
  #   group_by(State) %>%
  #   mutate(rank=row_number())
  # works, but needs to force an NA when the state does not have the ranking
  
  # needed columns
  #11 Heart.Attack
  #17 Heart.Failure
  #23 Pneumonia
  if (outcome == "heart attack") {
    #r$rank <- unlist(lapply(split(r[11], list(r$State), drop = T), rank))
    a = data.frame(r[2],r[7], lapply(r[11], as.numeric))
  } else if (outcome == "heart failure") {
    #r$rank <- unlist(lapply(split(r[17], list(r$State), drop = T), rank))
    a = data.frame(r[2],r[7], lapply(r[17], as.numeric))
  } else if (outcome == "pneumonia") {
    #r$rank <- unlist(lapply(split(r[23], list(r$State), drop = T), rank))
    a = data.frame(r[2],r[7], lapply(r[23], as.numeric))
  } else {
    print("invalid outcome")
    stop("invalid outcome");
  }
  
  # c = complete.cases(x[2])
  # f = x[c,]
  # f = f[order(f[2],f[1]),]

  
  c = complete.cases(a[3])
  a = a[c,]
  s = split(a, a$State)
  
  if (is.numeric(num)) {
    b = lapply(s, function(x){z = x[order(x[3], x[1]),]
      z[num,]})
  } else if (num == "worst") {
    b = lapply(s, function(x){z = x[order(x[3], x[1]),]
      z[nrow(z),]})
  } else if (num > nrow(f)) {
    print("NA")
  }
   return(do.call("rbind", b))
}