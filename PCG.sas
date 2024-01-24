/* Principle Component Generation */
libname c "C:\Users\bbsstudent\Desktop\SASCaseStudy";

/* princomp procedure */
proc princomp data=c.Unico;
    var d10_1-d10_8;
run;

/* 
Produce an output file containing the coordinates of 
the correlation of the active variables and the principle components
*/
proc princomp data=c.Unico out=c.unico_coord;
    var d10_1-d10_8;
run;

/* 
Creation of dataset of principle component 1 coordinate data
*/
data c.unit_1_84; set c.unico_coord;
    if id=1 or id=84;
run;

data c.unico_coord_1; set c.unico_coord;
    /* Average of unit i */
    avgi=mean(of d10_1-d10_8);
run;

proc corr data=c.unico_coord_1;
    /* Checking whether average of responses is related to the pricnicple component coordinate */
    var avgi prin1;
run;

/* 
Prof. Furio solution - changing of scale
size effect - sz
*/
/* For variable 1 - d10_1 */
/* Use of an array to cover all active variables */
data c.sz_unico; set c.Unico;
    avgi=mean(of d10_1-d10_8);
    mini=min(of d10_1-d10_8);
    maxi=max(of d10_1-d10_8);
    /* Active variables array */
    array a1 d10_1-d10_8; /* Input array */
    array a2 new_1-new_8; /* Output array */
    /* Conditions to be checked SAS for loop*/
    do over a2;
    if a1 > avgi then a2=(a1-avgi)/(maxi-avgi);
    if a1 < avgi then a2=(a1-avgi)/(avgi-mini);
    if a1 = avgi then a2=0;
    if a1 =. then a2=0;
    end;
    /* Adding labels */
    label new_1='Leisure';
    label new_2='Schemas';
    label new_3='New_Fans';
    label new_4='Usual_Friends';
    label new_5='Work_Meet';
    label new_6='Spectacle';
    label new_7='Suffer_Together';
    label new_8='Quality_Time';
run;

proc means data=c.sz_unico min max mean;
    var d10_: new_: ;
run;

proc princomp data=c.sz_unico out=c.sz_unico_1;
    var new_:; 
run;

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