JBoss BPM Suite & JBoss Fuse Integration Demo
=============================================

Demo based on JBoss BPM Suite and JBoss Fuse products to highlight a few of the more common use cases.

  * call a BPM process from a fuse camel route.

There are two options available to you for using this demo; local and Docker.


Option 1 - Install on your machine
----------------------------------
See Quick Start Guide in project as ODT and PDF for details on installation. For those that can't wait:

1. [Download and unzip.](https://github.com/jbossdemocentral/brms-fuse-integration-demo/archive/master.zip). If running on Windows, it is recommended the project be extracted to a location near the root drive path due to limitations of length of file/path names.

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat' file. 'init.bat' must be run with Administrative privileges.

4. Start the JBoss BPM Suite server, login, build and deploy JBoss BPM Suite process project at http://localhost:8080/business-central (u:erics/p:bpmsuite1!).

5. Add fabric server passwords for Maven Plugin to your ~/.m2/settings.xml file the fabric server's user and password so that the maven plugin can login to the fabric.

     ```
     <!-- Server login to upload to fabric. -->
     <servers>
         <server>
             <id>fabric8.upload.repo</id>
             <username>admin</username>
             <password>admin</password>
         </server>
     </servers> 
     ```

6. Start Fuse Server and start up fabric in fuse console: 

     ```
     fabric:create --wait-for-provisioning 
     ```

7. Deploy simple route from projects/brms-fuse-integration/simpleRoute:

     ```
     mvn fabric8:deploy
     ```

8. Login to Fuse management console at:  http://localhost:8181    (u:admin/p:admin).

9. Connect to root container with login presented by console  (u:admin/p:admin)   

10. Create container name c1 and add bpmsuitefuse profile (see screenshot below)

11. Trigger camel route by placing support/data/message.xml files into target/jboss-fuse-6.1.0.redhat-379/instances/c1/src/data folder (see screenshot below)

12. Enjoy the demo!


Option 2 - Generate docker install
----------------------------------
The following steps can be used to configure and run the demo in a docker container

1. [Download and unzip.](https://github.com/jbossdemocentral/brms-fuse-integration-demo/archive/master.zip). 

2. Add products to installs directory.

3. Copy contents of support/docker directory to the project root.

4. Build demo image

	```
	docker build -t jbossdemocentral/brms-fuse-integration-demo .
	```
5. Start demo container

	```
	docker run --it -p 8080:8080 -p 9990:9990 -p 8181:8181 jbossdemocentral/brms-fuse-integration-demo
	``` 
	
6. Login, build and deploy JBoss BPM Suite process project at http://<DOCKER_HOST>:8080/business-central (u:erics/p:bpmsuite1!).

7. Login to Fuse management console at:  http://<DOCKER_HOST>:8181    (u:admin/p:admin).

8. Navigate to Terminal tab and create fabric

     ```
     fabric:create --wait-for-provisioning 
     ```
9. Within the running container, deploy simple route from /opt/jboss/projects/brms-fuse-integration/simpleRoute:

     ```
     mvn fabric8:deploy
     ``` 
	
	1. When prompted to update the settings.xml file, select **y** and enter admin/admin for the user name and password
	2. If the deployment fails due to "Access Denied", rerun command. This is a known [issue](https://github.com/fabric8io/fabric8/issues/1404)

10. Create container name c1 and add bpmsuitefuse profile (see screenshot below)

11. Trigger camel route by placing /opt/jboss/support/data/message.xml file into /opt/jboss/fuse/jboss-fuse-6.1.0.redhat-379/instances/c1/src/data folder (see screenshot below)

12. Enjoy the demo!
  
Additional information can be found in the jbossdemocentral docker [developer repository](https://github.com/jbossdemocentral/docker-developer)


Coming soon
-----------

  * call a fuse end point from a BPM process.

  * embed a rule decision into a fuse camel route.

  * embed a process into a fuse camel route.


Supporting Articles
-------------------
[The Most Popular Way to Get Started Integrating BPM with Apache Camel](http://www.schabell.org/2014/09/most-popular-way-get-started-integrating-bpm-apache-camel.html)

[Enhancing your JBoss Integration with JBoss BRMS] (http://www.schabell.org/2013/08/enhancing-jboss-integration-jboss-fuse-brms.html)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v2.3 is JBoss BPM Suite 6.0.3 installer, JBoss Fuse Full 6.1.0 and optional docker installation. 

- v2.2 moved to JBoss Demo Central, with updated windows init.bat support.

- v2.1 is JBoss BPM Suite 6.0.3 installer, JBoss Fuse Full 6.1.0, with route and process

- v2.0 is JBoss BPM Suite 6.0.2 deployable, running on JBoss EAP 6.1.1, and JBoss Fuse Full 6.1.0, with route and process
	integration project deployed.

- v1.0 is BRMS 5.3.1 deployable, running on JBoss EAP 6.1.0, and JBoss Fuse Full 6.0.0.


[![Video Demo Run] (https://raw.githubusercontent.com/jbossdemocentral/brms-fuse-integration-demo/master/docs/demo-images/video-demo-run.png)](http://vimeo.com/ericschabell/bpmsuite-fuse-integraiton-demo-run)
![Fuse Container] (https://raw.githubusercontent.com/jbossdemocentral/brms-fuse-integration-demo/master/docs/demo-images/container.png)
![Fuse Camel Route] (https://raw.githubusercontent.com/jbossdemocentral/brms-fuse-integration-demo/master/docs/demo-images/camelroute.png)
![BPM Suite Process] (https://raw.githubusercontent.com/jbossdemocentral/brms-fuse-integration-demo/master/docs/demo-images/customer-evaluation.png)
![BPM Suite BAM] (https://raw.githubusercontent.com/jbossdemocentral/brms-fuse-integration-demo/master/docs/demo-images/bam-dashboard.png)
