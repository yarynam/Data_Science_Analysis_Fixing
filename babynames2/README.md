# Baby names dataset

This repository has three scripts that serve as a review to the questions originally presented for this dataset. The file 'DataAnalysisFix.py' contains a script that handles the original sqlite database and creates several tables of reduced size. Due to the size of the file, the database is not included, but all of the tables outputted by 'DataAnalysisFix.py' are. 

## 'Analysis.R'
The file 'analysis.R' takes the tables included in this repository and uses them in order to create several time series. Using tables that correspond to presidents, mvp basketball and football players and their respective inauguration, or recipient year we were able to create sets of time series with a simple dummy variable to measure the impact of their popularity on the amount of baby names that correspond to their first name. Hence a simple equation y = x + x(dummy) + e leads to an easy approach to estimate this impact.

## Questions answered: 
1. Does the approval rating of a President influence the rate of babies named after them?
The original approach to the problem focused on approval ratings. Nonetheless it is harder to use approval ratings than simply creating a before-and-after evaluation method. The plots in Analysis.R present several cases. For example, the plots of the popularity of the name 'Barack', 'Woodrow', or 'Lyndon' all present noticeable trend changes after the corresponding period for that president. However, the model captures only a significant variable in the case of Barack Obama, when the intercept is not significant and the year variable is also not significant. In the case of Lyndon B. Johnson, it can be seen that there are significant variables, but there is a a large lag and intercepts. In other words the changes on the name popularity follows trends in the population (baby boomers, etc). A few other cases are shown in the script to demonstrate that this simple statistical approach is useful in deciding whether a large change is significant or not.

2. Does a famous sports player's MVP status influence the popularity of babies named after their MVP recognition?

