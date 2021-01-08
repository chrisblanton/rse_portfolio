#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  7 11:30:13 2016
Simulation of Monoopoly to determine probabilities of landing of certain squares.
@author: cjb47
"""
import random
import matplotlib.pyplot as plt

def rolld6():
    roll = random.randint(1,6)
    return roll

def roll2d6():
    roll1 = rolld6()
    roll2 = rolld6()
    if roll1 == roll2:
        doubles = True
    else:
        doubles = False
    roll = roll1+roll2
    return roll, doubles    


board = ['Go', 'Mediterranean Avenue', 'Community Chest','Baltic Avenue', 'Income Tax',  
         'Reading Railroad', 'Oriential Avenue', 'Chance', 'Vermont Avenue',
         'Connecticut Avenue', 'In Jail/Just Visiting', 'St. Charless Place',
         'Electric Company', 'States Avenue', 'Virginia Avenue', 'Pennsylvania Railroad',
         'St. James Place', 'Community Chest', 'Tennessee Avenue', 'New York Avenue', 
         'Free Parking', 'Kentucky Avenue', 'Chance', 'Indiana Avenue', 'Illinois Avenue',
         'B&O Railroad', 'Atlantic Avenue', 'Ventor Avenue', 'Water Works', 'Marvin Gardens',
         'Go to Jail', 'Pacific Avenue', 'North Carolina Aveneue', 'Community Chest', 
         'Pennsylvania Avenue', 'Short Line', 'Chance', 'Park Place', 'Luxury Tax', 'Boardwalk']
         

#xsum = 0.0
#ntrials = 10000000
#for i in range(0,ntrials):
#    xval = roll2d6()
#    xsum += xval
#print xsum/float(ntrials)


# I am going to assume that the player always pays to get out of jail for my 
# first version
ngames = 10000
nturns = 10
spacecounter = [0]*len(board)
initialpos = 0 #Start on Go
for game in range(0,ngames):
    pos = initialpos
    ndoubles = 0
    for turn in range(0,nturns):
        roll, doubles = roll2d6()
        if doubles:
            ndoubles += 1
        else:
            ndoubles = 0
        if ndoubles > 2:
            pos = 10
            continue
        pos = (pos + roll) % 40
        spacecounter[pos] += 1
        if pos == 30:
            pos = 10   
#print spacecounter        
#fig = plt.bar(range(len(board)),spacecounter)

#fig = plt.figure()
#ax = fig.add_axes([0.1, 0.3,0.9, 0.5])
#ax.bar(range(len(board)),spacecounter,align='center')
#ax.set_xticks(range(len(board)))
#ax.set_xticklabels(board, rotation=90)
#fig.show()

#Normalized 
total =  sum(spacecounter)
print(total)
normspacecounter = spacecounter
for i in range(0,len(spacecounter)):
    #print float(spacecounter[i])/total
    normspacecounter[i] = float(spacecounter[i])/total*100
print(sum(normspacecounter))
fig2 = plt.figure()
ax2 = fig2.add_axes([0.1, 0.3,0.9, 0.5])
ax2.bar(range(len(board)),normspacecounter,align='center')
ax2.set_xticks(range(len(board)))
ax2.set_xticklabels(board, rotation=90)
fig2.show()
