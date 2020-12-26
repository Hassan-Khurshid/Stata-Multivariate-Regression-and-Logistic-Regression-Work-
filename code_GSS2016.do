*made in asignment 5*
log close
clear
clear matrix
clear mata	

set mem 500000
set maxvar 32000
set more off
log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\logGSS2016.log", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018.dta"
*the following line runs the master do file for GSS
do "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Code\code_GSS1972-2018.do.do"
keep if year ==2016 
*or you can write drop if year!=2016
missings dropvars, force
save "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2016.dta", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS2016.dta"


******************************Assignment 5**************************************************************
*Institutional confidence scale (inst_conf_scale) and sex (sex)
tab1 inst_conf_scale sex, miss
sum inst_conf_scale if sex ==1, detail
sum inst_conf_scale if sex ==2, detail
ttest inst_conf_scale, by(sex)



/*Create a “government responsibility” scale with the following items: jobsall, pricecon, hlthcare, aidold, aidindus, aidunemp, equalize, aidcol, aidhouse, and grnlaws (note: recode and reverse-scale as/if needed; new variables should be named govresp1-govresp10🡪 gov_resp_scale). Retain the extended missing values on the new variables and overall scale. Remember to follow the Principles of Good Scale Construction (see Lab 3 and Principles of Good Scale Construction Worksheet). Please submit the following output: */

tab1 jobsall pricecon hlthcare aidold aidindus aidunemp equalize aidcol aidhouse grnlaws, miss
gen govresp1= jobsall
gen govresp2= pricecon
gen govresp3= hlthcare
gen govresp4= aidold
gen govresp5= aidindus
gen govresp6= aidunemp
gen govresp7= equalize
gen govresp8= aidcol
gen govresp9= aidhouse
gen govresp10=grnlaws
label define resp_rev 0 "defin should not be" 1 "prob should not be" 2 "probab should be" 3 "defin should be" .c "can't choose" .i "IAP" .n "NA"
recode govresp1-govresp10  (4= 0) (3=1) (2=2) (1=3)
numlabel resp_rev, add
label values govresp1 govresp2 govresp3 govresp4 govresp5 govresp6 govresp7 govresp8 govresp9 govresp10 resp_rev 
label variable govresp1 "Providing Jobs for all"
label variable govresp2 "Keeping prices in check"
label variable govresp3 "Providing health care for sick"
label variable govresp4 "Providing for the elderly"
label variable govresp5 "Assisting Industrial Growth"
label variable govresp6 "Provide for unemployed"
label variable govresp7 "Reduce income differences"
label variable govresp8 "Assist low income college student"
label variable govresp9 "Provide housing for poor"
label variable govresp10 "Make industry less damaging"
tab1 govresp1 jobsall, miss
tab1 govresp2 pricecon, miss
tab1 govresp3 hlthcare, miss
tab1 govresp4 aidold, miss
tab1 govresp5 aidindus, miss
tab1 govresp6 aidunemp, miss
tab1 govresp7 equalize, miss
tab1 govresp8 aidcol, miss
tab1 govresp9 aidhouse, miss
tab1 govresp10 grnlaws, miss
egen gov_resp_scale = rowtotal(govresp1-govresp10), miss
label variable gov_resp_scale "10 Item Scale of Government's Responsibilities"
replace gov_resp_scale = .n if govresp1 == .n & govresp2 == .n & govresp3 == .n & govresp4 == .n & govresp5 == .n & govresp6== .n & govresp7 == .n & govresp8== .n & govresp9==.n & govresp10==.n 
replace gov_resp_scale = .i if govresp1 == .i & govresp2 == .i & govresp3 == .i & govresp4 == .i & govresp5 == .i & govresp6== .i & govresp7 == .i & govresp8== .i & govresp9==.i & govresp10==.i 
replace gov_resp_scale = .c if govresp1 == .c & govresp2 == .c & govresp3 == .c & govresp4 == .c & govresp5 == .c & govresp6== .c & govresp7 == .c & govresp8== .c & govresp9==.c & govresp10==.c 
label define resp_miss .n "NA" .c "can't choose" .i "IAP" .a "More than two missing variables"
label values gov_resp_scale resp_miss
numlabel resp_miss, add
tab gov_resp_scale, miss
sum gov_resp_scale, detail
sum gov_resp_scale govresp1-govresp10
alpha govresp1-govresp10, item
*It is found that no variables need to be removed in order to increase cronbach's alpha*
mvpatterns govresp1-govresp10, sort
egen nmiss_gov_resp_scale =rmiss2(govresp1-govresp10)
label variable nmiss_gov_resp_scale "Count for number of different cases of missing variables in 10-input item scale"
tab1 nmiss_gov_resp_scale gov_resp_scale, miss
replace gov_resp_scale = .a if nmiss_gov_resp_scale >2 & !missing(nmiss_gov_resp_scale)
tab gov_resp_scale, miss
sum gov_resp_scale, detail


