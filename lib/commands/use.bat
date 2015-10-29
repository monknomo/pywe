@@echo off

SHIFT
IF "%1"=="" (
	echo Please provide a Python version
	echo Use --versions to list available Python versions
	goto End
) ELSE (
	IF "%1"=="--help" (
		goto Help
	)
)
FOR /F %%G in ('dir /A:D /B %PYWE_HOME%\versions\*') do (
	IF "%1"=="%%G" (
		echo %1 > "%PYWE_HOME%\lib\currentVersion.txt"
		goto End
	)
)
echo %1 is not an installed version
echo use 'pywe --installed' to show installed versions
goto End  

:Help
echo --use ^<version^>
echo     Switches to the specificed Python version, if it is installed

:End