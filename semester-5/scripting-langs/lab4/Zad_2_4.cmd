@echo off

type Covid.txt | ..\lab3\SelKol 3 5 11 | findstr /b %2 | findstr /e %1 | ..\lab3\SelKol 2 | ..\lab3\SumaNum
