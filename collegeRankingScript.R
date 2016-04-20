cwurData <- read.csv("world-university-ranking/cwurData.csv", encoding="UTF-8")
cwurUSAData15 = subset(cwurData, country == "USA" & year == 2015)
cwurUSAData15$institution = as.character(cwurUSAData15$institution)
remove(cwurData)

timesData <- read.csv("world-university-ranking/timesData.csv")
timesUSAData15 = subset(timesData, country == "United States of America" & year == 2015)
remove(timesData)


shanghaiData <- read.csv("world-university-ranking/shanghaiData.csv", encoding="UTF-8")
school_and_country_table <- read.csv("~/CS/Big Data/Kaggle/world-university-ranking/school_and_country_table.csv")
shangWithCountry = merge(shanghaiData, school_and_country_table, by.x = "university_name", by.y = "school_name")
shanghaiUSAData = subset(shangWithCountry, country == "United States of America")
remove(shanghaiData)
remove(shangWithCountry)
remove(school_and_country_table)

Scorecard <- read.csv("college-scorecard-release-2015-09-23-15-08-57/output/Scorecard.csv", encoding="UTF-8")
accredScoreCard = subset(Scorecard, AccredAgency != "")
accredBachScoreCard = subset(accredScoreCard, accredScoreCard$PREDDEG == "Predominantly bachelor's-degree granting")
accredBachScoreCard$INSTNM<-as.character(accredBachScoreCard$INSTNM)
remove(accredScoreCard)
remove(Scorecard)

#View(subset(accredBachScoreCard, grepl("Columbia University", INSTNM, ignore.case = TRUE)))
accredBachScoreCard[accredBachScoreCard$Id == 119330,]$INSTNM = "Columbia University"
accredBachScoreCard[accredBachScoreCard$Id == 121210,]$INSTNM = "Purdue University"
accredBachScoreCard[accredBachScoreCard$Id == 118741,]$INSTNM = "University of Michigan"
accredBachScoreCard[accredBachScoreCard$Id == 116979,]$INSTNM = "Arizona State University"
accredBachScoreCard[accredBachScoreCard$Id == 120993,]$INSTNM = "University of Washington"
accredBachScoreCard[accredBachScoreCard$Id == 117963,]$INSTNM = ?"University of Illinois at Urbana-Champaign"
accredBachScoreCard[accredBachScoreCard$Id == 117815,]$INSTNM = "Georgia Institute of Technology"
accredBachScoreCard[accredBachScoreCard$Id == 121113,]$INSTNM = "University of Wisconsin-Madison"
accredBachScoreCard[accredBachScoreCard$Id == 118864,]$INSTNM = "University of Minnesota"
accredBachScoreCard[accredBachScoreCard$Id == 120263,]$INSTNM = "Pennsylvania State University"
accredBachScoreCard[accredBachScoreCard$Id == 120289,]$INSTNM = "University of Pittsburgh"
accredBachScoreCard[accredBachScoreCard$Id == 119892,]$INSTNM = "Ohio State University"
accredBachScoreCard[accredBachScoreCard$Id == 119223,]$INSTNM = "Rutgers, the State University of New Jersey"
accredBachScoreCard[accredBachScoreCard$Id == 118612,]$INSTNM = "University of Massachusetts"
accredBachScoreCard[accredBachScoreCard$Id == 120913,]$INSTNM = "University of Virginia"
accredBachScoreCard[accredBachScoreCard$Id == 120742,]$INSTNM = "Texas A&M University"
accredBachScoreCard[accredBachScoreCard$Id == 118114,]$INSTNM = "Indiana University"
accredBachScoreCard[accredBachScoreCard$Id == 120836,]$INSTNM = "William & Mary"
accredBachScoreCard[accredBachScoreCard$Id == 117492,]$INSTNM = "Colorado State University"
accredBachScoreCard[accredBachScoreCard$Id == 118992,]$INSTNM = "University of Missouri"
accredBachScoreCard[accredBachScoreCard$Id == 119094,]$INSTNM = "University of Nebraska-Lincoln"
accredBachScoreCard[accredBachScoreCard$Id == 119525,]$INSTNM = "Binghamton University, State University of New York"
accredBachScoreCard[accredBachScoreCard$Id == 120423,]$INSTNM = "University of South Carolina"
accredBachScoreCard[accredBachScoreCard$Id == 118405,]$INSTNM = "Louisiana State University"
accredBachScoreCard[accredBachScoreCard$Id == 119524,]$INSTNM = "State University of New York Albany"
accredBachScoreCard[accredBachScoreCard$Id == 119992,]$INSTNM = "Oklahoma State University"
accredBachScoreCard[accredBachScoreCard$Id == 121114,]$INSTNM = "University of Wisconsin-Milwaukee"

