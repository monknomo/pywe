@@echo off

FOR /F  %%a in (%PYWE_HOME%\lib\currentVersion.txt) do (
	SET $CURRENT_PY=%%a
)

"%PYWE_HOME%\versions\%$CURRENT_PY%\Scripts\pip.exe" %*