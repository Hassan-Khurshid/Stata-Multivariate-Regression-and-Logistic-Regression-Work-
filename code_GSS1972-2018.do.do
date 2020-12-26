*log close
clear
clear matrix
clear mata	

set mem 500000
set maxvar 32000
set more off
*log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\log_GSS1972-2018.log", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018.dta"
save "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018_rev.dta", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\GSS1972-2018_rev.dta", replace

ssc install missings
ssc install fre
ssc install estout
ssc install mdesc
search mvpatterns
set showbaselevels on, perm
*these label will be used later*
label define yngss 0 "No" 1 "Yes" .n "NA" .i "IAP" .d "DK" .c "Can't Choose"
numlabel yngss, add force

label define em .d "DK" .i "IAP" .n "NA" .c "can't choose"
numlabel em, add force

tab relig, miss
gen relig5cat = relig
recode relig5cat (1 10 11=1) (2=2) (6/9=3) (4=4) (3 5 12 13=5) (.d=.d) (.n=.n)
label variable relig5cat "recoded relig affiliation"
label define relig5cat 1 "Protestant" 2 "Catholic" 3 "Buddh/Hindu/Moslem or Islam/Other Eastern" 4 "none" 5 "other" .d "DK" .n "NA"
label values relig5cat relig5cat
numlabel relig5cat, add
tab relig5cat, miss
tab relig relig5cat, miss

tab health, miss
recode health (4=0) (3=1) (2=2) (1=3), gen(srh)
label variable srh "Self Rate Health, 4cat"
label define srh 0 "Poor" 1 "Fair" 2 "Good" 3 "Excellent" .d "DK" .i "IAP" .n "NA"
label values srh srh 
numlabel srh, add
tab srh health, miss
tab1 srh health, miss	 

*Q6
/*  Using the interval-ratio variable educ, create a new categorical variable for
educational attainment (educ4cat) with categories for 1=less than high school; 2=high
school diploma; 3=some college; 4=bachelor’s degree or more. Recode any user-defined
missing values into system-missing on the new variable */

tab educ, miss
recode educ (0/11 =1) (12 =2) (13/15 =3) (16/20 =4) (.a =.), gen(educ4cat)
label variable educ4cat "highest level of school completed"
label define educ4cat 1 "less than high school" 2 "high school diploma" 3 "some college" 4 "bachelors degree or more"
label values educ4cat educ4cat
numlabel educ4cat, add
tab educ4cat, miss
tab1 educ educ4cat, miss
tab educ educ4cat, miss

*Q7
/* Recode a new variable (marstat) based on marital, with categories for 1=married;
2=widowed; 3=divorced or separated; and 4=never married. Carry over any user-defined
values to the new variable */

tab marital, miss
gen marstat = marital
recode marstat (1=1) (2 =2) (3/4=3) (5=4)
label variable marstat "dummy marital status"
label define marstat 1 "married" 2 "widowed" 3 "separated/divorced" 4 "never married" 
label values marstat marstat
numlabel marstat, add
tab1 marital marstat, miss
tab marital marstat, miss

*Q8
/*Using the interval-ratio variable age, create a new categorical variable (age4cat)
with categories for 1=18-24; 2=25=44; 3=45-64; and 4=65 or older. Carry over any userdefined values to the new variable */

tab age, miss
gen age4cat= age
recode age4cat (18/24=1) (25/44=2) (45/64=3) (65/89=4) (.d= .d) (.n = .n)
label variable age4cat "dummy age "
label define age4cat 1 "18-24" 2 "25-55" 3 "45-64" 4 "65 or older" .n NA .d DK
label values age4cat age4cat
numlabel age4cat, add
tab age age4cat, miss
tab1 age age4cat, miss

*Q9
/*Using the variables that comprise the “support of abortion rights scale” (abdefect, abnomore, abhlth, abpoor, abrape, absingle, abany), create rescaled versions of each variable (using the suffix “_rs” for each variable; e.g., abdefect_rs) with categories for 1=yes; 0=no; .d=DK; .i=IAP; and .n=NA. Use only one single set of value labels */

