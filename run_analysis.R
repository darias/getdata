# run_analysis.R
#
#  You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#

load_data <- function() {
	# Load the subjects
	subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"")
	# Load the activities
	activities <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"")
	# Load the test data
	test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"")
	# Bind the columns
	df1 <- cbind(test, subjects, activities)

	# Load the training data
	subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"")
	# Load the activities
	activities <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"")
	# Load the test data
	test <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"")
	df2 <- cbind(test, subjects, activities)

	# Combine the two data frames
	df <- rbind(df1, df2)

	return(df)
}


get_columns <- function() {
	# Load the feature.txt file with column numbers and column names
	features <- read.table("UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE)
	# Get the mean columns
	means <- features[grep("mean", features$V2),]
	# Add appropriate column names without special characters
	means$colName <- gsub("-","_", gsub("\\(\\)", "", means$V2))
	# Get the std columns
	stds <- features[grep("std", features$V2),]
	# Add appropriate column names without special characters
	stds$colName <- gsub("-","_", gsub("\\(\\)", "", stds$V2))
	# Combine and sort mean and std columns by column number
	cols <- rbind(means, stds)
	cols <- cols[order(as.numeric(cols$V1)),]
	
	return(cols)
}


averages <- function(df) {
	# df is a data frame created by run_analysis()

	# Get the names. Use them instead of explicitly writing them into the cbind list below
	#cols <- get_columns()

	avg <- aggregate(
		cbind(
		tBodyAcc_mean_X, tBodyAcc_mean_Y,
		tBodyAcc_mean_Z, tBodyAcc_std_X,
		tBodyAcc_std_Y, tBodyAcc_std_Z,
		tGravityAcc_mean_X, tGravityAcc_mean_Y,
		tGravityAcc_mean_Z, tGravityAcc_std_X,
		tGravityAcc_std_Y, tGravityAcc_std_Z,
		tBodyAccJerk_mean_X, tBodyAccJerk_mean_Y,
		tBodyAccJerk_mean_Z, tBodyAccJerk_std_X,
		tBodyAccJerk_std_Y, tBodyAccJerk_std_Z,
		tBodyGyro_mean_X, tBodyGyro_mean_Y,
		tBodyGyro_mean_Z, tBodyGyro_std_X,
		tBodyGyro_std_Y, tBodyGyro_std_Z,
		tBodyGyroJerk_mean_X, tBodyGyroJerk_mean_Y,
		tBodyGyroJerk_mean_Z, tBodyGyroJerk_std_X,
		tBodyGyroJerk_std_Y, tBodyGyroJerk_std_Z,
		tBodyAccMag_mean, tBodyAccMag_std,
		tGravityAccMag_mean, tGravityAccMag_std,
		tBodyAccJerkMag_mean, tBodyAccJerkMag_std,
		tBodyGyroMag_mean, tBodyGyroMag_std,
		tBodyGyroJerkMag_mean, tBodyGyroJerkMag_std,
		fBodyAcc_mean_X, fBodyAcc_mean_Y,
		fBodyAcc_mean_Z, fBodyAcc_std_X,
		fBodyAcc_std_Y, fBodyAcc_std_Z,
		fBodyAcc_meanFreq_X, fBodyAcc_meanFreq_Y,
		fBodyAcc_meanFreq_Z, fBodyAccJerk_mean_X,
		fBodyAccJerk_mean_Y, fBodyAccJerk_mean_Z,
		fBodyAccJerk_std_X, fBodyAccJerk_std_Y,
		fBodyAccJerk_std_Z, fBodyAccJerk_meanFreq_X,
		fBodyAccJerk_meanFreq_Y, fBodyAccJerk_meanFreq_Z,
		fBodyGyro_mean_X, fBodyGyro_mean_Y,
		fBodyGyro_mean_Z, fBodyGyro_std_X,
		fBodyGyro_std_Y, fBodyGyro_std_Z,
		fBodyGyro_meanFreq_X, fBodyGyro_meanFreq_Y,
		fBodyGyro_meanFreq_Z, fBodyAccMag_mean,
		fBodyAccMag_std, fBodyAccMag_meanFreq,
		fBodyBodyAccJerkMag_mean, fBodyBodyAccJerkMag_std,
		fBodyBodyAccJerkMag_meanFreq, fBodyBodyGyroMag_mean,
		fBodyBodyGyroMag_std, fBodyBodyGyroMag_meanFreq,
		fBodyBodyGyroJerkMag_mean, fBodyBodyGyroJerkMag_std,
		fBodyBodyGyroJerkMag_meanFreq
		) ~ subject+activity_label, df, mean)

	return(avg)
}

run_analysis <- function() {

	### 1. Merge the training and test sets

	df <- load_data()

	### 2. Extract mean and std measurements
	### 4. Appropriately label the data

	cols <- get_columns()

	# Add the subject column
	cols <- rbind(cols, data.frame(V1=562, V2='', colName='subject'))
	# Add the activity column
	cols <- rbind(cols, data.frame(V1=563, V2='', colName='activity'))

	# Extract the desired columns from the original data by column number
	df <- df[, cols$V1]
	# Assign the new column names
	names(df) <- cols$colName

	### 3. Use descriptive activity names

	# Merge the activity labels into the data
	activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"")
	names(activity_labels) <- c("activity", "activity_label")
	df <- merge(df, activity_labels, by="activity")

	### 5. Generate the tidy dataset

	return(averages(df))
}
