FOR /F "tokens=1,2,3 delims=," %%a in ('type "%PYWE_HOME%\lib\pythonversions.txt"') do (
	echo attempting to install %%a
	call %PYWE_HOME%\lib\commands\install --install %%a	
)