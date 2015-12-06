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

### Installing Python with PyWE

PyWE uses [wget.exe](http://gnuwin32.sourceforge.net/packages/wget.htm) to download Python installers.  Wget maintains an aggressive security posture, and won't download from sites broken or unverifiable SSL unless you tell it to.  Python uses SSL on its download site.  Because Windows is not setup the same way Unix is, wget does not know where to check for certificates, and so will not download installers from Python without giving it some further instructions

#### Using a Certificate Bundle

The safest way to install Python is to obtain a certificate bundle and tell the installer where to find it.

For example:
    
    pywe --install --ca-certificate c:\cacerts\certbundle.pem 3.5.0
    
The most expedient way I have found to obtain a cert bundle [is to stand on the curl folks' shoulders](http://curl.haxx.se/docs/caextract.html).  This not the best security practice because you are trusting that the curl folks are competent and have not been compromised and that the transmission to you is safe.  Here's [a discussion of how you can do it yourself for ultimate peace of mind.](http://sourceforge.net/p/gnuwin32/discussion/general/thread/065c51d7/)

#### Ignoring Certificate Warnings

The most expedient way to install Python is to ignore certificate error:

    pywe --install --no-check-certificate 3.5.0

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

PyWE can be extended by adding files that windows can execute (batch files, vbscripts, powershell scripts, executables, others) to the %PYWE_HOME%\lib\commands directory.  PyWE passes arguments to scripts in this form "script.bat script_name other args following"  Each script should parse "script.bat script_name --help" and echo something helpful.

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

Creating a PyWE Installer
--------------------------

[This is long enough to have its own instructions](https://github.com/monknomo/pywe/blob/master/CREATE_INSTALLER.md)

Right now we are using an IExpress based process, but any improvement would be much appreciated, we're not in love with the way we do it, just that IExpress is free and easy.  An installer that would allow for users to select between global and per-user installs would be nice, for instance.

Historical Errata
------------------

PyWE was originally called Pywin, but after some search, it became apparent that there is another project called Pywin.  Not wanting to get involved in a search rank fight, we ceded the ground and renamed the project.  This was so early in the project life, that the single user/maintainer was not confused and hopes that future users won't even know about it, except for the existence of this note.