tab abdefect, miss
tab abhlth, miss
tab abnomore, miss
tab abpoor, miss
tab absingle, miss
tab abany, miss
recode abdefect (2=0), gen(abdefect_rs)
recode abnomore (2=0),gen(abnomore_rs)
recode abhlth (2=0), gen(abhlth_rs)
recode abpoor (2=0), gen(abpoor_rs)
recode abrape (2=0), gen(abrape_rs)
recode absingle (2=0), gen(absingle_rs)
recode abany (2=0), gen(abany_rs)
label variable abdefect_rs "Abortion due to strong chance of defects"
label variable abnomore_rs "Abortion due to no desire for kids"
label variable abhlth_rs "Abortion due to health risk"
label variable abpoor_rs "Abortion due to poverity"
label variable abrape_rs "Abortion because of rape"
label variable absingle_rs "Abortion due to single parent pressure"
label define ab 1 "Yes" 0 "No" .d DK .n NA .i IAP
label values abdefect_rs abnomore_rs abhlth_rs abpoor_rs abrape_rs absingle_rs abany_rs ab
numlabel ab, add
tab1 abdefect abdefect_rs , miss
tab1 abany abany_rs, miss 
tab1 abnomore abnomore_rs, miss 
tab1 abhlth abhlth_rs, miss
tab1 abpoor abpoor_rs, miss 
tab1 abrape abrape_rs, miss 
tab1 absingle absingle_rs, miss

*Q10
/* Reverse-code and rescale the 10 items that comprise the “confidence in institutions” scale (confinan, conbus, conclerg, coneduc, confed, conlabor, conpress, conmedic, contv, conjudge). Each new variable should have the suffix of “_rev” (e.g., confinan_rev) */

tab confinan, miss
gen confinan_rev= confinan
gen conbus_rev=conbus
gen conclerg_rev= conclerg
gen coneduc_rev= coneduc
gen confed_rev= confed
gen conlabor_rev= conlabor
gen conpress_rev=conpress
gen conmedic_rev=conmedic
gen contv_rev=contv
gen conjudge_rev=conjudge
gen consci_rev =consci
gen conlegis_rev = conlegis
gen conarmy_rev =conarmy
recode confinan_rev conbus_rev conclerg_rev coneduc_rev confed_rev conlabor_rev conpress_rev conmedic_rev contv_rev conjudge_rev consci_rev conlegis_rev conarmy_rev (3 =0) (2= 1) (1=2) 
label variable confinan_rev "Confidence in Financial Companies"
label variable conbus_rev "Confidence in Eminent Companies"
label variable conclerg_rev "Confidence due to Religion"
label variable coneduc_rev "Confidence due to Education"
label variable confed_rev "Confidence in Fed Gov Branches"
label variable conlabor_rev "Confidence in Labor"
label variable conpress_rev "Confidence in Press"
label variable conmedic_rev "Confidence in Medics"
label variable contv_rev "Confidence in Televison"
label variable conjudge_rev "Confidence in Judiciary"
label variable consci_rev "Confidence in Science"
label variable conlegis_rev "Confidence in government parties"
label variable conarmy_rev "Confidence in Army"
label define conf 0 "Hardly Any" 1 "Only Some" 2 "A Great Deal" .d DK .n NA .i IAP
label values confinan_rev conbus_rev conclerg_rev coneduc_rev confed_rev conlabor_rev conpress_rev conmedic_rev contv_rev conjudge_rev consci_rev conlegis_rev conarmy_rev conf
numlabel conf, add
tab1 confinan_rev confinan, miss
tab1 conbus_rev conbus, miss
tab1 conclerg_rev conclerg, miss
tab1 coneduc_rev coneduc, miss
tab1 confed_rev confed, miss
tab1 conlabor_rev conlabor, miss
tab1 conpress_rev conpress, miss
tab1 conmedic_rev conmedic, miss
tab1 contv_rev contv, miss
tab1 conjudge_rev conjudge, miss

*Example#2 from lecture 2*
tab1 race sex, miss
tab race sex, miss
gen race_gender =.
label variable race_gender "Recode of Race and Gender into One Variable"
label define race_gender 1 "White Women" 2 "White Men" 3 "Black Women" 4 "Black Men" 5 "Women of other race" 6 "Men of other race"
replace race_gender = 1 if race ==1 & sex ==2
replace race_gender =2 if race ==1 & sex ==1
replace race_gender =3 if race ==2 & sex==2
replace race_gender =4 if race ==2 & sex ==1 
replace race_gender =5 if race ==3 & sex ==2
replace race_gender =6 if race ==3 & sex ==1
label values race_gender race_gender
numlabel race_gender, add
tab race_gender, miss
list race sex race_gender if race_gender ==1 | race_gender ==3 | race_gender ==5 in 1/1000
*END*

