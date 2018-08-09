package com.jingyan.agri.modules.dealer;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

public class CreateOrderParams {
	private int customerId;
	private String code;
	private int userAddNum;
	@DateTimeFormat(iso=ISO.DATE,pattern="yyyy-MM-dd")
	private Date usedDate;
	private String remark;
	public int getCustomerId() {
		return customerId;
	}
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public int getUserAddNum() {
		return userAddNum;
	}
	public void setUserAddNum(int userAddNum) {
		this.userAddNum = userAddNum;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Date getUsedDate() {
		return usedDate;
	}
	public void setUsedDate(Date usedDate) {
		this.usedDate = usedDate;
	}
}
