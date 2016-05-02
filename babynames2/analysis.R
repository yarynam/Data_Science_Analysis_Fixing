#SET WORKING DIRECTORY
setwd('~/Desktop/Data_Science_Analysis_Fixing/babynames2')

#LOAD LIBRARIES
library(ggplot2)
library(TSA)

#LOAD TABLES
basketball = read.csv('basketball.csv')
bb = read.csv('basketball_babies.csv')

football = read.csv('football.csv')
fb = read.csv('football_babies.csv')

presidents = read.csv('presidents.csv')
pb = read.csv('president_babies.csv')

total = read.csv('total_babies.csv')

#MERGE PRESIDENT BABIES TABLE WITH TOTAL NAME COUNT PER YEAR
############################################################
ratios = c()
t = c()
for (i in 1:dim(pb)[1]){
	this_year = pb$year[i]
	t[i] = total$sum[total$year==this_year]
	ratios[i] = pb$count[i] / total$sum[total$year==this_year]
}
pb$ratios = ratios
pb$total = t

#CREATE TABLES WITH DUMMY VARIABLES FOR EACH PRESIDENT NAME
############################################################
year = c(seq(1880,2014))
count = rep(0,length(year))
total = rep(0,length(year))
ratio = rep(0,length(year))
dummy = rep(0,length(year))


for(i in 1:length(presidents$name)){
	temp = data.frame(year,count,total,ratio,dummy)
	this_name = presidents$name[i]
	election_year = presidents[presidents$name==this_name,2][1]
	df = pb[pb$name==this_name,]
	for(i in 1:dim(df)[1]){
		this_year = df$year[i]
		temp[temp$year==this_year,2] = df$count[i]
		temp[temp$year==this_year,3] = df$total[i]
		temp[temp$year==this_year,4] = df$ratios[i]
		if(this_year >= election_year-1){
			temp[temp$year==this_year,5] = 1	
		}
	}
	temp$name = rep(this_name,length(year))
	assign(toString(this_name),temp)
	rm(temp)
}

#REGRESSION
############################################################
#Barack Obama
plot(Barack$year,Barack$count,type='l')
BarackFit = lm(Barack$count ~ Barack$year + Barack$dummy)
summary(BarackFit)
acf(Barack$count,plot=TRUE)

#Benjamin Harrison
plot(Benjamin$year,Benjamin$count,type='l')
BenjaminFit = lm(Benjamin$count ~ Benjamin$year + Benjamin$dummy)
summary(BenjaminFit)
acf(Benjamin$count,plot=TRUE)

#Woodrow Wilson
plot(Woodrow$year,Woodrow$count,type='l')
WoodrowFit = lm(Woodrow$count ~ Woodrow$year + Woodrow$dummy)
summary(WoodrowFit)
acf(Woodrow$count)

#Lyndon B. Johnson
plot(Lyndon$year,Lyndon$count,type='l')
LyndonFit = lm(Lyndon$count ~ Lyndon$year + Lyndon$dummy)
summary(LyndonFit)
acf(Lyndon$count)