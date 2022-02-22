# powerCalcs
A script to calculate power costs for various power plans in NZ. 

I use this to find the cheapest power plan when flatting, and to compare if off-peak pricing plans are cheaper vs constant rates (turns out they normally are).
Data used is my own power usage over the past few years.

`ruby powerCalcs.rb`

Should probably implement some kind of inheritance or heriachal Power_Plan object but this was written hastily. 
Can add/modify new power plans as classes that follow the existing template - with a daily rate and a rate per kWh.
