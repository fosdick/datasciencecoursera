---
title: "Run Analysis"
output: github_document
---



## To begin
This script assumes you are in a working directory and the directory path c3/Practical already exists.  The script will create the data folder.


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

# not how this data fits together
# checking col widhts and lengths to get some idea
# looking for common dimensions
summary(dtSubjectTest)
```

```
##        V1       
##  Min.   : 2.00  
##  1st Qu.: 9.00  
##  Median :12.00  
##  Mean   :12.99  
##  3rd Qu.:18.00  
##  Max.   :24.00
```

```r
summary(dtSubjectTrain)
```

```
##        V1       
##  Min.   : 1.00  
##  1st Qu.: 8.00  
##  Median :19.00  
##  Mean   :17.41  
##  3rd Qu.:26.00  
##  Max.   :30.00
```

```r
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
names(dt)
```

```
##   [1] "subject"       "activityLabel" "V1"            "V2"           
##   [5] "V3"            "V4"            "V5"            "V6"           
##   [9] "V7"            "V8"            "V9"            "V10"          
##  [13] "V11"           "V12"           "V13"           "V14"          
##  [17] "V15"           "V16"           "V17"           "V18"          
##  [21] "V19"           "V20"           "V21"           "V22"          
##  [25] "V23"           "V24"           "V25"           "V26"          
##  [29] "V27"           "V28"           "V29"           "V30"          
##  [33] "V31"           "V32"           "V33"           "V34"          
##  [37] "V35"           "V36"           "V37"           "V38"          
##  [41] "V39"           "V40"           "V41"           "V42"          
##  [45] "V43"           "V44"           "V45"           "V46"          
##  [49] "V47"           "V48"           "V49"           "V50"          
##  [53] "V51"           "V52"           "V53"           "V54"          
##  [57] "V55"           "V56"           "V57"           "V58"          
##  [61] "V59"           "V60"           "V61"           "V62"          
##  [65] "V63"           "V64"           "V65"           "V66"          
##  [69] "V67"           "V68"           "V69"           "V70"          
##  [73] "V71"           "V72"           "V73"           "V74"          
##  [77] "V75"           "V76"           "V77"           "V78"          
##  [81] "V79"           "V80"           "V81"           "V82"          
##  [85] "V83"           "V84"           "V85"           "V86"          
##  [89] "V87"           "V88"           "V89"           "V90"          
##  [93] "V91"           "V92"           "V93"           "V94"          
##  [97] "V95"           "V96"           "V97"           "V98"          
## [101] "V99"           "V100"          "V101"          "V102"         
## [105] "V103"          "V104"          "V105"          "V106"         
## [109] "V107"          "V108"          "V109"          "V110"         
## [113] "V111"          "V112"          "V113"          "V114"         
## [117] "V115"          "V116"          "V117"          "V118"         
## [121] "V119"          "V120"          "V121"          "V122"         
## [125] "V123"          "V124"          "V125"          "V126"         
## [129] "V127"          "V128"          "V129"          "V130"         
## [133] "V131"          "V132"          "V133"          "V134"         
## [137] "V135"          "V136"          "V137"          "V138"         
## [141] "V139"          "V140"          "V141"          "V142"         
## [145] "V143"          "V144"          "V145"          "V146"         
## [149] "V147"          "V148"          "V149"          "V150"         
## [153] "V151"          "V152"          "V153"          "V154"         
## [157] "V155"          "V156"          "V157"          "V158"         
## [161] "V159"          "V160"          "V161"          "V162"         
## [165] "V163"          "V164"          "V165"          "V166"         
## [169] "V167"          "V168"          "V169"          "V170"         
## [173] "V171"          "V172"          "V173"          "V174"         
## [177] "V175"          "V176"          "V177"          "V178"         
## [181] "V179"          "V180"          "V181"          "V182"         
## [185] "V183"          "V184"          "V185"          "V186"         
## [189] "V187"          "V188"          "V189"          "V190"         
## [193] "V191"          "V192"          "V193"          "V194"         
## [197] "V195"          "V196"          "V197"          "V198"         
## [201] "V199"          "V200"          "V201"          "V202"         
## [205] "V203"          "V204"          "V205"          "V206"         
## [209] "V207"          "V208"          "V209"          "V210"         
## [213] "V211"          "V212"          "V213"          "V214"         
## [217] "V215"          "V216"          "V217"          "V218"         
## [221] "V219"          "V220"          "V221"          "V222"         
## [225] "V223"          "V224"          "V225"          "V226"         
## [229] "V227"          "V228"          "V229"          "V230"         
## [233] "V231"          "V232"          "V233"          "V234"         
## [237] "V235"          "V236"          "V237"          "V238"         
## [241] "V239"          "V240"          "V241"          "V242"         
## [245] "V243"          "V244"          "V245"          "V246"         
## [249] "V247"          "V248"          "V249"          "V250"         
## [253] "V251"          "V252"          "V253"          "V254"         
## [257] "V255"          "V256"          "V257"          "V258"         
## [261] "V259"          "V260"          "V261"          "V262"         
## [265] "V263"          "V264"          "V265"          "V266"         
## [269] "V267"          "V268"          "V269"          "V270"         
## [273] "V271"          "V272"          "V273"          "V274"         
## [277] "V275"          "V276"          "V277"          "V278"         
## [281] "V279"          "V280"          "V281"          "V282"         
## [285] "V283"          "V284"          "V285"          "V286"         
## [289] "V287"          "V288"          "V289"          "V290"         
## [293] "V291"          "V292"          "V293"          "V294"         
## [297] "V295"          "V296"          "V297"          "V298"         
## [301] "V299"          "V300"          "V301"          "V302"         
## [305] "V303"          "V304"          "V305"          "V306"         
## [309] "V307"          "V308"          "V309"          "V310"         
## [313] "V311"          "V312"          "V313"          "V314"         
## [317] "V315"          "V316"          "V317"          "V318"         
## [321] "V319"          "V320"          "V321"          "V322"         
## [325] "V323"          "V324"          "V325"          "V326"         
## [329] "V327"          "V328"          "V329"          "V330"         
## [333] "V331"          "V332"          "V333"          "V334"         
## [337] "V335"          "V336"          "V337"          "V338"         
## [341] "V339"          "V340"          "V341"          "V342"         
## [345] "V343"          "V344"          "V345"          "V346"         
## [349] "V347"          "V348"          "V349"          "V350"         
## [353] "V351"          "V352"          "V353"          "V354"         
## [357] "V355"          "V356"          "V357"          "V358"         
## [361] "V359"          "V360"          "V361"          "V362"         
## [365] "V363"          "V364"          "V365"          "V366"         
## [369] "V367"          "V368"          "V369"          "V370"         
## [373] "V371"          "V372"          "V373"          "V374"         
## [377] "V375"          "V376"          "V377"          "V378"         
## [381] "V379"          "V380"          "V381"          "V382"         
## [385] "V383"          "V384"          "V385"          "V386"         
## [389] "V387"          "V388"          "V389"          "V390"         
## [393] "V391"          "V392"          "V393"          "V394"         
## [397] "V395"          "V396"          "V397"          "V398"         
## [401] "V399"          "V400"          "V401"          "V402"         
## [405] "V403"          "V404"          "V405"          "V406"         
## [409] "V407"          "V408"          "V409"          "V410"         
## [413] "V411"          "V412"          "V413"          "V414"         
## [417] "V415"          "V416"          "V417"          "V418"         
## [421] "V419"          "V420"          "V421"          "V422"         
## [425] "V423"          "V424"          "V425"          "V426"         
## [429] "V427"          "V428"          "V429"          "V430"         
## [433] "V431"          "V432"          "V433"          "V434"         
## [437] "V435"          "V436"          "V437"          "V438"         
## [441] "V439"          "V440"          "V441"          "V442"         
## [445] "V443"          "V444"          "V445"          "V446"         
## [449] "V447"          "V448"          "V449"          "V450"         
## [453] "V451"          "V452"          "V453"          "V454"         
## [457] "V455"          "V456"          "V457"          "V458"         
## [461] "V459"          "V460"          "V461"          "V462"         
## [465] "V463"          "V464"          "V465"          "V466"         
## [469] "V467"          "V468"          "V469"          "V470"         
## [473] "V471"          "V472"          "V473"          "V474"         
## [477] "V475"          "V476"          "V477"          "V478"         
## [481] "V479"          "V480"          "V481"          "V482"         
## [485] "V483"          "V484"          "V485"          "V486"         
## [489] "V487"          "V488"          "V489"          "V490"         
## [493] "V491"          "V492"          "V493"          "V494"         
## [497] "V495"          "V496"          "V497"          "V498"         
## [501] "V499"          "V500"          "V501"          "V502"         
## [505] "V503"          "V504"          "V505"          "V506"         
## [509] "V507"          "V508"          "V509"          "V510"         
## [513] "V511"          "V512"          "V513"          "V514"         
## [517] "V515"          "V516"          "V517"          "V518"         
## [521] "V519"          "V520"          "V521"          "V522"         
## [525] "V523"          "V524"          "V525"          "V526"         
## [529] "V527"          "V528"          "V529"          "V530"         
## [533] "V531"          "V532"          "V533"          "V534"         
## [537] "V535"          "V536"          "V537"          "V538"         
## [541] "V539"          "V540"          "V541"          "V542"         
## [545] "V543"          "V544"          "V545"          "V546"         
## [549] "V547"          "V548"          "V549"          "V550"         
## [553] "V551"          "V552"          "V553"          "V554"         
## [557] "V555"          "V556"          "V557"          "V558"         
## [561] "V559"          "V560"          "V561"
```

```r
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

