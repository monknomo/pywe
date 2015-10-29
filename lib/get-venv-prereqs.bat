rem this doesn't have real arg parsing
rem the args must be like this
rem none at all
rem --cert pathtocert
rem --cert pathtocert --insecure
rem --insecure
set /a $i=0
set $insecure=
set $certDir=
set $pipProxy=
SETLOCAL ENABLEDELAYEDEXPANSION
set /a $throwawayArgs=%1+2
set $certDirIsNext=
set $pipProxyIsNext=

for %%x in (%*) do (
    IF !$i! LSS !$throwawayArgs! (
        rem do nothing, these are the args that were used in earlier scripts
    ) ELSE (
        IF "%%x"=="--insecure" (
            IF "!$certDirIsNext!"=="1" (
                echo You must provide a certificate with the --cert flag
            ) ELSE (
                IF "!$proxyDirIsNext!"=="1" (
                    echo You must provide a proxy with the --proxy flag
                ) ELSE (
                    set $insecure=1
                )
            )
        ) ELSE (
            IF "%%x"=="--cert" (
                IF "!$certDirIsNext!"=="1" (
                    echo You must provide a certificate with the --cert flag
                ) ELSE (
                    IF "!$proxyDirIsNext!1" (
                        echo You must provide a proxy with the --proxy flag
                    ) ELSE (
                        set $certDirIsNext=1
                    )
                )
            ) ELSE (
                IF "%%x"=="--proxy" (
                    IF "!$certDirIsNext%!"=="1" (
                        echo you must provide a certificate with the --cert flag
                    ) ELSE (
                        IF "!$proxyDirIsNext!"=="1" (
                            echo You must provide a proxy with the --proxy flag
                        ) ELSE (
                            set $proxyDirIsNext=1
                        )
                    )
                ) ELSE (
                    IF "!$certDirIsNext!"=="1" (
                        IF ""=="%%x" (
                            echo You must provide a certificate with the --cert flag
                            goto End
                        )
                        set $certDir=%%x
                        set $certDirIsNext=
                    ) ELSE (
                        IF "!$proxyDirIsNext!"=="1" (
                            IF ""=="%%x" (
                                echo You must provide a proxy with the --proxy flag
                                goto End
                            )
                            set $pipProxy=%%x
                            set $pipProxyIsNext=
                        )
                        rem more elses go here
                    )
                )
            )
        )
    )
    set /a $i+=1
)

if ""=="%$insecure%" (
    goto ezInstallSecure
) else (
    if "1"=="%$insecure%" (
        goto ezInstallInsecure
    )
)

:checkPipOptions

if ""=="%$certDir%" (
    rem no cert flag
    if ""=="%$pipProxy%" (
        rem just proxy flag
        goto pipWithProxy
    ) else (
        rem no cert or proxy flag
        goto pip
    )
) else (
    rem cert flag
    if ""=="%$pipProxy%" (
        rem just cert flag
        goto pipWithCert
    ) else (
        rem cert and proxy flag
        goto pipWithProxyAndCert
    )
)

:checkVirtualEnvOptions
if ""=="%$certDir%" (
    rem no cert flag
    if ""=="%$pipProxy%" (
        rem just proxy flag
        goto virtualEnvWithProxy
    ) else (
        rem no cert or proxy flag
        goto virtualEnv
    )
) else (
    rem cert flag
    if ""=="%$pipProxy%" (
        rem just cert flag
        goto virtualEnvWithCert
    ) else (
        rem cert and proxy flag
        goto virtualEnvWithProxyAndCert
    )
)


:ezInstallSecure
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\easy_install.exe" (
    rem change download location
    echo easy install not found, installing easy install
    %PYWE_HOME%\lib\wget --no-check-certificate -N --output-document="%PYWE_HOME%\lib\downloads\get_ez_setup.py" https://bootstrap.pypa.io/ez_setup.py
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
    %PYWE_HOME%\lib\wget --no-check-certificate -N --output-document="%PYWE_HOME%\lib\downloads\get_ez_setup.py" https://bootstrap.pypa.io/ez_setup.py

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
    %PYWE_HOME%\lib\wget --no-check-certificate -N --output-document="%PYWE_HOME%\lib\downloads\get-pip.py" https://bootstrap.pypa.io/get-pip.py
    rem use the cert flag
    echo "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py" --cert %$certDir%
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py" --cert %$certDir%
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
        echo pip install failed
        endlocal & exit /b 1
    ) ELSE (
        echo pip installed
        goto checkVirtualEnvOptions
    )
)
goto checkVirtualEnvOptions

:pipWithProxy
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
    echo pip not found, installing pip
    %PYWE_HOME%\lib\wget --no-check-certificate -N --output-document="%PYWE_HOME%\lib\downloads\get-pip.py" https://bootstrap.pypa.io/get-pip.py
    rem use the proxy flag
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py" --proxy %$pipProxy%
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
        echo pip install failed
        endlocal & exit /b 1
    ) ELSE (
        echo pip installed
        goto checkVirtualEnvOptions
    )
)
goto checkVirtualEnvOptions

:pipWithProxyAndCert
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" (
    echo pip not found, installing pip
    %PYWE_HOME%\lib\wget --no-check-certificate -N --output-document="%PYWE_HOME%\lib\downloads\get-pip.py" https://bootstrap.pypa.io/get-pip.py
    rem use both the cert and proxy flags
    "%PYWE_HOME%\versions\%$CURRENT_PY%\python.exe" "%PYWE_HOME%\lib\downloads\get-pip.py" --cert %$certDir% --proxy %$pipProxy%
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

:virtualEnvWithProxy
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\virtualenv.exe" (
    echo virtualenv not installed, installing virtualenv
    pip install virtualenv --proxy %$pipProxy%
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
    pip install virtualenv --cert %$certDir%
    IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\virtualenv.exe" (
        echo virtualenv install failed
        endlocal & exit /b 1
    ) ELSE (
        echo virtualenv installed
    )
)
goto End

:virtualEnvWithProxyAndCert
IF NOT EXIST "%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\virtualenv.exe" (
    echo virtualenv not installed, installing virtualenv
    pip install virtualenv --cert %$certDir% --proxy %$pipProxy%
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