notInTimes = timesUSAData15[!(timesUSAData15$university_name%in%accredBachScoreCard$INSTNM),]

x=0
row = NULL
for (x in 1:nrow(notInTimes)) {
  row = notInTimes[x,]
  tempRow = subset(accredBachScoreCard, grepl(row$university_name, INSTNM, ignore.case = TRUE))
  if(nrow(tempRow) == 1){
    accredBachScoreCard[accredBachScoreCard$Id == tempRow$Id,]$INSTNM = row$university_name
  }
}

x=0
row = NULL
for (x in 1:nrow(accredBachScoreCard)) {
  row = accredBachScoreCard[x,]
  if (substr(row$INSTNM, 1, 4) == "The "){
    accredBachScoreCard[x,]$INSTNM = substr(row$INSTNM, start = 5, stop = nchar(row$INSTNM))
  }
  
  if(grepl("-Main Campus", row$INSTNM, ignore.case = TRUE)){
    accredBachScoreCard[x,]$INSTNM = gsub("-Main Campus", "", row$INSTNM, ignore.case = TRUE)
  }
  if(grepl("Main Campus", row$INSTNM, ignore.case = TRUE)){
    accredBachScoreCard[x,]$INSTNM = gsub("Main Campus", "", row$INSTNM, ignore.case = TRUE)
  }
  if(grepl("-", row$INSTNM)){
    accredBachScoreCard[x,]$INSTNM = gsub("-", ", ", row$INSTNM)
  }
  
}

# Method 1: using the native R adist
source1.devices<-accredBachScoreCard
source2.devices<-timesUSAData15
# To make sure we are dealing with charts
source1.devices$INSTNM <- as.character(source1.devices$INSTNM)
source2.devices$university_name <- as.character(source2.devices$university_name)

# It creates a matrix with the Standard Levenshtein distance between the name fields of both sources
dist.name<-adist(source1.devices$INSTNM, source2.devices$university_name, partial = TRUE, ignore.case = TRUE)

# We now take the pairs with the minimum distance
min.name<-apply(dist.name, 1, min)

match.s1.s2<-NULL  
for(i in 1:nrow(dist.name))
{
  s2.i<-match(min.name[i],dist.name[i,])
  s1.i<-i
  match.s1.s2<-rbind(data.frame(s2.i=s2.i,s1.i=s1.i,s2name=source2.devices[s2.i,]$university_name, s1name=source1.devices[s1.i,]$INSTNM, adist=min.name[i]),match.s1.s2)
}
# and we then can have a look at the results
View(match.s1.s2)

CWUR_SCORE[CWUR_SCORE$INSTNM == "University of Missouri",]$ADM_RATE_ALL

