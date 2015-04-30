@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=JBoss BRMS & Fuse Integration Demo
set AUTHORS=Christina Lin, Andrew Block,
set AUTHORS2=Jeff Bride, Eric D. Schabell
set PROJECT=git@github.com:jbossdemocentral/brms-fuse-integration-demo.git
set TARGET_DIR=%PROJECT_HOME%target
set JBOSS_HOME=%PROJECT_HOME%target\jboss-eap-6.4
set FUSE_HOME=%PROJECT_HOME%target\jboss-fuse-6.1.1.redhat-412
set FUSE_BIN=%FUSE_HOME%\bin
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_CONF_FUSE=%FUSE_HOME%\etc\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%installs
set PRJ_DIR=%PROJECT_HOME%projects\brms-fuse-integration
set SUPPORT_DIR=%PROJECT_HOME%\support
set FUSE=jboss-fuse-full-6.1.1.redhat-412.zip
set BPMS=jboss-bpmsuite-6.1.0.GA-installer.jar
set EAP=jboss-eap-6.4.0-installer.jar
set BPM_VERSION=6.1
set FUSE_VERSION=6.1.1

REM wipe screen.
cls 

echo.
echo #########################################################################
echo ##                                                                     ##   
echo ##  Setting up the %DEMO%                                         ##
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
echo ##                     %AUTHORS%                     ##
echo ##                           %AUTHORS2%               ##
echo ##                                                                     ##   
echo ##  %PROJECT%            ##
echo ##                                                                     ##   
echo #########################################################################
echo.


call where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
	echo Maven Not Installed. Setup Cannot Continue
	GOTO :EOF
)

REM # make some checks first before proceeding. 
if exist %SRC_DIR%\%EAP% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %EAP% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist %SRC_DIR%\%BPMS% (
	echo BPM sources are present...
	echo.
) else (
	echo Need to download %BPMS% package from the Customer Support Portal
	echo and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

if exist %SRC_DIR%\%FUSE% (
	echo Fuse sources are present...
	echo.
) else (
	echo Need to download %FUSE% package from the Customer Support Portal
	echo and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

REM Remove the old JBoss instance, if it exists.
if exist %TARGET_DIR% (
         echo - existing JBoss product install removed...
         echo.
         rmdir /s /q %TARGET_DIR%
 )

REM Run installers.
echo EAP installer running now...
echo.
call java -jar %SRC_DIR%/%EAP% %SUPPORT_DIR%\installation-eap -variablefile %SUPPORT_DIR%\installation-eap.variables


if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Installation!
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

echo.
echo JBoss Fuse install running now...
echo.
if exist %PROJECT_HOME%\target (
	REM Unzip the JBoss FUSE instance.
	echo.
	echo Installing JBoss FUSE %FUSE_VERSION%
	echo.
	cscript /nologo %SUPPORT_DIR%\windows\unzip.vbs %SRC_DIR%\%FUSE% %PROJECT_HOME%\target
) else (
	echo.
	echo Missing target directory, stopping installation.
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
xcopy "%SUPPORT_DIR%\userinfo.properties" "%SERVER_DIR%\business-central.war\WEB-INF\classes\"

echo   - enabling demo accounts logins in users.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\users.properties" "%SERVER_CONF_FUSE%"


REM Optional: uncomment this to install mock data for BPM Suite.
REM
REM echo - setting up mock bpm dashboard data...
REM xcopy /Y /Q "%SUPPORT_DIR%\1000_jbpm_demo_h2.sql" "%SERVER_DIR%\dashbuilder.war\WEB-INF\etc\sql\"
REM echo.

echo Now going to build the projects...
echo.
cd "%PRJ_DIR%"
call mvn clean install

if %ERRORLEVEL% NEQ 0 (
	echo.
	echo Maven Build Failed! Setup cannot continue.
	cd "%PROJECT_HOME%"
GOTO :EOF
)

cd "%PROJECT_HOME%"

echo.
echo ===============================================================================
echo =                                                                             =
echo =  You can now start the JBoss BPM Suite with:                                =
echo =                                                                             =
echo = %SERVER_BIN%/standalone.bat                                                 =
echo =                                                                             =
echo =    - login, build and deploy JBoss BPM Suite process project at:            =
echo =                                                                             =
echo =        http://localhost:8080/business-central    u:erics / p:bpmsuite1!     =
echo =                                                                             =
echo =  Deploying the camel route in JBoss Fuse as follows:                        =
echo =                                                                             =
echo =   - add fabric server passwords for Maven Plugin to your                    =
echo =     ~/.m2/settings.xml file the fabric server's user and password so that   =
echo =     the maven plugin can login to the fabric. fabric8.upload.repoadminadmin =
echo =                                                                             =
echo =   - start the JBoss Fuse with:                                              =
echo =                                                                             =
echo =       %FUSE_BIN%/fuse                               =
echo =                                                                             =
echo =   - start up fabric in fuse console: fabric:create --wait-for-provisioning  =
echo =                                                                             =
echo =   - run 'mvn fabric8:deploy' from projects/brms-fuse-integration/simpleRoute=
echo =                                                                             =
echo =   - login to Fuse management console at:                                    =
echo =                                                                             =
echo =       http://localhost:8181     u:admin / p:admin                           =
echo =                                                                             =
echo =   - connect to root container with login presented by console               =
echo =	     u:admin / p:admin                                                     =
echo =                                                                             =
echo =   - create container name c1 and add BPMSuiteFuse profile                   =
echo =     see readme for screenshot                                               =
echo =                                                                             =
echo =   - open c1 container to view route under 'DIAGRAM' tab                     =
echo =                                                                             =
echo =   - trigger camel route by placing support/date/message.xml file into the   =
echo =     following folder:                                                       =
echo =                                                                             =
echo =       %FUSE_HOME%\instances\c1\src\data  =
echo =                                                                             =
echo =                                                                             =
echo =   %DEMO% Setup Complete.                                               =
echo ===============================================================================
echo.

