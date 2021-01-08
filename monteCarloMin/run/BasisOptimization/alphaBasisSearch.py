#!/usr/bin/python
import sys
import math
import os
import linecache
import re

alphaStart = raw_input('Alpha Start = ')
alphaStart = float(alphaStart)
alphaEnd = raw_input('Alpha End = ')
alphaEnd = float(alphaEnd)
alphaStepSize = raw_input('Step Size = ')
alphaStepSize = float(alphaStepSize)
numOfSteps = ((alphaEnd - alphaStart)/alphaStepSize) +1.
numOfSteps = int(numOfSteps)

inputfile = 'ebasis.basTplate'
inputf = open(inputfile, 'r')
inputContents = inputf.read()
outputfilename = 'ebasis.inp'
answerfilename = 'ans.2'
resultsfilename = 'BSResults.txt'
results = open(resultsfilename, 'w')
results.write('Alpha    Energy    Best\n')
tempAlpha = alphaStart

bestEng = 999.
best = ' '
Step = 0
while tempAlpha < (alphaEnd+alphaStepSize):
    Step = Step + 1
    output = open(outputfilename, 'w')
    tempStr = re.sub('alpha', str(tempAlpha)+'d0',inputContents)
    pAlpha = (math.sqrt(8*tempAlpha))/(4*tempAlpha)
    tempStr = re.sub('y1', str(pAlpha),tempStr)
    dAlpha = (math.sqrt(16*tempAlpha))/(4*tempAlpha)
    tempStr = re.sub('y2', str(dAlpha),tempStr)
    output.write(tempStr)
    output.close()
    os.system('./script1.sh')
    line = linecache.getline(answerfilename,2)
    linecache.clearcache()
    energyline = line.split()
    energy = float(energyline[1])
    if energy < bestEng:
        bestAlpha = tempAlpha
        bestEng = energy
        best = ' Yes '
    ansString = str(tempAlpha) + 'd0    ' + str(energy) + '    ' + best + '\n'
    results.write(ansString)
    best = ' '
    print('Alpha = '+ str(tempAlpha))
    tempAlpha = tempAlpha + alphaStepSize
    print('Step # ' + str(Step))
    print('Number of Steps = ' + str(numOfSteps))
    percentComplete = float(Step)/float(numOfSteps)*100.
    print('Percent Complete = '+str(percentComplete))
results.write('Best Alpha = '+str(bestAlpha)+'d0')
print('Best Alpha = '+str(bestAlpha))

inputf.close()
results.close()
    

