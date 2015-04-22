CODE BOOK - GETTING AND CLEANING DATA COURSE PROJECT
====================================================


CONTENTS:

1 - Introductory Remarks
2 - Variables Used
3 - Description of Data
4 - Process for Producing Tidy Data Set
5 - Appendix


1. INTRODUCTORY REMARKS

This course project required the manipulation of the Human Activity Recognition Using 
Smartphones Data Set described at the following web address:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The project specification is that I should create an R script called run_analysis.R that 
does the following: 

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the 
  average of each variable for each activity and each subject.
  
Note that I am not required to demonstrate any particular understanding of the data to be
tidied. 


2. VARIABLES USED

There are a large number of variables contained in the original data set. There are two
considerations relevant to determining how the data in the original data set is deployed 
in my tidy data set:
1 - The specified restrictions on the variables that should be presented; and
2 - The specification that the resultant data set should be tidy.

These considerations place some concrete restrictions on how I am able to handle the data
in the original set:

- I am required to include variables for the activities and and subjects monitored in 
	the study, as well as for the variables measured. 
- I am required to deploy the data in a tidy form, that is each variable in a column, 
	each observation in a row and each observational unit in a table (Wickham, 2014).

However both considerations also permit some scope in interpreting which variables from 
the original data set should be used and how these variables should be deployed. 
Selecting which variables to consider mean and standard deviation measurements and 
deciding on a particular tidy day form requires that some somewhat arbitrary decisions be 
made in determining which variables are relevant. 

The variables that I set out in my tidy data set are: subject, activity, measurement_type
and mean value. I describe each in turn.

subject: an integer value, ranging from 1 through 30, that serves to identify the 30 
	subjects that participated in the study.
	
activity: a factor variable with the values walking, walking upstairs, walking downstairs,
	sitting, standing and laying. The value attached to this variable stipulates the type 
	of activity that the subject was engaged in at the time when the measurement was 
	taken.
	
measurement_type: a factor variable with 66 levels (set out in the Appendix) describing 
	the type of measurement that a given observation pertains to. I determined which 
	variables from the original selection of 561 (contained in features.txt in the 
	original data set) should be used by obtaining all measurement types that contained 
	either the phrase 'mean()' or the phrase 'std()' as, so far as I can discern, these
	phrases most precisely indicate that the associated measurement is either a 
	measurement of a mean or of a standard deviation value (as required by the 
	specification). 
	
mean_value: a numeric variable containing the mean value of the measurement for the
	subject and activity specified in the rest of the observation. This is the only 
	variable type that my script calculates (as opposed to obtaining from subsetting the
	original data set). 
	

3. DESCRIPTION OF DATA

The original data set was obtained from downloading and unzipping the file at the
following link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The original set contains data in a number of different files. Of these, I determined that
the following files contained data useful to this project (descriptions are taken 
from the README of the original data set):

- 'features.txt': List of all features.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity 
  for each window sample. Its range is from 1 to 30. 
- 'test/subject_test.txt': Each row identifies the subject who performed the activity 
  for each window sample. Its range is from 1 to 30. 

Other files in the data set contained useful reference information, but were not directly
used as data sources in my analysis. 

I determined that the files contained in the two Inertial Signals folders were not 
relevant to my analysis and so I did not use these.

There were no missing values in the data sources that I used. 


4. PROCESS OF PRODUCING TIDY DATA SET

I produced a single R script, run_analysis.R, that produces the required tidy data set 
from the original data set. My methodology for doing this is as follows. 

1 - Source two packages, dplyr and reshape2, that will be of use in my script.

2 - Read the 7 data files (specified in the Data section above) into R and assign to 
	data frame variables. Reassign the second column of the features.txt data as a 
	character vector in order to obtain descriptive names of all measurement types.
	Prepend the words 'subjects' and 'activities' to this vector as I will later use it 
	to provide column names for the measurement value data.
	
3 - Column bind the train and test subject and activity data to the measurement value data
	to their respective measurement value data frames and use the features character 
	vector to provide column names to the resulting dataframes. 
	
4 - Row bind the train and test data frames into one all.data data frame, so fulfilling
	the first point in the specification. 
	
5 - Referring to activity_labels.txt, reformulate the activities column as a factor 
	variable with the original numerical values corresponding to the appropriate activity
	value, so fulfilling the third point in the specification. 
	
