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


hStart = raw_input('H Start = ')
hStart = float(hStart)
hEnd = raw_input('H End = ')
hEnd = float(hEnd)
hNumSteps = raw_input('H Number of Steps = ')
hNumSteps = int(hNumSteps)
hStepSize = (hEnd - hStart)/(hNumSteps-1)

tempAlpha = alphaStart
previousBestBasisFile = 'pBB.txt'
pBB = open(previousBestBasisFile, 'r')
previousBest = pBB.read()
pBBNumOfCenters = int(linecache.getline(previousBestBasisFile, 2))
linecache.clearcache()
numOfCenters = pBBNumOfCenters + 6

resultsfilename = 'BasisOpt.txt'
results = open(resultsfilename, 'w')
results.write('H        Alpha        Energy\n')

bestEng = 999.
while tempAlpha <= alphaEnd:
    tempH = hStart
    while tempH <= hEnd:
        outfilename = 'ebasis.inp'
        outfile = open(outfilename, 'w')
        outfile.write('NO. OF UNIQUE CENTERS\n')
        outfile.write(str(numOfCenters)+ '\n')
        #This all needs to be rewritten because this isn't how the centers are read.
        outfile.write(previousBest+'\n')
        #First p equivlent
        outfile.write('---------------HELIUM-----------------------\n')
        outfile.write('CENTER\n')
        outfile.write(str(tempH) + ' 0. 0. \n')
        outfile.write('S 1\n')
        outfile.write(' 1 ' + str(tempAlpha) + 'd0 1.0d0\n')
        #2nd p equivlanet
        outfile.write('---------------HELIUM-----------------------\n')
        outfile.write('CENTER\n')
        outfile.write('0. ' + str(tempH) + ' 0. \n')
        outfile.write('S 1\n')
        outfile.write(' 1 ' + str(tempAlpha) + 'd0 1.0d0\n')
        #3rd p equivalent
        outfile.write('---------------HELIUM-----------------------\n')
        outfile.write('CENTER\n')
        outfile.write('0. 0. ' + str(tempH) + '\n')
        outfile.write('S 1\n')
        outfile.write(' 1 ' + str(tempAlpha) + 'd0 1.0d0\n')
        #First d Equivalent
                outfile.write('---------------HELIUM-----------------------\n')
        outfile.write('CENTER\n')
        outfile.write(str(tempH) + ' 0. ' + str(tempH) + '\n')
        outfile.write('S 1\n')
        outfile.write(' 1 ' + str(tempAlpha) + 'd0 1.0d0\n')
        #Second d
        outfile.write('---------------HELIUM-----------------------\n')
        outfile.write('CENTER\n')
        outfile.write('0. '+ str(tempH)+ ' ' + str(tempH) + '\n')
        outfile.write('S 1\n')
        outfile.write(' 1 ' + str(tempAlpha) + 'd0 1.0d0\n')
        #Third d
        outfile.write('---------------HELIUM-----------------------\n')
        outfile.write('CENTER\n')
        outfile.write(str(tempH) + ' ' + str(tempH) + ' 0.'+ '\n')
        outfile.write('S 1\n')
        outfile.write(' 1 ' + str(tempAlpha) + 'd0 1.0d0\n')
        outfile.close()
        os.system('./script1.sh')
        answerfilename = 'ans.2'
        line = linecache.getline(answerfilename, 2)
        energyline = line.split()
        energy = energyline[2]
        if energy < best:
            bestAlpha = tempAlpha
            bestH = tempH
        linecache.clearcache()
        ansString = str(tempH) + ' '+ str(tempAlpha)+ ' ' + energy 
        results.write(ansString + '\n')
        tempH = tempH + hStepSize
    tempAlpha = tempAlpha + alphaStepSize

pBB = open(previousBestBasisFile, 'w')
pBB.write(previousBest+'\n')
        #First p equivlent
pBB.write('---------------HELIUM-----------------------\n')
pBB.write('CENTER\n')
pBB.write(str(bestH) + ' 0. 0. \n')
pBB.write('S 1\n')
pBB.write(' 1 ' + str(bestAlpha) + 'd0 1.0d0\n')
        #2nd p equivlanet
pBB.write('---------------HELIUM-----------------------\n')
pBB.write('CENTER\n')
pBB.write('0. ' + str(bestH) + ' 0. \n')
pBB.write('S 1\n')
pBB.write(' 1 ' + str(bestAlpha) + 'd0 1.0d0\n')
        #3rd p equivalent
pBB.write('---------------HELIUM-----------------------\n')
pBB.write('CENTER\n')
pBB.write('0. 0. ' + str(bestH) + '\n')
pBB.write('S 1\n')
pBB.write(' 1 ' + str(bestAlpha) + 'd0 1.0d0\n')
        #First d Equivalent
pBB.write('---------------HELIUM-----------------------\n')
pBB.write('CENTER\n')
pBB.write(str(bestH) + ' 0. ' + str(bestH) + '\n')
pBB.write('S 1\n')
pBB.write(' 1 ' + str(bestAlpha) + 'd0 1.0d0\n')
        #Second d
pBB.write('---------------HELIUM-----------------------\n')
pBB.write('CENTER\n')
pBB.write('0. '+ str(bestH)+ ' ' + str(bestH) + '\n')
pBB.write('S 1\n')
pBB.write(' 1 ' + str(bestAlpha) + 'd0 1.0d0\n')
        #Third d
pBB.write('---------------HELIUM-----------------------\n')
pBB.write('CENTER\n')
pBB.write(str(bestH) + ' ' + str(bestH) + ' 0.'+ '\n')
pBB.write('S 1\n')
pBB.write(' 1 ' + str(bestAlpha) + 'd0 1.0d0\n')

results.close()
        
