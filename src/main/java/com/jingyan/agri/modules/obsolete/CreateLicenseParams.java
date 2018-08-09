package com.jingyan.agri.modules.obsolete;

public class CreateLicenseParams {

	private String serviceProvider;
	private String serviceType;
	private String suiteType;
	private Integer count;
	public String getServiceProvider() {
		return serviceProvider;
	}
	public void setServiceProvider(String serviceProvider) {
		this.serviceProvider = serviceProvider;
	}
	public String getServiceType() {
		return serviceType;
	}
	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}
	public String getSuiteType() {
		return suiteType;
	}
	public void setSuiteType(String suiteType) {
		this.suiteType = suiteType;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
}
