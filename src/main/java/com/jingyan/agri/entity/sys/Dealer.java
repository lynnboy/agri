package com.jingyan.agri.entity.sys;

import java.util.Date;
import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class Dealer extends BaseEntity<Dealer> {

	public enum Status { NORMAL, SHADOW }

	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String login;
	@Getter @Setter
	private String password;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String phone;
	@Getter @Setter
	private String mobile;
	@Getter @Setter
	private String email;
	@Getter @Setter
	private String contactInfo;
	@Getter @Setter
	private Date createDate;
	@Getter @Setter
	private Integer status;
	@Getter @Setter
	private Date modifyDate;
	@Getter @Setter
	private String remarks;
	@Getter @Setter
	private Integer organId;
	@Getter @Setter
	private String organName;
	
	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"login",
				"name",
				"organName"
				);
	}
}
