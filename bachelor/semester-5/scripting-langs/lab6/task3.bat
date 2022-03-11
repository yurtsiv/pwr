@ECHO off
SET /a sum=0
SET /p country=Country: 

FOR /f "tokens=5,7 delims=	" %%a IN (Covid.txt) DO (
	IF "%%b"=="%country%" SET /a sum+=%%a
)

ECHO %sum%