---
title: "Run Analysis"
output: github_document
---



# Overview of Code
#### notice code comments provide additional information.

## To begin
Download the files and create a folder in the current directory call data if it does not exist


```r
#download data set
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path <- file.path(getwd(),"data")
dPath <- file.path(getwd(),"")
f <- file.path("Dataset.zip")
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, f))

# unzip the dataset
zipF<- file.path(path, f)
outDir <- file.path(getwd(),"data")
unzip(zipF,exdir=outDir)
```

## Load all the files just downloaded

For all the required files, import them into your environment as data tables.  You can think of these files as a set of rows and columns that all need to be combined.  Use the readme included in the downloaded files to learn more about what the data contains.


```r
# import all the dataset into variables.
# do some loggiing to understand the data
dtSubjectTrain <- fread(file.path(path, "UCI HAR Dataset/train", "subject_train.txt"))
dtSubjectTest  <- fread(file.path(path, "UCI HAR Dataset/test" , "subject_test.txt" ))

# not knowing how this data fits together
# checking col widhts and lengths to get some idea
# looking for common dimensions

length(dtSubjectTest$V1)
```

```
## [1] 2947
```

```r
length(dtSubjectTrain$V1)
```

```
## [1] 7352
```

```r
dtActivityYTrain <- fread(file.path(path, "UCI HAR Dataset/train", "y_train.txt"))
dtActivityYTest  <- fread(file.path(path, "UCI HAR Dataset/test", "y_test.txt" ))

dtActivityXTrain <- fread(file.path(path, "UCI HAR Dataset/train", "X_train.txt"))
dtActivityXTest  <- fread(file.path(path, "UCI HAR Dataset/test", "X_test.txt" ))


# not knowing this data fits together
# checking col widhts and lengths to get some idea
# looking for common dimensions
length(names(dtActivityYTest))
```

```
## [1] 1
```

```r
length(dtActivityXTest$V1)
```

```
## [1] 2947
```

```r
length(dtActivityYTrain$V1)
```

```
## [1] 7352
```

## Load all the files just downloaded

I visualize this as a gaint excel spreadsheet.  In that sense you can think of pasting the data from the files into the cells. The order doesn't really matter so long as you end up the following results.

subjectTrain | activityTrain | Ytrain | Xtrain
subjectTest  | activityTest | Ytest  | Xtest

These names represent the content of files as one data table.  These representative names make more sense if you look closely at the file names in the downloaded data set.

The feature row number in the features.txt files corespond to the columns found in the X data files.
The labels files numerically matches to the values in the activity column


```r
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
```

## merge in the feature and activity labels so that we can begin the tidy data process.

As described above we are relating the values in the feature and activity_labels file and inserting the text value names.  This way we can read more easily what the value is.  Another key step in this process is the melt command that transforms the data set so that every value that was in a column has it's own row.


```r
# regex to pulls out names with mean or std
# the tick here is that featureNum lines up with column number of the data set
features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]
# next we append the letter V to the row number value which matches the data set column names
features$featureCode <- features[, paste0("V", featureNum)]
summary(dt)
```

