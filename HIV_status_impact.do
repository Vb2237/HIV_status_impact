
Download data from https://www.openicpsr.org/openicpsr/project/113268/version/V1/view?path=/openicpsr/113268/fcr:versions/V1/Thornton-HIV-Testing-Data.dta&type=file 

use Thornton HIV Testing Data.dta, clear

//Data Cleansing//
drop if missing(test2004)
drop if missing(age)
drop if missing(age2)
drop if missing(Ti)
drop if missing(villnum)
drop if missing(got)
drop if hiv2004== -1

//Look at summary statistics of the sample//
summarize 

//Check if there is a difference between the treatment and control group//
*Incentive
sum age educ2004 hiv2004 if any==1 // age:33, educ2004:3, hiv2004: 6.2%
sum age educ2004 hiv2004 if any==0 // age:32, educ2004:4, hiv2004: 6.3%

*Distance
sum age educ2004 hiv2004 if under==1// age:32, educ2004:3, hiv2004: 8%
sum age educ2004 hiv2004 if under==0// age:33, educ2004:3, hiv2004:5%

//Test weather differences in age, HIV rates, and marriage are statistically different between the treatment and control group//
*Incentive
ttest age, by(any)
ttest hiv2004, by (any)
ttest mar, by (any)

*Distance
ttest age, by(under)
ttest hiv2004, by (under)
ttest mar, by (under)

//Create bar graphs to see the effects of the treatment//
label define anylabel 0 "No Incentive" 1 "Any Incentive"
label values any anylabel 
graph bar (percent) got, over(any) ytitle("percentage") blabel(total)

//Create the same bar graph, this time varying the amount of cash that people receive in treatment//

graph bar (percent) got, over(Ti) ytitle("percentage") blabel(total) xtitle ("Amount of Cash Received")
 
//Run an OLS regression where getting you HIV test result is the dependent variable, and receiving a cash incentive is your covariate//
reg got any, robust
reg got any age male educ2004 mar, robust

//Use a group means comparison this time//
ttest got, by (any)

//Run a similar OSL regression, replacing "Any Cash Incentive" with "Cash Amount"//
reg got Ti, robust
reg got Ti age male educ2004 mar, robust


//Find out if giving cash incentives have a different effect for men and women//
reg got Ti if male==0, robust
reg got Ti if male==1, robust

//Estimate the difference in treatment effects between men and women//
reg got i.male##i.any
