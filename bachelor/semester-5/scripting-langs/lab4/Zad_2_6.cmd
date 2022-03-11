@echo off

type Covid.txt | ..\lab3\SelKol 3 1 6 7 | findstr /b %2 | findstr /e %1  | ..\lab3\SelKol 3 2 | CustomSort.py | PierwszeN %3