## Load needed packages
library(plyr)
library(dplyr)
library(data.table)

## Read all tables
test.subjects <- read.table("test/subject_test.txt")
test.data <- read.table("test/X_test.txt")
test.labels <- read.table("test/y_test.txt")
train.subjects <- read.table("train/subject_train.txt")
train.data <- read.table("train/X_train.txt")
train.labels <- read.table("train/y_train.txt")
column.names <- read.table("features.txt")

## Merges the training and the test sets to create one data set.
test.train <- rbind(test.data, train.data)
subjects <- rbind(test.subjects, train.subjects)
activities <- rbind(test.labels, train.labels)
data <- cbind(subjects, test.train, activities)
columns <- as.vector(column.names[,2])
names(data) <- c("subject", columns, "activity")
## Extracts only the measurements on the mean and standard deviation for each measurement.
columns <- as.vector(names(data))
columns.mean <- as.vector(grep("mean", columns))
columns.std <- as.vector(grep("std", columns))
col <- c(1, columns.mean, columns.std, 563)
col <- sort(col, decreasing=FALSE)
data.mean.std <- data[,col]
## Uses descriptive activity names to name the activities in the data set
data.mean.std$activity <- as.factor(data.mean.std$activity)
data.mean.std$activity <- mapvalues(data.mean.std$activity, from = c(1,2,3,4,5,6), to =c("walking", "walking upstairs", "walking downstairs", "sitting", "standing", "laying"))
# Make syntactically valid names
names(data.mean.std) <- gsub('\\(|\\)',"",names(data.mean.std), perl = TRUE)
names(data.mean.std) <- make.names(names(data.mean.std))
# Make clearer names
names(data.mean.std) <- gsub('Acc',"Acceleration",names(data.mean.std))
names(data.mean.std) <- gsub('GyroJerk',"AngularAcceleration",names(data.mean.std))
names(data.mean.std) <- gsub('Gyro',"AngularSpeed",names(data.mean.std))
names(data.mean.std) <- gsub('Mag',"Magnitude",names(data.mean.std))
names(data.mean.std) <- gsub('^t',"TimeDomain.",names(data.mean.std))
names(data.mean.std) <- gsub('^f',"FrequencyDomain.",names(data.mean.std))
names(data.mean.std) <- gsub('\\.mean',".Mean",names(data.mean.std))
names(data.mean.std) <- gsub('\\.std',".StandardDeviation",names(data.mean.std))
names(data.mean.std) <- gsub('Freq\\.',"Frequency.",names(data.mean.std))
names(data.mean.std) <- gsub('Freq$',"Frequency",names(data.mean.std))
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each
## activity and each subject.
tidy.data <- ddply(data.mean.std, c("subject", "activity"), numcolwise(mean))
write.table(tidy.data, "tidy.data.txt", row.name = FALSE)