**********************************************************************************************************
/* Assignment#2 
part1

Please create a composite variable (race_eth) based on the variables for race (race) and Hispanic/Latino ethnicity (hispanic). You will need to create an interim variable (hisp; a dummy variable for Hispanic/Latino ethnicity). Anyone who reports Hispanic/Latino ancestry should be coded as Hispanic/Latino on race_eth, regardless of racial category reported. Any cases missing data on Hispanic/Latino ethnicity should be coded as “.u” for “unknown Hispanic/Latino ancestry) on the new race_eth variable */
tab1 race hispanic, miss
recode hispanic (1 =0) (2/50 = 1) (.d .i .n = .u), gen(hisp)
label variable hisp "dummy for hispanic/latino ethnicity"
label define yn 0 "No" 1 "Yes" .u "unknown Hispanic/Latino ancestry"
label values hisp yn
numlabel yn, add
tab hispanic hisp, miss
tab race hisp, miss
gen race_eth =.
label variable race_eth "recode of race variable"
label define race_eth 1 "NH White" 2 "NH Black" 3 "Hispanic" 4 "Other" .u "unknown Hisp origin"
replace race_eth = 1  if race == 1 & hisp == 0
replace race_eth = 2  if race ==2 & hisp ==0
replace race_eth = 3 if hisp ==1 
replace race_eth = 4 if race == 3 & hisp == 0 
replace race_eth = .u if hisp == .u   
label values race_eth race_eth
numlabel race_eth, add
tab race_eth, miss
list id race hisp race_eth if hisp== .u in 52000/52800
list id race hisp race_eth if race ==2 & hisp ==0 in 40000/40100
list id race hisp race_eth if race ==3 & hisp ==0 in 41000/41100
list id race hisp race_eth if hisp ==1 in 50000/50010
list id race hisp race_eth if race ==1 & hisp ==0 in 40000/40005

/*
Part2 
Please create a new variable that computes the number of weekday mins spent on the internet (wwwminwkdays) based on the number of weekday hours spent on the internet (intwkdyh) and the number of weekday minutes on the internet (intwkdym). Carry over extended missing values to the new variable. */

tab1 intwkdyh intwkdym, miss
tab intwkdyh intwkdym , miss
gen wwwminwkdays = (intwkdyh*60) + intwkdym
label variable wwwminwkdays "weekday minutes on the internet"
replace wwwminwkdays = .i if intwkdyh == .i & intwkdym == .i /*don't place 'or' sign */ 
replace wwwminwkdays = .n if intwkdyh == .n & intwkdym == .n 
replace wwwminwkdays = .d if intwkdyh == .d & intwkdym == .d 
tab wwwminwkdays, miss
sum wwwminwkdays, detail
list id intwkdyh intwkdym wwwminwkdays if !missing(wwwminwkdays), separator(40)

**********************************************************************************************************

*Assignment 3 Q2 part 1*
/* Using 1972-2018 GSS, please create the composite scales below, using the sum of the input scale items. Be sure to carry over extended missing values onto the new scale.
a.	(10 pts) Using the rescaled items for the “support of abortion rights” scale you created in Problem Set #1, create an overall scale (abscale) based on the sum of these items. */

*Since all seven recodes are correctly constructed as per the conventions, we will use the same recodes as they are*
tab abdefect abdefect_rs, miss
tab abhlth abhlth_rs, miss
tab abnomore abnomore_rs, miss
tab abrape abrape_rs, miss
tab abpoor abpoor_rs, miss
tab absingle absingle_rs, miss
tab abany abany_rs, miss
sum abdefect_rs-abany_rs
tab1 abdefect_rs-abany_rs, miss
label values abdefect_rs-abany_rs yngss

egen abscale = rowtotal(abdefect_rs-abany_rs), miss
label variable abscale "7 item abortion right scale"
tab abscale, miss
replace abscale = .i if abdefect_rs == .i & abhlth_rs == .i & abnomore_rs == .i & abpoor_rs == .i & absingle_rs ==.i & abrape_rs ==.i & abany_rs ==.i
replace abscale = .d if abdefect_rs == .d & abhlth_rs == .d & abnomore_rs == .d & abpoor_rs == .d & absingle_rs ==.d & abrape_rs ==.d & abany_rs ==.d
replace abscale = .n if abdefect_rs == .n & abhlth_rs == .n & abnomore_rs == .n & abpoor_rs == .n & absingle_rs ==.n & abrape_rs ==.n & abany_rs ==.n
label define yngss_miss .i "IAP" .d "DK" .n "NA"
label values abscale yngss_miss
numlabel yngss_miss, add
sum abscale abdefect_rs-abany_rs
sum abscale, detail
tab abscale, miss

