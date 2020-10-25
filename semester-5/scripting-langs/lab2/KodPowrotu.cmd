@echo off

KodPowrotu.exe /s %1

IF %ERRORLEVEL% LSS 10 (
    ECHO Przekazano: %1
    goto exit
)
IF %ERRORLEVEL% EQU 11 (
    ECHO Brak parametrow
    goto exit
)
IF %ERRORLEVEL% EQU 12 (
    ECHO Parametr X nie jest cyfra
    goto exit
)

:exit
