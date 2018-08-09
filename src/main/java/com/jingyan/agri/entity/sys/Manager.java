package com.jingyan.agri.entity.sys;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class Manager extends BaseEntity<Manager> {

	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String login;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String password;
	@Getter @Setter
	private String createDate;
}