as described above we are relating the values in the feature and activity_labels file and inserting the text value names.  This way we can read more easily what the value is.  Another key step in this process is the melt command that transforms the data set so that every value that was in a column has it's own row.


```r
# regex to pulls out names with mean or std
# the tick here is that featureNum lines up with column number of the data set
features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]
# next we append the letter V to the row number value which matches the data set column names
features$featureCode <- features[, paste0("V", featureNum)]
names(dt)
```

```
##   [1] "subject"       "activityLabel" "V1"            "V2"           
##   [5] "V3"            "V4"            "V5"            "V6"           
##   [9] "V7"            "V8"            "V9"            "V10"          
##  [13] "V11"           "V12"           "V13"           "V14"          
##  [17] "V15"           "V16"           "V17"           "V18"          
##  [21] "V19"           "V20"           "V21"           "V22"          
##  [25] "V23"           "V24"           "V25"           "V26"          
##  [29] "V27"           "V28"           "V29"           "V30"          
##  [33] "V31"           "V32"           "V33"           "V34"          
##  [37] "V35"           "V36"           "V37"           "V38"          
##  [41] "V39"           "V40"           "V41"           "V42"          
##  [45] "V43"           "V44"           "V45"           "V46"          
##  [49] "V47"           "V48"           "V49"           "V50"          
##  [53] "V51"           "V52"           "V53"           "V54"          
##  [57] "V55"           "V56"           "V57"           "V58"          
##  [61] "V59"           "V60"           "V61"           "V62"          
##  [65] "V63"           "V64"           "V65"           "V66"          
##  [69] "V67"           "V68"           "V69"           "V70"          
##  [73] "V71"           "V72"           "V73"           "V74"          
##  [77] "V75"           "V76"           "V77"           "V78"          
##  [81] "V79"           "V80"           "V81"           "V82"          
##  [85] "V83"           "V84"           "V85"           "V86"          
##  [89] "V87"           "V88"           "V89"           "V90"          
##  [93] "V91"           "V92"           "V93"           "V94"          
##  [97] "V95"           "V96"           "V97"           "V98"          
## [101] "V99"           "V100"          "V101"          "V102"         
## [105] "V103"          "V104"          "V105"          "V106"         
## [109] "V107"          "V108"          "V109"          "V110"         
## [113] "V111"          "V112"          "V113"          "V114"         
## [117] "V115"          "V116"          "V117"          "V118"         
## [121] "V119"          "V120"          "V121"          "V122"         
## [125] "V123"          "V124"          "V125"          "V126"         
## [129] "V127"          "V128"          "V129"          "V130"         
## [133] "V131"          "V132"          "V133"          "V134"         
## [137] "V135"          "V136"          "V137"          "V138"         
## [141] "V139"          "V140"          "V141"          "V142"         
## [145] "V143"          "V144"          "V145"          "V146"         
## [149] "V147"          "V148"          "V149"          "V150"         
## [153] "V151"          "V152"          "V153"          "V154"         
## [157] "V155"          "V156"          "V157"          "V158"         
## [161] "V159"          "V160"          "V161"          "V162"         
## [165] "V163"          "V164"          "V165"          "V166"         
## [169] "V167"          "V168"          "V169"          "V170"         
## [173] "V171"          "V172"          "V173"          "V174"         
## [177] "V175"          "V176"          "V177"          "V178"         
## [181] "V179"          "V180"          "V181"          "V182"         
## [185] "V183"          "V184"          "V185"          "V186"         
## [189] "V187"          "V188"          "V189"          "V190"         
## [193] "V191"          "V192"          "V193"          "V194"         
## [197] "V195"          "V196"          "V197"          "V198"         
## [201] "V199"          "V200"          "V201"          "V202"         
## [205] "V203"          "V204"          "V205"          "V206"         
## [209] "V207"          "V208"          "V209"          "V210"         
## [213] "V211"          "V212"          "V213"          "V214"         
## [217] "V215"          "V216"          "V217"          "V218"         
## [221] "V219"          "V220"          "V221"          "V222"         
## [225] "V223"          "V224"          "V225"          "V226"         
## [229] "V227"          "V228"          "V229"          "V230"         
## [233] "V231"          "V232"          "V233"          "V234"         
## [237] "V235"          "V236"          "V237"          "V238"         
## [241] "V239"          "V240"          "V241"          "V242"         
## [245] "V243"          "V244"          "V245"          "V246"         
## [249] "V247"          "V248"          "V249"          "V250"         
## [253] "V251"          "V252"          "V253"          "V254"         
## [257] "V255"          "V256"          "V257"          "V258"         
## [261] "V259"          "V260"          "V261"          "V262"         
## [265] "V263"          "V264"          "V265"          "V266"         
## [269] "V267"          "V268"          "V269"          "V270"         
## [273] "V271"          "V272"          "V273"          "V274"         
## [277] "V275"          "V276"          "V277"          "V278"         
## [281] "V279"          "V280"          "V281"          "V282"         
## [285] "V283"          "V284"          "V285"          "V286"         
## [289] "V287"          "V288"          "V289"          "V290"         
## [293] "V291"          "V292"          "V293"          "V294"         
## [297] "V295"          "V296"          "V297"          "V298"         
## [301] "V299"          "V300"          "V301"          "V302"         
## [305] "V303"          "V304"          "V305"          "V306"         
## [309] "V307"          "V308"          "V309"          "V310"         
## [313] "V311"          "V312"          "V313"          "V314"         
## [317] "V315"          "V316"          "V317"          "V318"         
## [321] "V319"          "V320"          "V321"          "V322"         
## [325] "V323"          "V324"          "V325"          "V326"         
## [329] "V327"          "V328"          "V329"          "V330"         
## [333] "V331"          "V332"          "V333"          "V334"         
## [337] "V335"          "V336"          "V337"          "V338"         
## [341] "V339"          "V340"          "V341"          "V342"         
## [345] "V343"          "V344"          "V345"          "V346"         
## [349] "V347"          "V348"          "V349"          "V350"         
## [353] "V351"          "V352"          "V353"          "V354"         
## [357] "V355"          "V356"          "V357"          "V358"         
## [361] "V359"          "V360"          "V361"          "V362"         
## [365] "V363"          "V364"          "V365"          "V366"         
## [369] "V367"          "V368"          "V369"          "V370"         
## [373] "V371"          "V372"          "V373"          "V374"         
## [377] "V375"          "V376"          "V377"          "V378"         
## [381] "V379"          "V380"          "V381"          "V382"         
## [385] "V383"          "V384"          "V385"          "V386"         
## [389] "V387"          "V388"          "V389"          "V390"         
## [393] "V391"          "V392"          "V393"          "V394"         
## [397] "V395"          "V396"          "V397"          "V398"         
## [401] "V399"          "V400"          "V401"          "V402"         
## [405] "V403"          "V404"          "V405"          "V406"         
## [409] "V407"          "V408"          "V409"          "V410"         
## [413] "V411"          "V412"          "V413"          "V414"         
## [417] "V415"          "V416"          "V417"          "V418"         
## [421] "V419"          "V420"          "V421"          "V422"         
## [425] "V423"          "V424"          "V425"          "V426"         
## [429] "V427"          "V428"          "V429"          "V430"         
## [433] "V431"          "V432"          "V433"          "V434"         
## [437] "V435"          "V436"          "V437"          "V438"         
## [441] "V439"          "V440"          "V441"          "V442"         
## [445] "V443"          "V444"          "V445"          "V446"         
## [449] "V447"          "V448"          "V449"          "V450"         
## [453] "V451"          "V452"          "V453"          "V454"         
## [457] "V455"          "V456"          "V457"          "V458"         
## [461] "V459"          "V460"          "V461"          "V462"         
## [465] "V463"          "V464"          "V465"          "V466"         
## [469] "V467"          "V468"          "V469"          "V470"         
## [473] "V471"          "V472"          "V473"          "V474"         
## [477] "V475"          "V476"          "V477"          "V478"         
## [481] "V479"          "V480"          "V481"          "V482"         
## [485] "V483"          "V484"          "V485"          "V486"         
## [489] "V487"          "V488"          "V489"          "V490"         
## [493] "V491"          "V492"          "V493"          "V494"         
## [497] "V495"          "V496"          "V497"          "V498"         
## [501] "V499"          "V500"          "V501"          "V502"         
## [505] "V503"          "V504"          "V505"          "V506"         
## [509] "V507"          "V508"          "V509"          "V510"         
## [513] "V511"          "V512"          "V513"          "V514"         
## [517] "V515"          "V516"          "V517"          "V518"         
## [521] "V519"          "V520"          "V521"          "V522"         
## [525] "V523"          "V524"          "V525"          "V526"         
## [529] "V527"          "V528"          "V529"          "V530"         
## [533] "V531"          "V532"          "V533"          "V534"         
## [537] "V535"          "V536"          "V537"          "V538"         
## [541] "V539"          "V540"          "V541"          "V542"         
## [545] "V543"          "V544"          "V545"          "V546"         
## [549] "V547"          "V548"          "V549"          "V550"         
## [553] "V551"          "V552"          "V553"          "V554"         
## [557] "V555"          "V556"          "V557"          "V558"         
## [561] "V559"          "V560"          "V561"
```

