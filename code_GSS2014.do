* Made from Lab 4 *
log close
clear
clear matrix
clear mata	

set mem 500000
set maxvar 32000
set more off
log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\log_GSS2014.log", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018.dta"
*the following line runs the master do file for GSS
do "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Code\code_GSS1972-2018.do.do"
keep if year ==2014 
*or you can write drop if year!=2014
missings dropvars, force
save "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2014.dta", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2014.dta"
set showbaselevels on, perm

tab1 confinan_rev-conarmy_rev, miss
sum confinan_rev-conarmy_rev
tab inst_conf_scale, miss

alpha confinan_rev-conarmy_rev, item
mvpatterns confinan_rev-conarmy_rev, sort
egen nmiss_inst_conf_scale = rmiss2(confinan_rev-conarmy_rev)
label variable nmiss_inst_conf_scale "#of missing variables/cases for 13 item inst_conf_scale"
tab nmiss_inst_conf_scale, miss
replace inst_conf_scale =. if nmiss_inst_conf_scale >=2 & !missing(nmiss_inst_conf_scale)

*Final Checks*
tab inst_conf_scale, miss
sum inst_conf_scale, detail

/*creating bmi2014 variable*
Create an interval-ratio variable (bmi2014) that combines 2014 weight (weight) and 2014 height (height) using the formula we learned in the Advanced Recoding and Computing lab. Carry over the extended missing values to bmi2014 (.i/IAP, .d/don’t know, .n=no answer) only if each value is the same across weight and height. Otherwise, allow those cases to default to system-missing on the new variable. Please note that these variables are only available in the 2014 wave. Please submit: */

tab1 weight height, miss
gen bmi2014 = (weight/((height*height))) * 703
label variable bmi2014 "2014-BMI"
replace bmi2014= .d if weight== .d & height == .d
replace bmi2014= .n if weight== .n & height == .n
replace bmi2014= .i if weight== .i & height == .i
label define bmimiss .i "IAP" .d "don’t know" .n "no answer"
label values bmi2014 bmimiss
numlabel bmimiss, add
tab bmi2014, miss
sum bmi2014, detail

*Age in years (age)*
tab1 bmi2014 age, miss
regress bmi2014 age

*Number of days of poor physical health in the past month (physhlth)
tab1 bmi2014 physhlth, miss
regress bmi2014 physhlth

*Number of hours per week on the internet (wwwhr)
tab1 bmi2014 wwwhr, miss
regress bmi2014 wwwhr

*Sex (sex – use women as the reference category/base level)
tab1 bmi2014 sex, miss
regress bmi2014 ib2.sex

*Nativity status (born– use those born in the U.S. as the reference category)
tab1 bmi2014 born, miss
regress bmi2014 i.born

*Self-rated health (health – use “excellent” as the reference category)
tab1 bmi2014 health, miss
regress bmi2014 i.health

*Race/ethnicity (race_eth) - use “Hispanic” as the reference category
tab1 bmi2014 race_eth, miss
regress bmi2014 ib3.race_eth

tab1 physhlth sex educ health, miss
fre bmi2014 age conrinc, tabulate(4)
regress physhlth bmi2014

* PS10 Example 1* 
tab1 physhlth sex health, miss 
fre bmi2014 age educ conrinc, tabulate(6) 
mark physhlth_flag
markout physhlth_flag sex health bmi2014 age educ conrinc
label variable physhlth_flag "analytic flag for # of poor physical health days - physhlth(N =677)"
tab physhlth_flag, miss
histogram physhlth if physhlth_flag == 1, freq
tab physhlth if physhlth_flag == 1, miss
sum physhlth if physhlth_flag == 1, detail
*Top coding at 95th Percentile*
gen physhlth_95tc = physhlth
recode physhlth_95tc (12/30=12)
label variable physhlth_95tc "# poor phys hlth days, tc at 95th %ile (12+ days)"
label define physhlth_95tc 12 "12 or more days"
label values physhlth_95tc physhlth_95tc
numlabel physhlth_95tc, add
*running two consistency checks*
tab1 physhlth_95tc physhlth if physhlth_flag == 1, miss
sum physhlth physhlth_95tc if physhlth_flag == 1
regress physhlth_95tc bmi2014 if physhlth_flag == 1
regress physhlth_95tc bmi2014 age i.sex if physhlth_flag == 1, beta
regress physhlth_95tc bmi2014 age i.sex educ conrinc if physhlth_flag == 1, beta
regress physhlth_95tc bmi2014 age i.sex educ conrinc i.health if physhlth_flag == 1, beta
*Top coding at 20 plus days*
recode physhlth (20/30 = 20), gen(physhlth_20pl)
label variable physhlth_20pl "# of Poor Phys Health days, tc at 20 plus days"
label define physhlth_20pl 20 "20 or more days"
label values physhlth_20pl physhlth_20pl
numlabel physhlth_20pl, add
*running two consistency checks*
tab1 physhlth_20pl physhlth if physhlth_flag == 1, miss
sum physhlth_20pl physhlth if physhlth_flag == 1
regress physhlth_20pl bmi2014 if physhlth_flag == 1
regress physhlth_20pl bmi2014 age i.sex if physhlth_flag == 1, beta
regress physhlth_20pl bmi2014 age i.sex educ conrinc if physhlth_flag == 1, beta
regress physhlth_20pl bmi2014 age i.sex educ conrinc i.health if physhlth_flag == 1, beta
*Top coding at 7 plus days*
recode physhlth (7/30 = 7), gen(physhlth_7pl)
label variable physhlth_7pl "# of Poor Phys Health days, tc at 7 plus days"
label define physhlth_7pl 7 "7 or more days"
label values physhlth_7pl physhlth_7pl 
numlabel physhlth_7pl, add
*running two consistency checks*
tab1 physhlth_7pl physhlth if physhlth_flag == 1, miss
sum physhlth_7pl physhlth if physhlth_flag == 1

