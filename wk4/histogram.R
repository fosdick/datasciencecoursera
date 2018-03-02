
outcome <- read.csv("a3-data/outcome-of-care-measures.csv", colClasses = "character")

head(outcome)
ncol(outcome)
names(outcome)
outcome[, 11] <- as.numeric(outcome[, 11])
## You may get a warning about NAs being introduced; that is okay
hist(outcome[, 11])