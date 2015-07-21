
package bpmsuiteresponse;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="process-id" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}byte"/>
 *         &lt;element name="state" type="{http://www.w3.org/2001/XMLSchema}byte"/>
 *         &lt;element name="parentProcessInstanceId" type="{http://www.w3.org/2001/XMLSchema}byte"/>
 *         &lt;element name="status" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="url" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "processId",
    "id",
    "state",
    "parentProcessInstanceId",
    "status",
    "url"
})
@XmlRootElement(name = "process-instance-response")
public class ProcessInstanceResponse {

    @XmlElement(name = "process-id", required = true)
    protected String processId;
    protected byte id;
    protected byte state;
    protected byte parentProcessInstanceId;
    @XmlElement(required = true)
    protected String status;
    @XmlElement(required = true)
    protected String url;

    /**
     * Gets the value of the processId property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getProcessId() {
        return processId;
    }

    /**
     * Sets the value of the processId property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setProcessId(String value) {
        this.processId = value;
    }

    /**
     * Gets the value of the id property.
     * 
     */
    public byte getId() {
        return id;
    }

    /**
     * Sets the value of the id property.
     * 
     */
    public void setId(byte value) {
        this.id = value;
    }

    /**
     * Gets the value of the state property.
     * 
     */
    public byte getState() {
        return state;
    }

    /**
     * Sets the value of the state property.
     * 
     */
    public void setState(byte value) {
        this.state = value;
    }

    /**
     * Gets the value of the parentProcessInstanceId property.
     * 
     */
    public byte getParentProcessInstanceId() {
        return parentProcessInstanceId;
    }

    /**
     * Sets the value of the parentProcessInstanceId property.
     * 
     */
    public void setParentProcessInstanceId(byte value) {
        this.parentProcessInstanceId = value;
    }

    /**
     * Gets the value of the status property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStatus() {
        return status;
    }

    /**
     * Sets the value of the status property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStatus(String value) {
        this.status = value;
    }

    /**
     * Gets the value of the url property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUrl() {
        return url;
    }

    /**
     * Sets the value of the url property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUrl(String value) {
        this.url = value;
    }

}
