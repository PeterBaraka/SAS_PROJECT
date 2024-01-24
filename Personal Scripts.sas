/* Describes the data*/
proc contents data=library_name.dataset;
run;

/* Setting a library name*/
libname lib_name "library path";

/* Select and Print data*/
proc print data=library_name.dataset;
    /**column selection**/
    var column1, column2, columnN;
    /* Operations */
    sum variable;
    /* Filter/Conditional Select */
    where condition_name;
run;

/* Select and Print data - Supress observation output*/
proc print data=library_name.dataset noobs;
run;

/* SAS Logical Operator syntax
& - AND - are both conditions true?
| - OR - is either condition true?
^ or ~ - NOT - reverse the logic of a comparison
BETWEEN ... AND ... - Limits data to particular selection
*/

/* Sorting data - Default - DESC */
proc sort data=library_name.dataset
    /* Out prevents overwriting of original dataset */
    out=new_output_dataset;
    by column_name;
run;

/* Include the name of the library where the datasets are stored */
libname orion "C:\Users\bbsstudent\Desktop\Data"


/* Do group statement syntax */
if condition then do;
statment1;
statement2;
end;