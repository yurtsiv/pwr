@echo off

type Covid.txt | ..\lab3\SelKol 3 5 11 | findstr /b 7 | findstr /e Africa | ..\lab3\SelKol 2 | ..\lab3\SumaNum