```
##     subject      activityLabel         V1                V2          
##  Min.   : 1.00   Min.   :1.000   Min.   :-1.0000   Min.   :-1.00000  
##        V3                 V4                V5                 V6         
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000  
##        V7                V8                V9               V10          
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000  
##       V11                V12               V13               V14         
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V15               V16               V17               V18         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V19               V20               V21               V22         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V23                V24               V25               V26         
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V27                V28                V29          
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V30                V31                V32          
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V33                V34                V35           
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.000000  
##       V36                V37                V38          
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V39                 V40               V41         
##  Min.   :-1.000000   Min.   :-1.0000   Min.   :-1.0000  
##       V42                 V43                V44         
##  Min.   :-1.000000   Min.   :-1.00000   Min.   :-1.0000  
##       V45               V46               V47               V48         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V49               V50               V51                V52          
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V53               V54                V55          
##  Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V56                V57               V58               V59         
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V60               V61               V62               V63         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V64               V65               V66               V67         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V68               V69               V70               V71         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V72               V73               V74               V75         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V76               V77               V78               V79         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V80                V81                V82           
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.000000  
##       V83                 V84               V85               V86         
##  Min.   :-1.000000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V87               V88               V89               V90         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V91               V92               V93               V94         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V95               V96               V97               V98         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V99               V100              V101              V102        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V103               V104               V105              V106        
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##       V107               V108               V109          
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.000000  
##       V110               V111               V112         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V113              V114               V115         
##  Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V116                V117               V118         
##  Min.   :-1.000000   Min.   :-1.00000   Min.   :-1.00000  
##       V119                V120               V121         
##  Min.   :-1.000000   Min.   :-1.00000   Min.   :-1.00000  
##       V122               V123               V124              V125        
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##       V126              V127              V128              V129        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V130              V131              V132              V133        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V134              V135              V136              V137        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V138              V139              V140              V141        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V142              V143              V144               V145         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V146               V147               V148         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V149               V150               V151         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V152               V153                 V154        
##  Min.   :-1.00000   Min.   :-1.0000000   Min.   :-1.0000  
##       V155               V156                V157         
##  Min.   :-1.00000   Min.   :-1.000000   Min.   :-1.00000  
##       V158               V159                V160         
##  Min.   :-1.00000   Min.   :-1.000000   Min.   :-1.00000  
##       V161               V162               V163         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V164              V165              V166              V167        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V168              V169              V170              V171        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V172              V173              V174              V175        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V176              V177              V178              V179        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V180              V181              V182              V183         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000  
##       V184                V185               V186         
##  Min.   :-1.000000   Min.   :-1.00000   Min.   :-1.00000  
##       V187               V188               V189         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V190               V191               V192         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V193               V194               V195         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V196               V197               V198         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V199               V200               V201              V202        
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##       V203              V204              V205              V206        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V207              V208              V209              V210         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000  
##       V211               V212               V213         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V214              V215              V216              V217        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V218              V219              V220              V221        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V222              V223               V224         
##  Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V225               V226               V227              V228        
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##       V229              V230              V231              V232        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V233              V234              V235               V236         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V237               V238               V239         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V240              V241              V242              V243        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V244              V245              V246              V247        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V248              V249               V250         
##  Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V251               V252               V253              V254        
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##       V255              V256              V257              V258        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V259              V260              V261               V262        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000  
##       V263               V264               V265         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V266              V267              V268              V269        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V270               V271              V272              V273        
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V274              V275              V276              V277        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V278              V279              V280              V281        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V282              V283              V284              V285        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V286              V287              V288              V289        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V290              V291              V292              V293        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V294               V295                V296         
##  Min.   :-1.00000   Min.   :-1.000000   Min.   :-1.00000  
##       V297              V298              V299               V300        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000  
##       V301               V302              V303              V304        
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V305              V306              V307              V308        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V309              V310              V311              V312        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V313              V314              V315              V316        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V317              V318              V319              V320        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V321              V322              V323              V324        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V325              V326              V327              V328        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V329              V330              V331              V332        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V333              V334              V335              V336        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V337              V338              V339              V340        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V341              V342              V343              V344        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V345              V346              V347              V348        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V349              V350              V351              V352        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V353              V354              V355              V356        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V357              V358              V359              V360        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V361              V362              V363              V364        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V365              V366              V367              V368        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V369              V370              V371              V372        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V373               V374                V375         
##  Min.   :-1.00000   Min.   :-1.000000   Min.   :-1.00000  
##       V376              V377              V378              V379        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V380              V381              V382              V383        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V384              V385              V386              V387        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V388              V389              V390              V391        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V392              V393              V394              V395        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V396              V397              V398              V399        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V400              V401              V402              V403        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V404              V405              V406              V407        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V408              V409              V410              V411        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V412              V413              V414              V415        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V416              V417              V418              V419        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V420              V421              V422              V423        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V424              V425              V426              V427        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V428              V429              V430              V431        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V432              V433              V434              V435        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V436              V437              V438              V439        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V440              V441              V442              V443        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V444              V445              V446               V447         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##       V448              V449              V450              V451        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V452               V453               V454         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##       V455               V456              V457               V458        
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000  
##       V459                V460              V461              V462        
##  Min.   :-1.000000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V463              V464              V465              V466        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V467              V468              V469              V470        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V471              V472              V473              V474        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V475              V476              V477              V478        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V479              V480              V481              V482        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V483              V484              V485              V486        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V487              V488              V489              V490        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V491              V492              V493              V494        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V495              V496              V497              V498        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V499              V500              V501              V502        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V503              V504              V505              V506        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V507              V508              V509              V510        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V511              V512              V513               V514        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000  
##       V515              V516              V517              V518        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V519              V520              V521              V522        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V523              V524              V525              V526          
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.000000  
##       V527               V528              V529              V530        
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V531              V532              V533              V534        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V535              V536              V537               V538        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000  
##       V539               V540               V541              V542        
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##       V543              V544              V545              V546        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V547              V548              V549              V550        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##       V551              V552               V553              V554        
##  Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##       V555                V556                V557         
##  Min.   :-1.000000   Min.   :-1.000000   Min.   :-1.00000  
##       V558                V559              V560          
##  Min.   :-1.000000   Min.   :-1.0000   Min.   :-1.000000  
##       V561          
##  Min.   :-1.000000  
##  [ reached getOption("max.print") -- omitted 5 rows ]
```

