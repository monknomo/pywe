@@echo on

FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
	SET $CURRENT_PY=%%a
)

"%PYWE_HOME%\versions\%$CURRENT_PY%\py.exe" %*