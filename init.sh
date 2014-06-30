#!/bin/sh 
DEMO="JBoss BRMS & Fuse Integration Demo"
AUTHORS="Kenny Peeples, Eric D. Schabell"
PROJECT="git@github.com:eschabell/brms-fuse-integration-demo.git"
JBOSS_HOME=./target/jboss-eap-6.1
FUSE_HOME=./target/jboss-fuse-6.1.0.redhat-379
FUSE_BIN=$FUSE_HOME/bin
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
PRJ_DIR=./projects/brms-fuse-integration
SUPPORT_DIR=./support
FUSE=jboss-fuse-full-6.1.0.redhat-379.zip
EAP=jboss-eap-6.1.1.zip
BPMS=jboss-bpms-6.0.2.GA-redhat-5-deployable-eap6.x.zip
DESIGNER=designer-patched.war
BPM_VERSION=6.0.2
FUSE_VERSION=6.1.0
EAP_VERSION=6.1.1

# wipe screen.
clear 

# add executeable in installs
chmod +x installs/*.zip

echo
echo "##################################################################"
echo "##                                                              ##"   
echo "##  Setting up the ${DEMO}           ##"
echo "##                                                              ##"   
echo "##                                                              ##"   
echo "##   ####   ####    #   #    ###       ####  #  #   ###  ####   ##"
echo "##   #   #  #   #  # # # #  #      #   #     #  #  #     #      ##"
echo "##   ####   ####   #  #  #   ##   ###  ###   #  #   ##   ###    ##"
echo "##   #   #  #      #     #     #   #   #     #  #     #  #      ##"
echo "##   ####   #      #     #  ###        #     ####  ###   ####   ##"
echo "##                                                              ##"   
echo "##                                                              ##"   
echo "##  brought to you by,                                          ##"   
echo "##             ${AUTHORS}                  ##"
echo "##                                                              ##"   
echo "##  ${PROJECT}     ##"
echo "##                                                              ##"   
echo "##################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [[ -r $SRC_DIR/$EAP || -L $SRC_DIR/$EAP ]]; then
		echo EAP sources are present...
		echo
else
		echo Need to download $EAP package from the Customer Support Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

if [[ -r $SRC_DIR/$FUSE || -L $SRC_DIR/$FUSE ]]; then
		echo Fuse sources are present...
		echo
else
		echo Need to download $FUSE package from the Customer Support Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

if [[ -r $SRC_DIR/$BPMS || -L $SRC_DIR/$BPMS ]]; then
		echo BPM Suite sources are present...
		echo
else
		echo Need to download $BPMS package from the Customer Support Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi


# Create the target directory if it does not already exist.
if [ ! -x target ]; then
		echo "  - creating the target directory..."
		echo
		mkdir target
else
		echo "  - detected target directory, moving on..."
		echo
fi

# Move the old JBoss instance, if it exists, to the OLD position.
if [ -x $JBOSS_HOME ]; then
		echo "  - existing JBoss EAP detected..."
		echo
		echo "  - moving existing JBoss EAP aside..."
		echo
		rm -rf $JBOSS_HOME.OLD
		mv $JBOSS_HOME $JBOSS_HOME.OLD

		# Unzip the JBoss EAP instance.
		echo Installing JBoss EAP $EAP_VERSION
		echo
		unzip -q -d target $SRC_DIR/$EAP
else
		# Unzip the JBoss EAP instance.
		echo Installing JBoss EAP $EAP_VERSION
		echo
		unzip -q -d target $SRC_DIR/$EAP
fi

# Move the old Fuse instance, if it exists, to the OLD position.
if [ -x $FUSE_HOME ]; then
		echo "  - existing JBoss FUSE detected..."
		echo
		echo "  - moving existing JBoss FUSE aside..."
		echo
		rm -rf $FUSE_HOME.OLD
		mv $FUSE_HOME $FUSE_HOME.OLD

		# Unzip the JBoss FUSE instance.
		echo Installing JBoss FUSE $FUSE_VERSION
		echo
		unzip -q -d target $SRC_DIR/$FUSE
else
		# Unzip the JBoss FUSE instance.
		echo Installing JBoss FUSE $FUSE_VERSION
		echo
		unzip -q -d target $SRC_DIR/$FUSE
fi

# Unzip the required files from JBoss product deployable.
echo Installing JBoss BPM Suite $BPM_VERSION
echo
unzip -q -o -d target $SRC_DIR/$BPMS

echo "  - enabling demo accounts logins in application-users.properties file..."
echo
cp $SUPPORT_DIR/application-users.properties $SERVER_CONF

echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
cp $SUPPORT_DIR/application-roles.properties $SERVER_CONF

echo "  - enabling management accounts login setup in mgmt-users.properties file..."
echo
cp $SUPPORT_DIR/mgmt-users.properties $SERVER_CONF

echo "  - setting up demo projects..."
echo
cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

# Optional: uncomment this to install mock data for BPM Suite.
#
#echo - setting up mock bpm dashboard data...
#cp $SUPPORT_DIR/1000_jbpm_demo_h2.sql $SERVER_DIR/dashbuilder.war/WEB-INF/etc/sql
#echo

echo Now going to build the projects...
echo
cd $PRJ_DIR
mvn clean install 

echo
echo
echo "You can now start the JBoss BPM Suite with $SERVER_BIN/standalone.sh"
echo

echo "You can start the JBoss Fuse with $FUSE_BIN/fuse"

echo "$PRODUCT $VERSION $DEMO Setup Complete."
echo

