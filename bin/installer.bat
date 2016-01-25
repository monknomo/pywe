rem make the directory structure
mkdir %ALLUSERSPROFILE%\pywe
mkdir %ALLUSERSPROFILE%\pywe\bin > %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
mkdir %ALLUSERSPROFILE%\pywe\lib >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
mkdir %ALLUSERSPROFILE%\pywe\lib\downloads >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
mkdir %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
mkdir %ALLUSERSPROFILE%\pywe\shims >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
mkdir %ALLUSERSPROFILE%\pywe\versions >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
mkdir %ALLUSERSPROFILE%\pywe\virtualEnvironments >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
rem copy files to new directory structure
move /Y LICENSE.txt %ALLUSERSPROFILE%\pywe >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y README.txt %ALLUSERSPROFILE%\pywe >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y pywe.bat %ALLUSERSPROFILE%\pywe\bin >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y pythonversions.txt %ALLUSERSPROFILE%\pywe\lib >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y wget.exe %ALLUSERSPROFILE%\pywe\lib >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y *.dll %ALLUSERSPROFILE%\pywe\lib >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y wget_LICENSE.txt %ALLUSERSPROFILE%\pywe\lib >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y get-venv-prereqs.bat %ALLUSERSPROFILE%\pywe\lib >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y easy_install.bat %ALLUSERSPROFILE%\pywe\shims >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y pip.bat %ALLUSERSPROFILE%\pywe\shims >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y py.bat %ALLUSERSPROFILE%\pywe\shims >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y python.bat %ALLUSERSPROFILE%\pywe\shims >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y pythonw.bat %ALLUSERSPROFILE%\pywe\shims >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y virtualenv.bat %ALLUSERSPROFILE%\pywe\shims >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y current.bat %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y install.bat  %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y uninstall.bat  %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y use.bat  %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y versions.bat  %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
move /Y installed.bat  %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1 
move /Y venv.bat %ALLUSERSPROFILE%\pywe\lib\commands >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
rem set environment
rem this sets up PYWE_HOME for all future command line sessions
echo setting PYWE_HOME  >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
setx PYWE_HOME "%ALLUSERSPROFILE%\pywe" >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
rem this adds pywe itself to the path so you can do "pyin --command" type stuff
rem this adds the pywe shims to the path, which let you to "python blah.py" type stuff
echo adding pywe/shims and pywe/bin to path  >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1
setx PATH "%ALLUSERSPROFILE%\pywe\shims;%ALLUSERSPROFILE%\pywe\bin;%PATH%" >> %ALLUSERSPROFILE%\pywe\install_log.txt  2>&1