list id abscale abdefect_rs-abany_rs if missing(abdefect_rs-abany_rs) in 1/50, nolabel
list id abscale abdefect_rs-abany_rs if missing(abrape_rs) & !missing(absingle_rs) in 60000/61000, nolabel
list id abscale abdefect_rs-abany_rs if !missing(abdefect_rs-abany_rs) in 64800/64810, nolabel


*Assignment 3 Q2 part 2*
/*Using the reverse-coded and rescaled items for the “confidence in institutions” scale you created in Problem Set #1, create an overall scale (inst_conf_scale) based on the sum of these items. */

tab confinan_rev confinan, miss
tab conbus_rev conbus, miss
tab conclerg_rev conclerg, miss
tab coneduc_rev coneduc, miss
tab confed_rev confed, miss
tab conlabor_rev conlabor, miss
tab conpress_rev conpress, miss
tab conmedic_rev conmedic, miss
tab contv_rev contv, miss
tab conjudge_rev conjudge, miss
*Since these are recoded correctly according to the conventions so we will use these for making the scale*
sum confinan_rev-conarmy_rev
tab1 confinan_rev-conarmy_rev, miss
egen inst_conf_scale = rowtotal(confinan_rev-conarmy_rev), miss
label variable inst_conf_scale "7 item Confidence in Inst Scale"
tab inst_conf_scale, miss

replace inst_conf_scale =.d if confinan_rev == .d & conbus_rev ==.d & conclerg_rev ==.d &coneduc_rev ==.d & confed_rev ==.d &conlabor_rev ==.d & conpress_rev ==.d & conmedic_rev == .d & contv_rev ==.d & conjudge_rev ==.d

replace inst_conf_scale =.n if confinan_rev == .n & conbus_rev ==.n & conclerg_rev ==.n &coneduc_rev ==.n & confed_rev ==.n &conlabor_rev ==.n & conpress_rev ==.n & conmedic_rev == .n & contv_rev ==.n & conjudge_rev ==.n

replace inst_conf_scale =.i if confinan_rev == .i & conbus_rev ==.i & conclerg_rev ==.i &coneduc_rev ==.i & confed_rev ==.i &conlabor_rev ==.i & conpress_rev ==.i & conmedic_rev == .i & contv_rev ==.i & conjudge_rev ==.i

label values inst_conf_scale yngss_miss

sum inst_conf_scale confinan_rev-conarmy_rev
sum inst_conf_scale, detail
tab inst_conf_scale, miss
set more on
list id inst_conf_scale confinan_rev-conarmy_rev if missing(confinan_rev-conarmy_rev) in 1/50, nolabel
list id inst_conf_scale confinan_rev-conarmy_rev if missing(contv_rev) & missing(conclerg_rev) & !missing(conbus_rev) in 50000/60000, nolabel
list id inst_conf_scale confinan_rev-conarmy_rev if !missing(confinan_rev-conarmy_rev) in 64800/64810, nolabel

**********************************************************************************************************
*Q3 Assignment #4 *