```r
# convert the featureCode field to a Vector
select <- c(key(dt), features$featureCode)
# use the vector to select from the data set the matching columns
dt <- dt[, select, with=FALSE]
# we now have only the measurements on the mean and standard deviation
names(dt)
```

```
##  [1] "subject"       "activityLabel" "V1"            "V2"           
##  [5] "V3"            "V4"            "V5"            "V6"           
##  [9] "V41"           "V42"           "V43"           "V44"          
## [13] "V45"           "V46"           "V81"           "V82"          
## [17] "V83"           "V84"           "V85"           "V86"          
## [21] "V121"          "V122"          "V123"          "V124"         
## [25] "V125"          "V126"          "V161"          "V162"         
## [29] "V163"          "V164"          "V165"          "V166"         
## [33] "V201"          "V202"          "V214"          "V215"         
## [37] "V227"          "V228"          "V240"          "V241"         
## [41] "V253"          "V254"          "V266"          "V267"         
## [45] "V268"          "V269"          "V270"          "V271"         
## [49] "V345"          "V346"          "V347"          "V348"         
## [53] "V349"          "V350"          "V424"          "V425"         
## [57] "V426"          "V427"          "V428"          "V429"         
## [61] "V503"          "V504"          "V516"          "V517"         
## [65] "V529"          "V530"          "V542"          "V543"
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

# write the tidy data set to a file
write.csv(Tidy, "tidy.csv", row.names=FALSE)
```
