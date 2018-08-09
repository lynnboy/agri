package com.jingyan.agri.entity;

import java.util.Date;
import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

public class License extends BaseEntity<License> {
	
	public enum Status { FREE, IN_USE, CONSUMED, }

	private static final long serialVersionUID = 1L;

	private Integer id;
	private String licenseKey;
	private Integer type;
	private Integer orderId;
	private Integer status;
	private Date issueDate;
	private Date createDate;

	public static List<String> getSortableFields() {
		return List.of(
				"status",
				"licenseKey"
				);
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getLicenseKey() {
		return licenseKey;
	}
	public void setLicenseKey(String licenseKey) {
		this.licenseKey = licenseKey;
	}
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Date getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
}
