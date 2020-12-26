**** Made in Assignment 4 Q1 ****

log close
clear
clear matrix
clear mata	

set mem 500000
set maxvar 32000
set more off
log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\logGSS2018.log", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018.dta"
*the following line runs the master do file for GSS
do "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Code\code_GSS1972-2018.do.do"
keep if year ==2018 
*or you can write drop if year!=2018
missings dropvars, force
save "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2018.dta", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2018.dta"

sum suicide1 suicide2 suicide3 suicide4
tab1 suicide1 suicide2 suicide3 suicide4, miss
gen suicide1r = suicide1
gen suicide2r =suicide2
gen suicide3r =suicide3
gen suicide4r =suicide4
recode suicide1r suicide2r suicide3r suicide4r (2=0)
label variable suicide1r "suicide OK if incurable disease"
label variable suicide2r "suicide OK if bankrupt"
label variable suicide3r "suicide OK if dishonored family"
label variable suicide4r "suicide OK if tired of living"
*label define yngss 1 "yes" 0 "no" .d "DK" .i "IAP" .n "NA" .c "can't choose"  This is already defined so don't run this 
label values suicide1r-suicide4r yngss
numlabel yngss, add force
tab suicide1 suicide1r, miss
tab suicide2 suicide2r, miss
tab suicide3 suicide3r, miss
tab suicide4 suicide4r, miss
tab1 suicide1 suicide1r, miss
tab1 suicide2 suicide2r, miss
tab1 suicide3 suicide3r, miss
tab1 suicide4 suicide4r, miss

/***** code for 4-item suicide scale
egen suicide_scale = rowtotal(suicide1r-suicide4r), miss
label variable suicide_scale "4 item scale for suicide rights"
replace suicide_scale = .d if suicide1r == .d & suicide2r == .d & suicide3r ==.d & suicide4r ==.d 
replace suicide_scale =.i if suicide1r == .i & suicide2r == .i & suicide3r ==.i & suicide4r ==.i
replace suicide_scale =.n if suicide1r == .n & suicide2r == .n & suicide3r ==.n & suicide4r ==.n
label define em .d "DK" .i "IAP" .n "NA" .c "can't choose"
label values suicide_scale em
numlabel em, add force
sum suicide_scale, detail
tab suicide_scale, miss
list suicide_scale suicide1r-suicide4r if !missing(suicide1r-suicide4r) in 1/150, nolabel
list suicide_scale suicide1r-suicide4r if missing(suicide2r) & !missing(suicide1r) in 1/150, nolabel
list suicide_scale suicide1r-suicide4r if missing(suicide1r-suicide4r) in 1/150, nolabel******/
alpha suicide1r-suicide4r, item

*since suicide1r has a cronbach alpha (0.8742) much higher than overall (0.7742), so it is dropped* 
/****code for 3-item suicide scale
drop suicide1r
egen suicide_scale = rowtotal(suicide2r-suicide4r), miss
label variable suicide_scale "3-item scale for suicide rights"
replace suicide_scale = .d if suicide2r == .d & suicide3r ==.d & suicide4r ==.d 
replace suicide_scale =.i if suicide2r == .i & suicide3r ==.i & suicide4r ==.i
replace suicide_scale =.n if suicide2r == .n & suicide3r ==.n & suicide4r ==.n
label define em .d "DK" .i "IAP" .n "NA" .c "can't choose" 
label values suicide_scale em
numlabel em, add force
sum suicide_scale, detail
tab suicide_scale, miss
sum suicide_scale suicide2r-suicide4r
list suicide_scale suicide2r-suicide4r if !missing(suicide2r-suicide4r) in 1/150, nolabel
list suicide_scale suicide2r-suicide4r if missing(suicide2r) & !missing(suicide4r) in 1/150, nolabel
list suicide_scale suicide2r-suicide4r if missing(suicide2r-suicide4r) in 1/150, nolabel
alpha suicide2r-suicide4r, item*****/
alpha suicide2r-suicide4r

*now suicide4r has a cronbach alpha (0.9053)much higher than the new overall (0.8742), so it will be dropped*
drop suicide4r
egen suicide_scale = rowtotal(suicide2r-suicide3r), miss
label variable suicide_scale "2-item scale for suicide rights"
replace suicide_scale = .d if suicide2r == .d & suicide3r ==.d 
replace suicide_scale =.i if suicide2r == .i & suicide3r ==.i 
replace suicide_scale =.n if suicide2r == .n & suicide3r ==.n 
label define em .d "DK" .i "IAP" .n "NA" .c "can't choose" 
label values suicide_scale em
numlabel em, add force
sum suicide_scale, detail
tab suicide_scale, miss
sum suicide_scale suicide2r-suicide3r
list suicide_scale suicide2r-suicide3r if !missing(suicide2r-suicide3r) in 1/150, nolabel
list suicide_scale suicide2r-suicide3r if missing(suicide2r) & !missing(suicide3r) in 1/1000, nolabel
list suicide_scale suicide2r-suicide3r if missing(suicide2r-suicide3r) in 1/150, nolabel

alpha suicide2r-suicide3r, item

*Now limiting the edited scale to include only valid data 
mvpatterns suicide2r-suicide3r, sort
egen nmiss_suicide_scale = rmiss2(suicide2r-suicide3r)
label variable nmiss_suicide_scale "Count for different number of missing variables for 2-item suicide scale"
tab nmiss_suicide_scale, miss
tab suicide_scale, miss
replace suicide_scale =.a if nmiss_suicide_scale >0 & nmiss_suicide_scale <=2
tab suicide_scale
tab suicide_scale, miss
sum suicide_scale, detail


