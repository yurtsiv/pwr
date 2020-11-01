@echo off

type Covid.txt | ..\lab3\SelKol 3 1 6 7 | findstr /b 6 | findstr /e Poland | ..\lab3\SelKol 3 2 | NaturalSort.py | ..\lab3\SelKol 2 | PierwszeN 3