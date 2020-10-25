@echo off

for %%a in (Europe America Africa Asia Oceania) do (
    echo %%a
    type Covid.txt | ..\lab3\SelKol 5 11 | findstr %%a | ..\lab3\SelKol 1 | ..\lab3\SumaNum
)