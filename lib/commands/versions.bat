@@echo off

SETLOCAL
SHIFT
IF "%1"=="--help" (
	goto Help
)

FOR /F "tokens=1,2,3 delims=," %%a in (%PYWE_HOME%\lib\pythonversions.txt) do (
	echo %%a	
)
goto End

:Help
echo --versions
echo     Displays a list of Python versions available for install

:End
ENDLOCAL