package com.jingyan.agri.entity;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jingyan.agri.common.persistence.BaseEntity;

public class Customer extends BaseEntity<Customer> {
	
	public static class Contact {
		
		private String name;
		private String email;
		private String phone;
		private String division;
		private String address;
		
		public static Contact from(String contactInfo) {
			try {
				ObjectMapper mapper = new ObjectMapper();
				Contact contact = mapper.readValue(contactInfo, Contact.class);
				return contact;
			} catch (Exception e) {
				e.printStackTrace();
				throw new RuntimeException("Invalid contact value.");
			}
		}
		
		@Override
		public String toString() {
			ObjectMapper mapper = new ObjectMapper();
			String contactInfo;
			try {
				contactInfo = mapper.writeValueAsString(this);
			} catch (JsonProcessingException e) {
				throw new RuntimeException("failed to make json contact.");
			}
			return contactInfo;
		}

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

	private static final long serialVersionUID = 1L;

	private Integer id;
	private Integer dealerId;
	private String name;
	private String tenantId;
//	private String contactName;
//	private String contactEmail;
//	private String contactPhone;
//	private String contactDivision;
//	private String address;
//	private String contactInfo;
	private Date createDate;
	private String dealerName;
	private boolean hasOrder;
	
	public static List<String> getSortableFields() {
		return List.of("id", "name");
	}
	private Contact contact = new Contact();
	
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
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getContactName() {
		return contact.getName();
	}
	public void setContactName(String contactName) {
		this.contact.setName(contactName);
	}
	public String getContactEmail() {
		return contact.getEmail();
	}
	public void setContactEmail(String contactEmail) {
		this.contact.setEmail(contactEmail);
	}
	public String getContactPhone() {
		return contact.getPhone();
	}
	public void setContactPhone(String contactPhone) {
		contact.setPhone(contactPhone);
	}
	public String getContactDivision() {
		return contact.getDivision();
	}
	public void setContactDivision(String contactDivision) {
		contact.setDivision(contactDivision);
	}
	public String getAddress() {
		return contact.getAddress();
	}
	public void setAddress(String address) {
		contact.setAddress(address);
	}
	public String getContactInfo() {
		return contact.toString();
	}
	public void setContactInfo(String contactInfo) {
		contact = Contact.from(contactInfo);
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Contact getContact() {
		return contact;
	}
//	public void setContact(Contact contact) {
//		this.contact = contact;
//	}

	public String getDealerName() {
		return dealerName;
	}
	public void setDealerName(String dealerName) {
		this.dealerName = dealerName;
	}
	public boolean isHasOrder() {
		return hasOrder;
	}
	public void setHasOrder(boolean hasOrder) {
		this.hasOrder = hasOrder;
	}
	public String getTenantId() {
		return tenantId;
	}
	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}
}
