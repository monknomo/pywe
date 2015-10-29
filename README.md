Installing PyWE
=====================

To install PyWE, download the latest release, double click on the installer and agree to the license.  PyWE will be installed to your computer.  The default installation is to %ALLUSERSPROFILE%\pywe.  %PYWE_HOME% is created and the system %PATH% is modified.

Using PyWE
-------------

From the command line type pywe --help to get a list of commands and their usage.  

PyWE is extensible, but includes a basic list of commands to start with.

* "pywe --commands" displays a list of commands
* "pywe --current" displays the current version of Python in use
* "pywe --install <version>" installs the specified version of Python
* "pywe --installed" returns a list of installed versions of Python
* "pywe --uninstall <version>" uninstalls the specified version of Python, if it is installed
* "pywe --use" <version> switches to the specified version of Python, if it is installed
* "pywe --versions" displays a list of all currently supported Python versions to install

Manual Installation
--------------------

If you prefer to 'build from source', download/clone this repository to your machine.  Installing from the exe is the recommended approach for normal usage.

### Installation

Unzip or clone pywe to your chosen directory.  The exe installer uses %ALLUSERSPROFILE%\pywe.  For the purposes of discussion, lets say you've put PyWE in c:\pywe

### Set some environment variables

Environment variables can be set in the GUI or through the command line.  The command line is the preferred method for manual PyWE installs, because it is easier to describe.

Establish your %PYWE_HOME% 
    
	setx PYWE_HOME c:\pywe

You must add %PYWE_HOME%\bin to your system path.

    setx PATH %PATH%;c:\pywe\bin

You must also add %PYWE_HOME%\shims to your system path before any existing python installations

    setx PATH c:\pywe\shims;%PATH%
	
#### The GUI Way

You can configure the required environment variables by right clicking on "My Computer" or "Computer" from the start menu, or on the desktop and selecting “properties”  From the System menu, select "Advanced system settings"  From there, select “Environment Variables.”  Create a new System variable called “PYWE_HOME” and set it to whatever directory you have unzipped PyWE to (you should see bin, lib etc from this directory).  Add %PYWE_HOME%\bin and %PYWE_HOME%\shims to the system PATH.
	
After you have setup all the environment variables, start a new command line window.

Extending PyWE
---------------------

PyWE can be extended by adding files that windows can execute (batch file, vbscript, powershell script, other) to the %PYWE_HOME%\lib\commands directory.  PyWE passes arguments to scripts in this form "script.bat script_name other args following"  Each script should parse "script.bat script_name --help" and echo something helpful.

### Simple PyWE Extension Example

example.bat
```batch
@@echo off
SHIFT
IF "%1"=="--help" (
	goto Help
)
echo This is an example script
goto End

:Help
echo --example provides an example to people who would extend pywe
goto End

:End
```
	
Placing this example into the %PYWE_HOME%\lib\commands directory will add an additional --example command to pywe.  It will echo "This is an example script" when "pywe --example" is called.  It will echo "--example provides an example to people who would extend pywe" when "pywe --help" or "pywe --example --help" are called.

Uninstalling PyWE 
--------------------

As yet, there is not a one click PyWE installer.  Removing PyWE requires removing the %PYWE_HOME% directory, removing the %PYWE_HOME% environment variable and modifying the system PATH to remove references to PyWE.

If PyWE has been installed to the default location, navigate to %ALLUSERSPROFILE% and delete the pywe directory.  

Remove the %PYWE_HOME% environment variable

    setx PYWE_HOME
	
Modify the PATH by right clicking on "My Computer" or "Computer" from the start menu, or on the desktop and selecting “properties.”  From the System menu, select "Advanced system settings."  From there, select “Environment Variables.”  Remove all references to pywe from the PATH variable.


