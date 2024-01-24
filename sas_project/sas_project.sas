LIBNAME sas_proj 'C:\Users\bbsstudent\Desktop\YouTube_Project';

proc import 
   datafile="C:\Users\bbsstudent\Desktop\YouTube_Project\yt_s_var.csv" 
   out=sas_proj.yt_s_var
   dbms=csv
   replace;
run;

proc print data=sas_proj.yt_s_var;
run;

proc cluster data=sas_proj.yt_s_var method=ward;
    var d10_1-d10_8;
run;

proc tree;
run;

proc cluster data=sas_proj.yt_s_var method=ward outtree=sas_proj.tree noprint;
        id id;
        var d10_1-d10_8;
run;

proc tree data=sas_proj.yt_s_var ncl=3 out=sas_proj.cluster noprint; 
    id id;
run;