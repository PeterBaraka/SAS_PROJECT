libname c "C:\Users\bbsstudent\Desktop\SASCaseStudy";

proc cluster data=c.sz_unico_1 method=ward outtree=c.sz_tree;
    var prin1-prin4;
    id id;
run;

proc tree data=c.sz_tree; run;

proc tree data=c.sz_tree noprint nclusters=6 out=c.sz_cluster;
    id id;
run;

/* Sorting the data before merging */
proc sort data=c.sz_cluster; by id; run;
proc sort data=c.sz_unico_1; by id; run;
/* Merging of the data */
data c.sz_unico_2; merge c.sz_unico_1 c.sz_cluster;
    by id;
run;

/* Run the various statistical tests on the newly merged dataset */
proc freq data=c.sz_unico_2;
    /* All - considers all statistical tests */
    table sex*cluster / expected all;
run;

/* Creation of new fake dataset */
data c.sz_unico_fake; set c.sz_unico_2;
    cluster=7;
run;

/* New dataset made of original and fake dataset */
data c.sz_unico_long; set c.sz_unico_2 c.sz_unico_fake;
run;

/* Macro to produce 6 analysis of our 6 clusters */
%macro do_k_cluster;
%do k=1 %to 6;
proc ttest data=c.sz_unico_long;
    where cluster=&k or cluster=7;
    class cluster;
    var new:;
    /* ttests => name of output test result
    Naming standard increments for each new value (&k)*/
    ods output ttests=c.cl_ttest_&k (where=(method='Satterthwaite')
    rename=(tvalue=tvalue_&k) rename=(probt=prob_&k));
run;
%end;
%mend do_k_cluster;
%do_k_cluster

data c.cl_ttest_all;
    merge
    c.cl_ttest_1
    c.cl_ttest_2
    c.cl_ttest_3
    c.cl_ttest_4
    c.cl_ttest_5
    c.cl_ttest_6;
    by variable;
run;

/* Creation of labels - data identity card */
proc contents data=c.sz_unico_long out=c.contents;
run;

/* Change dataset column name */
data c.contents; set c.contents;
    rename name=variable;
run;

/* Merge column labels from diff tables */
data c.cl_ttest_all_1;
    merge c.cl_ttest_all (in=a) c.contents(in=b);
        by variable;
        if a;
run;