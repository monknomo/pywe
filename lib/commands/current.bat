@@echo off

SETLOCAL
SHIFT
IF "%1"=="--help" (
	goto Help
)
FOR /F %%a in ('type "%PYWE_HOME%\lib\currentVersion.txt"') do (
	echo %%a	
)
goto End

:Help
echo --current 
echo     Displays the current Python in use

:End
ENDLOCAL