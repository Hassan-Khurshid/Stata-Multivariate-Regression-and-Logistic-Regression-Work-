log close
clear
clear matrix
clear mata	

set mem 500000
set maxvar 32000
set more off
log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\log_GSS1996.log", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018.dta"
*the following line runs the master do file for GSS
do "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Code\code_GSS1972-2018.do.do"
keep if year ==1996 
*or you can write drop if year!=1996
missings dropvars, force
save "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1996.dta", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1996.dta"

tab abscale, miss
sum abdefect_rs-abany_rs
alpha abdefect_rs-abany_rs, item
*since abhlth_rs has cornbach alpha (0.8941) greater than overall alpha (0.8845) so this is dropped to increase overall alpha*
/**** code for 6 item abortion scale 
drop abscale
drop abhlth_rs
egen abscale = rowtotal(abdefect_rs abnomore_rs abpoor_rs-abany_rs), miss
label variable abscale "6 item abortion right scale"
tab abscale, miss
replace abscale = .i if abdefect_rs == .i & abnomore_rs == .i & abpoor_rs == .i & absingle_rs ==.i & abrape_rs ==.i & abany_rs ==.i
replace abscale = .d if abdefect_rs == .d & abnomore_rs == .d & abpoor_rs == .d & absingle_rs ==.d & abrape_rs ==.d & abany_rs ==.d
replace abscale = .n if abdefect_rs == .n & abnomore_rs == .n & abpoor_rs == .n & absingle_rs ==.n & abrape_rs ==.n & abany_rs ==.n
*label define yngss_miss .i "IAP" .d "DK" .n "NA" *this is already defined in master file (just for reference sake)
label values abscale yngss_miss
numlabel yngss_miss, add
sum abscale abdefect_rs abnomore_rs abpoor_rs-abany_rs
sum abscale, detail
tab abscale, miss
list id abscale abdefect_rs abnomore_rs abpoor_rs-abany_rs if missing(abdefect_rs, abnomore_rs, abpoor_rs-abany_rs) in 1/50, nolabel
list id abscale abdefect_rs abnomore_rs abpoor_rs-abany_rs if missing(abrape_rs) & !missing(absingle_rs) in 60000/61000, nolabel
list id abscale abdefect_rs abnomore_rs abpoor_rs-abany_rs if !missing(abdefect_rs, abnomore_rs, abpoor_rs-abany_rs) in 64800/64810, nolabel *****/
alpha abdefect_rs abnomore_rs abpoor_rs-abany_rs, item

*since abrape_rs alpha (0.9056)and abdefect_rs alpha (0.9027)are greater than overall alpha (0.8941), so both of these will be dropped to increase overall alpha*
drop abscale
drop abdefect_rs abrape_rs
egen abscale = rowtotal(abnomore_rs abpoor_rs absingle_rs abany_rs), miss
label variable abscale "4 item abortion right scale"
tab abscale, miss
replace abscale = .i if abnomore_rs == .i & abpoor_rs == .i & absingle_rs ==.i & abany_rs ==.i
replace abscale = .d if abnomore_rs == .d & abpoor_rs == .d & absingle_rs ==.d & abany_rs ==.d
replace abscale = .n if abnomore_rs == .n & abpoor_rs == .n & absingle_rs ==.n & abany_rs ==.n
*label define yngss_miss .i "IAP" .d "DK" .n "NA" *this is already defined in master file (just for reference sake)
label values abscale yngss_miss
numlabel yngss_miss, add
sum abscale abnomore_rs abpoor_rs absingle_rs abany_rs
sum abscale, detail
tab abscale, miss
list id abscale abnomore_rs abpoor_rs absingle_rs abany_rs if missing(abnomore_rs, abpoor_rs, absingle_rs, abany_rs) in 1/50, nolabel
list id abscale abnomore_rs abpoor_rs absingle_rs abany_rs if missing(absingle_rs) & !missing(abpoor_rs) in 1000/1500, nolabel
list id abscale abnomore_rs abpoor_rs absingle_rs abany_rs if !missing(abnomore_rs, abpoor_rs, absingle_rs, abany_rs) in 1000/1050, nolabel
alpha abnomore_rs abpoor_rs absingle_rs abany_rs, item

