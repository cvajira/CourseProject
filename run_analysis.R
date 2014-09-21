library(dplyr)
library(tidyr)

##Reading the train files
subject.train<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
y.train<-read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
x.train<-read.table("./UCI HAR Dataset/train/x_train.txt",header=FALSE)

##Reading the test file
subject.test<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
y.test<-read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
x.test<-read.table("./UCI HAR Dataset/test/x_test.txt",header=FALSE)

## combining train data files(columnwise)
dataset.train<-cbind(subject.train,y.train,x.train)
rm("subject.train","y.train","x.train")

## combining test datafiles(columnwise)
dataset.test<-cbind(subject.test,y.test,x.test)
rm("subject.test","y.test","x.test")

##combining "test" and "train" files
dataset.complete<-rbind(dataset.train,dataset.test)
rm("dataset.test","dataset.train")

##Reading features
features<-read.table("./UCI HAR Dataset/features.txt",header=FALSE)
features.labels<-t(features)[2,]
rm("features")

##naming column of complete data set
names(dataset.complete)<-c("subject","activity",features.labels)
rm("features.labels")

##making table from complete data set
dataset.comp<-tbl_df(dataset.complete)
rm("dataset.complete")

##selecting dataset which contain only mean() or std()
mydataset<-select(dataset.comp, subject,activity,matches("-mean\\(\\)",ignore.case=TRUE),matches("-std\\(\\)",ignore.case=TRUE))
rm("dataset.comp")

##reading activitylabels and changing activity number to discriptive labels
Act.labels<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)
mydataset$activity<-factor(mydataset$activity)
levels(mydataset$activity)<-Act.labels[[2]]

##assiging discriptive variable names
nondisc.variables<-names(mydataset)[3:length(names(mydataset))]
rexp<-"^(\\w+)-(.*)$"
nondiscpart1<-sub(rexp, "\\1",nondisc.variables)
nondiscpart2<-sub(rexp, "\\2",nondisc.variables)

nondiscpart2<-sub(pattern="\\()+",replacement="",nondiscpart2,ignore.case=TRUE)
nondiscpart2<-sub(pattern="-",replacement="of",nondiscpart2,ignore.case=TRUE)
nondiscpart2<-sub(pattern="^(.*?)([Xx]|[Yy]|[Zz])$",replacement="\\1\\2axis",nondiscpart2,ignore.case=TRUE)
nondiscpart2<-sub(pattern="mean$",replacement="meanof",nondiscpart2,ignore.case=TRUE)
nondiscpart2<-sub(pattern="std$",replacement="stdof",nondiscpart2,ignore.case=TRUE)


nondiscpart1<-sub(pattern="\\Acc+",replacement="Accelaration",nondiscpart1,ignore.case=TRUE)
nondiscpart1<-sub(pattern="\\Gyro+",replacement="Gyroscope",nondiscpart1,ignore.case=TRUE)
nondiscpart1<-sub(pattern="^t",replacement="Timedomain",nondiscpart1,ignore.case=TRUE)
nondiscpart1<-sub(pattern="^f",replacement="Freqdomain",nondiscpart1,ignore.case=TRUE)
nondiscpart1<-sub(pattern="^(.*?)(BodyBody)(.*?)",replacement="\\1Body\\3",nondiscpart1,ignore.case=TRUE)
nondiscpart1<-sub(pattern="^(.*?)Mag$",replacement="Magnitudeof\\1",nondiscpart1,ignore.case=TRUE)
nondiscpart1<-sub(pattern="$",replacement="Signals",nondiscpart1,ignore.case=TRUE)

names(mydataset)[3:length(names(mydataset))]<-paste(nondiscpart2,nondiscpart1,sep="")
rm("nondiscpart1","nondiscpart2","nondisc.variables","rexp")

mydataset2<-tbl_df(mydataset)
rm("mydataset")

##extracting dataset with average of each variable for each activity and each subject
tidyset<-summarise_each(group_by(mydataset2,subject,activity),funs(mean))
rm("mydataset2")

##writing results to a table
write.table(tidyset, file = "result.txt", sep=",",row.names = F )



