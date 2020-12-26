log close
clear
clear matrix
clear mata	

set mem 500000
set maxvar 32000
set more off
log using "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Log\log_allmidus.log", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\allmidus.dta"
save "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\allmidus_rev.dta", replace
use "D:\Rutgers\Sem III\Applied Multivariate Methods\AMM\Analysis\Data\allmidus_rev.dta", replace

ssc install missings
ssc install fre
ssc install estout
set showbaselevels on, perm

tab A1PRSEX, miss
recode A1PRSEX (2=1) (1=0) (8= .r), gen(woman)
label variable woman "Dummy for woman"
label define woman 1 "Female" 0 "Male" .r "Refused"
label values woman woman
numlabel woman, add
tab1 A1PRSEX woman, miss
tab A1PRSEX woman, miss


tab A1PA4, miss
recode A1PA4 (4 5 =1) (1 2 3 = 0) (7 =.d), gen(evgsrhw1)
label variable evgsrhw1 "W1 Dummy for Very Good or Excellent SRH"
label define evg 0 "Poor, Fair, or Good SRH" 1 "Excellent or Very Good SRH" .d "Don't Know"
label values evgsrhw1 evg
numlabel evg, add
tab1 A1PA4 evgsrhw1, miss
tab A1PA4 evgsrhw1, miss

*ASssignment 1

*Q1
tab C1PF1, miss
recode C1PF1 (2/7 = 1) (1=0) (97 = .d) (98 =.r), gen(hispanic)
label variable C1PF1 "Hispanic Ethnicity"
label define hispanic 0 "Not Spanish/Hispanic" 1 "Hispanic Decent" .d "Don't Know" .r "Refused"
label values hispanic hispanic
numlabel hispanic, add
tab hispanic, miss
tab1 hispanic C1PF1, miss
tab hispanic C1PF1, miss

*Q2
tab C1PB19, miss
recode C1PB19 (2/4 = 2) (5 =3) (7 8 . = .), gen(marstatw3)
label variable marstatw3 "Married vs Non-Married"
label define married 1 "Married" 2 "Separated/Divorced/Widowed" 3 "Never Married"
label values marstatw3 married
numlabel married, add
tab marstatw3, miss
tab1 marstatw3 C1PB19, miss
tab marstatw3 C1PB19, miss
 
*Q3
/* Recode Wave 3 education (C1PB1) into a new variable (educw3) with categories for 1=less than high school diploma; 2=high school grad or GED; 3=some college or 2 year college/vocational school; 4=bachelor’s degree; 5=more than bachelor’s degree.  Recode “don’t know” or “refused” into system-missing */

tab C1PB1, miss
gen educw3= C1PB1
recode educw3 (1/3=1) (4/5=2) (6/8=3) (9=4) (10/12=5) (97= .) (98= .) (.=.)
label variable educw3 "Education Status Wave 3"
label define educw3 1 "less than high school diploma" 2 "high school grad or GED" 3 "some college/2 year college/vocational school" 4 "bachelor's degree" 5 "more than bachelors" 
label values educw3 educw3
numlabel educw3, add
tab educw3, miss
tab1 C1PB1 educw3, miss
tab C1PB1 educw3, miss

*Q4
/*Based on the interval-ratio variable C1PA4 (“days unable to work because of health”) into a categorical variable (daysnoworkw3) with categories for 0=0 days; 1=1-6 days; 2=7-13 days; 3=14 days or more. Recode “don’t know” and “refused” into two new, separate extended missing categories */

tab C1PA4, miss
gen daysnoworkw3 = C1PA4
recode daysnoworkw3 (0=0) (1/6 =1) (7/13 =2) (14/30 = 3) (97 =.d) (98 =.r) (.=.)
label variable daysnoworkw3 "health days"
label define daysnoworkw3 0 "0 days" 1 "1-6 days" 2 "7-13 days" 3 "14-30 days" .d "don't know" .r "refused"
label values daysnoworkw3 daysnoworkw3
numlabel daysnoworkw3, add
tab daysnoworkw3, miss
tab1 C1PA4 daysnoworkw3, miss
tab C1PA4 daysnoworkw3, miss

*Q5
/* Reverse-code C1SE1B (“I feel in charge of the situation in which I live”) into a new
variable (inchargew3) such that 1=Disagree Strongly  7=Agree Strongly (hint: all categories
in between should be transformed). Recode “respondent does not have SAQ data into a userdefined missing value - “.i” for “INAP/no SAQ data” (e.g., (-1=.i) ). Recode “refused” into its
own new user-defined missing category */

