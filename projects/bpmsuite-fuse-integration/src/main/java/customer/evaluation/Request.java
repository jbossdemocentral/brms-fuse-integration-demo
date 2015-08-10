package customer.evaluation;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "customerrequest")
public class Request {
	
	
	private String personId;
	private String requestId;
	private Integer amount;
	private Integer age;
	private String personName;
	
	public String getPersonId() {
		return personId;
	}
	public void setPersonId(String personId) {
		this.personId = personId;
	}
	public Integer getAmount() {
		return amount;
	}
	public void setAmount(Integer amount) {
		this.amount = amount;
	}
	public String getRequestId() {
		return requestId;
	}
	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}
	public Integer getAge() {
		return age;
	}
	public void setAge(Integer age) {
		this.age = age;
	}
	public String getPersonName() {
		return personName;
	}
	public void setPersonName(String personName) {
		this.personName = personName;
	}
	
	

}
