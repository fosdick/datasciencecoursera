# Getting and Cleaning Data

## Course Project

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps to work on this course project

1.  run the file run_analysis.R with the working directory set to the folder where it resides.  Note that this script calls a second file runAnalysisCodebook.Rmd where the actual code lives.

## Dependencies

```knit```, ```markdown``` and ```data.table```
Additionally there may be others depending on you setup.  This was written on R studio v3.4.3 with iOS 10.13.3.
If the script does not run check the error log and look for missing dependencies.