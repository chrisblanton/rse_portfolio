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
    
  
def shuffledeck(deck):
    random.shuffle(list(deck))
    return
    
def makedeck(deck):
    deck = range(16)
    deck = shuffledeck(list(deck))
    return 

board = ['Go', #0
         'Mediterranean Avenue', #1
         'Community Chest', #2
         'Baltic Avenue',  #3
         'Income Tax', #4
         'Reading Railroad', #5
         'Oriential Avenue', #6
         'Chance', #7
         'Vermont Avenue', #8
         'Connecticut Avenue', #9
         'In Jail/Just Visiting',#10 
         'St. Charless Place', #11
         'Electric Company', #12
         'States Avenue',  #13
         'Virginia Avenue', #14
         'Pennsylvania Railroad', #15
         'St. James Place', #16
         'Community Chest', #17
         'Tennessee Avenue', #18
         'New York Avenue', #19
         'Free Parking', #20
         'Kentucky Avenue', #21
         'Chance', #22
         'Indiana Avenue', #23 
         'Illinois Avenue', #24
         'B&O Railroad', #25
         'Atlantic Avenue', #26
         'Ventor Avenue',  #27
         'Water Works',  #28
         'Marvin Gardens', #29
         'Go to Jail', #30
         'Pacific Avenue', #31 
         'North Carolina Aveneue', #32
         'Community Chest', #33
         'Pennsylvania Avenue', #34
         'Short Line', #35
         'Chance', #36
         'Park Place', #37
         'Luxury Tax', #38
         'Boardwalk' #39
         ]
         

chance = ['Advance to Go (Collect $200)', #0
          'Advance to Illinois Ave. - If you pass Go, collect $200', #1
          'Advance to St. Charles Place – If you pass Go, collect $200', #2
          'Advance token to nearest Utility. If unowned, you may buy it from the Bank. If owned, throw dice and pay owner a total ten times the amount thrown. ', #3
          'Advance token to the nearest Railroad and pay owner twice the rental to which he/she is otherwise entitled. If Railroad is unowned, you may buy it from the Bank. ', #4
          'Advance token to the nearest Railroad and pay owner twice the rental to which he/she is otherwise entitled. If Railroad is unowned, you may buy it from the Bank. ', #5
          'Bank pays you dividend of $50', #6
          'Get out of Jail Free – This card may be kept until needed, or traded/sold', #7
          'Go Back 3 Spaces', #8
          'Go to Jail – Go directly to Jail – Do not pass Go, do not collect $200', #9
          'Make general repairs on all your property – For each house pay $25 – For each hotel $100 ', #10
          'Pay poor tax of $15', #11
          'Take a trip to Reading Railroad – If you pass Go, collect $200', #12
          'Take a walk on the Boardwalk – Advance token to Boardwalk', #13
          'You have been elected Chairman of the Board – Pay each player $50', #14
          'Your building loan matures – Collect $150' #15
          ]

communitychest = ['Advance to Go (Collect $200)', #0
                  'Bank error in your favor – Collect $200 ', #1
                  'Doctor\'s fees – Pay $50', #2
                  'From sale of stock you get $50', #3
                  'Get Out of Jail Free  – This card may be kept until needed or sold', #4
                  'Go to Jail – Go directly to jail – Do not pass Go – Do not collect $200', #5
                  'Grand Opera Night – Collect $50 from every player for opening night seats', #6
                  'Holiday Fund matures - Receive $100 ', #7
                  'Income tax refund – Collect $20', #8
                  'Life insurance matures – Collect $100', #9
                  'Pay hospital fees of $100 ', #10
                  'Pay school fees of $150', #11
                  'Receive $25 consultancy fee', #12
                  'You are assessed for street repairs – $40 per house – $115 per hotel', #13
                  'You have won second prize in a beauty contest – Collect $10',#14
                  'You inherit $100' #15
                  ]
              

                