tab C1SE1B, miss
recode C1SE1B (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1 =7) (-1 =.i) (8 =.r), gen(inchargew3)
label variable inchargew3 "Situation in charge opinion"
label define inchargew3 1 "disagree strongly" 2 "disagree somewhat" 3 "disagree a little" 4 "neither agree nor disagree" 5 "agree a little" 6 "agree somewhat" 7 "strongly agree" .r "refused" .i "INAP/no SAQ data"
label values inchargew3 inchargew3
numlabel inchargew3, add
tab	inchargew3, miss	
tab1 C1SE1B inchargew3, miss
tab C1SE1B inchargew3, miss

*Example#1 Lecture 2*
tab1 B1PF1 B1PF7A, miss
recode B1PF1 (1=0) (2 3 4 5 6 7 = 1) (97 98 . = .), gen(w2hisp)
label variable w2hisp "Dummy for Hispanic"
label define yn 0 "No" 1 "Yes"
label values w2hisp yn
numlabel yn, add  
tab1 B1PF1 w2hisp, miss

recode B1PF7A (7 8 . =.), gen(w2race)
label variable w2race "Sorted variable for race"
label define w2race 1 "White" 2 "Black/ Afr Amer" 3 "Native Amer/ Alask Nat" 4 "Asian" 5 "Nat Hawaiian or Pacif Isl" 6 "Other (Specify)"
label values w2race w2race
numlabel w2race, add
tab1 B1PF7A w2race, miss 

tab B1PF1 w2hisp, miss
tab B1PF7A w2race, miss

*now run crosstabs across new input variables to determine target frequencies

tab w2race w2hisp, miss

* now starts real work for this:

gen raceeth =.  
label variable raceeth "adding Hispanic race into Race variable"
label define raceeth 1 "NH White" 2 "NH Black/ Afr Amer" 3 "Hispanic/Latino (any kind)" 4 "NH Native Amer/Alask Nat" 5 "NH Asian" 6 "NH Nat Hawaiian or Pacif Isl" 7 "NH Other (Specify)"
replace raceeth = 1 if w2race == 1 & w2hisp == 0
replace raceeth = 2 if w2race == 2 & w2hisp == 0
replace raceeth =3 if w2hisp == 1
replace raceeth =4 if w2race== 3 & w2hisp == 0
replace raceeth =5 if w2race == 4 & w2hisp == 0
replace raceeth =6 if w2race == 5 & w2hisp == 0
replace raceeth =7 if w2race == 6 & w2hisp == 0
label values raceeth raceeth
numlabel raceeth, add

list w2hisp w2race raceeth if raceeth ==2
*END*

*Example#3 from lecture2*
tab1 B1SA37A B1SA37B B1SA39, miss
tab B1SA37B B1SA37A, miss 
gen htinches = (B1SA37A *12) + B1SA37B
label variable htinches "Recode of heights into inches"
replace htinches = .r if B1SA37B == 98 | B1SA37A ==98
label define refbmi .r "Refused on any BMI input variable"
label values htinches refbmi
numlabel refbmi, add 
list B1SA37A B1SA37B htinches in 1/100
sum htinches, detail
recode B1SA39 (998 =.r), gen(weightlbs)
label variable weightlbs "Recoded Weight Variable with extended missing values"
label values weightlbs refbmi
numlabel refbmi, add
tab1 B1SA39 weightlbs, miss

gen w2bmi = (weightlbs/(htinches*htinches))*703
gen w2bmi_rd = round(w2bmi, 0.1)
label variable w2bmi_rd "rounded bmi variable to nearest tenth"
list w2bmi w2bmi_rd in 1/50, nolabel 
*END*

/* Assignment#2 Q3
Based on the rounded BMI variable (w2bmi_rd), please create a new variable (w2bmi_cat) for which 1=underweight (below 18.5); 2=normal weight (18.5-24.9); 3=overweight (25.0-29.9); 4=obese (30.0 and above) */

gen w2bmi_cat =.
label define w2bmi_cat 1 "underweight (below 18.5)" 2 "normal weight (18.5-24.9)" 3 "overweight (25.0-29.9)" 4 "obese (30.0 and above)"
label values w2bmi_cat w2bmi_cat
numlabel w2bmi_cat, add
replace w2bmi_cat =1 if w2bmi_rd < 18.5 
replace w2bmi_cat =2 if w2bmi_rd >= 18.5 & w2bmi_rd <=24.9
replace w2bmi_cat =3 if w2bmi_rd >=25 & w2bmi_rd <= 29.9 
replace w2bmi_cat =4 if w2bmi_rd >= 30 & !missing(w2bmi_rd)
tab w2bmi_cat, miss