* PS10 Example 2*
histogram bmi2014 if physhlth_flag == 1, freq
tab bmi2014 if physhlth_flag ==1, miss
sum bmi2014 if physhlth_flag ==1, detail

gen bmi2014_rd = round(bmi2014, 1)
label variable bmi2014_rd "BMI rounded to whole number”
list bmi2014 bmi2014_rd in 1/50, nolabel
gen bmi2014rd_bc = bmi2014_rd
replace bmi2014rd_bc = 19 if bmi2014_rd <=19 
* or you can use: recode bmi2014rd_bc (min/19=19)* 
label variable bmi2014rd_bc "2014 BMI bc at 19.0 or less"
label define bmi2014rd_bc .i "IAP" .n "no answer" .d "don't know" 19 "19 or less”
label values bmi2014rd_bc bmi2014rd_bc 
numlabel bmi2014rd_bc, add
tab1 bmi2014_rd bmi2014rd_bc, miss
*regressing with rescaled income variable to get meaningful coefficient of it*
regress physhlth bmi2014 if physhlth_flag == 1
regress physhlth bmi2014 age i.sex if physhlth_flag == 1, beta
regress physhlth bmi2014 age i.sex educ conrinc10k if physhlth_flag == 1, beta
regress physhlth bmi2014 age i.sex educ conrinc10k i.health if physhlth_flag == 1, beta


****************************************** PS13********************************************************
* creating ordinal variabel for bmi
tab bmi2014, miss
recode bmi2014 (min/18.5 = 1) (18.5/25 =2) (25/30 =3) (30/68 =4), gen(bmi4cat)
label variable bmi4cat "BMI Ordinal Classification"
label define bmi 1 "Underweight" 2 "Optimal" 3 "Overweight" 4 "Obese"
label values bmi4cat bmi
numlabel bmi, add
tab bmi4cat, miss

mark bmi4cat_flag
markout bmi4cat_flag bmi4cat region4cat sex age conrinc10k educ
label variable bmi4cat_flag "flag for ologit bmi4cat model series (N=1,031)"
tab bmi4cat_flag, miss

* Bottom coding at $554.25 and top coding at $10346 conrinc10k into conrinc10ktcbc:
tab conrinc10k, miss
recode conrinc10k (min/0.55425 = 0.55425) (10.346/16 =10.346), gen(conrinc10ktcbc)
label variable conrinc10ktcbc "Back code and top coded version of conrinc10k"
tab conrinc10ktcbc if bmi4cat_flag == 1, miss

*bottom coding educ variable to educbc8 at 8 years or less
tab educ, miss
recode educ (0/8 = 8), gen(educbc8)
label variable educbc8 "backcoded version of educ at 8 years or less"
label define educbc 8 "8 years or less"
label values educbc educbc8 
numlabel educbc, add
tab educbc8 if bmi4cat_flag ==1, miss
tab educ educbc8, miss

ologit bmi4cat i.region4cat if bmi4cat_flag == 1, or
ologit bmi4cat i.region4cat i.sex if bmi4cat_flag == 1, or
ologit bmi4cat i.region4cat i.sex age if bmi4cat_flag == 1, or
ologit bmi4cat i.region4cat i.sex age conrinc10ktcbc educbc8 if bmi4cat_flag == 1, or

ologit bmi4cat i.region4cat if bmi4cat_flag == 1, or
estimates store bmiologit1
ologit bmi4cat i.region4cat i.sex if bmi4cat_flag == 1, or
estimates store bmiologit2
ologit bmi4cat i.region4cat i.sex age if bmi4cat_flag == 1, or
estimates store bmiologit3
ologit bmi4cat i.region4cat i.sex age conrinc10ktcbc educbc8 if bmi4cat_flag == 1, or
estimates store bmiologit4


esttab bmiologit1 bmiologit2 bmiologit3 bmiologit4, eform varwidth(30) label b(%6.4f) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_p p) compress nogaps not ///
title("Multivariate Ordinal Logistic Regression Models" "Predicting BMI Quartile Based on Region and Sociodemographic Characteristics," "2014 General Social Survey") ///
mtitle("Model 1" "Model 2" "Model 3" "Model 4")

* creating ordinal variable for sei10
tab sei10, miss
sum sei10, detail
gen sei10q = sei10
label variable sei10q "sei10 in quartiles"
recode sei10q (min/25.1=1) (25.2/39.6=2) (39.7/64.1=3) (64.2/max=4)
label define sei10q 1 "0-24th percentile" 2 "25th to 49th percentile" 3 "50th to 74th percentile" 4 "75th percentile and higher" .i "IAP, DK, NA, uncodeable"
label values sei10q sei10q
numlabel sei10q, add
tab sei10 sei10q, miss
tab sei10q, miss
tab sei10q

mark sei10q_flag
markout sei10q_flag sei10q race_eth region4cat marstat age
label variable sei10q_flag "flag for ologit sei10q model series (N=2,414)"
tab sei10q_flag, miss