/* Q2 part b 
Government responsibility scale (gov_resp_scale) and political party affiliation (partyid_rev). */

tab partyid, miss
recode partyid (0 1 = 1) (2 3 4 = 2) (5 6 =3) (7= 4) (.n = .n), gen(partyid_rev) 
label variable partyid_rev "political party affiliation"
label define paty 1 "Democrat" 2 "Independent" 3 "Republican" 4 "Other" .n "NA." 
label values partyid_rev paty
numlabel paty, add
tab partyid_rev, miss
tab partyid_rev partyid, miss
tab1 partyid_rev partyid, miss
tab1 partyid_rev gov_resp_scale, miss
*Doing Anova test*
tab1 gov_resp_scale partyid_rev, miss
sum gov_resp_scale if partyid_rev == 1, detail
sum gov_resp_scale if partyid_rev == 2, detail
sum gov_resp_scale if partyid_rev == 3, detail
sum gov_resp_scale if partyid_rev == 4, detail
oneway gov_resp_scale partyid_rev, tab scheffe

/* Q2 part c
Government responsibility scale (gov_resp_scale) and sex (sex) */
tab1 sex gov_resp_scale, miss
sum gov_resp_scale if sex==1, detail
sum gov_resp_scale if sex==2, detail
ttest gov_resp_scale, by(sex)

/* Q2 part d
Depressive symptoms (cesd_scale) and race/ethnicity (race_eth) */
tab1 cesd_scale race_eth, miss
sum cesd_scale if race_eth==1, detail
sum cesd_scale if race_eth==2, detail
sum cesd_scale if race_eth==3, detail
sum cesd_scale if race_eth==4, detail
oneway cesd_scale race_eth, tab scheffe

/* Q2 part 3
Black-White only (race_eth) differences in government responsibility scale (gov_resp_scale). NOTE: Be sure to limit this test to only those two racial groups (see Lab 5). */
tab1 gov_resp_scale race_eth, miss
sum gov_resp_scale if race_eth == 1, detail
sum gov_resp_scale if race_eth == 2, detail
ttest gov_resp_scale if race_eth ==1 |race_eth ==2, by(race_eth)




*PS6 Example 1 
*Creating 3-Category Variable from Scale*
sum inst_conf_scale, detail
gen inst_conf_scale_cat = inst_conf_scale
recode inst_conf_scale_cat (0/8=1) (9/14=2) (15/26=3)
*or you can run this line:
*recode inst_conf_scale_cat (min/8=1) (9/14=2) (15/max=3)
label variable inst_conf_scale_cat "3-cat institutional confidence scale (IQR)"
label values inst_conf_scale_cat scalecat
label define scalecat 1 "low (<25th percentile)" 2 "medium (25th-74th percentile)" 3 "high (75th percentile or higher)" .c "can’t choose" .d "DK" .i "IAP" .n "NA"
numlabel scalecat, add
tab inst_conf_scale_cat, miss
tab inst_conf_scale inst_conf_scale_cat, miss
*Conducting Chi-Square Test*
tab1 race_eth inst_conf_scale_cat, miss 
*pattern tab1 IV DV, miss
tab inst_conf_scale_cat race_eth, chi2 col
*pattern tab DV IV, chi2 col
*For correlation, template is:
*pwcorr DV IV, obs sig
*or pwcorr IV DV, obs sig	


