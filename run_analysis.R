
#Load dplyr 
library(dplyr)
library(data.table)

#Create dataframes for each file to merge
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

#combine X train & x test data 
X <- rbind(x_train, x_test)

#combine y train & xy test data 
Y <- rbind(y_train, y_test)

#combine subject data 
Subject <- rbind(subject_train, subject_test)
MergeData <- cbind(Subject, Y, X)

#Extract only the measurements on the mean and standard deviation
Mean_Std.Extract <- MergeData %>% select(subject, code, contains("mean"), contains("std"))
Mean_Std.Extract$code <- activities[Mean_Std.Extract$code, 2]

#rename variables to proper name to follow tidy guidelines -- Note: not sure if Angle and 
#Gravity need to be capitalized 
names(Mean_Std.Extract)[2] = "activity"
names(Mean_Std.Extract)<-gsub("Acc", "Accelerometer", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("Gyro", "Gyroscope", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("BodyBody", "Body", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("Mag", "Magnitude", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("angle", "Angle", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("gravity", "Gravity", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("^t", "Time", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("^f", "Frequency", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("tBody", "TimeBody", names(Mean_Std.Extract))
names(Mean_Std.Extract)<-gsub("-mean()", "Mean", names(Mean_Std.Extract), ignore.case = TRUE)
names(Mean_Std.Extract)<-gsub("-std()", "STD", names(Mean_Std.Extract), ignore.case = TRUE)
names(Mean_Std.Extract)<-gsub("-freq()", "Frequency", names(Mean_Std.Extract), ignore.case = TRUE)



#From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject.
TidyData <- Mean_Std.Extract %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(TidyData, "TidyData.txt", row.name=FALSE)
