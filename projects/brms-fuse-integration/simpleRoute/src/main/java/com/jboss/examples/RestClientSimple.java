package com.jboss.examples;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.jboss.bpm.console.client.model.ProcessDefinitionRef;
import org.jboss.bpm.console.client.model.ProcessDefinitionRefWrapper;
import org.jboss.bpm.console.client.model.ProcessInstanceRef;
import org.jboss.bpm.console.client.model.ProcessInstanceRefWrapper;
import org.jboss.bpm.console.client.model.TaskRef;
import org.jboss.bpm.console.client.model.TaskRefWrapper;

import com.google.gson.Gson;

/**
 * Hello world!
 * 
 */
public class RestClientSimple {
    private static final String BASE_URL = "http://localhost:8080/business-central-server/rs/";
    private static final String AUTH_URL = BASE_URL + "identity/secure/j_security_check";
    private final String username;
    private final String password;

    //private static final String PROCESS_ID = "defaultPackage.hello";
    private static final String PROCESS_ID = "com.sample.bpmn.hello";

    public RestClientSimple(final String u, final String p) {
        this.username = u;
        this.password = p;
    }
    public RestClientSimple() {
        this.username = "admin";
        this.password = "admin";
    }

    public static void main(String[] args) throws Exception {

        RestClientSimple client = new RestClientSimple("admin", "admin");

        // get process definitions
        ProcessDefinitionRefWrapper processDefinitionWrapper = client.getProcessDefinitions(client);

        // pick up "org.jbpm.approval.rewards"
        ProcessDefinitionRef definitionRef = null;
        for (ProcessDefinitionRef processDefinitionRef : processDefinitionWrapper.getDefinitions()) {
            if (processDefinitionRef.getId().equals(PROCESS_ID)) {
                definitionRef = processDefinitionRef;
                break;
            }
        }
        if (definitionRef == null) {
            System.out.println(PROCESS_ID + " doesn't exist");
            return;
        }

        // start a process instance
        ProcessInstanceRef processInstanceRef = client.startProcess(client, definitionRef);

    }

    public void startProcessFromCamel()
    {
        RestClientSimple client = new RestClientSimple();
        try
        {
        // get process definitions
        ProcessDefinitionRefWrapper processDefinitionWrapper = client.getProcessDefinitions(client);
        // pick up "org.jbpm.approval.rewards"
        ProcessDefinitionRef definitionRef = null;
        for (ProcessDefinitionRef processDefinitionRef : processDefinitionWrapper.getDefinitions()) {
            if (processDefinitionRef.getId().equals(PROCESS_ID)) {
                definitionRef = processDefinitionRef;
                break;
            }
        }
        if (definitionRef == null) {
            System.out.println(PROCESS_ID + " doesn't exist");
            return;
        }
        // start a process instance
        Map<String,String> fromCamel = new HashMap<String,String>();
        fromCamel.put("stock","RHT");
        fromCamel.put("Price",  "50");
        //client.startProcessWithParameters(client, definitionRef, fromCamel);
        ProcessInstanceRef processInstanceRef = client.startProcess(client, definitionRef);
        
        } catch (Exception e) {
        	System.out.println("Error Calling BRMS " + e.getMessage() );
        	e.printStackTrace();
        }
    }
    
    private void claimTask(RestClientSimple client, long taskId, String actorId) throws Exception {
        String claimTaskUrl = BASE_URL + "task/" + taskId + "/assign/" + actorId;
        String dataFromService = client.getDataFromService(claimTaskUrl, "POST", null, false);
        System.out.println(dataFromService);
    }

    private void completeTask(RestClientSimple client, long taskId, Map<String, String> params) throws Exception {
        String completeTaskUrl = BASE_URL + "form/task/" + taskId + "/complete";
        String dataFromService = client.getDataFromService(completeTaskUrl, "POST", params, true);
        System.out.println(dataFromService);

        return;

    }

