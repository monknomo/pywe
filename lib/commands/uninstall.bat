rem @@echo off
SETLOCAL EnableDelayedExpansion
SHIFT
IF "%1"=="" (
	echo A python version to uninstall must be supplied
	echo use 'pywe --installed' to list installed versions
	goto End
) ELSE (
	IF "%1"=="--help" (
		goto Help
	) ELSE (
        IF "%1"=="--no-check-certificate" (
            SET $UNSAFE=1
            SHIFT
        )
    )
)

rem figure out what kind of uninstaller to expect and where it might be
FOR /F "tokens=1,2,3,4 delims=," %%a in ('type "%PYWE_HOME%\lib\pythonversions.txt"') do (
	IF "%%a"=="%1" (
		SET PYTHONDLVERSION=%%c
		SET PYTHONDLURL=%%b
        SET PYINSTSTYLE=%%d
		rem this is in lieu of a good way to break loops in batch files
		goto CheckForUninstaller
	)	
)

ECHO %1 is either unsupported or unrecogized as a version of PYTHONDLURL
ECHO %1 should be a Python version number
ECHO Try "pywe --versions" to see what is available
goto End

:CheckForUninstaller
IF "%PYINSTSTYLE%"=="msi1" (
    IF NOT EXIST "%PYWE_HOME%\lib\downloads\python-%1.msi" (
        echo Uninstaller not found, retrieving from the internet
        IF "%$UNSAFE%"=="1" (
            "%PYWE_HOME%\lib\wget.exe" --no-check-certificate --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" "%PYTHONDLURL%"  
        ) ELSE (
            "%PYWE_HOME%\lib\wget.exe" --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" "%PYTHONDLURL%"  
        )
    ) ELSE (
        rem do nothing
    )
    msiexec /x "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" TARGETDIR="%PYWE_HOME%\versions\%1" /qn
    del /Q /F /S "%PYWE_HOME%\versions\%PYTHONDLVERSION%"
    rd /S /Q "%PYWE_HOME%\versions\%PYTHONDLVERSION%"
    rem del /Q /F "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi"
) ELSE (
    IF "%PYINSTSTYLE%"=="exe1" (
        IF NOT EXIST "%PYWE_HOME%\lib\downloads\python-%1.exe" (
            echo Uninstaller not found, retrieving from the internet
            IF "%$UNSAFE%"=="1" (
                "%PYWE_HOME%\lib\wget.exe" --no-check-certificate --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" "%PYTHONDLURL%" 
            ) ELSE (
                "%PYWE_HOME%\lib\wget.exe" --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" "%PYTHONDLURL%" 
            )
        ) else (
            rem do nothing
        )
        echo uninstalling
        "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" /uninstall /passive TargetDir="%PYWE_HOME%\versions\%PYTHONDLVERSION%"
        rem del /Q /F "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe"

    ) ELSE (
        echo The Python installer style is not recognized
        echo There is a problem with your %PYWE_HOME%\lib\pythonversions.txt
    )
)
FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
	SET $CURRENT_PY=%%a
)
IF "%$CURRENT_PY%"=="%PYTHONDLVERSION%" (
    echo. > "%PYWE_HOME%\lib\currentVersion.txt"
    
    
)
GOTO End

:Help
echo --uninstall ^<version^>
echo     Uninstall the specified ^<version^>, if it exists
echo --uninstall --no-check-certificate ^<version^>
echo     Uninstall the specified ^<version^>, if it exists, does not check
echo     SSL certs
:End
ENDLOCAL