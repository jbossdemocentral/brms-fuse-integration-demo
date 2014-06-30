package com.jboss.examples;

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
     * Returns data from a service call (GET).
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

//    public void startProcessFromCamel()
//    {
//        try
//        {
//        // get process definitions
//        ProcessDefinitionRefWrapper processDefinitionWrapper = getProcessDefinitions();
//        // pick up "org.jbpm.approval.rewards"
//        ProcessDefinitionRef definitionRef = null;
//        for (ProcessDefinitionRef processDefinitionRef : processDefinitionWrapper.getDefinitions()) {
//            if (processDefinitionRef.getId().equals(PROCESS_ID)) {
//                definitionRef = processDefinitionRef;
//                break;
//            }
//        }
//        if (definitionRef == null) {
//            System.out.println(PROCESS_ID + " doesn't exist");
//            return;
//        }
//        // start a process instance
//        Map<String,String> fromCamel = new HashMap<String,String>();
//        fromCamel.put("stock","RHT");
//        fromCamel.put("Price",  "50");
//        //client.startProcessWithParameters(client, definitionRef, fromCamel);
//        ProcessInstanceRef processInstanceRef = startProcess(definitionRef);
//        
//        } catch (Exception e) {
//        	System.out.println("Error Calling BRMS " + e.getMessage() );
//        	e.printStackTrace();
//        }
//    }
    
    private void claimTask(long taskId, String actorId) throws Exception {
        String claimTaskUrl = BASE_URL + "task/" + taskId + "/assign/" + actorId;
        String dataFromService = getDataFromService(claimTaskUrl, "POST", null, false);
        System.out.println(dataFromService);
    }

    private void completeTask(long taskId, Map<String, String> params) throws Exception {
        String completeTaskUrl = BASE_URL + "form/task/" + taskId + "/complete";
        String dataFromService = getDataFromService(completeTaskUrl, "POST", params, true);
        System.out.println(dataFromService);

        return;

    }

    private List<TaskRef> getTaskListForPotentialOwner(String actorId) throws Exception {
        String getTaskListUrl = BASE_URL + "tasks/" + actorId + "/participation";
        String dataFromService = getDataFromService(getTaskListUrl, "GET");
        System.out.println(dataFromService);

        Gson gson = GsonFactory.createInstance();
        TaskRefWrapper wrapper = gson.fromJson(dataFromService, TaskRefWrapper.class);

        List<TaskRef> taskList = wrapper.getTasks();

        return taskList;
    }

    private ProcessInstanceRef getLatestProcessInstance(ProcessDefinitionRef def)
            throws Exception {
        String getInstanceUrl = BASE_URL + "process/definition/" + def.getId() + "/instances";
        String dataFromService = getDataFromService(getInstanceUrl, "GET");
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

    private void startProcessWithParameters(ProcessDefinitionRef def, Map<String, String> params) throws Exception {
        String newInstanceUrl = BASE_URL + "form/process/" + def.getId() + "/complete";
        String dataFromService = getDataFromService(newInstanceUrl, "POST", params, true);
        System.out.println("--------");
        System.out.println(dataFromService); // BZ871302 : cannot get
                                             // processInstanceId from response
        System.out.println("--------");

        return;
    }

    private static ProcessDefinitionRefWrapper getProcessDefinitions() throws Exception {
        String newInstanceUrl = BASE_URL + "deployment";
        String dataFromService = getDataFromService(newInstanceUrl, "GET");
        System.out.println(dataFromService);

        Gson gson = new Gson();
        ProcessDefinitionRefWrapper wrapper = gson.fromJson(dataFromService, ProcessDefinitionRefWrapper.class);

        for (ProcessDefinitionRef ref : wrapper.getDefinitions()) {
            System.out.println("process deploymnet ID is: " + ref.getDeploymentId());
        }

        return wrapper;
    }

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