    private List<TaskRef> getTaskListForPotentialOwner(RestClientSimple client, String actorId) throws Exception {
        String getTaskListUrl = BASE_URL + "tasks/" + actorId + "/participation";
        String dataFromService = client.getDataFromService(getTaskListUrl, "GET");
        System.out.println(dataFromService);

        Gson gson = GsonFactory.createInstance();
        TaskRefWrapper wrapper = gson.fromJson(dataFromService, TaskRefWrapper.class);

        List<TaskRef> taskList = wrapper.getTasks();

        return taskList;
    }

    private ProcessInstanceRef getLatestProcessInstance(RestClientSimple client, ProcessDefinitionRef def)
            throws Exception {
        String getInstanceUrl = BASE_URL + "process/definition/" + def.getId() + "/instances";
        String dataFromService = client.getDataFromService(getInstanceUrl, "GET");
        System.out.println(dataFromService);

        Gson gson = GsonFactory.createInstance();
        ProcessInstanceRefWrapper wrapper = gson.fromJson(dataFromService, ProcessInstanceRefWrapper.class);

        List<ProcessInstanceRef> instances = wrapper.getInstances();

        // return the last process instance
        if (instances.size() > 0) {
            return instances.get(instances.size() - 1);
        }
        return null;
    }

    private ProcessInstanceRef startProcess(RestClientSimple client, ProcessDefinitionRef def) throws Exception {
        String newInstanceUrl = BASE_URL + "process/definition/" + def.getId() + "/new_instance";
        String dataFromService = client.getDataFromService(newInstanceUrl, "POST");
        System.out.println("--------");
        System.out.println(dataFromService);
        System.out.println("--------");

        Gson gson = GsonFactory.createInstance();
        ProcessInstanceRef processInstanceRef = gson.fromJson(dataFromService, ProcessInstanceRef.class);

        return processInstanceRef;
    }

    private void startProcessWithParameters(RestClientSimple client, ProcessDefinitionRef def,
            Map<String, String> params) throws Exception {
        String newInstanceUrl = BASE_URL + "form/process/" + def.getId() + "/complete";
        String dataFromService = client.getDataFromService(newInstanceUrl, "POST", params, true);
        System.out.println("--------");
        System.out.println(dataFromService); // BZ871302 : cannot get
                                             // processInstanceId from response
        System.out.println("--------");

        return;
    }

    private ProcessDefinitionRefWrapper getProcessDefinitions(RestClientSimple client) throws Exception {
        String newInstanceUrl = BASE_URL + "process/definitions";
        String dataFromService = client.getDataFromService(newInstanceUrl, "GET");
        System.out.println(dataFromService);

        Gson gson = new Gson();
        ProcessDefinitionRefWrapper wrapper = gson.fromJson(dataFromService, ProcessDefinitionRefWrapper.class);

        for (ProcessDefinitionRef ref : wrapper.getDefinitions()) {
            System.out.println("process ID is: " + ref.getId());
        }

        return wrapper;
    }

    private String getDataFromService(String urlpath, String method) throws Exception {
        // no params
        return getDataFromService(urlpath, method, null, false);
    }

    private String getDataFromService(String urlpath, String method, Map<String, String> params, boolean multipart)
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

        if (username != null && password != null) {

            try {
                int result = httpclient.executeMethod(theMethod);
                System.out.println("Call " + theMethod.getURI()+" :: result = " + result);
                System.out.println(theMethod.getResponseBodyAsString());
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                theMethod.releaseConnection();
            }
            PostMethod authMethod = new PostMethod(AUTH_URL);
            NameValuePair[] data = { new NameValuePair("j_username", username),
                    new NameValuePair("j_password", password) };
            authMethod.setRequestBody(data);
            try {
                int result = httpclient.executeMethod(authMethod);
                System.out.println("Call " + authMethod.getURI()+" :: result = " + result);
                System.out.println(theMethod.getResponseBodyAsString());
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                authMethod.releaseConnection();
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