#View(subset(accredBachScoreCard, grepl("University of Missouri", INSTNM, ignore.case = TRUE)))
cwurUSAData15[cwurUSAData15$world_rank == 19,]$institution = "University of Michigan"
cwurUSAData15[cwurUSAData15$world_rank == 25,]$institution = "University of Wisconsin-Madison"
cwurUSAData15[cwurUSAData15$world_rank == 31,]$institution = "University of Washington"
cwurUSAData15[cwurUSAData15$world_rank == 33,]$institution = "University of Illinois at Urbana-Champaign"
cwurUSAData15[cwurUSAData15$world_rank == 43,]$institution = "Purdue University"
cwurUSAData15[cwurUSAData15$world_rank == 46,]$institution = "University of Pittsburgh"
cwurUSAData15[cwurUSAData15$world_rank == 47,]$institution = "Pennsylvania State University"
cwurUSAData15[cwurUSAData15$world_rank == 49,]$institution = "Ohio State University"
cwurUSAData15[cwurUSAData15$world_rank == 50,]$institution = "Rutgers, the State University of New Jersey"
cwurUSAData15[cwurUSAData15$world_rank == 52,]$institution = "Washington University in St Louis"
cwurUSAData15[cwurUSAData15$world_rank == 102,]$institution = "Texas A&M University"
cwurUSAData15[cwurUSAData15$world_rank == 106,]$institution = "Indiana University"
cwurUSAData15[cwurUSAData15$world_rank == 164,]$institution = "Indiana University, Purdue University, Indianapolis"
cwurUSAData15[cwurUSAData15$world_rank == 194,]$institution = "University of Missouri"
cwurUSAData15[cwurUSAData15$world_rank == 219,]$institution = "University of Massachusetts"
cwurUSAData15[cwurUSAData15$world_rank == 271,]$institution = "Colorado State University"
cwurUSAData15[cwurUSAData15$world_rank == 219,]$institution = "University of Massachusetts"
cwurUSAData15[cwurUSAData15$world_rank == 273,]$institution = "Buffalo State SUNY"
cwurUSAData15[cwurUSAData15$world_rank == 300,]$institution = "University of South Carolina"
cwurUSAData15[cwurUSAData15$world_rank == 314,]$institution = "University of Nebraska-Lincoln"
cwurUSAData15[cwurUSAData15$world_rank == 332,]$institution = "Louisiana State University"
cwurUSAData15[cwurUSAData15$world_rank == 350,]$institution = "University of Oklahoma, Norman Campus"
cwurUSAData15[cwurUSAData15$world_rank == 359,]$institution = "University of New Hampshire, Main Campus"
cwurUSAData15[cwurUSAData15$world_rank == 360,]$institution = "William & Mary"
cwurUSAData15[cwurUSAData15$world_rank == 380,]$institution = "Washington State University"
cwurUSAData15[cwurUSAData15$world_rank == 388,]$institution = "State University of New York Albany"
cwurUSAData15[cwurUSAData15$world_rank == 403,]$institution = "Binghamton University, State University of New York"
cwurUSAData15[cwurUSAData15$world_rank == 412,]$institution = "Oklahoma State University"
cwurUSAData15[cwurUSAData15$world_rank == 409,]$institution = "University of Alabama"
cwurUSAData15[cwurUSAData15$world_rank == 469,]$institution = "Texas Tech University"
cwurUSAData15[cwurUSAData15$world_rank == 489,]$institution = "University of Nebraska at Omaha"
cwurUSAData15[cwurUSAData15$world_rank == 510,]$institution = "University of Wisconsin-Milwaukee"
cwurUSAData15[cwurUSAData15$world_rank == 543,]$institution = "University of Akron"
cwurUSAData15[cwurUSAData15$world_rank == 550,]$institution = "University of Arkansas"
cwurUSAData15[cwurUSAData15$world_rank == 554,]$institution = "University of Missouri, Kansas City"
cwurUSAData15[cwurUSAData15$world_rank == 585,]$institution = "University of Montana"
cwurUSAData15[cwurUSAData15$world_rank == 590,]$institution = "Southern Illinois University, Carbondale"
cwurUSAData15[cwurUSAData15$world_rank == 748,]$institution = "University of Missouri, St Louis"

notInCwur = cwurUSAData15[!(cwurUSAData15$institution%in%accredBachScoreCard$INSTNM),]
#accredBachScoreCard$mn_earn_wne_p10 = as.numeric(accredBachScoreCard$mn_earn_wne_p10)
TIMES_SCORE = merge(accredBachScoreCard, timesUSAData15, by.x = "INSTNM", by.y = "university_name")
CWUR_SCORE = merge(accredBachScoreCard, cwurUSAData15, by.x = "INSTNM", by.y = "institution")
write.csv(TIMES_SCORE, file = "TIMES_SCORE.csv", row.names=FALSE)
write.csv(CWUR_SCORE, file = "CWUR_SCORE.csv", row.names=FALSE)

require(ggplot2)
qplot(TIMES_SCORE$female_male_ratio, TIMES_SCORE$ADM_RATE_ALL)
qplot(CWUR_SCORE$national_rank, CWUR_SCORE$ADM_RATE_ALL)

reg = lm(CWUR_SCORE$ADM_RATE_ALL ~ CWUR_SCORE$world_rank)
plot(CWUR_SCORE$world_rank, CWUR_SCORE$ADM_RATE_ALL)
abline(v = 194, col = "red")
abline(h = 0.7861, col = "red")
abline(reg)

reg = lm(CWUR_SCORE$ADM_RATE_ALL, CWUR_SCORE$national_rank)
plot(CWUR_SCORE$national_rank, CWUR_SCORE$ADM_RATE_ALL)
abline(reg)

reg = lm(CWUR_SCORE$NPT4_PUB ~ CWUR_SCORE$world_rank)
plot(CWUR_SCORE$world_rank, CWUR_SCORE$NPT4_PUB)
abline(reg)

reg = lm(CWUR_SCORE$RET_FT4 ~ CWUR_SCORE$world_rank)
plot(CWUR_SCORE$world_rank, CWUR_SCORE$RET_FT4)
abline(reg)

#CWUR_SCORE$gt_25k_p6 = as.numeric(CWUR_SCORE$gt_25k_p6)
reg = lm(CWUR_SCORE$ACTCM75 ~ CWUR_SCORE$world_rank)
plot(CWUR_SCORE$world_rank, CWUR_SCORE$ACTCM75)
abline(reg)

smoothScatter(CWUR_SCORE$national_rank, CWUR_SCORE$ADM_RATE_ALL)
