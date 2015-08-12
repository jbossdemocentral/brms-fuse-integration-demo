#!/bin/sh 
DEMO="JBoss BRMS & Fuse Integration Demo"
AUTHORS="Christina Lin, Andrew Block,"
AUTHORS2="Jeff Bride, Eric D. Schabell"
PROJECT="git@github.com:jbossdemocentral/brms-fuse-integration-demo.git"
JBOSS_HOME=./target/jboss-eap-6.4
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_CONF_FUSE=$FUSE_HOME/etc/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
PRJ_DIR=./projects/brms-fuse-integration
SUPPORT_DIR=./support
EAP=jboss-eap-6.4.0-installer.jar
BPMS=jboss-bpmsuite-6.1.0.GA-installer.jar
JBOSS_CONFIG=standalone.xml
EAP_VERSION=6.4.0
BPM_VERSION=6.1.0

#Fuse env 
DEMO_HOME=./target
FUSE_ZIP=jboss-fuse-full-6.2.0.redhat-133.zip
FUSE_HOME=$DEMO_HOME/jboss-fuse-6.2.0.redhat-133
FUSE_PROJECT=projects/bpmsuite-fuse-integration
FUSE_SERVER_CONF=$FUSE_HOME/etc
FUSE_SERVER_SYSTEM=$FUSE_HOME/system
FUSE_SERVER_BIN=$FUSE_HOME/bin
FUSE_VERSION=6.2.0


# wipe screen.
clear 

echo
echo "#########################################################################"
echo "##                                                                     ##"   
echo "##  Setting up the ${DEMO}                  ##"
echo "##                                                                     ##"   
echo "##                                                                     ##"   
echo "##   ####   ####    #   #    ###             ####  #  #   ###  ####    ##"
echo "##   #   #  #   #  # # # #  #         #      #     #  #  #     #       ##"
echo "##   ####   ####   #  #  #   ##      ###     ###   #  #   ##   ###     ##"
echo "##   #   #  #      #     #     #      #      #     #  #     #  #       ##"
echo "##   ####   #      #     #  ###              #     ####  ###   ####    ##"
echo "##                                                                     ##"   
echo "##                                                                     ##"   
echo "##  brought to you by,                                                 ##"   
echo "##                     ${AUTHORS}                    ##"
echo "##                          ${AUTHORS2}               ##"
echo "##                                                                     ##"   
echo "##  ${PROJECT}     ##"
echo "##                                                                     ##"   
echo "#########################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# Check mvn version must be in 3.1.1 to 3.2.4	
verone=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $1}')
vertwo=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $2}')
verthree=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $3}')     
     
if [[ $verone -eq 3 ]] && [[ $vertwo -eq 1 ]] && [[ $verthree -ge 1 ]]; then
		echo  Correct Maven version $verone.$vertwo.$verthree
		echo
elif [[ $verone -eq 3 ]] && [[ $vertwo -eq 2 ]] && [[ $verthree -le 4 ]]; then
		echo  Correct Maven version $verone.$vertwo.$verthree
		echo
else
		echo Please make sure you have Maven 3.1.1 - 3.2.4 installed in order to use fabric maven plugin.
		echo
		echo We are unable to run with current installed maven version: $verone.$vertwo.$verthree
		echo	
		exit
fi

