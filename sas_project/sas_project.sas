LIBNAME sas_proj 'C:\Users\bbsstudent\Desktop\YouTube_Project';

proc import 
   datafile="C:\Users\bbsstudent\Desktop\YouTube_Project\yt_s.csv" 
   out=sas_proj.yt_s
   dbms=csv
   replace;
run;

proc print data=sas_proj.yt_s;
run;

proc cluster data=sas_proj.yt_s method=single;
    var 'age'-'content_quality';
run;

proc tree;
run;