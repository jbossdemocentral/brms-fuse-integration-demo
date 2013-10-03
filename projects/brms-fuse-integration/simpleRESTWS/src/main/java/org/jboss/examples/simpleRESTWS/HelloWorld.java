package org.jboss.examples.simpleRESTWS;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;

/**
 * This is our web service implementation, which implements the web service interface.
 * We also add the @WebService annotation to it to mark this class an implementation for the endpoint interface.
 */
@Path("/HelloWorldRest/")
public class HelloWorld {

    /**
     * Just a simple implementation for a friendly message that says hello.
     */
	@GET
	@Path("/HelloWorldRest/{name}/")
    public String sayHi(@PathParam("name") String name) {
        return "Hello " + name;
    }
}