/* PS6 Q1
 Create a categorical variable (gov_resp_scale_cat) based on the interquartile range for the government responsibility scale (gov_resp_scale). The categories on the variable should be: 1=low (<25th percentile); 2=medium (25th-74th percentile); 3=high (75th percentile or higher). All original extended missing values should be carried over to the new variable. Please submit:
a.	Frequencies on the new variable
b.	Consistency checks
c.	Code for the whole problem
*/
sum gov_resp_scale, detail
recode gov_resp_scale (min/15=1) (16/23=2) (24/max = 3), gen(gov_resp_scale_cat) 
label variable gov_resp_scale_cat "3-cat government responsibility scale (IQR)"
label define scalecat 1 "low (<25th percentile)" 2 "medium (25th-74th percentile)" 3 "high (75th percentile or higher)" .c "can’t choose" .d "DK" .i "IAP" .n "NA" .a "more than 2 missing", modify
label values gov_resp_scale_cat scalecat
numlabel scalecat, add
tab gov_resp_scale_cat, miss
tab gov_resp_scale gov_resp_scale_cat, miss

/* PS6 Q2
Create a categorical variable (cesd_scale_cat) based on the interquartile range for the CES-D scale (cesd_scale). The categories on the variable should be: 1=low (<25th percentile); 2=medium (25th-74th percentile); 3=high (75th percentile or higher). All original extended missing values should be carried over to the new variable.
a.	Frequencies on the new variable
b.	Consistency checks
c.	Code for the whole problem
*/
sum cesd_scale, detail
tab cesd_scale, miss
gen cesd_scale_cat = cesd_scale
recode cesd_scale_cat (0=1) (1/3=2) (4/12=3)
label variable cesd_scale_cat "3-cat depression symptoms scale (IQR)"
label define scalecat 1 "low (<25th percentile)" 2 "medium (25th-74th percentile)" 3 "high (75th percentile or higher)".c "can’t choose" .d "DK" .i "IAP" .n "NA" .a "all missing", modify
label values cesd_scale_cat scalecat
numlabel scalecat, add
tab cesd_scale_cat, miss
tab cesd_scale cesd_scale_cat, miss
tab1 cesd_scale cesd_scale_cat, miss

/* PS6 Q2
a.	Government responsibility scale (gov_resp_scale) and education in years (educ)  */
tab1 gov_resp_scale educ, miss
pwcorr gov_resp_scale educ, obs sig
scatter gov_resp_scale educ || lfit gov_resp_scale educ 

/* PS6 Q2
b.	Government responsibility scale in categories (gov_resp_scale_cat) and education in categories (educ4cat) */
tab1 gov_resp_scale_cat educ4cat, miss
tab gov_resp_scale_cat educ4cat, chi2 col

/* PS6 Q2
c.	Government responsibility scale in categories (gov_resp_scale_cat) and political party affiliation (partyid_rev).  */
tab1 gov_resp_scale_cat partyid_rev, miss
tab gov_resp_scale_cat partyid_rev, chi2 col

/* PS6 Q2
d.	 Institutional confidence scale (inst_conf_scale) and income (conrinc) */
tab1 inst_conf_scale conrinc, miss
pwcorr inst_conf_scale conrinc, obs sig
scatter inst_conf_scale conrinc|| lfit inst_conf_scale conrinc

/* PS6 Q2
e.	CES-D scale in categories (cesd_scale_cat) and race/ethnicity (race_eth) */
tab1 cesd_scale_cat race_eth, miss
tab cesd_scale_cat race_eth, chi2 col

/* PS6 Q2
f.	Government responsibility scale (gov_resp_scale) and income (conrinc) */
tab1 gov_resp_scale conrinc, miss
pwcorr gov_resp_scale conrinc, obs sig
scatter gov_resp_scale conrinc|| lfit gov_resp_scale conrinc

/* PS6 Q2
g.	Government responsibility scale in categories (gov_resp_scale_cat) and age in categories (age4cat) */
tab1 gov_resp_scale_cat age4cat, miss
tab gov_resp_scale_cat age4cat, chi2 col

/* PS6 Q2
h.	CES-D scale (cesd_scale) and age in years (age) */
tab1 cesd_scale age, miss
pwcorr cesd_scale age, obs sig
scatter cesd_scale age|| lfit cesd_scale age


*Assignment 8 Q2*
tab1 inst_conf_scale race_eth cesd_scale_cat, miss
fre educ conrinc age , tabulate(4)
mark inst_conf_scale_flag
markout inst_conf_scale_flag race_eth cesd_scale_cat educ conrinc age
label variable inst_conf_scale_flag "analytic flag for confidence in 7 item institution scale (0-26) - (N =554)"
tab inst_conf_scale_flag, miss
regress inst_conf_scale i.race_eth if inst_conf_scale_flag ==1
regress inst_conf_scale i.race_eth i.cesd_scale_cat if inst_conf_scale_flag == 1, beta 
regress inst_conf_scale i.race_eth i.cesd_scale_cat age educ conrinc if inst_conf_scale_flag == 1, beta 

