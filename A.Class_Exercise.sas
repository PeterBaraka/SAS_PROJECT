/* Set output dataset as select attributes to print using KEEP statment, 
DROP statemnt removes unwanted attributes*/
DATA work.delays(keep=Employee_ID Customer_ID Order_Date Delivery_Date Order_Month);
    /* SET statement adds input dataset*/
    SET orion.orders;
    /* Assign permanent labels */
    LABEL Customer_ID = 'Customer ID'
          Employee_ID = 'Employee ID'
          Order_Date = 'Date Ordered'
          Delivery_Date = 'Date Delivered'
          Order_Month = 'Month Ordered';
    /* Assign formats to variables */
    FORMAT Order_Date Delivery_Date MMDDYY10.;
    FORMAT Customer_ID Employee_ID 12.;
    /* Filter by Employee_ID */
    WHERE Employee_ID = 99999999;
    /* Filter using IF */
    IF Delivery_Date > Order_Date + 4 AND Order_Month = 8;
RUN;

/* Print metadata */
PROC CONTENTS DATA=work.delays;
RUN;