6 - I am unable to use the select function (from dplyr) while some column names are 
	duplicate values. Fortunately, looking at these values, I find that none of them are 
	relevant to my analysis and so I am able to subset the all.data data set to remove 
	these columns. 
	
7 - I then use the select function to obtain only the columns with names containing the 
	terms 'mean()' and 'std()' for reasons set out in the Variables section above. As this
	process removes the subject and activity columns, I reattach these with cbind().
	
8 - The principles of tidy data require that all variables should be in a column, and my
	selection data set still has the measurement type variable in the dataframe head. I 
	melt() the dataframe to resolve this, preserving the subject and activity variable 
	columns.
	
9 - I am then able to collapse the measurement variables into the mean of the values for 
	each activity and each subject by using the dplyr group_by() and summarise() functions
	with mean() selected as the aggregating function for summarise. The data set is now 
	tidy. All that remains is to assign some more descriptive column names and write the 
	data set to disk in the manner specified in the project instructions.  
	
	
5. APPENDIX

The following is the abridged content of the features_info.txt file from the original data 
set. I include all sections useful to the task of deciphering the meanings of the various 
measurement types. 

--------

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to 
obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these 
three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, 
tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing 
fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, 
fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

--------

The following is the full list of types of measurement selected for my tidy data set:

 [1] tBodyAcc-mean()-X          
 [2] tBodyAcc-mean()-Y          
 [3] tBodyAcc-mean()-Z          
 [4] tGravityAcc-mean()-X       
 [5] tGravityAcc-mean()-Y       
 [6] tGravityAcc-mean()-Z       
 [7] tBodyAccJerk-mean()-X      
 [8] tBodyAccJerk-mean()-Y      
 [9] tBodyAccJerk-mean()-Z      
[10] tBodyGyro-mean()-X         
[11] tBodyGyro-mean()-Y         
[12] tBodyGyro-mean()-Z         
[13] tBodyGyroJerk-mean()-X     
[14] tBodyGyroJerk-mean()-Y     
[15] tBodyGyroJerk-mean()-Z     
[16] tBodyAccMag-mean()         
[17] tGravityAccMag-mean()      
[18] tBodyAccJerkMag-mean()     
[19] tBodyGyroMag-mean()        
[20] tBodyGyroJerkMag-mean()    
[21] fBodyAcc-mean()-X          
[22] fBodyAcc-mean()-Y          
[23] fBodyAcc-mean()-Z          
[24] fBodyAccJerk-mean()-X      
[25] fBodyAccJerk-mean()-Y      
[26] fBodyAccJerk-mean()-Z      
[27] fBodyGyro-mean()-X         
[28] fBodyGyro-mean()-Y         
[29] fBodyGyro-mean()-Z         
[30] fBodyAccMag-mean()         
[31] fBodyBodyAccJerkMag-mean() 
[32] fBodyBodyGyroMag-mean()    
[33] fBodyBodyGyroJerkMag-mean()
[34] tBodyAcc-std()-X           
[35] tBodyAcc-std()-Y           
[36] tBodyAcc-std()-Z           
[37] tGravityAcc-std()-X        
[38] tGravityAcc-std()-Y        
[39] tGravityAcc-std()-Z        
[40] tBodyAccJerk-std()-X       
[41] tBodyAccJerk-std()-Y       
[42] tBodyAccJerk-std()-Z       
[43] tBodyGyro-std()-X          
[44] tBodyGyro-std()-Y          
[45] tBodyGyro-std()-Z          
[46] tBodyGyroJerk-std()-X      
[47] tBodyGyroJerk-std()-Y      
[48] tBodyGyroJerk-std()-Z      
[49] tBodyAccMag-std()          
[50] tGravityAccMag-std()       
[51] tBodyAccJerkMag-std()      
[52] tBodyGyroMag-std()         
[53] tBodyGyroJerkMag-std()     
[54] fBodyAcc-std()-X           
[55] fBodyAcc-std()-Y           
[56] fBodyAcc-std()-Z           
[57] fBodyAccJerk-std()-X       
[58] fBodyAccJerk-std()-Y       
[59] fBodyAccJerk-std()-Z       
[60] fBodyGyro-std()-X          
[61] fBodyGyro-std()-Y          
[62] fBodyGyro-std()-Z          
[63] fBodyAccMag-std()          
[64] fBodyBodyAccJerkMag-std()  
[65] fBodyBodyGyroMag-std()     
[66] fBodyBodyGyroJerkMag-std() 
  
  