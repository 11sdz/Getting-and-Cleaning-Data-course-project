##dataset path

pth<-getwd()
train_pth<-paste(pth,"\\UCI HAR Dataset\\train",sep = "")
test_pth<-paste(pth,"\\UCI HAR Dataset\\test",sep="")

##reading table from training text files
features_table<-read.table(file = paste(pth,"\\UCI HAR Dataset\\features.txt",sep=""))
subject_train<-read.table(file = paste(train_pth,"\\subject_train.txt",sep=""))
x_train<-read.table(file = paste(train_pth,"\\X_train.txt",sep=""))
y_train<-read.table(file = paste(train_pth,"\\y_train.txt",sep=""))

##reading table from testing text files
subject_test<-read.table(file = paste(test_pth,"\\subject_test.txt",sep=""))
x_test<-read.table(file = paste(test_pth,"\\X_test.txt",sep=""))
y_test<-read.table(file = paste(test_pth,"\\y_test.txt",sep=""))
activity_labels<-read.table(file=paste(pth,"\\UCI HAR Dataset\\activity_labels.txt",sep=""))
activity_labels<-unlist(activity_labels[,2])

##column names
colnames(x_train)<-features_table[,2] ##assigning variable names from features
colnames(x_test)<-features_table[,2] ##assigning variable names from features
colnames(y_train)<-c("label")
colnames(y_test)<-c("label")
colnames(subject_train)<-c("subject")
colnames(subject_test)<-c("subject")

#mutate to create new column with the defining lables
y_train<-mutate(y_train,activity=activity_labels[y_train$label])
y_test<-mutate(y_test,activity=activity_labels[y_test$label])

y_train<-y_train%>% select(-c(label))
y_test<-y_test%>% select(-c(label))

##keeping only mean and standart deviation variables
x_test<-x_test[,grepl("mean()|std()",names(x_test))]
x_train<-x_train[,grepl("mean()|std()",names(x_train))]

#merging
test_set<-cbind(subject_test,y_test)
test_set<-cbind(test_set,x_test)
train_set<-cbind(subject_train,y_train)
train_set<-cbind(train_set,x_train)

##cleaning unnecessary
rm(features_table,subject_test,subject_train,x_test,x_train,y_test,y_train)

test_set<-test_set%>%rename_with(~ sub("^f","freq",.x))
test_set<-test_set%>%rename_with(~ sub("^t","time",.x))
train_set<-train_set%>%rename_with(~ sub("^f","freq",.x))
train_set<-train_set%>%rename_with(~ sub("^t","time",.x))


##merging rows
all_set<-bind_rows(test_set,train_set)

##cleaning unnecessary
rm(train_set,test_set)

all_set<-all_set%>% group_by(subject,activity) %>% summarise(across(everything(),mean))

all_set