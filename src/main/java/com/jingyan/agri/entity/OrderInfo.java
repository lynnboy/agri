package com.jingyan.agri.entity;

import java.util.Date;
import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

public class OrderInfo extends BaseEntity<OrderInfo> {

	private static final long serialVersionUID = 1L;

	private Integer id;
	private String customerName;
	private String tenantId;
	private String dealerName;
	private Integer status;
	private Date createDate;
	
	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"customerName",
				"status"
				);
	}
	
	public String getPoNumber() {
		return id == null ? "" : String.format("UFOP%05d", this.id);
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public String getDealerName() {
		return dealerName;
	}
	public void setDealerName(String dealerName) {
		this.dealerName = dealerName;
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

	public String getTenantId() {
		return tenantId;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}

}