sum cesd1-cesd5
tab1 cesd1-cesd5, miss
*creating recodes for each variable 
gen cesd1r = cesd1
gen cesd2r = cesd2
gen cesd3r = cesd3
gen cesd4r = cesd4
gen cesd5r = cesd5
label define ced 0 "none or almost none of the time" 1 "some of the time" 2 "most of the time" 3 "all or almost all of the time".d "DK" .i " no IAP" .n "NA"
label define cedrc 0 "all or almost all of the time" 1 "most of the time" 2 "some of the time" 3 "none or almost none of the time".d "DK" .i " no IAP" .n "NA"
numlabel ced cedrc, add
recode cesd1r cesd2r cesd4r cesd5r (1=0) (2=1) (3=2) (4=3) (.d=.d) (.i=.i) (.n=.n)  
recode cesd3r (4=0) (3=1) (2=2) (1=3) (.d=.d) (.i=.i) (.n=.n)  
label variable cesd1r "how many times felt depressed in past week"
label variable cesd2r "how many times had restless sleep in past week"
label variable cesd3r "how many times felt happy in past week"
label variable cesd4r "how many times felt lonely in past week"
label variable cesd5r "how many times felt sad in past week"
label values cesd1r cesd2r cesd4r cesd5r ced
label values cesd3r cedrc
tab cesd1 cesd1r, miss
tab cesd2 cesd2r, miss
tab cesd3 cesd3r, miss
tab cesd4 cesd4r, miss
tab cesd5 cesd5r, miss
tab1 cesd1 cesd1r, miss
tab1 cesd2 cesd2r, miss
tab1 cesd3 cesd3r, miss
tab1 cesd4 cesd4r, miss
tab1 cesd5 cesd5r, miss
*creating a depression scale*
/**** code for 5-item scale
egen cesd_scale = rowtotal(cesd1r-cesd5r), miss
label variable cesd_scale "5-item scale of depressive symptoms"
tab cesd_scale, miss
replace cesd_scale = .d if cesd1r == .d & cesd2r ==.d & cesd3r ==.d & cesd4r ==.d & cesd5r ==.d 
replace cesd_scale =.n if cesd1r == .n & cesd2r ==.n & cesd3r ==.n & cesd4r ==.n & cesd5r ==.n
replace cesd_scale =.i if cesd1r == .i & cesd2r ==.i & cesd3r ==.i & cesd4r ==.i & cesd5r ==.i
label values cesd_scale em
tab cesd_scale, miss
sum cesd1r-cesd5r 
sum cesd_scale cesd1r-cesd5r ****/
alpha cesd1r-cesd5r, item

*since cronbach alpha of cesd2r (0.7913) is greater than overall alpha of 5 items (0.7611), we will drop this item*
drop cesd2r
egen cesd_scale = rowtotal(cesd1r cesd3r-cesd5r), miss
label variable cesd_scale "4-item scale of depressive symptoms"
tab cesd_scale, miss
replace cesd_scale = .d if cesd1r == .d & cesd3r ==.d & cesd4r ==.d & cesd5r ==.d 
replace cesd_scale =.n if cesd1r == .n & cesd3r ==.n & cesd4r ==.n & cesd5r ==.n
replace cesd_scale =.i if cesd1r == .i & cesd3r ==.i & cesd4r ==.i & cesd5r ==.i
label values cesd_scale em
tab cesd_scale, miss
sum cesd1r cesd3r-cesd5r 
sum cesd_scale cesd1r cesd3r-cesd5r 
list id cesd_scale cesd1r cesd3r-cesd5r if !missing(cesd1r, cesd3r-cesd5r) in 60000/60020, nolabel
list id cesd_scale cesd1r cesd3r-cesd5r if missing(cesd1r, cesd3r-cesd5r) in 1/10, nolabel
list id cesd_scale cesd1r cesd3r-cesd5r if missing(cesd1r) & (!missing(cesd3r) | !missing(cesd4r)), nolabel
alpha cesd1r cesd3r-cesd5r , item

*now limiting the output scale to those with complete data on all four input scale items*
mvpatterns cesd1r-cesd5r, sort
egen nmiss_cesd_scale = rmiss2(cesd1r-cesd5r)
label variable nmiss_cesd_scale "Count for missing variable frequencies for 4 item scale of depression symptoms"
tab nmiss_cesd_scale, miss
replace cesd_scale =.a if nmiss_cesd_scale >0 & nmiss_cesd_scale <=4 
* so any combination of variable that has more than 0 missing variables gets coded as .a 
tab cesd_scale
tab cesd_scale, miss
sum cesd_scale, detail



*PS6 Example 1 Creating 3-Category Variable from Scale*
label define scalecat 1 "low (<25th percentile)" 2 "medium (25th-74th percentile)" 3 "high (75th percentile or higher)" .c "can’t choose" .d "DK" .i "IAP" .n "NA"

*LAB 9 Example#1 *
tab region, miss
*creating new variable called region4cat for region
recode region (1/2 = 1) (3/4 =2) (5/7 =3) (8/9 =4), gen(region4cat)
label variable region4cat "categorical variable for regions"
label define regn 1 "Northeast (New Engl and Mid Atl)" 2 "Midwest (W-No Central and E-No Centr" 3 "South (S Atl, E-S Central, W-S Centr" 4 "West (Mountain and Pacific)"
label values region4cat regn
numlabel regn, add 
tab1 region region4cat, miss

*Rescaling Variable Income for PS10*
gen conrinc10k = conrinc * .0001
label variable conrinc10k "income in $10k"
*consistency check for rescaling*
list conrinc conrinc10k if !missing(conrinc) in 1/50
sum conrinc conrinc10k




