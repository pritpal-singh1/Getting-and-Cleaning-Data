library(reshape2)

x_train<-read.table("train/X_train.txt",header=FALSE,sep="",dec=".")
y_train<-read.table("train/Y_train.txt",header=FALSE,sep="",dec=".")
s_train<-read.table("train/subject_train.txt",header=FALSE,sep="",dec=".")

x_test<-read.table("test/X_test.txt",header=FALSE,sep="",dec=".")
y_test<-read.table("test/Y_test.txt",header=FALSE,sep="",dec=".")
s_test<-read.table("test/subject_test.txt",header=FALSE,sep="",dec=".")




# merge {train, test} data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)


#3. load feature & activity info
# feature info
feature<-read.table("features.txt",header=FALSE,sep="",dec=".")

# activity labels
a_label<-read.table("activity_labels.txt",header=FALSE,sep="",dec=".")
a_label[,2] <- as.character(a_label[,2])

# extract feature cols & names named 'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)


#4. extract data by cols & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)


#5. generate tidy data set
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)