*LAB 9 Example#1 *
tab region4cat
tab1 prestg10 sex race_eth region4cat whydisc5, miss
fre educ age, tab(6)
mvpatterns prestg10 educ age sex race_eth region4cat whydisc5
tab whydisc5 discwk5, miss
*Back-Coding*
tab whydisc5, miss
clonevar whydisc5_rev = whydisc5
replace whydisc5_rev = 0 if discwk5 == 2
codebook whydisc5 
label define WHYDISC5 0 "was not discriminated against at work", add
label values whydisc5_rev WHYDISC5
numlabel WHYDISC5, add force
tab whydisc5_rev, miss

mdesc prestg10 educ age sex race_eth region4cat whydisc5
mdesc prestg10 educ age sex race_eth region4cat whydisc5_rev
mvpatterns prestg10 educ age sex race_eth region4cat whydisc5
mvpatterns prestg10 educ age sex race_eth region4cat whydisc5_rev

tab whydisc5_rev wrkstat, miss
tab wrkstat,miss



*************************************PS13********************************


recode snsmoth (2 =0) (.n =.n) (.i = .i) (.d = .d), gen(social)
recode absingle (2 =0) (.n =.n) (.i = .i) (.d = .d), gen(single)
label variable social "dummy for whether or not use social media"
label variable single "dummy for whether married or not"
label values social single yngss
numlabel yngss, add force
tab1 single social, miss 

recode stress (1=4) (2=3) (3=2) (4=1) (5=0), gen(stress_rc)
label variable stress_rc "reverse coded variable of stress level (ordinal)"
label define strs 0 "Never" 1 "Hardly ever" 2 "Sometimes" 3 "Often" 4 "Always" .a "NA" .c "Can't chose" .n "No ISSP"
label values stress_rc strs
numlabel strs, add


tab1 stress_rc sex race_eth single social, miss
fre age educ conrinc10k, tabulate(10)
su stress_rc sex race_eth single social age educ conrinc10k
mdesc stress_rc sex race_eth single social age educ conrinc10k
mvpatterns stress_rc sex race_eth single social age educ conrinc10k
mark stress_rc_flag
markout stress_rc_flag stress_rc sex race_eth single social age educ conrinc10k
label variable stress_rc_flag "flag for stress level (GSS 2018 (N= 8300)"
tab stress_rc_flag , miss

recode happy (3= 0) (2=1) (1 =2), gen(happy_rc)
label variable happy_rc "reverse coded variable of happiness level (ordinal)"
label define hpy 0 "Not too happy" 1 "Pretty happy" 2 "Very happy"  .d "DK" .n "NA"
label values happy_rc hpy
numlabel hpy, add
tab happy_rc, miss

tab1 happy_rc sex race_eth single social, miss
fre age educ conrinc10k, tabulate(10)
su happy_rc sex race_eth single social age educ conrinc10k
mdesc happy_rc sex race_eth single social age educ conrinc10k
mvpatterns happy_rc sex race_eth single social age educ conrinc10k
mark happy_rc_flag
markout happy_rc_flag happy_rc sex race_eth single social age educ conrinc10k
label variable happy_rc_flag "flag for happiness level (GSS 2018 - N= 436)"
tab happy_rc_flag , miss

ologit happy_rc i.sex if happy_rc_flag == 1, or
estimates store happy_rcologit1
ologit happy_rc i.sex age educ if happy_rc_flag== 1, or
estimates store happy_rcologit2
ologit happy_rc i.sex age educ i.single i.social if happy_rc_flag == 1, or
estimates store happy_rcologit3
ologit happy_rc i.sex age educ i.single i.social i.race_eth conrinc10k if happy_rc_flag == 1, or
estimates store happy_rcologit4

esttab happy_rcologit1 happy_rcologit2 happy_rcologit3 happy_rcologit4, varwidth(30) eform label star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_p p) not compress nogaps title("Multivariate Ordinal Logistic Regression Models" "Predicting happiness level Based on Race/Ethnicity and Sociodemographic Characteristics," "2016 GSS Survey") mtitle("Model 1" "Model 2" "Model 3" "Model 4")



