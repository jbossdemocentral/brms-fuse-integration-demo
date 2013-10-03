
package org.jboss.examples.simpleSOAPWS;

import javax.jws.WebService;

/**
 * This is our web service implementation, which implements the web service interface.
 * We also add the @WebService annotation to it to mark this class an implementation for the endpoint interface.
 */
@WebService(endpointInterface = "org.jboss.examples.simpleSOAPWS.HelloWorld")
public class HelloWorldImpl implements HelloWorld {

    /**
     * Just a simple implementation for a friendly message that says hello.
     */
    public String sayHi(String name) {
        return "Hello " + name;
    }
}
