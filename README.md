JBoss BPM Suite & Fuse Integration Demo
=======================================

Demo based on JBoss BPM Suite and JBoss Fuse products to highlight a few of the more common use cases.

  * call a BPM process from a fuse camel route.


Setup and Configuration
-----------------------

See Quick Start Guide in project as ODT and PDF for details on installation. For those that can't wait:

1. [Download and unzip.](https://github.com/eschabell/brms-fuse-integration-demo/archive/fuse-6.1.0.zip)

2. Add products to installs directory.

3. Run 'init.sh'.

4. Start, login, build and deploy JBoss BPM Suite process project at http://localhost:8080/business-central (u:erics/p:bpmsuite).

5. Start, login, deploy camel route in JBoss BPM Fuse or run 'mvn camel:run' from projects/brms-fuse-integration/simpleRoute.

6. Enjoy the demo!

Detailed documentation and presentations can be found in docs directory.

Note: JBoss BPM Suite user login (u:erics/p:bpmsuite), for Fuse the login (u:admin/p:brmsfuse).

Coming soon:

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

![Fuse Service Task] (https://raw.githubusercontent.com/eschabell/brms-fuse-integration-demo/master/docs/demo-images/rewards-process.png)
