How run_analysis works
=============
1. We start from reading the files. We assume data files are already downloaded, unzipped and they are in working directory.
data files can be obtained from following link: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

2. First we read training data set and then test data set. After we read all files, we start to build data set.

3. First thing we do is we combing train data. In this data set, subject.train refere to subjects of training data set. According to the given discription we have 30 subjects. Then y.train refers to their activities. Again they do 6 activides coded by 1-6. Next x.train contain the data of measurements. We combine these data as column wise

4. We do the step(3) again for test data.

5. Now we combine train data and test data together to obtain complete data set. This is done using row bind.

6. Next we extracts measurements on the mean and standard deviation of each measurement. To do that we check whether variable name contains "-mean()" or "-std()" 

7. Next we read activity names from "activity_label.txt" file and use those activity labels to rename activities(instead of "1-6"  naming convention now we have disriptive activity set).

8. next we need to label variables with disriptive names.

9. to do that first we seperate varaible name to two part. Seperation point is first occurance of "-". For example "tBodyAcc-mean()-X" seperate into "tBodyAcc" and "-mean()-X"

10. We assign first part to "nondiscpart1" varaible and second part to "nondiscpart2" variable

11. Next we take "nondiscpart2" varaible. Which contain elemnt like "-mean()-X", "-std()". We remove "()", "-" and substitute "X axis" for "X", "mean" by "meanof", "std" by "stdof",etc.

12. After that we take "nondiscpart1" varaible. We do foolowing assignments.
    i. ACC ----Accelaration
    ii Gyro --Gyroscope
    iii t-Timedomain
    iv  f-FreqDomain
    v.  we correct typo "BodyBody" by removing repetition
    vi. We bring "Mag" to front of varaible and now it read "Magnitudeof"
    vii We add "Signals" to the end

13. We concatenate nondiscpart1 and nondiscpart2 to get full discriptive lables

14. Then we assign that as names of data set(except first two labels("subject" and "Activity"))

15. Then we take average of each variable for each activity and each subject

16. We write the data set into current directory as text file.