ngames = 1000
nturns = 30
spacecounter = [0]*len(board)
initialpos = 0 #Start on Go
for game in range(0,ngames):
    pos = initialpos
    ndoubles = 0
    chancedeck = range(16)
    commdeck = range(16)
    random.shuffle(list(chancedeck))
    #print chancedeck
    random.shuffle(list(commdeck))
    #print commdeck
    for turn in range(0,nturns):
        ndoubles = 0 
        #Shuffle cards
        while ndoubles < 2:
            roll, doubles  = roll2d6()
            if doubles:
                ndoubles +=1
            pos = (pos + roll) % 39
            if pos == 30:
                pos = 10
                spacecounter[pos] += 1
                break
            spacecounter[pos] +=1
            #We only really care about Chance and CC cards that either send the player to jail or to another space. 
            #Chance Cards
            if pos in [7,22,36]:
                #Check to see if there are cards left, if there aren't reset the deck.
                if len(chancedeck) == 0:
                    #makedeck(chancedeck)
                    chancedeck = range(16)
                    random.shuffle(list(chancedeck))
                #Draw a card
                chancedraw = int(list(chancedeck).pop())
                #Handle the possibilities.
                if chancedraw == 0:
                    # Advance to Go.
                    pos = 0
                    spacecounter[pos] += 1
                if chancedraw == 1:
                    # Advance to Illinois Avenue
                    spacecounter[pos] -=1
                    pos = 24
                    spacecounter[pos] += 1
                if chancedraw == 2:
                    # Advance to St. Charles Place
                    spacecounter[pos] -= 1
                    pos = 11
                    spacecounter[pos] += 1
                if chancedraw == 3:
                    #Advance to nearest utility.
                    spacecounter[pos] -=1
                    if pos == 7:
                        pos = 12
                        spacecounter[pos] += 1
                    if pos == 22:
                        pos = 28
                        spacecounter[pos] += 1
                    if pos == 36:
                        pos == 12
                        spacecounter[pos] += 1
                if chancedraw == 4:
                    # Advance to nearest railroad.
                    spacecounter[pos] -= 1
                    if pos == 7:
                        pos = 15
                        spacecounter[pos] += 1
                    if pos == 22:
                        pos = 25
                        spacecounter[pos] += 1
                    if pos == 36:
                        pos = 5
                        spacecounter[pos] += 1
                if chancedraw == 5:
                    # Advance to nearest railroad. There are two of thest cards. 
                    spacecounter[pos] -= 1
                    if pos == 7:
                        pos = 15
                        spacecounter[pos] += 1
                    if pos == 22:
                        pos = 25
                        spacecounter[pos] += 1
                    if pos == 36:
                        pos = 5
                        spacecounter[pos] += 1
                if chancedraw == 8:
                    #Go back 3 spaces.
                    spacecounter[pos] -= 1
                    pos = pos - 3
                    spacecounter[pos] += 1
                if chancedraw == 9:
                    #Go to Jail.
                    spacecounter[pos] -= 1
                    pos = 10
                    spacecounter[pos] +=1
                if chancedraw == 12:
                    #Advance to the reading. 
                    spacecounter[pos] -= 1
                    pos = 5
                    spacecounter[pos] += 1
                if chancedraw == 13:
                    #Advance to Boardwalk.
                    spacecounter[pos] -= 1
                    pos = 39
                    spacecounter[pos] += 1
                    #Community Chest Cards
            if pos in [2,17,33]:
                #Check to see if there are cards left, if there aren't reset the deck.
                if len(commdeck) == 0:
                    #makedeck(commdeck)
                    commdeck = range(16)
                    random.shuffle(commdeck)
                    #Draw a card
                commdraw = int(list(commdeck).pop())
                #Handle the possibilities.
                if commdraw == 0:
                    #Advance to Go
                    spacecounter[pos] -= 1
                    pos = 0
                    spacecounter[pos] += 1
                if commdraw == 5:
                    #Go to jail
                    spacecounter[pos] -= 1
                    pos = 10
                    spacecounter[pos] += 1
            #Go to Jail if on go to jail.
            if pos == 30:
                pos = 10
                spacecounter[pos] += 1
            #Get an extra turn if you roll doubles less than 3 times.
            if ndoubles > 2:
                pos = 10
                spacecounter[pos] +=1
            # You still get to land on the space even if it is your third time. 

#print spacecounter            

#Normalized 
total =  sum(spacecounter)
print(total)
normspacecounter = spacecounter
for i in range(0,len(spacecounter)):
    #print float(spacecounter[i])/total
    normspacecounter[i] = float(spacecounter[i])/total*100
    print(board[i], normspacecounter[i])
print(sum(normspacecounter))
fig2 = plt.figure()
ax2 = fig2.add_axes([0.1, 0.3,0.9, 0.5])
mycolors = [
'white', #Go
'brown', #Med Ave
'white', #Comm
'brown', #Baltic
'white', #Income
'black', #Reading
'cyan',  #Oriential
'white', #Chance
'cyan',  #Vermont
'cyan',  #Conn
'white', #Jail
'purple', #St. Charles
'white',  #Electric
'purple', #States
'purple', #Virgina
'black', #Penn Railroad
'orange', #St. James
'white', #Community
'orange', #Tenn
'orange', #NY
'white', #Free parking
'red', #kentucky
'white', #chance
'red', #Indiana
'red', #Illinois
'black', #B&O
'yellow', #Atlantic
'yellow', #Ventor
'white', #Water
'yellow', #Marvin
'white', #Go to Jail
'green', #Pacific
'green', #North Carolina
'white', #Community chest
'green', #PA Ave
'black', #Short line
'white', #Chance
'blue', #Park Place
'white', #Luxury
'blue' #Boardwalk
]
#print mycolors
#print len(mycolors)
ax2.bar(range(len(board)),normspacecounter,align='center',color=mycolors)
ax2.set_xticks(range(len(board)))
ax2.set_xticklabels(board, rotation=90)
fig2.show()
a=input()