```r
# convert the featureCode field to a Vector
select <- c(key(dt), features$featureCode)
# use the vector to select from the data set the matching columns
dt <- dt[, select, with=FALSE]
# we now have only the measurements on the mean and standard deviation
summary(dt)
```

```
##     subject      activityLabel         V1                V2          
##  Min.   : 1.00   Min.   :1.000   Min.   :-1.0000   Min.   :-1.00000  
##  1st Qu.: 9.00   1st Qu.:2.000   1st Qu.: 0.2626   1st Qu.:-0.02490  
##  Median :17.00   Median :4.000   Median : 0.2772   Median :-0.01716  
##  Mean   :16.15   Mean   :3.625   Mean   : 0.2743   Mean   :-0.01774  
##  3rd Qu.:24.00   3rd Qu.:5.000   3rd Qu.: 0.2884   3rd Qu.:-0.01062  
##  Max.   :30.00   Max.   :6.000   Max.   : 1.0000   Max.   : 1.00000  
##        V3                 V4                V5                 V6         
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000  
##  1st Qu.:-0.12102   1st Qu.:-0.9924   1st Qu.:-0.97699   1st Qu.:-0.9791  
##  Median :-0.10860   Median :-0.9430   Median :-0.83503   Median :-0.8508  
##  Mean   :-0.10892   Mean   :-0.6078   Mean   :-0.51019   Mean   :-0.6131  
##  3rd Qu.:-0.09759   3rd Qu.:-0.2503   3rd Qu.:-0.05734   3rd Qu.:-0.2787  
##  Max.   : 1.00000   Max.   : 1.0000   Max.   : 1.00000   Max.   : 1.0000  
##       V41               V42                 V43          
##  Min.   :-1.0000   Min.   :-1.000000   Min.   :-1.00000  
##  1st Qu.: 0.8117   1st Qu.:-0.242943   1st Qu.:-0.11671  
##  Median : 0.9218   Median :-0.143551   Median : 0.03680  
##  Mean   : 0.6692   Mean   : 0.004039   Mean   : 0.09215  
##  3rd Qu.: 0.9547   3rd Qu.: 0.118905   3rd Qu.: 0.21621  
##  Max.   : 1.0000   Max.   : 1.000000   Max.   : 1.00000  
##       V44               V45               V46               V81          
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000  
##  1st Qu.:-0.9949   1st Qu.:-0.9913   1st Qu.:-0.9866   1st Qu.: 0.06298  
##  Median :-0.9819   Median :-0.9759   Median :-0.9665   Median : 0.07597  
##  Mean   :-0.9652   Mean   :-0.9544   Mean   :-0.9389   Mean   : 0.07894  
##  3rd Qu.:-0.9615   3rd Qu.:-0.9464   3rd Qu.:-0.9296   3rd Qu.: 0.09131  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.00000  
##       V82                 V83                 V84         
##  Min.   :-1.000000   Min.   :-1.000000   Min.   :-1.0000  
##  1st Qu.:-0.018555   1st Qu.:-0.031552   1st Qu.:-0.9913  
##  Median : 0.010753   Median :-0.001159   Median :-0.9513  
##  Mean   : 0.007948   Mean   :-0.004675   Mean   :-0.6398  
##  3rd Qu.: 0.033538   3rd Qu.: 0.024578   3rd Qu.:-0.2912  
##  Max.   : 1.000000   Max.   : 1.000000   Max.   : 1.0000  
##       V85               V86               V121               V122         
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.00000  
##  1st Qu.:-0.9850   1st Qu.:-0.9892   1st Qu.:-0.04579   1st Qu.:-0.10399  
##  Median :-0.9250   Median :-0.9543   Median :-0.02776   Median :-0.07477  
##  Mean   :-0.6080   Mean   :-0.7628   Mean   :-0.03098   Mean   :-0.07472  
##  3rd Qu.:-0.2218   3rd Qu.:-0.5485   3rd Qu.:-0.01058   3rd Qu.:-0.05110  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.00000   Max.   : 1.00000  
##       V123               V124              V125              V126        
##  Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.: 0.06485   1st Qu.:-0.9872   1st Qu.:-0.9819   1st Qu.:-0.9850  
##  Median : 0.08626   Median :-0.9016   Median :-0.9106   Median :-0.8819  
##  Mean   : 0.08836   Mean   :-0.7212   Mean   :-0.6827   Mean   :-0.6537  
##  3rd Qu.: 0.11044   3rd Qu.:-0.4822   3rd Qu.:-0.4461   3rd Qu.:-0.3379  
##  Max.   : 1.00000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V161               V162               V163         
##  Min.   :-1.00000   Min.   :-1.00000   Min.   :-1.00000  
##  1st Qu.:-0.11723   1st Qu.:-0.05868   1st Qu.:-0.07936  
##  Median :-0.09824   Median :-0.04056   Median :-0.05455  
##  Mean   :-0.09671   Mean   :-0.04232   Mean   :-0.05483  
##  3rd Qu.:-0.07930   3rd Qu.:-0.02521   3rd Qu.:-0.03168  
##  Max.   : 1.00000   Max.   : 1.00000   Max.   : 1.00000  
##       V164              V165              V166              V201        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9907   1st Qu.:-0.9922   1st Qu.:-0.9926   1st Qu.:-0.9819  
##  Median :-0.9348   Median :-0.9548   Median :-0.9503   Median :-0.8746  
##  Mean   :-0.7313   Mean   :-0.7861   Mean   :-0.7399   Mean   :-0.5482  
##  3rd Qu.:-0.4865   3rd Qu.:-0.6268   3rd Qu.:-0.5097   3rd Qu.:-0.1201  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V202              V214              V215              V227        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9822   1st Qu.:-0.9819   1st Qu.:-0.9822   1st Qu.:-0.9896  
##  Median :-0.8437   Median :-0.8746   Median :-0.8437   Median :-0.9481  
##  Mean   :-0.5912   Mean   :-0.5482   Mean   :-0.5912   Mean   :-0.6494  
##  3rd Qu.:-0.2423   3rd Qu.:-0.1201   3rd Qu.:-0.2423   3rd Qu.:-0.2956  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V228              V240              V241              V253        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9907   1st Qu.:-0.9781   1st Qu.:-0.9775   1st Qu.:-0.9923  
##  Median :-0.9288   Median :-0.8223   Median :-0.8259   Median :-0.9559  
##  Mean   :-0.6278   Mean   :-0.6052   Mean   :-0.6625   Mean   :-0.7621  
##  3rd Qu.:-0.2733   3rd Qu.:-0.2454   3rd Qu.:-0.3940   3rd Qu.:-0.5499  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V254              V266              V267              V268        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9922   1st Qu.:-0.9913   1st Qu.:-0.9792   1st Qu.:-0.9832  
##  Median :-0.9403   Median :-0.9456   Median :-0.8643   Median :-0.8954  
##  Mean   :-0.7780   Mean   :-0.6228   Mean   :-0.5375   Mean   :-0.6650  
##  3rd Qu.:-0.6093   3rd Qu.:-0.2646   3rd Qu.:-0.1032   3rd Qu.:-0.3662  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V269              V270               V271              V345        
##  Min.   :-1.0000   Min.   :-1.00000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9929   1st Qu.:-0.97689   1st Qu.:-0.9780   1st Qu.:-0.9912  
##  Median :-0.9416   Median :-0.83261   Median :-0.8398   Median :-0.9516  
##  Mean   :-0.6034   Mean   :-0.52842   Mean   :-0.6179   Mean   :-0.6567  
##  3rd Qu.:-0.2493   3rd Qu.:-0.09216   3rd Qu.:-0.3023   3rd Qu.:-0.3270  
##  Max.   : 1.0000   Max.   : 1.00000   Max.   : 1.0000   Max.   : 1.0000  
##       V346              V347              V348              V349        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9848   1st Qu.:-0.9873   1st Qu.:-0.9920   1st Qu.:-0.9865  
##  Median :-0.9257   Median :-0.9475   Median :-0.9562   Median :-0.9280  
##  Mean   :-0.6290   Mean   :-0.7436   Mean   :-0.6550   Mean   :-0.6122  
##  3rd Qu.:-0.2638   3rd Qu.:-0.5133   3rd Qu.:-0.3203   3rd Qu.:-0.2361  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V350              V424              V425              V426        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9895   1st Qu.:-0.9853   1st Qu.:-0.9847   1st Qu.:-0.9851  
##  Median :-0.9590   Median :-0.8917   Median :-0.9197   Median :-0.8877  
##  Mean   :-0.7809   Mean   :-0.6721   Mean   :-0.7062   Mean   :-0.6442  
##  3rd Qu.:-0.5903   3rd Qu.:-0.3837   3rd Qu.:-0.4735   3rd Qu.:-0.3225  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V427              V428              V429              V503        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9881   1st Qu.:-0.9808   1st Qu.:-0.9862   1st Qu.:-0.9847  
##  Median :-0.9053   Median :-0.9061   Median :-0.8915   Median :-0.8755  
##  Mean   :-0.7386   Mean   :-0.6742   Mean   :-0.6904   Mean   :-0.5860  
##  3rd Qu.:-0.5225   3rd Qu.:-0.4385   3rd Qu.:-0.4168   3rd Qu.:-0.2173  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V504              V516              V517              V529        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9829   1st Qu.:-0.9898   1st Qu.:-0.9907   1st Qu.:-0.9825  
##  Median :-0.8547   Median :-0.9290   Median :-0.9255   Median :-0.8756  
##  Mean   :-0.6595   Mean   :-0.6208   Mean   :-0.6401   Mean   :-0.6974  
##  3rd Qu.:-0.3823   3rd Qu.:-0.2600   3rd Qu.:-0.3082   3rd Qu.:-0.4514  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000  
##       V530              V542              V543        
##  Min.   :-1.0000   Min.   :-1.0000   Min.   :-1.0000  
##  1st Qu.:-0.9781   1st Qu.:-0.9921   1st Qu.:-0.9926  
##  Median :-0.8275   Median :-0.9453   Median :-0.9382  
##  Mean   :-0.7000   Mean   :-0.7798   Mean   :-0.7922  
##  3rd Qu.:-0.4713   3rd Qu.:-0.6122   3rd Qu.:-0.6437  
##  Max.   : 1.0000   Max.   : 1.0000   Max.   : 1.0000
```