# add executeable in installs
chmod +x installs/*.zip

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	echo Product sources EAP are present...
	echo
else
	echo Need to download $EAP package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$BPMS ] || [ -L $SRC_DIR/$BPMS ]; then
	echo Product sources BPM are present...
	echo
else
	echo Need to download $BPMS package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$FUSE ] || [ -L $SRC_DIR/$FUSE ]; then
		echo Product sources FUSE are present...
		echo
else
		echo Need to download $FUSE package from the Customer Support Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# Remove JBoss product installation if exists.
if [ -x target ]; then
	echo "  - existing JBoss product installation detected..."
	echo
	echo "  - removing existing JBoss product installation..."
	echo
	rm -rf target
fi

# Run installers.
echo "JBoss EAP installer running now..."
echo
java -jar $SRC_DIR/$EAP $SUPPORT_DIR/installation-eap -variablefile $SUPPORT_DIR/installation-eap.variables

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

echo
echo "JBoss BPM Suite installer running now..."
echo
java -jar $SRC_DIR/$BPMS $SUPPORT_DIR/installation-bpms -variablefile $SUPPORT_DIR/installation-bpms.variables

if [ $? -ne 0 ]; then
	echo Error occurred during BPMS installation!
	exit
fi

echo
echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
cp $SUPPORT_DIR/application-roles.properties $SERVER_CONF

echo "  - setting up demo projects..."
echo
cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo "  - setup email task notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/business-central.war/WEB-INF/classes/

#Start Fuse installation
if [ -x target ]; then
  # Unzip the JBoss FUSE instance.
  echo Installing JBoss FUSE $FUSE_VERSION
  echo
  unzip -q -d target $SRC_DIR/$FUSE_ZIP
else
	echo
	echo Missing target directory, stopping installation.
	echo 
	exit
fi

#SETUP and INSTALL FUSE services
echo "  - enabling demo accounts logins in users.properties file..."
echo
cp $SUPPORT_DIR/fuse/users.properties $FUSE_SERVER_CONF

echo "  - making sure 'FUSE' for server is executable..."
echo
chmod u+x $FUSE_HOME/bin/start

echo "  - Start up Fuse in the background..."
echo
sh $FUSE_SERVER_BIN/start

echo "  - Create Fabric in Fuse..."
echo
sh $FUSE_SERVER_BIN/client -r 3 -d 10 -u admin -p admin 'fabric:create'
     
sleep 15

COUNTER=5
#===Test if the fabric is ready=====================================
echo
echo "  - Testing fabric, retry when not ready..."
echo
while true; do
    if [ $(sh $FUSE_SERVER_BIN/client 'fabric:status'| grep "100%" | wc -l ) -ge 3 ]; then
        break
    fi
    
    if [  $COUNTER -le 0 ]; then
    	echo ERROR, while creating Fabric, please check your Network settings.
    	break
    fi
    let COUNTER=COUNTER-1
    sleep 2
done
#===================================================================

cd $FUSE_PROJECT     
echo
echo "Start compile and deploy Fuse and BPM Suite demo project to fuse..."
echo         
mvn fabric8:deploy 

cd ../.. 

echo
echo "  - stopping any running fuse instances..."
echo
jps -lm | grep karaf | grep -v grep | awk '{print $1}' | xargs kill -KILL


echo
echo "==========================================================================================="
echo "=                                                                                         ="
echo "=  You can now start the JBoss BPM Suite with:                                            ="
echo "=                                                                                         ="
echo "=        $SERVER_BIN/standalone.sh                                                        ="
echo "=                                                                                         ="
echo "=    - login, build and deploy JBoss BPM Suite process project at:                        ="
echo "=                                                                                         ="
echo "=        http://localhost:8080/business-central (u:erics / p:bpmsuite1!)                  ="
echo "=                                                                                         ="
echo "=  Deploying the camel route in JBoss Fuse as follows:                                    ="
echo "=                                                                                         ="
echo "=    - add fabric server passwords for Maven Plugin to your ~/.m2/settings.xml            =" 
echo "=      file the fabric server's user and password so that the maven plugin can            ="
echo "=      login to the fabric. fabric8.upload.repo  admin  admin                             ="
echo "=                                                                                         ="
echo "=    - start the JBoss Fuse with:                                                         ="
echo "=                                                                                         ="
echo "=        $FUSE_SERVER_BIN/fuse                                    ="
echo "=                                                                                         ="
echo "=    - login to Fuse management console at:                                               ="
echo "=                                                                                         ="
echo "=        http://localhost:8181    (u:admin/p:admin)                                       ="
echo "=                                                                                         ="
echo "=    - connect to root container with login presented by console  (u:admin/p:admin)       ="
echo "=                                                                                         ="
echo "=    - create container name c1 and add bpmsuiteintegration profile                       ="
echo "=                                                     (see readme for screenshot)         ="
echo "=                                                                                         ="
echo "=    - open c1 container to view route under 'DIAGRAM' tab                                ="
echo "=                                                                                         ="
echo "=    - trigger camel route by placing support/data/cusotmerrequest-1.xml file into the    ="
echo "=      following folder:                                                                  ="
echo "=                                                                                         ="
echo "=        $FUSE_HOME/instances/c1/customerData                       =" 
echo "=                                                                                         ="
echo "=                                                                                         ="
echo "=   $DEMO Setup Complete.                                    ="
echo "==========================================================================================="
echo
