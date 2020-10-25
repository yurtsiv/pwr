@echo off

type Covid.txt | ..\lab3\SelKol 3 6 11 | findstr /b 5 | ..\lab3\SelKol 2 3 | CustomSort.py | PierwszeN 1 | ..\lab3\SelKol 2