```r
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
```

## This next step in a more involved process of cleaning up the names.

There are 66 unique feature names, however, they are long and encoded with various meaning that is hard to read or understand.  Using Regex we go through and caterogize them further by adding new columns tht decode the meanings of the names in feature column.


```r
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
```

```
## [1] TRUE
```

```r
# they are equal so we feel good
```

## Create final tidy data set

Finally we select out the data values using the new labels and preform count and aveage operations.


```r
# now set a key for the data table on each of the new columns that have awesome new names
setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)

# then use the key list to make a new table that has the average and total number or rows (count)
Tidy <- dt[, list(count = .N, average = mean(value)), by=key(dt)]
# the result is a table with a tidy data set?
summary(Tidy)
```

```
##     subject                   activity    featDomain  featAcceleration
##  Min.   : 1.0   LAYING            :1980   Time:7200   NA     :4680    
##  1st Qu.: 8.0   SITTING           :1980   Freq:4680   Body   :5760    
##  Median :15.5   STANDING          :1980               Gravity:1440    
##  Mean   :15.5   WALKING           :1980                               
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                               
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                               
##        featInstrument featJerk      featMagnitude  featVariable featAxis 
##  Accelerometer:7200   NA  :7200   NA       :8640   Mean:5940    NA:3240  
##  Gyroscope    :4680   Jerk:4680   Magnitude:3240   SD  :5940    X :2880  
##                                                                 Y :2880  
##                                                                 Z :2880  
##                                                                          
##                                                                          
##      count          average        
##  Min.   :36.00   Min.   :-0.99767  
##  1st Qu.:49.00   1st Qu.:-0.96205  
##  Median :54.50   Median :-0.46989  
##  Mean   :57.22   Mean   :-0.48436  
##  3rd Qu.:63.25   3rd Qu.:-0.07836  
##  Max.   :95.00   Max.   : 0.97451
```

```r
# write the tidy data set to a file
write.table(dtTidy, 'tidy.txt', quote=FALSE, sep="\t", row.names=FALSE)
```
