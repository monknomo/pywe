rem this doesn't have real arg parsing
rem the args must be like this
rem none at all
rem --cert pathtocert
rem --insecure
rem only supports python 2.6+


set $UNSAFE=
set $caDirectory=
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
    SET $CURRENT_PY=%%a
)
SET $EZSURL=https://bootstrap.pypa.io/ez_setup.py

IF "%1"=="nocheckcertificate" (
    goto setUnsafe
) ELSE (
    IF "%1"=="cacertificate" (
        GOTO setCACERT
    ) ELSE (
        GOTO flagsSet
    )
)



rem annoying section to deal with variable expansion in if blocks
:setUnsafe
    echo UNSAFE SET
    set $UNSAFE=1
    SHIFT
    goto flagsSet

:setCACERT
    echo CACERT SETTING
    SHIFT
    set $caDirectory=%1
    set $caDirectory=%1
    SHIFT
    echo %1
    goto flagsSet

:flagsSet

if ""=="%$UNSAFE%" (
    if ""=="%$caDirectory%" (
        goto ezInstallSecure
    ) else (
        goto ezInstallSecureWithCert
    )
) else (
    goto ezInstallInsecure
)

:checkPipOptions

if ""=="%$UNSAFE%" (
    if ""=="%$caDirectory%" (
        rem no cert flag
        goto pip
    ) else (
        rem cert flag
        goto pipWithCert

    )
) else (
    rem insecure pip
    goto pipInsecure    
)


:checkVirtualEnvOptions

rem this step does not use wget and so the insecure flag is not relevant
if ""=="%$caDirectory%" (
    rem no cert flag
    goto virtualEnv
) else (
    rem cert flag
    goto virtualEnvWithCert
)



:ezInstallSecure
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\easy_install.exe" (
    rem change download location
    echo easy install not found, installing easy install
    %PYWE_HOME%\lib\wget -N --output-document="%PYWE_HOME%\lib\downloads\get_ez_setup.py"  %$EZSURL%
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get_ez_setup.py"
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\easy_install.exe" (
        echo easy install install failed
        endlocal & exit /b 1
    ) ELSE (
        echo easy install installed
        goto checkPipOptions
    )
)
goto checkPipOptions

:ezInstallSecureWithCert
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\easy_install.exe" (
    rem change download location
    echo easy install not found, installing easy install
    echo %PYWE_HOME%\lib\wget --ca-certificate=%$caDirectory% -N --output-document="%PYWE_HOME%\lib\downloads\get_ez_setup.py" %$EZSURL%
    %PYWE_HOME%\lib\wget --ca-certificate=%$caDirectory% -N --output-document="%PYWE_HOME%\lib\downloads\get_ez_setup.py" %$EZSURL%
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get_ez_setup.py"
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\easy_install.exe" (
        echo easy install install failed
        endlocal & exit /b 1
    ) ELSE (
        echo easy install installed
        goto checkPipOptions
    )
)
goto checkPipOptions

:ezInstallInsecure
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\easy_install.exe" (
    rem change download location
    echo easy install not found, installing easy install
    %PYWE_HOME%\lib\wget --no-check-certificate -N --output-document="%PYWE_HOME%\lib\downloads\get_ez_setup.py" %$EZSURL%
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get_ez_setup.py" --insecure    
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\easy_install.exe" (
        echo easy install install failed
        endlocal & exit /b 1
    ) ELSE (
        echo easy install installed
        goto checkPipOptions
    )
)
goto checkPipOptions

:pipWithCert
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
    echo pip not found, installing pip
    %PYWE_HOME%\lib\wget --ca-certificate=%$caDirectory% -N --output-document="%PYWE_HOME%\lib\downloads\get-pip.py" https://bootstrap.pypa.io/get-pip.py
    rem use the cert flag
    echo "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py" --cert %$caDirectory%
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py" --cert %$caDirectory%
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
        echo pip install failed
        endlocal & exit /b 1
    ) ELSE (
        echo pip installed
        goto checkVirtualEnvOptions
    )
)
goto checkVirtualEnvOptions

:pip
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
    echo pip not found, installing pip
    %PYWE_HOME%\lib\wget -N --output-document="%PYWE_HOME%\lib\downloads\get-pip.py" https://bootstrap.pypa.io/get-pip.py
    rem no flags at all, this is the default and should work for most people
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py"
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
        echo pip install failed
        endlocal & exit /b 1
    ) ELSE (
        echo pip installed
        goto checkVirtualEnvOptions
    )
)
goto checkVirtualEnvOptions

:pipInsecure
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
    echo pip not found, installing pip
    %PYWE_HOME%\lib\wget --no-check-certificate -N --output-document="%PYWE_HOME%\lib\downloads\get-pip.py" https://bootstrap.pypa.io/get-pip.py
    rem no flags at all, this is the default and should work for most people
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py"
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
        echo pip install failed
        endlocal & exit /b 1
    ) ELSE (
        echo pip installed
        goto checkVirtualEnvOptions
    )
)
goto checkVirtualEnvOptions

:virtualEnv
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\virtualenv.exe" (
    echo virtualenv not installed, installing virtualenv
    pip install virtualenv
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\virtualenv.exe" (
        echo virtualenv install failed
        endlocal & exit /b 1
    ) ELSE (
        echo virtualenv installed
    )
)
goto End

:virtualEnvWithCert
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\virtualenv.exe" (
    echo virtualenv not installed, installing virtualenv
    pip install virtualenv --cert %$caDirectory%
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\virtualenv.exe" (
        echo virtualenv install failed
        endlocal & exit /b 1
    ) ELSE (
        echo virtualenv installed
    )
)
goto End

:End

ENDLOCAL
