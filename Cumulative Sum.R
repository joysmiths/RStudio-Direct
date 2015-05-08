# Cumulative Sum - a couple of examples

#################### NOTE: I PREFER THE AGGREGATE (LINE 11) AND DDPLY (LINES 26-) FUNCTIONS B/C OF THE FORMAT OF THE OUTPUT ###########################

### Condition cumulative sum - explanation at bottom on line 50

#sample dataframe:
data=data.frame(ID=c("0001","0002","0003","0004","0004","0004","0001","0001","0002","0003"),Saldo=c(10,10,10,15,20,50,100,80,10,10),place=c("grocery","market","market","cars","market","market","cars","grocery","cars","cars"))
data

#can use aggregate to return the cumulative sum/id:
# general form of the function
# aggregate(vartosum~category/orindiv/to/sum/by, function(x) max(cumsum(x)))

# example:
aggregate(Saldo~ID, data, function(x) max(cumsum(x)))

#to SEE the additive sum for each observation per ID:
# general form of function:
# within(dataframename, {nameofnewvar<-ave(nameofvartosum, vartosumby, FUN=cumsum)})

# example:
within(data, {Saldo.Total<-ave(Saldo, ID, FUN=cumsum)})


#########an alternative to aggregate is the ddply function from the plyr package:

# general form of function:
# library(plyr)
# ddply(nameofdataframe, .(identifiervar), summarize, nameofnewvar/newcategory=sum(vartosum))

# example:
library(plyr)
ddply(data, .(ID), summarize, Saldo.Total=sum(Saldo))

 #OR, again, to see the additive sum as you move along each ID:
library(plyr)
ddply(data, .(ID), transform, csum=cumsum(Saldo))

#another option
data$csum<-ave(data$Saldo, data$ID, FUN=cumsum)
data$csum

#and, another option 
library(data.table)
DT[, csum := cumsum(Saldo), by=ID]
DT


# conditional cumulative sums
# let's say you want to know the cumulative sum of a variable by YEAR and ID:
library(plyr)
ddply(dataframe, .(VarToSortBy1, VarToSortBy2), mutate, Target/OutcomeVar=cumsum(VarToSum))

# this option is my preferred method b/c the command is pretty efficient, the function leads to a new variable in the dataframe, and this function automatically sorts the data

# you can use the function in Base R:
transform(dataframe, TargetVar=ave(VarToSum, VarToSumBy1, VarToSumBy2, FUN=cumsum)) #not meaningful for factors

######## WHAT IF YOU WANT THE CUMULATIVE NO. OF TIMES AN ID OCCURS IN A DATAFRAME:
#general form of function:
dataframe$newVarName<-with(dataframe, ave(as.character(studentid), studentid, FUN=seq_along)) #don't know how you handle this when you need to group by more than one vari
#example:
lastschool$feeders<-with(lastschool, ave(as.character(stud_id), stud_id, FUN=seq_along))
#this might work as well:
IrlenWinterRdg$obs<-ave(IrlenWinterRdg$state_id, FUN=seq_along)

#from dplyr:
#(results in legit cumulative sum, NOT sum along/count by sequence -- so if you want to flag 1st, 4th, or 22nd instance, this ain't the code you're looking for)
newDataFrame<-origDataFrame %>% group_by(id) %>% mutate(count=n())                            #translaltes to : take this data frame AND (%>%) group it by student id AND create new variable (mutate) called "count" that sums the # of times id is present, and puts that in column for each row
#OR
newDataFrame<-origDataFrame %>% group_by(id, another vari, another vari) %>% mutate(count=n())

## You can use SPLITSTACKSHAPE when you need to sum ids by more than two groups:
http://stackoverflow.com/questions/22330069/generating-sequential-ids-within-a-nested-r-dataframe
library(splitstackshape)
getanID(mydf, c("vari1", "vari2", "vari3"))



