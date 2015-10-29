rem@@echo on

SETLOCAL EnableDelayedExpansion
 
SHIFT
set $caDirectory=
IF "%1"=="" (
	echo Please provide a Python version
	echo Use --versions to list available Python versions
	goto End
) ELSE ( 
	IF "%1"=="--help" (
		goto Help
	) ELSE (
        IF "%1"=="--no-check-certificate" (
            set $UNSAFE=1
            SHIFT
            IF "%1"=="--ca-directory" (
                SHIFT
                set $caDirectory=%1
                SHIFT
            ) ELSE (
                rem do nothing
            )
        ) ELSE (
            IF "%1"=="--ca-directory" (
                SHIFT set $caDirectory=%1
                SHIFT
                IF "%1"=="--no-check-certificate" (
                    set $UNSAFE=1
                    SHIFT
                ) ELSE (
                    rem do nothing
                )
            )
        )
    )
)

FOR /F "tokens=1,2,3,4 delims=," %%a in ('type "%PYWE_HOME%\lib\pythonversions.txt"') do (
	IF "%%a"=="%1" (
		SET PYTHONDLVERSION=%%c
		SET PYTHONDLURL=%%b
        SET PYINSTSTYLE=%%d
		rem this is in lieu of a good way to break loops in batch files
		goto InstallPython
	)	
)
rem if the python version isn't in pythonversions.txt, we can't install it
echo Python version not found
echo Use --versions to list available Python versions
goto End

:InstallPython
rem as of python 3.5.0 python stopped providing an msi installer
rem as most of the old installers are msi installers this requires two install
rem techniques.  Past is prologue, so pythonversions.txt now allows for 
rem specifiying an installation technique so we can accomodate even more
IF "%PYINSTSTYLE%"=="msi1" (
    IF NOT EXIST "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" (
        IF "%$UNSAFE%"=="1" (
            IF "%$caDirectory"=="" (
                "%PYWE_HOME%\lib\wget.exe" --no-check-certificate --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" "%PYTHONDLURL%"  
                if errorlevel 1 (
                    echo An error was encountered trying to download Python from
                    echo "%PYTHONDLURL%" 
                    del "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi"
                    GOTO End
                )        
            ) ELSE (
                "%PYWE_HOME%\lib\wget.exe" --no-check-certificate --ca-directory=%$caDirectory% --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" "%PYTHONDLURL%"  
                if errorlevel 1 (
                    echo An error was encountered trying to download Python from
                    echo "%PYTHONDLURL%" 
                    del "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi"
                    GOTO End
                )  
            )
        ) ELSE (
            "%PYWE_HOME%\lib\wget.exe" --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" "%PYTHONDLURL%"
            if errorlevel 1 (
                    echo An error was encountered trying to download Python from
                    echo "%PYTHONDLURL%" 
                    del "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi"
                    GOTO End
                )
        )
        IF "%PYWE_DEBUG%"=="1" (
            GOTO End
        )
    )

    
    rem the /a flag on msiexec is supposed to unzip the python installer as though it were an administrative network install.  It doesn't modify the system in any way
    rem this might be troublesome, in that python requires some dlls...
    echo Download complete, installing python %PYTHONDLVERSION%
    msiexec /i "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.msi" /qn TARGETDIR="%PYWE_HOME%\versions\%PYTHONDLVERSION%"
) ELSE (
    IF "%PYINSTSTYLE%"=="exe1" (
        IF NOT EXIST "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" (
            IF "%$UNSAFE%"=="1" (
                IF "%$caDirectory%"=="" (
                    "%PYWE_HOME%\lib\wget.exe" --no-check-certificate --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" "%PYTHONDLURL%"   
                    if errorlevel 1 (
                        echo An error was encountered trying to download Python from
                        echo "%PYTHONDLURL%" 
                        del "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe"
                        GOTO End
                    )
                ) ELSE (
                    "%PYWE_HOME%\lib\wget.exe" --no-check-certificate --ca-directory=%$caDirectory% --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" "%PYTHONDLURL%"   
                    if errorlevel 1 (
                        echo An error was encountered trying to download Python from
                        echo "%PYTHONDLURL%" 
                        del "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe"
                        GOTO End
                    )
                )
            ) ELSE (     
                "%PYWE_HOME%\lib\wget.exe" --continue --tries=5 --output-document="%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" "%PYTHONDLURL%" 
                if errorlevel 1 (
                    echo An error was encountered trying to download Python from
                    echo "%PYTHONDLURL%" 
                    del "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe"
                    GOTO End
                )
            )        
            IF "%PYWE_DEBUG%"=="1" (
                GOTO End
            )
            rem the /a flag on msiexec is supposed to unzip the python installer as though it were an administrative network install.  It doesn't modify the system in any way
            rem this might be troublesome, in that python requires some dlls...
            echo Download complete, installing python %PYTHONDLVERSION%
        )
        "%PYWE_HOME%\lib\downloads\python-%PYTHONDLVERSION%.exe" /passive TargetDir="%PYWE_HOME%\versions\%PYTHONDLVERSION%" Include_launcher=0 InstallLauncherAllUsers=0 SimpleInstall=1 Shortcuts=0 AssociateFiles=0
        
    ) ELSE (
        echo The Python installer style is not recognized
        echo There is a problem with your %PYWE_HOME%\lib\pythonversions.txt
    )
)
echo setting current version if it doesn't exist
IF NOT EXIST "%PYWE_HOME%\lib\currentVersion.txt" (
	echo "%1" > "%PYWE_HOME%\lib\currentVersion.txt"
)
GOTO End

:Help
echo --install ^<version^> 
echo     Installs that version of Python
echo --install --no-check-certificate ^<version^>
echo    Installs that version of Python, but does not check SSL certs
goto End

:End
IF "%PYWE_DEBUG%"=="1"  (
	echo done with trying to install
)
ENDLOCAL