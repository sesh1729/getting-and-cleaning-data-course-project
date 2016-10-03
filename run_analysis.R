#Course Project for Getting and Cleaning Data

library(dplyr,reshape2)

#Define a file name
filename<-"UCI_HAR_DATASET.zip"

#Check if the file already exists, and download if it doesn't exist already
if(!file.exists(filename)){
    download.file(destfile = filename,method='curl',url='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')
}

#Check if the directory exists, and unzip the file if the directory doesn't exist already
if(!file.exists("UCI HAR Dataset")){
    unzip(filename)
}

#Read the features and activity labels files
features<-read.delim2(file='./UCI HAR Dataset/features.txt',sep = " ",header=FALSE)
activity_labels <- read.delim2(file='./UCI HAR Dataset/activity_labels.txt',sep = " ",header=FALSE)

#Load Train Dataset
subject_train <- read.delim2(file='./UCI HAR Dataset/train/subject_train.txt',header = FALSE,sep="")
X_train <- read.delim2(file='./UCI HAR Dataset/train/X_train.txt',header = FALSE,sep="")
Y_train <- read.delim2(file='./UCI HAR Dataset/train/Y_train.txt',header = FALSE,sep="")
train_data<-cbind(subject_train,Y_train,X_train)

#Delete temperory objects that are not being used to free up memory
rm(subject_train,X_train, Y_train)
names(train_data)<-c("Subject","ActivityLabel",as.character(features[,2]))
    
#Load Test Dataset
subject_test <- read.delim2(file='./UCI HAR Dataset/test/subject_test.txt',header = FALSE, sep="")
X_test <- read.delim2(file='./UCI HAR Dataset/test/X_test.txt',header = FALSE, sep="")
Y_test <- read.delim2(file='./UCI HAR Dataset/test/Y_test.txt',header = FALSE, sep="")
test_data<-cbind(subject_test,Y_test,X_test)

#Delete temperory objects that are not being used to free up memory
rm(subject_test,X_test,Y_test)
names(test_data)<-c("Subject","ActivityLabel",as.character(features[,2]))

#1: Merge the training and the test sets to create one data set.
all_data <-rbind(train_data,test_data)
rm("train_data","test_data")

#2: Extract only the measurements on the mean and standard deviation for each measurement.
selected_data <-all_data[,c("Subject","ActivityLabel",as.character(features[grep('(mean\\(\\)|std\\(\\))',features[,2]),2]))]
rm(all_data)

#3: Assign descriptive activity names to name the activities in the data set

#Assign proper column names to Activity Labels data
names(activity_labels)<-c("ActivityLabel","ActivityName")
selected_data<-merge(selected_data,activity_labels,sort=FALSE)
#Remove the activity label column to avoid redundant information
selected_data$ActivityLabel<-NULL


#4: Appropriately label the data set with descriptive variable names.
# Replacing -mean() and -mean()- with Mean
names(selected_data)<-gsub('-mean\\(\\)-*','Mean',names(selected_data))
# Replacing -std() and -std()- with Std
names(selected_data)<-gsub('-std\\(\\)-*','Std',names(selected_data))
# Replacing "Mag" with "Magnitude"
names(selected_data)<-gsub('Mag','Magnitude',names(selected_data))

#5: Create a second, independent tidy data set with the average of each variable for each activity and each subject.

# change the Subject ID to Factors
selected_data$Subject<-as.factor(selected_data$Subject)

#melt and re-cast the table
selected_data_melted<-melt(selected_data,id=c("Subject","ActivityName"))
selected_data_melted$value<-as.numeric(selected_data_melted$value)
selected_data_mean<-dcast(selected_data_melted, Subject + ActivityName ~ variable, mean)

#write the clean data
write.table(selected_data_mean, "tidy_HAR_data_means.txt", row.names = FALSE, quote = FALSE)
