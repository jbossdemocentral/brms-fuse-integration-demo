package com.jboss.examples;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.apache.commons.httpclient.methods.multipart.StringPart;

/**
 * Starting an instance of the process, without submitting any variables in a map.
 * 
 */
public class RestClientSimple {
    private static final String BASE_URL = "http://localhost:8080/business-central/rest/";
    private static final String DEPLOYMENT_ID = "cusotmer:evaluation:1.0";
    private static final String PROCESS_DEF_ID = "customer.evaluation";

    public static void main(String[] args) throws Exception {

    	System.out.println("Starting process instance: " + DEPLOYMENT_ID);
        System.out.println();
        
    	// start a process instance with no variables.
        startProcess();

        System.out.println();
    	System.out.println("Completed process instance: " + DEPLOYMENT_ID);
    }

    /**
     * Start a process using the rest api start call, no map variables passed.
     * 
     * @throws Exception
     */
    private static void startProcess() throws Exception {
        String newInstanceUrl = BASE_URL + "runtime/" + DEPLOYMENT_ID + "/process/" + PROCESS_DEF_ID + "/start";
        String dataFromService = getDataFromService(newInstanceUrl, "POST");
        System.out.println("--------");
        System.out.println(dataFromService);
        System.out.println("--------");
    }


    /**
     * Call service (GET) with no params.
     * 
     * @param urlpath Rest API call.
     * @param method Post or Get call.
     * @return
     * @throws Exception
     */
    private static String getDataFromService(String urlpath, String method) throws Exception {
        // no params
        return getDataFromService(urlpath, method, null, false);
    }

    /**
     * Call service (GET) with variables (Map).
     * 
     * @param urlpath
     * @param method
     * @param params
     * @param multipart
     * @return
     * @throws Exception
     */
    private static String getDataFromService(String urlpath, String method, Map<String, String> params, boolean multipart)
            throws Exception {
        HttpClient httpclient = new HttpClient();

        HttpMethod theMethod = null;
        StringBuffer sb = new StringBuffer();

        if ("GET".equalsIgnoreCase(method)) {
            theMethod = new GetMethod(urlpath);
        } else if ("POST".equalsIgnoreCase(method)) {
            theMethod = new PostMethod(urlpath);

            if (params != null) {

                if (multipart) {
                    List<Part> parts = new ArrayList<Part>();
                    for (String key : params.keySet()) {
                        StringPart stringPart = new StringPart(key, params.get(key));
                        stringPart.setCharSet("UTF-8");
                        parts.add(stringPart);                    }
                    ((PostMethod) theMethod).setRequestEntity(new MultipartRequestEntity(parts.toArray(new Part[0]),
                            theMethod.getParams()));
                } else {

                    List<NameValuePair> NameValuePairList = new ArrayList<NameValuePair>();
                    for (String key : params.keySet()) {
                        NameValuePairList.add(new NameValuePair(key, params.get(key)));
                    }
                    ((PostMethod) theMethod).setRequestBody(NameValuePairList.toArray(new NameValuePair[0]));
                }
            }

        }
       
        try {
            int result = httpclient.executeMethod(theMethod);
            System.out.println("Call " + theMethod.getURI()+" :: result = " + result);
            sb.append(theMethod.getResponseBodyAsString());
            String rawResult = sb.toString();
            return rawResult;

        } catch (Exception e) {
            throw e;
        } finally {
            theMethod.releaseConnection();
        }

    }

}
