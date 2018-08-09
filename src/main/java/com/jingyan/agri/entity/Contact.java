package com.jingyan.agri.entity;

import com.jingyan.agri.common.persistence.BaseEntity;

public class Contact extends BaseEntity<Contact> {
	
	private static final long serialVersionUID = 1L;

	private String name;
	private String email;
	private String phone;
	private String division;
	private String address;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getDivision() {
		return division;
	}

	public void setDivision(String division) {
		this.division = division;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
}
