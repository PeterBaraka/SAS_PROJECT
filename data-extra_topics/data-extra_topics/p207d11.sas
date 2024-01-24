data charity;
   set orion.employee_donations;
   keep employee_id qtr1-qtr4; 
   array Contrib{4} qtr1-qtr4;
   do i=1 to 4;        
      Contrib{i}=Contrib{i}*1.25;
   end; 
run; 

proc print data=charity noobs;
run;

data charity2;
   set orion.employee_donations;
   keep Employee_ID Qtr1-Qtr4; 
   array Contrib Qtr1-Qtr4;
   do over Contrib;        
      Contrib=Contrib*1.25;
   end; 
run;

proc print data=charity2 noobs;
run;
