setwd("D:\\coursea\\getting_cleansing_data\\course_project\\UCI_HAR_Dataset")

# Source of data for this project: 
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# This R script does the following:

# 1. Merges the training and the test sets to create one data set.

tmp1 <- read.table("train\\X_train.txt")
tmp2 <- read.table("test\\X_test.txt")
xx <- rbind(tmp1, tmp2)



tmp1y<- read.table("train\\subject_train.txt")
tmp2y <- read.table("test\\subject_test.txt")
ss <- rbind(tmp1y, tmp2y)

tmp1x <- read.table("train\\y_train.txt")
tmp2x <- read.table("test\\y_test.txt")
yy <- rbind(tmp1x, tmp2x)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
idx_of_gd_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
xx <- xx[, idx_of_gd_features]
names(xx) <- features[idx_of_gd_features, 2]
names(xx) <- gsub("\\(|\\)", "", names(xx))
names(xx) <- tolower(names(xx))

# 3. Uses descriptive activity names to name the activities in the data set.

activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
yy[,1] = activities[Y[,1], 2]
names(yy) <- "activity"

# 4. Appropriately labels the data set with descriptive activity names.

names(ss) <- "subject"
clean <- cbind(ss, yy, xx)
write.table(clean, "merged_clean.txt")

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

uniqueSubj = unique(ss)[,1]
nSubj = length(unique(ss)[,1])
nActi = length(activities[,1])
numCols = dim(clean)[2]
result = clean[1:(nSubj*nActi), ]

row = 1
for (s in 1:nSubj) {
  for (a in 1:nActi) {
    result[row, 1] = uniqueSubj[s]
    result[row, 2] = activities[a, 2]
    tmp <- clean[clean$subject==s & clean$activity==activities[a, 2], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}
write.table(result, "data_with_avg.txt")
th_avg.txt")
