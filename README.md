Course Project for Getting and Cleaning Data
============================================

This repository contains a script called "run_analysis.R" which does the following:

1. Downloads the zip file containing the UCI HAR Data, after checking that the the file doesn't exist already.
2. Unizips the zip file
3. Reads the information such as features, and activity_labels, files related to train dataset, and files related to test dataset.
4. Concatenates the training and test data into one dataframe using "rbind"
5. Extracts the measurements on the mean and standard deviation for each measurement.
6. Upated the activity names, based on the information in the activity_labels.txt file.
7. Cleans up the Column names in the dataset, to make them more descriptive. 
8. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
9. Exports the results to a file called "tidy_HAR_data_means.txt", which is also included in this repository

