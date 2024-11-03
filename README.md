# Getting and Cleaning Data (Coursera) -peer graded
In this project we were asked to create clean and tidy data which also have descriptive variable names.
by reading the readme we can see that they record the data in training and testing by using 6 different activities described in activity_labels.txt and 30 subjects who participated.

###Reading the data
Reading with read.table() function provides data frame 
x_train and x_test are tables with 561 different variables (as in features.txt) and 7352 and 2947 rows.
y_train and y_test are tables with 1 variable "activity" (1 to 6 describing the activity label) with 7352 and 2947 rows.
subject_train and subject_test are tables with 1 variable "subject" (subject id) with 7352 and 2947 rows.
using features.txt i assigned the 561 variable names to x_train and x_test.


###Merging the data

1. using mutate to assigne the activity_label to the corresponding values 1="WALKING" 2="WALKING_UPSTAIRS"....
2. using grepl to keep only the variables that are mean or standard deviation keeping us with 81 columns
3. renaming "t" to "time" and "f" to "freq" giving more desciptive names to the variables
4. coloumn binding subject_train,y_train,x_train resulting in 81 columns and 7352 rows
5. coloumn binding subject_test,y_test,x_test resulting in 81 column and 2947 rows
6. row binding resulting in 81 variables and 10299 rows

### tidy data
we can see that different rows have the same subject and activity label with different values.
so we can group it by the subject and then activity creating a more tidy data and summarising the average of same observations
resulting in only 180=30 (subjects) * 6 (activities) observations
