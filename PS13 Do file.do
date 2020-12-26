*race_eth
tab1 race hispan, miss

gen race_rev = race
label variable race_rev "6-cat race"
recode race_rev (1=1) (2=2) (3=3) (4/6=4) (7=5) (8/9=6)
label define race_rev 1 "white" 2 "black" 3 "native american or alaska native" 4 "asian or pacific islander" 5 "other race" 6 "2 or more race groups"
label values race_rev race_rev
numlabel race_rev, add
tab1 race race_rev, miss
tab race race_rev, miss

gen ethnicity = hispan
label variable ethnicity "dummy for hispanic"
recode ethnicity (0=0) (1/4=1)
label define ethnicity 0 "not hispanic" 1 "hispanic"
label values ethnicity ethnicity
numlabel ethnicity, add
tab1 hispan ethnicity, miss
tab hispan ethnicity, miss

tab1 race_rev ethnicity, miss

gen race_eth = . 
label variable race_eth "race/ethnicity"
label define race_eth 1 "NH White" 2 "NH Black" 3 "hispanic/latino, any race" 4 "NH Nat Amer or Alask Nat" 5 "NH Asian or Pac Islander" 6 "NH Other Race" 7 "NH 2 or More Race Groups"
numlabel race_eth, add
replace race_eth = 1 if race_rev == 1 & ethnicity == 0
replace race_eth = 2 if race_rev == 2 & ethnicity == 0
replace race_eth = 3 if ethnicity == 1
replace race_eth = 4 if race_rev == 3 & ethnicity == 0
replace race_eth = 5 if race_rev == 4 & ethnicity == 0
replace race_eth = 6 if race_rev == 5 & ethnicity == 0
replace race_eth = 7 if race_rev == 6 & ethnicity == 0
replace race_eth = . if race_rev == . & ethnicity == .
label values race_eth race_eth
tab race_eth, miss

list race ethnicity race_eth in 1/100
list race ethnicity race_eth if race_eth == 5

*educ5cat
tab educ, miss

gen educ5cat = educ
label variable educ5cat "5-category educational attainment"
recode educ5cat (0/5=1) (6=2) (7/8=3) (10=4) (11=5)
label define educ5cat 1 "less than HS diploma" 2 "HS diploma or equivalent" 3 "some college or associate's" 4 "Bachelor's degree" 5 "graduate education"
label values educ5cat educ5cat
numlabel educ5cat, add
tab1 educ5cat educ, miss
tab educ5cat educ, miss


sum inctot, detail
recode inctot (min/0 = 0)
sum inctot, detail
recode inctot (0/7299 = 1) (7300/32999 =2) (33000/94999 =3) (95000/9999999 = 4), gen(inctot_bcq)
label variable inctot_bcq "quartile range variable version of inctot"
label define bcq 1 "0-24th percentile" 2 "25th to 49th percentile" 3 "50th to 74th percentile" 4 "75th percentile and higher" .i "IAP, DK, NA, uncodeable"
label values inctot_bcq bcq
tab inctot_bcq, miss

tab1 diffrem diffphys, miss 
recode diffrem (0 = .n) (1 =0) (2=1), gen(diffrem_rec)
label define yngss 0 "No" 1 "Yes" .n "NA" .i "IAP" .d "DK" .c "Can't Choose"
label values diffrem_rec yngss
numlabel yngss, add force
tab diffrem_rec, miss
recode diffphys (0 = .n) (1 =0) (2=1), gen(diffphys_rec)
label values diffphys_re yngss
numlabel yngss, add force
tab diffphys_rec, miss

*Constructing a composite scale now*
egen diff_scale = rowtotal(diffrem_rec diffphys_rec), miss
label variable diff_scale "2 item difficulty scale"
sum  diff_scale diffrem_rec diffphys_rec
tab diff_scale, miss
label values diff_scale miss
tab diff_scale, miss
recode diff_scale (1/2 =1), gen(diff_dum)
label variable diff_dum "dummy for difficulty from two item scale"
label define diff 0 "No Difficulty" 1 "Yes Difficulty" .n "Not Available"
label values diff_dum diff
numlabel diff, add force
tab diff_dum, miss

tab1 inctot_bcq diff_dum race_eth sex educ5cat, miss
fre age, tabulate(10)
su inctot_bcq diff_dum race_eth sex  educ5cat age
mdesc inctot_bcq diff_dum race_eth sex  educ5cat age
mvpatterns inctot_bcq diff_dum race_eth sex  educ5cat age
mark inctot_bcq_flag
markout inctot_bcq_flag inctot_bcq diff_dum race_eth sex  educ5cat age
label variable inctot_bcq_flag "flag for total income (NJC ACS Data (N= 8300)"
tab inctot_bcq_flag , miss


ologit inctot_bcq i.diff_dum if inctot_bcq_flag == 1, or
estimates store inctotologit1
ologit inctot_bcq i.diff_dum i.race_eth ib2.sex if inctot_bcq_flag== 1, or
estimates store inctotologit2
ologit inctot_bcq i.diff_dum i.race_eth ib2.sex ib5.educ5cat age if inctot_bcq_flag == 1, or
estimates store inctotologit3


esttab inctotologit1 inctotologit2 inctotologit3, varwidth(30) eform label star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N r2_p p) not compress nogaps title("Multivariate Ordinal Logistic Regression Models" "Predicting income Based on Race/Ethnicity and Sociodemographic Characteristics," "2017 New Jersey American Community Survey") mtitle("Model 1" "Model 2" "Model 3")