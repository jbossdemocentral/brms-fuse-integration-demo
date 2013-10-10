JBoss BRMS & Fuse Integration Demo
==================================

Demo based on JBoss BRMS/Fuse products.


Quickstart
----------

1. Clone project.

2. Add products to installs directory.

3. Run 'init.sh'

4. Enjoy the demo!


Released versions
-----------------

See the tagged releases for the following versions of the product:

- no release yet, still developing.

Added
---------------------
1. chmod +x on all files in the installs
2. add-user.sh for management admin/redhat1!
http://localhost:8080/business-central-server/rs/server/resources/jbpm
http://localhost:8080/business-central-server/

http://localhost:8080/jbpm-human-task/ 404 error
http://localhost:8080/designer 404 error
process engine plugin not available http://localhost:8080/business-central-server/rs/engine/deployments
so we can execute /business-central-server/rs/engine/job/{id}/execute
http://localhost:8080/business-central-server/rs/server/status
{"plugins":[{"type":"org.jboss.bpm.console.server.plugin.FormDispatcherPlugin","available":true},{"type":"org.jboss.bpm.console.server.plugin.GraphViewerPlugin","available":true},{"type":"org.jboss.bpm.console.server.plugin.ProcessEnginePlugin","available":false}]

/designer
01:01:36,747 INFO  [org.jboss.web] (ServerService Thread Pool -- 69) JBAS018224: Unregister web context: /jboss-brms
01:01:36,749 INFO  [org.jboss.web] (ServerService Thread Pool -- 68) JBAS018224: Unregister web context: /jbpm-human-task
01:01:36,751 INFO  [org.jboss.web] (ServerService Thread Pool -- 67) JBAS018224: Unregister web context: /business-central-server
01:01:36,752 INFO  [org.jboss.web] (ServerService Thread Pool -- 70) JBAS018224: Unregister web context: /business-central
}