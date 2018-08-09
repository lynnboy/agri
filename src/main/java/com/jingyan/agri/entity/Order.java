package com.jingyan.agri.entity;

import java.util.Date;

import com.jingyan.agri.common.persistence.BaseEntity;

public class Order extends BaseEntity<Order> {

	public enum Status { NEW, CONFIRMED, FINISHED, DISCARDED, }

	private static final long serialVersionUID = 1L;

	private Integer id;
	private Integer dealerId;
	private Integer customerId;
	private Integer userCount;
	private Integer monthCount;
	private Integer status;
	private Date createDate;
	private Date issueDate;
	private String remarks;

	public String getPoNumber() {
		return id == null ? "" : String.format("UFOP%05d", this.id);
	}

	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getDealerId() {
		return dealerId;
	}
	public void setDealerId(Integer dealerId) {
		this.dealerId = dealerId;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public Integer getUserCount() {
		return userCount;
	}
	public void setUserCount(Integer userCount) {
		this.userCount = userCount;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getMonthCount() {
		return monthCount;
	}

	public void setMonthCount(Integer monthCount) {
		this.monthCount = monthCount;
	}
}
