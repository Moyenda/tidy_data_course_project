library(dplyr)
library(reshape2)

features <- read.table('features.txt')
features <- as.character(features$V2)
features <- c('subjects', 'activities', features)

test.subject <- read.table('test/subject_test.txt')
train.subject <- read.table('train/subject_train.txt')

test.labels <- read.table('test/y_test.txt')
test.data <- read.table('test/X_test.txt')

train.labels <- read.table('train/y_train.txt')
train.data <- read.table('train/X_train.txt')

test.data <- cbind(test.subject, test.labels, test.data)
train.data <- cbind(train.subject, train.labels, train.data)

colnames(test.data) <- features
colnames(train.data) <- features

all.data <- rbind(test.data, train.data)

all.data$activities <- factor(all.data$activities, levels = c(1:6), labels = 
                        c('walking', 'walking upstairs', 'walking downstairs', 
                          'sitting', 'standing', 'laying'))

filter.var <- unique(colnames(all.data))
all.data <- all.data[, filter.var]

means.data <- select(all.data, contains('mean()'))
sd.data <- select(all.data, contains('std()'))

subjects <- all.data$subjects
activities <- all.data$activities

selection <- cbind(subjects, activities, means.data, sd.data)
selection <- arrange(selection, subjects, activities)

molten <- melt(selection, id.vars = c('subjects', 'activities'))
grouped <- group_by(molten, subjects, activities, variable)

tidy.set <- summarise(grouped, mean(value))
colnames(tidy.set) <- c('subject', 'activity', 'measurement_type', 'mean_value')

write.table(tidy.set, file = 'tidyset.txt', row.names = FALSE)