# Codebook for Human Activity Recognition (HAR) Dataset Processing Script

This codebook explains the steps and variables used in the R script to process the "UCI HAR Dataset".

---

## Table of Contents
1. [Dataset Path Definition](#dataset-path-definition)
2. [Reading Data Files](#reading-data-files)
3. [Setting Column Names](#setting-column-names)
4. [Mutating Activity Labels](#mutating-activity-labels)
5. [Selecting Mean and Standard Deviation Variables](#selecting-mean-and-standard-deviation-variables)
6. [Combining Data Sets](#combining-data-sets)
7. [Renaming Columns](#renaming-columns)
8. [Merging Training and Testing Sets](#merging-training-and-testing-sets)
9. [Calculating Mean by Subject and Activity](#calculating-mean-by-subject-and-activity)
10. [Output](#output)

---

### 1. Dataset Path Definition

- **`pth`**: Sets the working directory path to the current working directory.
- **`train_pth`** and **`test_pth`**: Define paths for the training and testing datasets in the "UCI HAR Dataset" folder using `paste()`.

### 2. Reading Data Files

- **`features_table`**: Reads `features.txt`, which contains variable names (features) for the dataset.
- **`subject_train`** and **`subject_test`**: Load subject identifiers from `subject_train.txt` and `subject_test.txt`.
- **`x_train`** and **`x_test`**: Load the main dataset features for the training and testing sets from `X_train.txt` and `X_test.txt`.
- **`y_train`** and **`y_test`**: Load activity labels for the training and testing sets from `y_train.txt` and `y_test.txt`.
- **`activity_labels`**: Reads `activity_labels.txt` and extracts only the activity names.

### 3. Setting Column Names

- **`colnames(x_train)`** and **`colnames(x_test)`**: Assign feature names from `features_table` to `x_train` and `x_test`.
- **`colnames(y_train)`** and **`colnames(y_test)`**: Rename activity label columns in `y_train` and `y_test` to `"label"`.
- **`colnames(subject_train)`** and **`colnames(subject_test)`**: Rename columns to `"subject"` for subject identifiers.

### 4. Mutating Activity Labels

- **`mutate(y_train, ...)`** and **`mutate(y_test, ...)`**: Add a new `"activity"` column in `y_train` and `y_test`, mapping each label to the corresponding activity name from `activity_labels`.
- **`select(-c(label))`**: Removes the `"label"` column from `y_train` and `y_test`, keeping only the new `"activity"` column.

### 5. Selecting Mean and Standard Deviation Variables

- **`x_train <- x_train[, grepl("mean()|std()", names(x_train))]`** and **`x_test <- x_test[, grepl("mean()|std()", names(x_test))]`**: Filters columns to keep only those containing "mean()" or "std()", representing mean and standard deviation features.

### 6. Combining Data Sets

- **`test_set`**: Combines `subject_test`, `y_test`, and filtered `x_test` using `cbind`.
- **`train_set`**: Combines `subject_train`, `y_train`, and filtered `x_train` using `cbind`.
- **`rm(...)`**: Removes intermediate data frames (`features_table`, `subject_test`, `subject_train`, `x_test`, `x_train`, `y_test`, `y_train`) to free memory.

### 7. Renaming Columns

- **`rename_with(~ sub("^f", "freq", .x))`** and **`rename_with(~ sub("^t", "time", .x))`**: Updates column names in `test_set` and `train_set` to use descriptive prefixes:
  - `^f` is replaced by `"freq"` for frequency-domain signals.
  - `^t` is replaced by `"time"` for time-domain signals.

### 8. Merging Training and Testing Sets

- **`all_set <- bind_rows(test_set, train_set)`**: Combines `test_set` and `train_set` by rows to form the complete dataset `all_set`.
- **`rm(train_set, test_set)`**: Removes `train_set` and `test_set` to free memory.

### 9. Calculating Mean by Subject and Activity

- **`all_set <- all_set %>% group_by(subject, activity) %>% summarise(across(everything(), mean))`**: Groups `all_set` by `"subject"` and `"activity"` columns and calculates the mean for all remaining columns, summarizing each feature by subject and activity.

### 10. Output

- **`all_set`**: The final dataset, where each row represents the average of each mean and standard deviation feature, grouped by subject and activity. This is the main output.

---

This script processes the raw "Human Activity Recognition" dataset by:
1. Filtering for mean and standard deviation features.
2. Adding descriptive labels and combining training and testing data.
3. Creating a summarized tidy dataset of mean values by activity and subject.

