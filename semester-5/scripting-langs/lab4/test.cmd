@echo off


SET letters[0]=A
SET letters[1]=B
SET letters[2]=C
SET letters[3]=D
SET letters[4]=E
SET letters[5]=F
SET letters[6]=G
SET letters[7]=H
SET letters[8]=I
SET letters[9]=J
SET letters[10]=K
SET letters[11]=L
SET letters[12]=M
SET letters[13]=N
SET letters[14]=O
SET letters[15]=P
SET letters[16]=Q
SET letters[17]=R
SET letters[18]=S
SET letters[19]=T
SET letters[20]=U
SET letters[21]=V
SET letters[22]=W
SET letters[23]=X
SET letters[24]=Y
SET letters[25]=Z

setlocal enableDelayedExpansion

FOR /F "tokens=1,2" %%A IN (Covid.txt) DO (
    FOR %%p IN (%*) DO (
        echo %%!letters[%%p]!
    )
)
