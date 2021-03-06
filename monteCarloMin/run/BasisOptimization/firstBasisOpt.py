#!/usr/bin/python
import sys
import os
import linecache

alphaStart = raw_input('Alpha Start = ')
alphaStart = float(alphaStart)
alphaEnd = raw_input('Alpha End = ')
alphaEnd = float(alphaEnd)
alphaNumSteps = raw_input('Alpha Number of Steps = ')
alphaNumSteps = int(alphaNumSteps)
alphaStepSize = (alphaEnd - alphaStart)/(alphaNumSteps-1)

tempAlpha = alphaStart

resultsfilename = 'FirstBasisOpt.txt'
results = open(resultsfilename, 'w')
results.write('Alpha        Energy\n')

while tempAlpha <= alphaEnd:
    outfilename = 'ebasis.inp'
    outfile = open(outfilename, 'w')
    outfile.write('NO. OF UNIQUE CENTERS\n')
        #Here is where the number of centers go. 
    outfile.write('1\n')
    outfile.write('---------------HELIUM-----------------------\n')
    outfile.write('CENTER\n')
        #Here is where the new centers (h's go). 
    outfile.write('0.0 0.0 0.0\n')
    outfile.write('SYMBOLS\n')
        #Here is where the total number of functions go.
    outfile.write('1\n')
    outfile.write('S 1\n')
    outfile.write('1 ' + str(tempAlpha) + 'd0 1.0d0')
    outfile.close()
    os.system('./script1.sh')
    answerfilename = 'ans.2'
    line = linecache.getline(answerfilename, 2)
    energyline = line.split()
    energy = energyline[1]
    linecache.clearcache()
    ansString = str(tempAlpha)+ ' ' + energy 
    results.write(ansString + '\n')
    tempAlpha = tempAlpha + alphaStepSize

results.close()

