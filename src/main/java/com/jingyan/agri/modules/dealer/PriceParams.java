package com.jingyan.agri.modules.dealer;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import com.fasterxml.jackson.annotation.JsonFormat;

public class PriceParams {
	private Integer curCustomerCount = 0;
	@DateTimeFormat(iso=ISO.DATE)
	@JsonFormat(pattern="yyyy-MM-dd")
	private Date curDueDate;
	private Integer newCustomerCount = 0;
	private Integer newSuiteCount = 0;
	@DateTimeFormat(iso=ISO.DATE)
	@JsonFormat(pattern="yyyy-MM-dd")
	private Date activateDate = new Date();
	private Integer totalCustomerCount;
	@DateTimeFormat(iso=ISO.DATE)
	@JsonFormat(pattern="yyyy-MM-dd")
	private Date newDueDate;

	public Integer getCurCustomerCount() {
		return curCustomerCount;
	}
	public void setCurCustomerCount(Integer curCustomerCount) {
		this.curCustomerCount = curCustomerCount;
	}
	public Date getCurDueDate() {
		return curDueDate;
	}
	public void setCurDueDate(Date curDueDate) {
		this.curDueDate = curDueDate;
	}
	public Integer getNewCustomerCount() {
		return newCustomerCount;
	}
	public void setNewCustomerCount(Integer newCustomerCount) {
		this.newCustomerCount = newCustomerCount;
	}
	public Integer getNewSuiteCount() {
		return newSuiteCount;
	}
	public void setNewSuiteCount(Integer newSuiteCount) {
		this.newSuiteCount = newSuiteCount;
	}
	public Date getActivateDate() {
		return activateDate;
	}
	public void setActivateDate(Date activateDate) {
		this.activateDate = activateDate;
	}
	public Integer getTotalCustomerCount() {
		return totalCustomerCount;
	}
	public void setTotalCustomerCount(Integer totalCustomerCount) {
		this.totalCustomerCount = totalCustomerCount;
	}
	public Date getNewDueDate() {
		return newDueDate;
	}
	public void setNewDueDate(Date newDueDate) {
		this.newDueDate = newDueDate;
	}
}
