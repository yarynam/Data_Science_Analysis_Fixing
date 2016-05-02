import csv
import sqlite3
import pandas as pd
from datetime import datetime as dt
from bs4 import BeautifulSoup as bs
import requests

#Table (pandas dataframe) named football containing all MVPs (1979-2014)
################################################################################################
football_mvp_names =  {
		'name' : ['Aaron','Peyton','Adrian','Aaron','Tom','Peyton',
		'Peyton','Tom','LaDainian','Shaun','Peyton','Peyton',
		'Steve','Rich','Kurt','Terrell','Brett','Brett',
		'Brett','Brett','Steve','Emmitt','Steve','Thurman',
		'Joe','Joe','Boomer','John','Lawrence','Marcus','Dan',
		'Joe','Mark','Ken','Brian','Earl'],
        'year' : [2014,2013,2012,2011,2010,2009,2008,2007,2006,2005,
        2004,2003,2002,2001,2000,1999,1998,1997,1996,1995,1994,1993,
        1992,1991,1990,1989,1988,1987,1986,1985,1984,1983,1982,1981,
        1980,1979]
        }

football = pd.DataFrame(football_mvp_names)
football.to_csv('football.csv',index=False)

#Table (pandas dataframe) named basketball containing all basketball MVPs (1980-2014)
################################################################################################
basketball_mvp_names = {
		'name' : ['Stephen','Kevin','LeBron','LeBron','Derrick',
		'LeBron','LeBron','Kobe','Dirk','Steve','Steve','Kevin',
		'Tim','Tim','Allen','Shaquille','Karl','Michael','Karl',
		'Michael','David','Hakeem','Charles','Michael','Michael',
		'Magic','Magic','Michael','Magic','Larry','Larry','Larry',
		'Moses','Moses','Julius'],
        'year' : [2014,2013,2012,2011,2010,2009,2008,2007,2006,
        2005,2004,2003,2002,2001,2000,1999,1998,1997,1996,1995,1994,
        1993,1992,1991,1990,1989,1988,1987,1986,1985,1984,1983,1982,
        1981,1980]
        }

basketball = pd.DataFrame(basketball_mvp_names)
basketball.to_csv('basketball.csv',index=False)

# #Table named 'presidential_approval' containing weekly presidential approval polling 1941 - 2016
# ################################################################################################
# presidential_approval = pd.read_csv('https://raw.githubusercontent.com/jcbain/celeb_baby_names/master/data/presApproval.csv',header=0)
# presidential_approval = pd.DataFrame({
# 	'name':presidential_approval['President'],
# 	'approving':presidential_approval['Approving '],
# 	'disapproving':presidential_approval['Disapproving '],
# 	'unsure':presidential_approval['unsure/no data'],
# 	'year':presidential_approval['End Date ']
# 	})

# print("\n\nUgh..this one takes a while...\n")
# for i in range(presidential_approval['year'].size):
# 	presidential_approval['year'][i] = dt.strptime(presidential_approval['year'][i],'%m/%d/%Y').year

# for i in range(presidential_approval['year'].size):
# 	presidential_approval['name'][i] = presidential_approval['name'][i].split(' ')[0]

# #DANGER LIES AHEAD -- 
# presidential_approval = presidential_approval.groupby(['year','name']).sum()

# #Refactoring approval/disapproval ratings to be in (0,1)
# total = presidential_approval['approving'] + presidential_approval['disapproving'] + presidential_approval['unsure']
# presidential_approval['approving'] = presidential_approval['approving'] / total
# presidential_approval['disapproving'] = presidential_approval['disapproving'] / total
# presidential_approval['unsure'] = presidential_approval['unsure'] / total

# #Export to csv file
# presidential_approval.to_csv('approval.csv',index=True)


#Table named 'presidents' containing all the names and starting dates in office for all 44 presidents
################################################################################################
res = requests.get('http://www.potus.com')
soup = bs(res.text,'html.parser')

ol = soup.find('ol')
a = ol.find_all('a')

strings = []
for i in range(len(a)):
	strings.append(str(a[i].text))

names = []
dates = []
for i in range(len(strings)):
	names.append(strings[i].split(' ')[0])
	dates.append(int(strings[i].split(' ')[-1].split('-')[0]))

names = names[20:]
dates = dates[20:]
presidents = pd.DataFrame({'name':names,'year':dates})
presidents.to_csv('presidents.csv',index=False)

#SQL queries to database.sqlite -- retrieving names per year from baby names table
################################################################################################
connection = sqlite3.connect('database.sqlite')
c = connection.cursor()

#PRESIDENTS
query = 'SELECT Name, Year, sum(Count) as count FROM NationalNames WHERE Name IN %s GROUP BY Year, Name' % str(tuple(names))
c.execute(query)
result1 = c.fetchall()
df1 = pd.DataFrame(result1, columns=['name','year','count'])
df1.to_csv('president_babies.csv',columns=['name','year','count'],index=False)

#MVP BASKETBALL PLAYER NAMES
query = 'SELECT Name, Year, sum(Count) as count FROM NationalNames WHERE Year>1975 AND Name in %s GROUP BY Year, Name' % str(tuple(basketball['name']))
c.execute(query)
result2 = c.fetchall()
df2 = pd.DataFrame(result2,columns=['name','year','count'])
df2.to_csv('basketball_babies.csv',columns=['name','year','count'],index=False)


#MVP FOOTBAL PLAYER NAMES
query = 'SELECT Name,Year,sum(Count) as count FROM NationalNames WHERE Year>1975 AND Name in %s GROUP BY Year, Name' % str(tuple(football['name']))
c.execute(query)
result3 = c.fetchall()
df3 = pd.DataFrame(result3,columns=['name','year','count'])
df3.to_csv('football_babies.csv',columns=['name','year','count'],index=False)

