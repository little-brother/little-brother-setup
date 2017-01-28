@echo off
cls
set "SETUP_DIR=%cd%"

echo *************************************************
echo *** Welcome to Little brother DCIM installer! ***
echo *************************************************
echo.
set /p install_dir=Set install location: 

if not exist "%install_dir%" (
	set /p dummy = PRESS ENTER TO CREATE "%install_dir%"
	mkdir %install_dir%

) else (
	set /p dummy = PRESS ENTER TO CLEAR %install_dir%
	
	rmdir /s /q %install_dir% > nul
	mkdir %install_dir%
)
echo.
echo.

echo Start download...
cd /d %install_dir%
node %SETUP_DIR%\cli\download https://github.com/little-brother/little-brother-dcim/archive/master.zip sources.zip
node %SETUP_DIR%\cli\unzip sources.zip .

set source=%install_dir%\little-brother-dcim-master
set target=%install_dir%
for /d /r "%source%" %%i in (*) do if exist "%target%\%%~ni" (dir "%%i" | find "0 File(s)" > nul & if errorlevel 1 move /y "%%i\*.*" "%target%\%%~ni" > nul) else (move /y "%%i" "%target%" > nul)
move %source%\*.* . > nul
rd /s /q %source%
del /F /Q sources.zip

echo Install modules...
cmd /c npm i

echo.
echo Start download local agent...
mkdir agent > nul
cd agent
node %SETUP_DIR%\cli\download https://github.com/little-brother/little-brother-dcim-agent/archive/master.zip sources.zip
node %SETUP_DIR%\cli\unzip sources.zip .

set source=%install_dir%\agent\little-brother-dcim-agent-master
set target=%install_dir%\agent
for /d /r "%source%" %%i in (*) do if exist "%target%\%%~ni" (dir "%%i" | find "0 File(s)" > nul & if errorlevel 1 move /y "%%i\*.*" "%target%\%%~ni" > nul) else (move /y "%%i" "%target%" > nul)
move %source%\*.* . > nul
rd /s /q %source% 
del /F /Q sources.zip

echo Install modules...
cmd /c npm i

cd /d %install_dir%

echo *************************************************
echo ***      PRESS ENTER TO RUN APPLICATION       ***
echo ***      and open login page in browser       *** 
echo ***        Use admin/admin to log in          *** 
echo ************************************************* 
set /p dummy =
start cmd /k npm start
timeout 5 > nul
cmd /c start http://127.0.0.1:2000