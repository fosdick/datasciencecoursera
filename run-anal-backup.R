#requires rknit, rmarkdown

#download data set
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path <- file.path(getwd(),"c3/Practical/data")
dPath <- file.path(getwd(),"c3/Practical")
f <- file.path("Dataset.zip")
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, f))

# unzip the dataset
zipF<- file.path(path, f)
outDir <- file.path(getwd(),"c3/Practical/data")
unzip(zipF,exdir=outDir)


# import all the dataset into variables.
# do some loggiing to understand the data
dtSubjectTrain <- fread(file.path(path, "UCI HAR Dataset/train", "subject_train.txt"))
dtSubjectTest  <- fread(file.path(path, "UCI HAR Dataset/test" , "subject_test.txt" ))

# not how this data fits together
# checking col widhts and lengths to get some idea
# looking for common dimensions
summary(dtSubjectTest)
summary(dtSubjectTrain)
length(dtSubjectTest$V1)
length(dtSubjectTrain$V1)


dtActivityYTrain <- fread(file.path(path, "UCI HAR Dataset/train", "y_train.txt"))
dtActivityYTest  <- fread(file.path(path, "UCI HAR Dataset/test", "y_test.txt" ))

dtActivityXTrain <- fread(file.path(path, "UCI HAR Dataset/train", "X_train.txt"))
dtActivityXTest  <- fread(file.path(path, "UCI HAR Dataset/test", "X_test.txt" ))


# not knowing this data fits together
# checking col widhts and lengths to get some idea
# looking for common dimensions
length(names(dtActivityYTest))
length(dtActivityXTest$V1)
length(dtActivityYTrain$V1)


# the files are a mix of columns and rows

dtActivityTrain <- cbind(dtActivityYTrain, dtActivityXTrain)
dtActivityTest <- cbind(dtActivityYTest, dtActivityXTest)

# a one column data table, label the column subject
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")

# a one column data table, label the column activityLabel
dtActivity <- rbind(dtActivityTrain,dtActivityTest)
setnames(dtActivity, 1, "activityLabel")
dt <- cbind(dtSubject, dtActivity);
names(dt)
setkey(dt, subject, activityLabel)

# import file as data table
activityLabels <- fread(file.path(path, "UCI HAR Dataset", "activity_labels.txt"))

# rename the columns to something descriptive
colnames(activityLabels)[1:2] <- c("activityLabel", "activityName")


# doing same thing for feature labels
# import features file as data table
features  <- fread(file.path(path, "UCI HAR Dataset", "features.txt" ))

# give helpful column names to the feature data table
colnames(features)[1:2] <- c("featureNum", "featureName")


# regex to pulls out names with mean or std
# the tick here is that featureNum lines up with column number of the data set
features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]
# next we append the letter V to the row number value which matches the data set column names
features$featureCode <- features[, paste0("V", featureNum)]
names(dt)


# convert the featureCode field to a Vector
select <- c(key(dt), features$featureCode)
# use the vector to select from the data set the matching columns
dt <- dt[, select, with=FALSE]
# we now have only the measurements on the mean and standard deviation
names(dt)
# using the column label activityLabel we join the Descriptive names matching the numeric values
dt <- merge(dt, activityLabels, by="activityLabel", all.x=TRUE)
setkey(dt, subject, activityLabel, activityName)

# melt transforms the table using the set keys above.
dt <- data.table(melt(dt, key(dt), variable.name="featureCode"))
# so now every value that was in a column has it's own row
# now we add the feature number and feature name using merge
dt <- merge(dt, features[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)
# the result replaces the difficult to read Vnum which was the original value of the column heading
# with a more readable name and reference number

# addes new column with factors from the given column
dt$activity <- factor(dt$activityName)
dt$feature <- factor(dt$featureName)

# define function to apply regex search
grepthis <- function (regex) {
  grepl(regex, dt$feature)
}
# Clean up the data one step further by group the features by common properties
n <- 2
y <- matrix(seq(1, n), nrow=n)
# go through all the feature names if it starts with the let t label as time
# if it starts with letter f, label as Freq
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol=nrow(y))
dt$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))

# label the Instrument type as either Accelerometer or Gyroscope by matching
# Acc or Gryo any place in the feature name
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol=nrow(y))
dt$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))

# label Acceleartion by either Body/Gravity using the pattern passed into grepthis
x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol=nrow(y))
dt$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))

# label mean() / std() as Mean or SD
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol=nrow(y))
dt$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))

# label feature names containing Jerk as either NA or Jerk
dt$featJerk <- factor(grepthis("Jerk"), labels=c(NA, "Jerk"))

# label features with Mag in name as Magnitude
dt$featMagnitude <- factor(grepthis("Mag"), labels=c(NA, "Magnitude"))

n <- 3
y <- matrix(seq(1, n), nrow=n)
# using the matrix y create a vector of the grep results
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol=nrow(y))
# with the grep result matix us this to label the feature as either X,Y or Z
dt$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

# lets make sure that we didn't miss any features.
# count the number of unique feature names in the features colunm
r1 <- nrow(dt[, .N, by=c("feature")])
# count the number of unqiue feature names we just created in the new columns
r2 <- nrow(dt[, .N, by=c("featDomain", "featAcceleration", "featInstrument", "featJerk", "featMagnitude", "featVariable", "featAxis")])
r1 == r2
# they are equal so we feel good

# now set a key for the data table on each of the new columns that have awesome new names
setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)

# then use the key list to make a new table that has the average and total number or rows (count)
dtTidy <- dt[, list(count = .N, average = mean(value)), by=key(dt)]
# the result is a table with a tidy data set?


knit("makeCodebook.Rmd", output="codebook.md", encoding="ISO8859-1", quiet=TRUE)
markdownToHTML("codebook.md", "codebook.html")


