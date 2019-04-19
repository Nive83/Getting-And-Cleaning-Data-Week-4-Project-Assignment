if(!file.exists("./data")){dir.create("./data")}## create a directory
fiileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fiileurl,destfile = "./data/Dataset.zip",method="curl")## download the zip file
unzip(zipfile="./data/Dataset.zip",exdir="./data")##unzip the file
pathdata=file.path("./data","UCI HAR Dataset")## create path for the destination files
files=list.files(pathdata,recursive = TRUE)## make sure this unzipped file is in the directory
files
## Read the content of the training table
xt = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
yt = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
st= read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
## Read the contect of the testing table
xtt= read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytt= read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
stt = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
ft = read.table(file.path(pathdata, "features.txt"),header = FALSE)## reading the future file
al= read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)## reading the activity file
##set the colnmanes for the training data
colnames(xt) = ft[,2]
colnames(yt) = "activityId"
colnames(st) = "subjectId"
## set the colnames for the test data
colnames(xtt) = ft[,2]
colnames(ytt)="activityId"
colnames(stt)="subjectId"
## set the colnames for the activity labels 
colnames(al) <- c('activityId','activityType')
##Merging the training data and test data
mrg_train = cbind(yt, st, xt)
mrg_test = cbind(ytt, stt, xtt)
allinall=rbind(mrg_train,mrg_test)## combine rows of two tables
colNames = colnames(allinall)
## get the subset of all the mean and SD cols
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
setForMeanAndStd <- allinall[ , mean_and_std == TRUE]## subset for the required dataset
setWithActivityNames = merge(setForMeanAndStd, al, by='activityId', all.x=TRUE)## Merge both the table
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)## the new tidy data set 
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
##write output to a text file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)

