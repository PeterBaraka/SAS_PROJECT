/*  */
LIBNAME sas_proj 'C:\Users\bbsstudent\Desktop\YouTube_Project';

/*  */
proc import 
   datafile="C:\Users\bbsstudent\Desktop\YouTube_Project\yt_s_var.csv" 
   out=sas_proj.yt_s_var
   dbms=csv
   replace;
run;

/*  */
proc print data=sas_proj.yt_s_var;
run;

/*  */
proc cluster data=sas_proj.yt_s_var method=ward;
    var d10_1-d10_8;
run;

/*  */
proc tree;
run;

/*  */
proc cluster data=sas_proj.yt_s_var method=ward outtree=sas_proj.tree noprint;
        id id;
        var d10_1-d10_8;
run;

/*  */
proc tree data=sas_proj.tree ncl=3 out=sas_proj.cluster noprint; 
    id id;
run;

/*  */
proc sort data=sas_proj.yt_s_var;
    by id;
run;

/*  */
proc sort data=sas_proj.cluster;
    by id;
run;

/*  */
data sas_proj.yt_1; merge sas_proj.yt_s_var sas_proj.cluster;
    by id;
run;

/*  */
proc freq data=sas_proj.yt_1;
    table gender*cluster / expected chisq;
run;

/*  */
proc means data=sas_proj.yt_1;
    var d10_1-d10_8;
run;

/*  */
proc ttest;
run;

/*  */
data sas_proj.yt_fake; 
    set sas_proj.yt_1;
    cluster=4;
run;

/*  */
data sas_proj.yt_append; 
    set sas_proj.yt_1 sas_proj.yt_fake;
run;

/*  */
proc ttest data=sas_proj.yt_append;
    where cluster=1 or cluster=4;
    var d10_1-d10_8;
    class cluster;
run;

/*  */
proc ttest data=sas_proj.yt_append;
    where cluster=2 or cluster=4;
    var d10_1-d10_8;
    class cluster;
run;

/*  */
proc ttest data=sas_proj.yt_append;
    where cluster=3 or cluster=4;
    var d10_1-d10_8;
    class cluster;
run;

/*  */
proc corr data=sas_proj.yt_1;
    var d10_1-d10_8;
run;

/*  */
proc princomp data=sas_proj.yt_s_var;
    var d10_1-d10_8;
run;

/*  */
proc princomp data=sas_proj.yt_s_var out=sas_proj.yt_coord;
    var d10_1-d10_8;
run;

/*  */
data sas_proj.yt_pc_unit; set sas_proj.yt_coord;
    /* if id=1 or id=84; */
run;

/*  */
data sas_proj.yt_coord_1; set sas_proj.yt_coord;
    avgi=mean(of d10_1-d10_8);
run;

/*  */
proc corr data=sas_proj.yt_coord_1;
    var avgi prin1;
run;

/*  */
data sas_proj.sz_unico; set sas_proj.Unico;
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
    label new_1='w_sports';
    label new_2='w_educative';
    label new_3='l_music';
    label new_4='w_vlogs';
    label new_5='w_diy';
    label new_6='w_gaming';
    label new_7='imp_duration';
    label new_8='imp_thumbnail';
run;

/*  */
proc means data=sas_proj.sz_yt min max mean;
    var d10_: new_: ;
run;

/*  */
proc princomp data=sas_proj.sz_yt out=sas_proj.sz_yt_1;
    var new_:; 
run;

/*  */
proc cluster data=sas_proj.sz_yt_1 method=ward outtree=sas_proj.sz_tree;
    var prin1-prin4;
    id id;
run;

/*  */
proc tree data=sas_proj.sz_tree; run;

/*  */
proc tree data=sas_proj.sz_tree noprint nclusters=6 out=sas_proj.sz_cluster;
    id id;
run;

/* Sorting the data before merging */
proc sort data=sas_proj.sz_cluster; by id; run;
proc sort data=sas_proj.sz_yt_1; by id; run;
/* Merging of the data */
data sas_proj.sz_yt_2; merge sas_proj.sz_yt_1 sas_proj.sz_cluster;
    by id;
run;

/* Run the various statistical tests on the newly merged dataset */
proc freq data=sas_proj.sz_yt_2;
    /* All - considers all statistical tests */
    table gender*cluster / expected all;
run;

/* Creation of new fake dataset */
data sas_proj.sz_yt_fake; set sas_proj.sz_yt_2;
    cluster=7;
run;

/* New dataset made of original and fake dataset */
data sas_proj.sz_yt_long; set sas_proj.sz_yt_2 sas_proj.sz_yt_fake;
run;

/* Macro to produce 6 analysis of our 6 clusters */
%macro do_k_cluster;
%do k=1 %to 6;
proc ttest data=sas_proj.sz_yt_long;
    where cluster=&k or cluster=7;
    class cluster;
    var new:;
    /* ttests => name of output test result
    Naming standard increments for each new value (&k)*/
    ods output ttests=sas_proj.cl_ttest_&k (where=(method='Satterthwaite')
    rename=(tvalue=tvalue_&k) rename=(probt=prob_&k));
run;
%end;
%mend do_k_cluster;
%do_k_cluster

data sas_proj.cl_ttest_all;
    merge
    sas_proj.cl_ttest_1
    sas_proj.cl_ttest_2
    sas_proj.cl_ttest_3
    sas_proj.cl_ttest_4
    sas_proj.cl_ttest_5
    sas_proj.cl_ttest_6;
    by variable;
run;

/* Creation of labels - data identity card */
proc contents data=sas_proj.sz_yt_long out=sas_proj.yt_contents;
run;

/* Change dataset column name */
data sas_proj.yt_contents; set sas_proj.yt_contents;
    rename name=variable;
run;

/* Merge column labels from diff tables */
data sas_proj.cl_ttest_all_1;
    merge sas_proj.cl_ttest_all (in=a) sas_proj.yt_contents(in=b);
        by variable;
        if a;
run;