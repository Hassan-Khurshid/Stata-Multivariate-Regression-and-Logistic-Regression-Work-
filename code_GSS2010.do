* made as Assignment8's requirement in Qs1*
log close
clear
clear matrix
clear mata	

set mem 500000
set maxvar 32000
set more off
set showbaselevels on, perm
log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\logGSS2010.log", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018.dta"
*the following line runs the master do file for GSS
do "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Code\code_GSS1972-2018.do.do"
keep if year ==2010
*or you can write drop if year!=2010
missings dropvars, force
save "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2010.dta", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2010.dta"

*Assignment 8 Qs1*
tab1 conrinc race_eth sex suprvsjb, miss
fre educ age weekswrk, tabulate(4)
mark conrinc_flag
markout conrinc_flag conrinc educ race_eth sex weekswrk suprvsjb
label variable conrinc_flag "analytic flag for income in constant dollars - conrinc(N =963)"
tab conrinc_flag, miss
regress conrinc educ if conrinc_flag == 1
regress conrinc educ i.race_eth age i.sex if conrinc_flag == 1, beta 
regress conrinc educ i.race_eth age i.sex weekswrk i.suprvsjb if conrinc_flag == 1, beta

*PS10 Socio Economic Example - Putting it all together - the steps*
tab1 sei10 marstat sex race_eth region4cat health, miss
fre age weekswrk, tabulate(8)
sum sei10 marstat age sex race_eth region4cat health weekswrk
mdesc sei10 marstat age sex race_eth region4cat health weekswrk
mvpatterns sei10 marstat age sex race_eth region4cat health weekswrk
mark sei10_flag
markout sei10_flag sei10 marstat age sex race_eth region4cat health weekswrk
label variable sei10_flag "flag for 2010 SEI analyses (N=1204)"
tab sei10_flag, miss
histogram sei10 if sei10_flag ==1 ,freq
histogram weekswrk if sei10_flag ==1 ,freq
tab sei10 if sei10_flag ==1, miss
tab weekswrk if sei10_flag == 1, miss
sum sei10 weekswrk if sei10_flag == 1, detail
regress sei10 i.marstat if sei10_flag == 1 
estimates store mod1
regress sei10 i.marstat age i.sex if sei10_flag == 1, beta 
estimates store mod2
regress sei10 i.marstat age i.sex i.race_eth i.region4cat if sei10_flag == 1, beta 
estimates store mod3
regress sei10 i.marstat age i.sex i.race_eth i.region4cat i.health weekswrk if sei10_flag == 1, beta 
estimates store mod4 

esttab mod1 mod2 mod3 mod4, varwidth(40) label b(%6.3f) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_a p) compress nogaps not ///
title("Multivariate OLS Models Predicting Socioeconomic Index Based on Marital Status and Sociodemographic Characteristics, 2010 General Social Survey") ///
mtitle("Model 1" "Model 2" "Model 3" "Model 4")

esttab mod1 mod2 mod3 mod4, varwidth(40) label b(%6.3f) beta star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_a p) compress nogaps not ///
title("Multivariate OLS Models Predicting Socioeconomic Index Based on Marital Status and Sociodemographic Characteristics, 2010 General Social Survey") ///
mtitle("Model 1" "Model 2" "Model 3" "Model 4")

*********************************** LOGISTIC REGRESSION ************************************************
tab pres08, miss
recode pres08 (2 3 4 = 0), gen(obama08)
label variable obama08 "Dummy for voted for Obama in 2008"
label values obama08 yngss
numlabel yngss, add
tab1 pres08 obama08, miss
tab pres08 obama08, miss
logistic obama08 i.race_eth

/* tab relig, miss
gen relig5cat = relig
recode relig5cat (1 10 11=1) (2=2) (6/9=3) (4=4) (3 5 12 13=5) (.d=.d) (.n=.n)
label variable relig5cat "recoded relig affiliation"
label define relig5cat 1 "Protestant" 2 "Catholic" 3 "Buddh/Hindu/Moslem or Islam/Other Eastern" 4 "none" 5 "other" .d "DK" .n "NA"
label values relig5cat relig5cat
numlabel relig5cat, add
tab relig5cat, miss
tab relig relig5cat, miss */

logistic obama08 ib4.relig5cat

mark obama08_flag
markout obama08_flag obama08 race_eth sex age4cat educ4cat conrinc10k
label variable obama08_flag "flag for Obama08 logistic regression models (N=810)"
tab obama08_flag, miss

logistic obama08 i.race_eth if obama08_flag == 1
estimates store obamamod1
logistic obama08 i.race_eth i.sex i.age4cat if obama08_flag == 1
estimates store obamamod2
logistic obama08 i.race_eth i.sex i.age4cat ib4.educ4cat if obama08_flag == 1
estimates store obamamod3
logistic obama08 i.race_eth i.sex i.age4cat ib4.educ4cat conrinc10k if obama08_flag == 1
estimates store obamamod4

esttab obamamod1 obamamod2 obamamod3 obamamod4, eform varwidth(40) label b(%6.3f) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_p p) compress nogaps not ///
title(Multivariate Binary Logistic Regression Models Predicting Voting for Obama in 2008 Based on Race/Ethnicity and Sociodemographic Characteristics, 2010 General Social Survey) ///
mtitle("Model 1" "Model 2" "Model 3" "Model 4")


************************ PS12 ************************************************************
/*Please run a series of nested multivariate binary logistic regression models to predict whether or not someone is prochoice (use input variable: abany) based on: 
Model 1: race/ethnicity (race_eth, ref=NH White)
Model 2: Model 1 + sex (sex, ref=women) + age in categories (age4cat, ref=65+)
Model 3: Model 2 + education in categories (educ4cat, ref=bachelor’s degree or more) 
Model 4: Model 3 + political views (polviews, keep as ordinal, treat as interval-ratio when running and interpreting regression) + region (region4cat, ref=Northeast (New Engl and Mid Atl)) */

recode abany (2=0), gen(prochoice)
label variable prochoice "Dummy for whether or not someone is prochoice" 
label values prochoice yngss
numlabel yngss, add
tab prochoice, miss

tab1 prochoice race_eth sex age4cat educ4cat, miss
fre polviews, tabulate(10)
sum prochoice  race_eth sex age4cat educ4cat polviews
mdesc prochoice  race_eth sex age4cat educ4cat region4cat polviews
mvpatterns prochoice  race_eth sex age4cat educ4cat region4cat polviews 
mark prochoice_flag
markout prochoice_flag prochoice  i.race_eth ib2.sex ib4.age4cat ib4.educ4cat polviews i.region4cat 
label variable prochoice_flag "analytical flag for abortion opinion (n=1186)"
tab prochoice_flag, miss

logistic prochoice i.race_eth if prochoice_flag == 1
estimates store prochoice1
logistic prochoice  i.race_eth ib2.sex ib4.age4cat if prochoice_flag == 1
estimates store prochoice2
logistic prochoice i.race_eth ib2.sex ib4.age4cat ib4.educ4cat if prochoice_flag == 1
estimates store prochoice3
logistic prochoice  i.race_eth ib2.sex ib4.age4cat ib4.educ4cat polviews i.region4cat if prochoice_flag == 1
estimates store prochoice4

esttab prochoice1 prochoice2 prochoice3 prochoice4, eform varwidth(40) label b(%6.3f) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_p p) compress nogaps not ///
title(Multivariate Binary Logistic Regression Models Predicting Prochoice for abortions based on Race/Ethnicity and Sociodemographic Characteristics and political-views, 2010 General Social Survey) ///
mtitle("Model 1" "Model 2" "Model 3" "Model 4")

