Building PyWE Installer Executable
======================================

PyWE is designed to be used on Windows, so I try to create a friendly executable installer.  The simplest approach to make an installer to copy a bunch of batch scripts and create some environment variables seemed to be using IExpress.exe.  I created a .sed file, which assumes the pywe repository is in C:\github\pywe. 

IExpress.exe Gotcha
----------------

There are two versions of IExpress.exe included with 64-bit Windows, one that makes 32-bit executables and one that makes 64-bit executables.  The 32-bit executable creator is in C:\Windows\SysWOW64.  The 64-bit executable creator is in C:\Windows\System32.  I find this a little bit confusing/backwards, so I'm making special mention of it.

If you are on 32-bit Windows, the 32-bit IExpress.exe is the only one available, in C:\Windows\System32.

IExpress.exe seems to require being started as adminstrator, but I have not run into this on all my computers, YMMV

Illustrated Guide to Creating PyWE Executable
-------------------------------------------------

1. I generally start IExpress.exe and open the .sed file. 
![IExpress Step 1](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/1iexpress.PNG)

2. I select "Modify Self Extraction Directive file." because I'm typically going to change the name of the created exe, typically the version or bit number.
![IExpress Step 2](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/2iexpress.PNG)

3. I typically click through this step because I want to run a batch file after extracting the contents of the exe
![IExpress Step 3](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/3iexpress.PNG)

4. I click through this step as well, because I don't often change the title of the utility
![IExpress Step 4](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/4iexpress.PNG)

5. I click through this step, because the license file is pretty static
![IExpress Step 5](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/5iexpress.PNG)

6. I usually give this step a little attention, in case new shims or commands have been added
![IExpress Step 6](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/6iexpress.PNG)

7. I click through this step, becuase the name of the installer script is pretty static.  The gotcha is that the "/c" argument is necessary on systems running cmd.exe, which is what I'm targeting (sorry ancient Windows users, use the manual installation)
![IExpress Step 7](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/7iexpress.PNG)

8. Sometimes I will reword the displayed message if something better comes to mind
![IExpress Step 8](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/8iexpress.PNG)

9. Here I often bump the version number and make sure I'm correctly calling the exe 32bit or 64bit
![IExpress Step 9](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/9iexpress.PNG)

10. The only restart required after a PyWE install is opening a new command window so the environment variables show up
![IExpress Step 10](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/10iexpress.PNG)

11. I save the file because I've probably made changes and don't want to lose them
![IExpress Step 11](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/11iexpress.PNG)

12. Click "Next" the executable needs created
![IExpress Step 12](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/12iexpress.PNG)

13. Click Finish, the excutable has been created
![IExpress Step 13](https://raw.githubusercontent.com/monknomo/pywe/master/instructional-media/13iexpress.PNG)