list M2ID w2bmi_rd w2bmi_cat if w2bmi_rd == 41
list M2ID w2bmi_rd w2bmi_cat if w2bmi_rd  > 35 & !missing(w2bmi_rd)
list M2ID w2bmi_rd w2bmi_cat if w2bmi_rd > 15 & w2bmi_rd <20
list M2ID w2bmi_rd w2bmi_cat if w2bmi_rd < 18
list M2ID w2bmi_rd w2bmi_cat if w2bmi_rd > 20 &  !missing(w2bmi_rd) in 4450/4470
*END*

/* Assignment#2 Q4
In Wave 3 of MIDUS, respondents were asked to rate their overall life satisfaction now (C1SQ1) and their life satisfaction 10 years ago (C1SQ2).  Create a new variable (retrolifesat) comparing their life satisfaction 10 years ago to their life satisfaction currently. The resulting variable should be interval-ratio, with extended missing values for .i=”R does not have SAQ data” and .r=”refused.” Negative values should reflect worse life satisfaction now than 10 years ago.  Carry over any extended missing values. Remember: garbage in, garbage out. You will have to construct interim variables.*/

tab1 C1SQ1 C1SQ2, miss 
tab C1SQ1 C1SQ2, miss 

recode C1SQ1 (-1 =.i) (98 = .r), gen(LifeNow)
recode C1SQ2  (-1 =.i) (98 = .r), gen(LifeThen)
label variable LifeNow "Life Satisfaction Currently"
label variable LifeThen "Life Satisfaction 10 years ago"
label define life .i "R does not have SAQ data" .r "refused" 
label values LifeThen LifeNow life
numlabel life, add
tab1 C1SQ1 LifeNow, miss
tab1 C1SQ2 LifeThen, miss
tab LifeNow LifeThen, miss

gen retrolifesat = LifeNow - LifeThen
label variable retrolifesat "Comparison of current vs previous satisfaction"
replace retrolifesat = .i if LifeThen == .i & LifeNow == .i
replace retrolifesat = .r if LifeThen == .r & LifeNow == .r
label define retrolifesat -10 "Smallest Difference" 10 "Largest Difference" .i "R does not have SAQ data" .r "refused"
label values retrolifesat retrolifesat
numlabel retrolifesat, add
tab retrolifesat, miss
sum retrolifesat, detail
list M2ID LifeThen LifeNow retrolifesat in 1/50
*END*

/* Assignment#2 Q5 
5.	(30 pts) Create a new variable (prosplifesat for prospective life satisfaction) comparing respondents’ current life satisfaction to their anticipated life satisfaction 10 years from now (C1SQ3). The resulting variable should be interval-ratio, with extended missing values for .i=”R does not have SAQ data” and .r=”refused.” Negative values should reflect worse anticipated life satisfaction in 10 years than now. Carry over any extended missing values.  Remember: garbage in, garbage out. You will have to construct interim variables. */

tab1 C1SQ1 C1SQ3, miss 
tab C1SQ1 C1SQ3, miss
recode C1SQ3 (-1 =.i) (98 = .r), gen(LifeAfterwards)
label variable LifeAfterwards "Anticipated Life Satisfaction"
label values LifeAfterwards life 
numlabel life, add
tab1 C1SQ3 LifeAfterwards, miss
tab LifeAfterwards LifeNow, miss

gen prosplifesat = LifeAfterwards - LifeNow
label variable prosplifesat "Comparison of current vs prospective life satisfaction"
replace prosplifesat= .i if LifeAfterwards == .i & LifeNow == .i
replace prosplifesat = .r if LifeAfterwards == .r & LifeNow == .r
tab prosplifesat, miss
sum prosplifesat, detail
list M2ID LifeNow LifeAfterwards prosplifesat in 1/50
*END*


*Assignment#3*
*Q1a*
/* please create the five separate composite scales below, using the sum of the seven input scale items. 
	Environmental mastery (envmast_scale; envmast1-envmast7)
	i.	Simple descriptives (exclude “detail” option) of the scale and input items
	ii.	Consistency checks using “list” showing five cases for all three potential outcomes (use “nolabel” to see values only)
	iii.	Code */
	
sum C1SE1B C1SE1H C1SE1N C1SE1T C1SE1Z C1SE1FF C1SE1LL
tab1 C1SE1B C1SE1H C1SE1N C1SE1T C1SE1Z C1SE1FF C1SE1LL, miss

