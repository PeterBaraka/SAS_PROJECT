proc format;
   value Tiers low-25000='Tier1'
	         25000<-50000='Tier2'
	        50000<-100000='Tier3'
			   100000<-high='Tier4';
run;

proc freq data=orion.sales;
  	tables Salary;
	format Salary Tiers.;
run;
