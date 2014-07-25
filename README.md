getdata
=======

# Human Activity Recognition Using Smartphones README

## Quick Start

To run the analysis. Pull the project directory. Download the data zip file and decompress it in the project directory.

Run the "run_analysis" function with no arguments. The output will be the "tidy" dataset of averages aggregated by subject and activity.

## Background

The reference zip file was downloaded and uncompressed. The documentation files were read (several times) to understand data. The data files were examined.

The data has training and test parts that are to be combined.

Each part has three component files: a 561-values/row training/test data file, an activity label file, and a subject file. Specifically,

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'test/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

The data is documented by a field list in the features.txt file. The activities are also encoded using the activity_labels.txt file.

## Procedure

The run_analysis R script does the follwing things:

* For test and training data, load subject, activiy, and data files. Add the subject and activity data as additional columns to the data file. Combine the test and training data.

* Load the column information from the features_info.txt file to determine what columns to extract by selecting field name that have "mean" or "std" in them. Convert the names to be suitable for use in an R data frame. Add additional columns for the subject and activity columns.

* Rename the data frame columns to have the extracted names.

* Merge the activity_labels.txt data into the data frame.

* Take the averages of all the mean and standard deviation columns aggregated over subject and activity.
