sysuse nlsw88
* you can either use sysuse or you can utilize 'use/save/use' method
log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\log_nlsw88.log", replace
numlabel, add
gen race_copy = race
label variable race_copy "Race of Respondents"
label define newrace 1 "White" 2 "Black" 3 "Other Race"  /* if you want to modify
then execute this line: label define newrace 1 "White" 2 "Black" 3 "Other Race", modify
and then remove modify from the do file after executing this line */  
label values race_copy newrace
numlabel newrace, add
tab race_copy