label define pbw 0 "Agree strongly" 1 "Agree somewhat" 2 "Agree a little" 3 "Neither agree nor disagree" 4 "Disagree a little" 5 "Disagree somewhat" 6 "Disagree strongly" .r "refused" .n "respondent does not have SAQ data" 
label define pbwrc  0 "Disagree strongly" 1 "Disagree somewhat" 2 "Disagree a little" 3 "Neither agree nor disagree" 4 "Agree a little" 5 "Agree somewhat" 6 "Agree strongly" .r "refused" .n "respondent does not have SAQ data" 
numlabel pbw pbwrc, add

*recodes of individual items*
recode C1SE1B (7 =0) (6=1) (5=2) (4=3) (3=4) (2 =5) (1= 6) (-1 =.n) (8 =.r), gen(envmast1)
label variable envmast1 "Feels in charge of situation"
label values envmast1 pbwrc
recode C1SE1H (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (-1 =.n) (8 =.r), gen(envmast2)
label variable envmast2 "Demands of life get them down"
label values envmast2 pbw
recode C1SE1N (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (-1 =.n) (8 =.r), gen(envmast3)
label variable envmast3 "Don't fit well with community"
label values envmast3 pbw
recode C1SE1T (7 =0) (6=1) (5=2) (4=3) (3=4) (2 =5) (1= 6) (-1 =.n) (8 =.r), gen(envmast4)
label variable envmast4 "Good at managing responsibilities"
label values envmast4 pbwrc
recode C1SE1Z (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (-1 =.n) (8 =.r), gen(envmast5)
label variable envmast5 "Feel overwhelmed with responsibilities"
label values envmast5 pbw
recode C1SE1FF (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (-1 =.n) (8 =.r), gen(envmast6)
label variable envmast6 "Difficulty in arranging life to to their satisfaction"
label values envmast6 pbw
recode C1SE1LL (7 =0) (6=1) (5=2) (4=3) (3=4) (2 =5) (1= 6) (-1 =.n) (8 =.r), gen(envmast7)
label variable envmast7 "Successfull at building an environment to their liking"
label values envmast7 pbwrc

tab1 C1SE1B envmast1, miss
tab1 C1SE1H envmast2, miss
tab1 C1SE1N envmast3, miss
tab1 C1SE1T envmast4, miss
tab1 C1SE1Z envmast5, miss
tab1 C1SE1FF envmast6, miss
tab1 C1SE1LL envmast7, miss
tab C1SE1B envmast1, miss
tab C1SE1H envmast2, miss
tab C1SE1N envmast3, miss
tab C1SE1T envmast4, miss
tab C1SE1Z envmast5, miss
tab C1SE1FF envmast6, miss
tab C1SE1LL envmast7, miss
sum envmast1-envmast7

*Constructing a composite scale now*
egen envmast_scale = rowtotal(envmast1-envmast7), miss
label variable envmast_scale "7 item environmental mastery scale"
sum  envmast_scale envmast1-envmast7
tab envmast_scale, miss
replace envmast_scale  = .r if envmast1 ==.r & envmast2 ==.r & envmast3 ==.r & envmast4 ==.r & envmast5 ==.r & envmast6 ==.r & envmast7 ==.r
replace envmast_scale = .n  if envmast1 ==.n & envmast2 ==.n & envmast3 ==.n & envmast4 ==.n & envmast5 ==.n & envmast6 ==.n & envmast7 ==.n
label define pbwmiss .n "R does not have SAQ data" .r "refused on all items"
label values envmast_scale pbwmiss
numlabel pbwmiss, add
tab envmast_scale, miss
*listing to check consistency*
list M2ID envmast_scale envmast1-envmast7 in 1/100, nolabel
list M2ID envmast_scale envmast1-envmast7 if missing(envmast2) & !missing(envmast4), nolabel
list M2ID envmast_scale envmast1-envmast7 if !missing(envmast1-envmast7) in 7280/7290, nolabel
list M2ID envmast_scale envmast1-envmast7 if  missing(envmast1-envmast7) in 5750/5760, nolabel




*Q1b*
sum C1SE1C C1SE1I C1SE1O C1SE1U C1SE1AA C1SE1GG C1SE1MM
tab1 C1SE1C C1SE1I C1SE1O C1SE1U C1SE1AA C1SE1GG C1SE1MM, miss

*generating variables
gen persgrowth1= C1SE1C
gen persgrowth2= C1SE1I
gen persgrowth3= C1SE1O
gen persgrowth4= C1SE1U
gen persgrowth5= C1SE1AA
gen persgrowth6= C1SE1GG
gen persgrowth7= C1SE1MM

recode persgrowth2 persgrowth4 persgrowth5 (7 =0) (6=1) (5=2) (4=3) (3=4) (2 =5) (1= 6) (-1 =.n) (8 =.r)
recode persgrowth1 persgrowth3 persgrowth6 persgrowth7 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (-1 =.n) (8 =.r) 
label variable persgrowth1 "not interested in horizon-expanding activities"
label variable persgrowth2 "realizes the importance of new experiences to change viewpoint"
label variable persgrowth3 "haven't improved much as a person over the years"
label variable persgrowth4 "developed a lot as a person over time"
label variable persgrowth5 "life has been continous process of learning, changing and growth"
label variable persgrowth6 "gave up trying to make big improvements or changes to my life long ago"
label variable persgrowth7 "do not enjoy being in new situations that require changing old habits"
label values persgrowth2 persgrowth4 persgrowth5 pwbrc
label values persgrowth1 persgrowth3 persgrowth6 persgrowth7 pwb

tab1 persgrowth1 C1SE1C, miss
tab1 persgrowth2 C1SE1I, miss
tab1 persgrowth3 C1SE1O, miss
tab1 persgrowth4 C1SE1U, miss
tab1 persgrowth5 C1SE1AA, miss
tab1 persgrowth6 C1SE1GG, miss
tab1 persgrowth7 C1SE1MM, miss
tab persgrowth1 C1SE1C, miss
tab persgrowth2 C1SE1I, miss
tab persgrowth3 C1SE1O, miss
tab persgrowth4 C1SE1U, miss
tab persgrowth5 C1SE1AA, miss
tab persgrowth6 C1SE1GG, miss
tab persgrowth7 C1SE1MM, miss
sum persgrowth1-persgrowth7

egen persgrowth_scale = rowtotal(persgrowth1-persgrowth7), miss
label variable persgrowth_scale  "7 Item Personal Growth Scale"
sum  persgrowth_scale persgrowth1-persgrowth7
tab persgrowth_scale, miss
replace persgrowth_scale= .r if persgrowth1==.r & persgrowth2==.r & persgrowth3==.r & persgrowth4==.r & persgrowth5==.r & persgrowth6==.r & persgrowth7==.r
replace persgrowth_scale= .n if persgrowth1==.n & persgrowth2==.n & persgrowth3==.n & persgrowth4==.n & persgrowth5==.n & persgrowth6==.n & persgrowth7==.n
label values persgrowth_scale pbwmiss
numlabel pbwmiss, add
sum persgrowth_scale, detail
tab persgrowth_scale, miss
*listing to check consistency*
list M2ID persgrowth_scale persgrowth1-persgrowth7 in 1/100, nolabel
list M2ID persgrowth_scale persgrowth1-persgrowth7 if missing(persgrowth3) & !missing(persgrowth1), nolabel
list M2ID persgrowth_scale persgrowth1-persgrowth7 if !missing(persgrowth1-persgrowth7) in 5000/5015, nolabel
list M2ID persgrowth_scale persgrowth1-persgrowth7 if  missing(persgrowth1-persgrowth7) in 5750/5760, nolabel



*Q1c*
sum C1SE1D C1SE1J C1SE1P C1SE1V C1SE1BB C1SE1HH C1SE1NN
tab1 C1SE1D C1SE1J C1SE1P C1SE1V C1SE1BB C1SE1HH C1SE1NN, miss
*generating variables
gen posrel1 = C1SE1D
gen posrel2= C1SE1J
gen posrel3= C1SE1P
gen posrel4= C1SE1V
gen posrel5= C1SE1BB
gen posrel6= C1SE1HH
gen posrel7= C1SE1NN

recode posrel2 posrel3 posrel6 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (-1 =.n) (8 =.r) 
recode posrel1 posrel4 posrel5 posrel7 (7=0) (6=1) (5=2) (4=3) (3=4) (2=5) (1=6) (8=.r) (-1=.n)
label variable posrel1 "People see as affectionate"
label variable posrel2 "Maintaining close relationships has been difficult"
label variable posrel3 "Feel lonely because of few close friends"
label variable posrel4 "Enjoy conversations with friends and family"
label variable posrel5 "People describe as a person willing to share his/her time"
label variable posrel6 "Never experienced a good relationship"
label variable posrel7 "Can trust their friends"
label values posrel2 posrel3 posrel6 pbw
label values posrel1 posrel4 posrel5 posrel7 pbwrc
tab posrel1 C1SE1D, miss
tab posrel2 C1SE1J, miss
tab posrel3 C1SE1P, miss
tab posrel4 C1SE1V, miss
tab posrel5 C1SE1BB, miss
tab posrel6 C1SE1HH, miss
tab posrel7 C1SE1NN, miss
tab1 posrel1 C1SE1D, miss
tab1 posrel2 C1SE1J, miss
tab1 posrel3 C1SE1P, miss
tab1 posrel4 C1SE1V, miss
tab1 posrel5 C1SE1BB, miss
tab1 posrel6 C1SE1HH, miss
tab1 posrel7 C1SE1NN, miss

egen posrel_scale = rowtotal(posrel1-posrel7), miss
label variable posrel_scale "7 item Positive Relation scale"
sum posrel_scale posrel1-posrel7
tab posrel_scale, miss

replace posrel_scale = .r if posrel1 ==.r & posrel2 == .r & posrel3 == .r & posrel4 == .r & posrel5 == .r & posrel6 == .r & posrel7 ==.r
replace posrel_scale = .n if posrel1 ==.n & posrel2 == .n & posrel3 == .n & posrel4 == .n & posrel5 == .n & posrel6 == .n & posrel7 ==.n
label values posrel_scale pbwmiss
numlabel pbwmiss, add
sum posrel_scale, detail
tab posrel_scale, miss
*listing to check consistency*
list M2ID posrel_scale posrel1-posrel7 in 1/100, nolabel
list M2ID posrel_scale posrel1-posrel7 if missing(posrel2) & !missing(posrel5), nolabel
list M2ID posrel_scale posrel1-posrel7  if !missing(posrel1-posrel7) in 5000/5015, nolabel
list M2ID posrel_scale posrel1-posrel7  if  missing(posrel1-posrel7) in 5750/5760, nolabel



*Q1d*
sum C1SE1E C1SE1K C1SE1Q C1SE1W C1SE1CC C1SE1OO C1SE1QQ
tab1 C1SE1E C1SE1K C1SE1Q C1SE1W C1SE1CC C1SE1OO C1SE1QQ, miss

gen purplife1= C1SE1E
gen purplife2= C1SE1K
gen purplife3= C1SE1Q
gen purplife4= C1SE1W
gen purplife5= C1SE1CC
gen purplife6= C1SE1OO
gen purplife7= C1SE1QQ
recode purplife1 purplife3 purplife4 purplife7 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (-1 =.n) (8 =.r) 
recode purplife2 purplife5 purplife6 (7=0) (6=1) (5=2) (4=3) (3=4) (2=5) (1=6) (8=.r) (-1=.n)
label variable purplife1 "Don't think about the future"
label variable purplife2 "Have a sense of direction"
label variable purplife3 "Don't have a good sense of what they are trying to accomplish"
label variable purplife4 "Daily activities seem trivial to them"
label variable purplife5 "Enjoy making plans for future"
label variable purplife6 "They do not wander aimlessly through life"
label variable purplife7 "Feel they have already lived life"
label values  purplife1 purplife3 purplife4 purplife7 pwb
label values purplife2 purplife5 purplife6 pwbrc

tab purplife1 C1SE1E, miss
tab purplife2 C1SE1K, miss
tab purplife3 C1SE1Q, miss
tab purplife4 C1SE1W, miss
tab purplife5 C1SE1CC, miss
tab purplife6 C1SE1OO, miss
tab purplife7 C1SE1QQ, miss
tab1 purplife1 C1SE1E, miss
tab1 purplife2 C1SE1K, miss
tab1 purplife3 C1SE1Q, miss
tab1 purplife4 C1SE1W, miss
tab1 purplife5 C1SE1CC, miss
tab1 purplife6 C1SE1OO, miss
tab1 purplife7 C1SE1QQ, miss

egen purplife_scale  = rowtotal(purplife1-purplife7), miss
label variable purplife_scale "7 item scale for life Purpose"
sum purplife_scale purplife1-purplife7
sum purplife_scale, detail
tab purplife_scale, miss
replace purplife_scale = .r if purplife1 == .r & purplife2 == .r & purplife3 == .r & purplife4 == .r & purplife5 == .r & purplife6 == .r & purplife7 == .r
replace purplife_scale = .n if purplife1 == .n & purplife2 == .n & purplife3 == .n & purplife4 == .n & purplife5 == .n & purplife6 == .n & purplife7 == .n
label values purplife_scale pbwmiss
sum purplife_scale, detail
tab purplife_scale, miss

*listing to check consistency*
list M2ID purplife_scale purplife1-purplife7 if missing(purplife1-purplife7) in 1/20, nolabel
list M2ID purplife_scale purplife1-purplife7 if missing(purplife4) & !missing(purplife2), nolabel
list M2ID purplife_scale purplife1-purplife7 if !missing(purplife1-purplife7) in 100/150, nolabel



*Q1e*
sum C1SE1F C1SE1L C1SE1R C1SE1X C1SE1DD C1SE1JJ C1SE1PP
tab1 C1SE1F C1SE1L C1SE1R C1SE1X C1SE1DD C1SE1JJ C1SE1PP, miss
gen selfacc1= C1SE1F
gen selfacc2= C1SE1L
gen selfacc3= C1SE1R
gen selfacc4= C1SE1X
gen selfacc5= C1SE1DD
gen selfacc6= C1SE1JJ
gen selfacc7= C1SE1PP
recode selfacc1 selfacc2 selfacc4 selfacc7 (7=0) (6=1) (5=2) (4=3) (3=4) (2=5) (1=6) (8=.r) (-1=.n)
recode selfacc3 selfacc5 selfacc6 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=.r) (-1=.n)
label variable selfacc1 "pleased with how life has turned out"
label variable selfacc2 "feel positive and confident about theirself"
label variable selfacc3 "people have gotten more out of life than them"
label variable selfacc4 "like most aspects of personality"
label variable selfacc5 "feel disappointed about achievements in life"
label variable selfacc6 "attitude not as positive as most people's"
label variable selfacc7 "feel good after comparing self to friends"
label values selfacc3 selfacc5 selfacc6  pwb
label values selfacc1 selfacc2 selfacc4 selfacc7 pwbrc
tab selfacc1 C1SE1F, miss
tab selfacc2 C1SE1L, miss
tab selfacc3 C1SE1R, miss
tab selfacc4 C1SE1X, miss
tab selfacc5 C1SE1DD, miss
tab selfacc6 C1SE1JJ, miss
tab selfacc7 C1SE1PP, miss
tab1 selfacc1 C1SE1F, miss
tab1 selfacc2 C1SE1L, miss
tab1 selfacc3 C1SE1R, miss
tab1 selfacc4 C1SE1X, miss
tab1 selfacc5 C1SE1DD, miss
tab1 selfacc6 C1SE1JJ, miss
tab1 selfacc7 C1SE1PP, miss

egen selfacc_scale= rowtotal(selfacc1-selfacc7), miss
label variable selfacc_scale "7 item purpose in life scale"
replace selfacc_scale = .r if selfacc1 == .r & selfacc2 == .r & selfacc3 == .r & selfacc4 == .r & selfacc5 == .r & selfacc6 == .r & selfacc7 ==.r
replace selfacc_scale =.n if selfacc1 == .n & selfacc2 == .n & selfacc3 == .n & selfacc4 == .n & selfacc5 == .n & selfacc6 == .n & selfacc7 ==.n
label values selfacc_scale pbwmiss 
sum selfacc1-selfacc7 selfacc_scale
sum selfacc_scale, detail 
tab selfacc_scale, miss

list M2ID selfacc_scale selfacc1-selfacc7 if missing(selfacc1-selfacc7) in 1/20, nolabel
list M2ID selfacc_scale selfacc1-selfacc7 if missing(selfacc3) & !missing(selfacc4), nolabel
list M2ID selfacc_scale selfacc1-selfacc7 if !missing(selfacc1-selfacc7) in 100/150, nolabel


*Example#1 from lecture4*
*First making the auton variables*
sum C1SE1A C1SE1G C1SE1M C1SE1S C1SE1Y C1SE1EE C1SE1KK  
tab1 C1SE1A C1SE1G C1SE1M C1SE1S C1SE1Y C1SE1EE C1SE1KK
gen auton1 = C1SE1A 
gen auton2 = C1SE1G 
gen auton3 =  C1SE1M 
gen auton4 = C1SE1S 
gen auton5 = C1SE1Y 
gen auton6 = C1SE1EE
gen auton7 = C1SE1KK
recode auton1 auton2 auton4 auton7 (7=0) (6=1) (5=2) (4=3) (3=4) (2=5) (1=6) (8=.r) (-1=.n)
recode auton3 auton5 auton6 (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=.r) (-1=.n)
label variable auton1 "Not afraid to voice opinions"
label variable auton2 "Decisions are not influenced by what someone else is doing"
label variable auton3 "Gets influenced by people of strong opinions"
label variable auton4 "Have confidence in their own opinions"
label variable auton5 "Difficult for them to voice their own opinions"
label variable auton6 "Worries about what others think of them"
label variable auton7 "Judge myself by what they think is important, not what others think is"
label values auton1 auton2 auton4 auton7 pbwrc
label values auton3 auton5 auton6 pbw
tab1 C1SE1A auton1 , miss
tab1 C1SE1G auton2, miss
tab1 C1SE1M auton3, miss
tab1 C1SE1S auton4, miss
tab1 C1SE1Y auton5, miss
tab1 C1SE1EE auton6, miss
tab1 C1SE1KK auton7, miss
tab C1SE1A auton1, miss
tab C1SE1G auton2, miss
tab C1SE1M auton3, miss
tab C1SE1S auton4, miss
tab C1SE1Y auton5, miss
tab C1SE1EE auton6, miss
tab C1SE1KK auton7, miss 
sum auton1-auton7
egen auton_scale = rowtotal(auton1-auton7), missing
label variable auton_scale "7 Item autonomy scale"
sum auton_scale auton1-auton7
replace auton_scale = .n if auton1 == .n & auton2 ==.n & auton3 == .n & auton4 == .n & auton5 == .n & auton6 == .n & auton7 == .n
replace auton_scale = .r if auton1 == .r & auton2 == .r & auton3 == .r & auton4 == .r & auton5 == .r & auton6 == .r & auton7 == .r
label values auton_scale pwbmiss
*Now we continue with example 1 of lecture 4*

alpha auton1-auton7, item 
alpha auton1-auton7, item casewise 
alpha purplife1-purplife7, item
alpha purplife2-purplife7, item
alpha purplife2-purplife6, item

tab C1SRINC, miss

****************************PS9**********************************************************
tab C1SRINC, miss
recode C1SRINC (-1 = .i) (999998 =.n), gen(w3income)
label variable w3income "Wave -3 Income"
codebook C1SRINC 
label define incum .i "No SAQ Data" .n "Not calculated", add
label values w3income incum
numlabel incum, add force
tab w3income, miss
tab C1PB1, miss
recode C1PB1 (1/3 = 1) (4/5 =2) (6/7 =3) (8 =4) (9 =5) (10/12 =6) (97 = .d) (98 =.r), gen(w3educ6cat)
label variable w3educ6cat "recode of C1PB1"
label define educat 1 "less than high school" 2 "high school diploma or GED" 3 "some college" 4 "2-year degree" 5 "bachelor’s degree" 6 "more than bachelor’s degree" .d "Don't Know" .r "Refused"
label values w3educ6cat educat
numlabel educat, add
tab w3educ6cat, miss
tab C1PRAGE, miss
clonevar w3age = C1PRAGE
clonevar w3sex = C1PRSEX

fre w3age, tab(6)
tab1 w3income raceeth w3educ6cat w3sex, miss
sum w3income raceeth w3educ6cat w3sex w3age
mdesc w3income raceeth w3educ6cat w3sex w3age
mvpatterns w3income raceeth w3educ6cat w3sex w3age 
*after checking for possible back-coding we make the analytical flag
mark w3income_flag
markout w3income_flag w3income i.raceeth ib6.w3educ6cat i.w3sex w3age
label variable w3income_flag "analytic flag for wave 3 income - w3income(N =2492)"
tab w3income_flag, miss
regress w3income i.raceeth if w3income_flag==1, beta
regress w3income i.raceeth ib6.w3educ6cat if w3income_flag==1, beta
regress w3income i.raceeth ib6.w3educ6cat w3age i.w3sex if w3income_flag==1, beta


***************************** PS11*******************************************************
/* Using C1SC1, please create a dummy variable for whether or not respondents are insured (w3insured). */
tab C1SC1, miss 
recode C1SC1 (2 =0) (-1 = .i) (8 = .r), gen(w3insured)
label variable w3insured "Dummy variable for respondent's insurance coverage"
label define w3insured 0 "No" 1 "Yes" .r "Refused" .i "No SAQ Data"
label values w3insured w3insured
numlabel w3insured, add 
tab1 C1SC1 w3insured, miss
tab C1SC1 w3insured, miss

tab1 w3insured auton_scale, miss
logistic w3insured w3age
logistic w3insured auton_scale 
logistic w3insured i.woman
logistic w3insured ib1.evgsrhw1
logistic w3insured i.raceeth
logistic w3insured ib4.educw3