/*PS10 Qs1
Please create a new variable (bmi2018) based on the formula/techniques we used in the Advanced Recoding and Computing Lab. Please submit:
a.	Frequencies on the new variable (show only first and last ~10 rows of output)
b.	Extended descriptives on the new variable
c.	Appropriate consistency check (for two input variables and one output variable). Show only 5-10 cases. NOTE: Only check the scenario for no missing values on any variable; no need to check the other two scenarios */

tab1 weight height, miss
gen bmi2018 = (weight/((height*height))) * 703
label variable bmi2018 "2018-BMI"
replace bmi2018= .d if weight== .d & height == .d
replace bmi2018= .n if weight== .n & height == .n
replace bmi2018= .i if weight== .i & height == .i
label define bmimiss .i "IAP" .d "don’t know" .n "no answer"
label values bmi2018 bmimiss
numlabel bmimiss, add
tab bmi2018, miss
fre bmi2018, tabulate(6)
sum bmi2018, detail
list bmi2018 height weight if !missing(bmi2018) & !missing(height) & !missing(weight) in 1/10, nolabel

/*2. Please round both bmi2018 and sei10 into new variables (bmi2018rd and sei10rd). Submit:
a.	extended descriptives for the original and recoded variables
b.	your code for the whole question */

gen bmi2018rd = round(bmi2018, 1)
label variable bmi2018rd "BMI rounded to whole number"
label values bmi2018rd bmimiss
numlabel bmimiss, add force
list bmi2018 bmi2018rd in 1/10, nolabel
sum bmi2018 bmi2018rd, detail
gen sei10rd = round(sei10, 1)
label variable sei10rd "SEI rounded to whole number"
list sei10 sei10rd in 1/10, nolabel
sum sei10 sei10rd, detail
*Qs3b*
tab1 bmi2018rd age4cat sex race_eth region4cat, miss
fre sei10rd, tabulate(6)
*Qs3c*
sum bmi2018rd age4cat sex race_eth region4cat sei10rd
mdesc bmi2018rd age4cat sex race_eth region4cat sei10rd
mvpatterns bmi2018rd age4cat sex race_eth region4cat sei10rd
tab bmi2018rd age4cat, miss
tab bmi2018rd  sex, miss
fre height weight, tabulate(6)
recode height (min/60 =1) (61/81 =2), gen(new_height)
recode weight (min/150 =1) (151/395 =2), gen(new_weight)
tab1 new_height new_weight, miss
tab new_height new_weight, miss
*Qs3d*
mark bmi2018rd_flag
markout bmi2018rd_flag bmi2018rd age4cat sex race_eth region4cat sei10rd
label variable bmi2018rd_flag "Analtical flag for 2018 BMI N= 1357"
tab bmi2018rd_flag, miss
*Qs3e*
histogram bmi2018rd if bmi2018rd_flag ==1, freq
histogram sei10rd if bmi2018rd_flag ==1, freq
sum sei10rd bmi2018rd if bmi2018rd_flag == 1, detail
fre sei10rd if bmi2018rd_flag == 1, tabulate(10)
fre bmi2018rd if bmi2018rd_flag  ==1, tabulate(10)
*Qs3f - bottomcoding*
gen bmi2018rd_bc = bmi2018rd
replace bmi2018rd_bc = 19 if bmi2018rd <= 19
label variable bmi2018rd_bc "2018 BMI back-coding at 19 or less"
label define bmi2018rd_bc .i "IAP" .n "no answer" .d "don't know" 19 "19 or less"
label values bmi2018rd_bc bmi2018rd_bc
numlabel bmi2018rd_bc, add
fre bmi2018rd_bc if bmi2018rd_flag ==1, tabulate(10)
sum bmi2018rd_bc bmi2018rd if bmi2018rd_flag ==1, detail
*Qs3f - Topcoding*
recode sei10rd (92/93= 92), gen(sei10rd_tc)
label variable sei10rd_tc "socio-economic index, top coded at 92 and above"
label define sei10rd_tc  92 "92 or more index number"
label values sei10rd_tc sei10rd_tc  
numlabel sei10rd_tc, add
fre sei10rd_tc if bmi2018rd_flag == 1, tabulate(10)
sum sei10rd_tc sei10rd if bmi2018rd_flag == 1
*regressing and storing for table*
regress bmi2018rd_bc i.age4cat if bmi2018rd_flag == 1 
estimates store mod1
regress bmi2018rd_bc i.age4cat ib2.sex i.race_eth ib3.region4cat if bmi2018rd_flag == 1, beta 
estimates store mod2
regress bmi2018rd_bc i.age4cat ib2.sex i.race_eth ib3.region4cat sei10rd_tc if bmi2018rd_flag == 1, beta 
estimates store mod3

esttab mod1 mod2 mod3, varwidth(40) label b(%6.3f) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_a p) compress nogaps not ///
title("Multivariate OLS Models Predicting Socioeconomic Index Based on Marital Status and Sociodemographic Characteristics, 2010 General Social Survey") ///
mtitle("Model 1" "Model 2" "Model 3")

esttab mod1 mod2 mod3, varwidth(40) label b(%6.3f) beta star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_a p) compress nogaps not ///
title("Multivariate OLS Models Predicting Socioeconomic Index Based on Marital Status and Sociodemographic Characteristics, 2010 General Social Survey") ///
mtitle("Model 1" "Model 2" "Model 3")
