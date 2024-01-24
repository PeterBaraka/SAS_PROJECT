/* CLUSTERING PROCEDURE */
libname c "C:\Users\bbsstudent\Desktop\SASCaseStudy";
/* Select clustering method */
proc cluster data=c.Unico method=single;
/* proc cluster data=c.Unico method=ward; */
    /* Set variable range */
    var d10_1-d10_8;
run;
/* Generate dendrogram */
proc tree; run;

/* 
Good groups should not have any heterogenity
Partial Average
General Average
Single Linkage
Application of Chi Square test to clusters
outtree - save the history of the aggregation of the trees formed 
noprint - prevents the printing of output
*/

proc cluster data=c.Unico method=ward outtree=c.tree noprint;
/* Key variable identifier using id parameter */
    id id;
    /* Column names */
    var d10_1-d10_8;
run;
/* 
The input becomes the output once its processed 
NCL - SAS parameter denoting number of clusters
out - sets a cluster output file
*/
proc tree data=c.tree ncl=3 out=c.cluster noprint; 
    id id;
run;

/* Sorting of the dataset */
proc sort data=c.Unico;
    by id;
run;
proc sort data=c.cluster;
    by id;
run;
/* Creation and merging of a new dataset with the original one*/
data c.Unico_1; merge c.Unico c.cluster;
    by id;
run;
/* 
Freq - 
*/
proc freq data=c.Unico_1;
    /* Select the table and the variables to test */
    /* Parametrization can also occur here */
    table sex*cluster / expected chisq;
run;

/* Means procedure obtains means of each 
active variable withn the dataset  */
proc means data=c.Unico_1;
    var d10_1-d10_8;
run;

proc ttest
/* This procedure is very basic 
thus is not applied when evaluating clusters. 
Thus to evaluate the use a a where clause to compare the various
clusters based on a naming attribute*/

/* Duplication of dataset to test ttest on cluster */
data c.Unico_fake; 
    set c.Unico_1;
    cluster=4;
run;

/* Creation of new combined cluster */
data c.Unico_append; 
    set c.Unico_1 c.Unico_fake;
run;

/* 
Running ttest and the use of 
the Satterthwaite adjustment
*/
/* Description of cluster 1 */
proc ttest data=c.Unico_append;
    where cluster=1 or cluster=4;
    var d10_1-d10_8;
    class cluster;
run;

/* Description of cluster 3 */
proc ttest data=c.Unico_append;
    where cluster=3 or cluster=4;
    var d10_1-d10_8;
    class cluster;
run;
/* 
Running the same procedure on cluster 3  with 4 we realise more negative t-values and pooled differences

*/

/* 
The larger the p value then the better the t value is for clustering
*/

/*
Obtaining the correlation coefficient of each column to each other
*/
proc corr data=c.Unico_1;
    var d10_1-d10_8;
run;
/* 
If the variables are very correlated then it presents that there is just one mass variable
rather than independant variables
*/