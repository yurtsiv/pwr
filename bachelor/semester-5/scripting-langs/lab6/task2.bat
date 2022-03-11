@ECHO off
SET /a sum=0

FOR /f "tokens=5 delims=	" %%A IN (Covid.txt) DO (
	SET /a sum+=%%A
)

ECHO %sum%