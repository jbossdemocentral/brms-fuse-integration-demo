@ECHO OFF
setlocal enableDelayedExpansion

set PROJECT_HOME=%~dp0
set DEMO=JBoss BRMS ^& Fuse Integration Demo
set AUTHORS=Christina Lin, Andrew Block,
set AUTHORS2=Jeff Bride, Eric D. Schabell
set PROJECT=git@github.com:jbossdemocentral/brms-fuse-integration-demo.git
set JBOSS_HOME=%PROJECT_HOME%target\jboss-eap-6.4
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%installs
set PRJ_DIR=%PROJECT_HOME%projects\bpmsuite-fuse-integration
set SUPPORT_DIR=%PROJECT_HOME%\support
set BPMS=jboss-bpmsuite-6.2.0.GA-installer.jar
set EAP=jboss-eap-6.4.0-installer.jar
set EAP_PATCH=jboss-eap-6.4.4-patch.zip
set JBOSS_CONFIG=standalone.xml
set EAP_VERSION=6.4.4
set BPM_VERSION=6.2.0


REM Fuse env
set DEMO_HOME=%PROJECT_HOME%target
set FUSE_ZIP=jboss-fuse-full-6.2.0.redhat-133.zip
set FUSE_HOME=%PROJECT_HOME%target\jboss-fuse-6.2.0.redhat-133
set FUSE_PROJECT=%PROJECT_HOME%\projects\bpmsuite-fuse-integration
set FUSE_SERVER_CONF=%FUSE_HOME%\etc\
set FUSE_SYSTEM=%FUSE_HOME%\system
set FUSE_SERVER_BIN=%FUSE_HOME%\bin
set FUSE_VERSION=6.2.0


REM wipe screen.
cls 

echo.
echo #########################################################################
echo ##                                                                     ##   
echo ##  Setting up the !DEMO!                  ##
echo ##                                                                     ##   
echo ##                                                                     ##   
echo ##   ####   ####    #   #    ###             ####  #  #   ###  ####    ##
echo ##   #   #  #   #  # # # #  #         #      #     #  #  #     #       ##
echo ##   ####   ####   #  #  #   ##      ###     ###   #  #   ##   ###     ##
echo ##   #   #  #      #     #     #      #      #     #  #     #  #       ##
echo ##   ####   #      #     #  ###              #     ####  ###   ####    ##
echo ##                                                                     ##   
echo ##                                                                     ##   
echo ##  brought to you by,                                                 ##   
echo ##                     %AUTHORS%                    ##
echo ##                           %AUTHORS2%              ##
echo ##                                                                     ##   
echo ##  %PROJECT%     ##
echo ##                                                                     ##   
echo #########################################################################
echo.


call where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo Maven Not Installed. Setup Cannot Continue
	GOTO :EOF
)

REM Check mvn version must be in 3.1.1 to 3.2.4	
FOR /F "tokens=3 " %%G IN ('call mvn -version ^| findstr -B "Apache Maven*"') DO ( 
	for /F "tokens=1-3 delims=." %%A in ('echo %%G') do ( 
		if %%A EQU 3 if %%B EQU 1 if %%C GTR 1 GOTO :passPrereqs
		
		if %%A EQU 3 if %%B EQU 2 if %%C LEQ 4 GOTO :passPrereqs
		
		echo Please make sure you have Maven 3.1.1 - 3.2.4 installed in order to use fabric maven plugin.
		echo.
		echo We are unable to run with current installed maven version: %%G
		echo.	
		GOTO :EOF
	)	
)

:passPrereqs

