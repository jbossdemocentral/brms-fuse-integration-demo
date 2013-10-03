
package org.jboss.examples.simpleSOAPWS;

import javax.jws.WebService;

/**
 * The HelloWorld interface defines a single method.
 *
 * We add the @WebService annotation to mark this interface as the definition for our web service.
 */
@WebService
public interface HelloWorld {

    String sayHi(String name);

}
