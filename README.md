JBoss BPM Suite & Fuse Integration Demo
=======================================

Demo based on JBoss BPM Suite and JBoss Fuse products to highlight a few of the more common use cases.

  * call a BPM process from a fuse camel route.


Setup and Configuration
=======================

See Quick Start Guide in project as ODT and PDF for details on installation. For those that can't wait:

1. [Download and unzip.](https://github.com/eschabell/brms-fuse-integration-demo/archive/master.zip)

2. Add products to installs directory.

3. Run 'init.sh'.

4. Start the JBoss BPM Suite server, login, build and deploy JBoss BPM Suite process project at http://localhost:8080/business-central (u:erics/p:bpmsuite).

5. Add fabric server passwords for Maven Plugin to your ~/.m2/settings.xml file the fabric server's user and password so that the maven plugin can login to the fabric.
     ```
     <server>
       <id>fabric8.upload.repo</id>
       <username>admin</username>
       <password>admin</password>
     </server> 
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

10. Create container name c1 and add BPMSuiteFuse profile (see screenshot below)

11. Trigger camel route by placing support/data/message.xml files into target/jboss-fuse-6.1.0.redhat-379/instances/c1/src/data folder (see screenshot below)

12. Enjoy the demo!


Coming soon:
------------

  * call a fuse end point from a BPM process.

  * embed a rule decision into a fuse camel route.

  * embed a process into a fuse camel route.


Supporting Articles
-------------------

[Enhancing your JBoss Integration with JBoss BRMS] (http://www.schabell.org/2013/08/enhancing-jboss-integration-jboss-fuse-brms.html)


Released versions
-----------------

See the tagged releases for the following versions of the product:

- v2.0 is JBoss BPM Suite 6.0.2 deployable, running on JBoss EAP 6.1.1, and JBoss Fuse Full 6.1.0, with route and process
	integration project deployed.

- v1.0 is BRMS 5.3.1 deployable, running on JBoss EAP 6.1.0, and JBoss Fuse Full 6.0.0.

![Fuse Container] (https://raw.githubusercontent.com/eschabell/brms-fuse-integration-demo/master/docs/demo-images/container.png)
![Fuse Camel Route] (https://raw.githubusercontent.com/eschabell/brms-fuse-integration-demo/master/docs/demo-images/camelroute.png)
![BPM Suite Process] (https://raw.githubusercontent.com/eschabell/brms-fuse-integration-demo/master/docs/demo-images/customer-evaluation.png)
![BPM Suite BAM] (https://raw.githubusercontent.com/eschabell/brms-fuse-integration-demo/master/docs/demo-images/bam-dashboard.png)