REM # make some checks first before proceeding. 
if exist %SRC_DIR%\%EAP% (
        echo Product sources EAP are present...
        echo.
) else (
        echo Need to download %EAP% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist %SRC_DIR%\%EAP_PATCH% (
        echo Product patches are present...
        echo.
) else (
        echo Need to download %EAP_PATCH% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist %SRC_DIR%\%BPMS% (
	echo Prodct sources BPM are present...
	echo.
) else (
	echo Need to download %BPMS% package from the Customer Support Portal
	echo and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

if exist %SRC_DIR%\%FUSE_ZIP% (
	echo Prodct sources Fuse are present...
	echo.
) else (
	echo Need to download %FUSE_ZIP% package from the Customer Support Portal
	echo and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

REM Remove the old JBoss instance, if it exists.
if exist %DEMO_HOME% (
         echo - existing JBoss product installation detected...
         echo.
	     echo - removing existing JBoss product installation...
         echo.
         rmdir /s /q %DEMO_HOME%
 )

REM Run installers.
echo JBoss EAP installer running now...
echo.
call java -jar %SRC_DIR%/%EAP% %SUPPORT_DIR%\installation-eap -variablefile %SUPPORT_DIR%\installation-eap.variables


if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Installation!
	echo.
	GOTO :EOF
)

call set NOPAUSE=true

echo.
echo Applying JBoss EAP patch now...
echo.
call %JBOSS_HOME%/bin/jboss-cli.bat --command="patch apply %SRC_DIR%/%EAP_PATCH% --override-all"

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Patch Installation!
	echo.
	GOTO :EOF
)

echo.
echo JBoss BPM Suite installer running now...
echo.
call java -jar %SRC_DIR%/%BPMS% %SUPPORT_DIR%\installation-bpms -variablefile %SUPPORT_DIR%\installation-bpms.variables

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During %PRODUCT% Installation!
	echo.
	GOTO :EOF
)

echo   - enabling demo accounts role setup in application-roles.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"

echo   - setting up demo projects..."
echo.
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-niogit" "%SERVER_BIN%\.niogit\" 

echo   - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone.xml" "%SERVER_CONF%"

echo - setup email task notification users...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\userinfo.properties" "%SERVER_DIR%\business-central.war\WEB-INF\classes\"


echo.
echo JBoss Fuse install running now...
echo.
if exist %PROJECT_HOME%\target (
	REM Unzip the JBoss FUSE instance.
	echo.
	echo Installing JBoss FUSE %FUSE_VERSION%
	echo.
	cscript /nologo %SUPPORT_DIR%\windows\unzip.vbs %SRC_DIR%\%FUSE_ZIP% %PROJECT_HOME%\target
) else (
	echo.
	echo Missing target directory, stopping installation.
	echo.
	GOTO :EOF
)

echo   - enabling demo accounts logins in users.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\fuse\users.properties" "%FUSE_SERVER_CONF%"

:configureFuse

call "cmd /c %FUSE_SERVER_BIN%/start.bat"

call "%FUSE_SERVER_BIN%/client.bat" -r 120 -h localhost -u admin -p admin "fabric:create"

timeout /t 25 /nobreak > NUL

set counter=5

:testFabric

for /f "delims=" %%i in ('call "%FUSE_SERVER_BIN%/client.bat" -h localhost -u admin -p admin "fabric:status" ^| findstr "100"') do set output=%%i

if NOT "%output%" == "" GOTO :fabricReady

set /a counter-=1

timeout /t 5 /nobreak > NUL

if %counter% gtr 0 (
	GOTO :testFabric
) ELSE (
	echo Fabric creation unsuccessful
	GOTO :EOF
)

:fabricReady


echo Start compile and deploy Fuse and BPM Suite demo project to fuse...
echo.
cd "%PRJ_DIR%"
call mvn fabric8:deploy 

if %ERRORLEVEL% NEQ 0 (
	echo.
	echo Maven Build Failed! Setup cannot continue.
	cd "%PROJECT_HOME%"
GOTO :EOF
)

cd "%PROJECT_HOME%"

echo.
echo   - stopping any running fuse instances...
echo.
FOR /F "tokens=1" %%G IN ('jps -lm ^| findstr -i karaf') DO ( 
	taskkill /F /PID %%G >NUL
)

:displayReadme
echo.
echo ===============================================================================
echo =                                                                             =
echo =  You can now start the JBoss BPM Suite with:                                =
echo =                                                                             =
echo = %SERVER_BIN%/standalone.bat
echo =                                                                             =
echo =    - login, build and deploy JBoss BPM Suite process project at:            =
echo =                                                                             =
echo =        http://localhost:8080/business-central    u:erics / p:bpmsuite1!      =
echo =                                                                             =
echo =                                                                             =
echo =   - start the JBoss Fuse with:                                              =
echo =                                                                             =
echo =       %FUSE_SERVER_BIN%/fuse                
echo =                                                                             =
echo =                                                                             =
echo =   - login to Fuse management console at:                                    =
echo =                                                                             =
echo =       http://localhost:8181     u:admin / p:admin                           =
echo =                                                                             =
echo =                                                                             =
echo =   - create container name c1 and add bpmsuiteintegration profile            =
echo =     see readme for screenshot                                               =
echo =                                                                             =
echo =   - open c1 container to view route under 'DIAGRAM' tab                     =
echo =                                                                             =
echo =   - trigger camel route by placing support/data/customerrequest-1.xml       =
echo =     file into the following folder:                                         =
echo =                                                                             =
echo =       %FUSE_HOME%\instances\c1\customerData
echo =                                                                             =
echo =                                                                             =
echo =  !DEMO! Setup Complete.                         =
echo ===============================================================================
echo.

