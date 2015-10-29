rem @@ECHO off

SHIFT

rem check for prereqs




IF "%1"=="" (
	ECHO Please provide an argument
	ECHO Use --venv --help to see all options
	GOTO End
) ELSE (
	IF "%1"=="create" (
		shift
        FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
            SET $CURRENT_PY=%%a
        )
		GOTO createVenv
	) ELSE (
		IF "%1"=="activate" (
			shift
            FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
                SET $CURRENT_PY=%%a
            )
			GOTO activateVenv
		) ELSE (
			IF "%1"=="deactivate" (
				shift
                FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
                    SET $CURRENT_PY=%%a
                )
				GOTO deactivateVenv
			) ELSE (
				IF "%1"=="list" (
                    FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
                        SET $CURRENT_PY=%%a
                    )
					GOTO listVenv
				) ELSE (
					IF "%1"=="--help" (
					goto help
					)
				)
			)
		)
	)
)
GOTO end
rem pywe --venv create <name>
:createVenv
setlocal
set $venvName=%1
shift
call "%PYWE_HOME%\lib\get-venv-prereqs.bat" 2 %*
IF ERRORLEVEL 1 (
	goto end
)
IF EXIST "%PYWE_HOME%\virtualEnvironments\%$venvName%" (
	ECHO %$venvName% already exists
)

virtualenv "%PYWE_HOME%\virtualEnvironments\%$venvName%"
endlocal

GOTO end

rem pywe --venv use <name>
:activateVenv
setlocal
set $venvName=%1
shift
call "%PYWE_HOME%\lib\get-venv-prereqs.bat" 2 %*
IF ERRORLEVEL 1 (
	goto end
)
IF NOT EXIST "%PYWE_HOME%\virtualEnvironments\%$venvName%\Scripts\activate" (
	ECHO activate script doesn't exist
	IF NOT EXIST "%PYWE_HOME%\virtualEnvironments\%$venvName%" (
		ECHO %$venvName% does not appear to be a virtual environment
	)
	ECHO use ^'pywe --venv create ^<name^>^' to make a virtual environment
) ELSE (
	endlocal
	"%PYWE_HOME%\virtualEnvironments\%$venvName%\Scripts\activate.bat"
	goto End
)
endlocal
GOTO end

rem pywe --venv stop <name>
:deactivateVenv
setlocal
set $venvName=%1
shift
call "%PYWE_HOME%\lib\get-venv-prereqs.bat" 2 %*
IF ERRORLEVEL 1 (
	goto end
)
IF NOT EXIST "%PYWE_HOME%\virtualEnvironments\%$venvName%\Scripts\deactivate.bat" (
	ECHO deactivate script doesn't exist
	IF NOT EXIST "%PYWE_HOME%\virtualEnvironments\%$venvName%" (
		ECHO %$venvName% does not appear to be a virtual environment
	)
	ECHO use ^'pywe --venv create ^<name^>^' to make a virtual environment
) else (
	endlocal
	call "%PYWE_HOME%\virtualEnvironments\%$venvName%\Scripts\deactivate.bat"
	goto End
)
endlocal
GOTO end

:listVenv
dir %PYWE_HOME%\virtualEnvironments\* /b /a:d
GOTO end

:help
echo --venv 
echo     Manages Python virtual environments
echo     --venv create ^<name^>
echo         Creates a virtual environment called ^<name^>
echo     --venv activate ^<name^>
echo         Activates the existing virtual environment ^<name^>
echo     --venv deactivate ^<name^>
echo         Deactivates the exisiting virtual environment ^<name^>
echo     --venv list
echo         Lists all exisiting virtual environments
echo     --venv --help
echo         Displays all venv commands

:end