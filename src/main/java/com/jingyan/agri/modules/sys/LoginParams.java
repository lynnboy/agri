package com.jingyan.agri.modules.sys;

import lombok.Getter;
import lombok.Setter;

public class LoginParams {
	@Getter @Setter 
	private String userName;
	@Getter @Setter 
	private String password;
	@Getter @Setter 
	private String validateCode;
	@Getter @Setter 
	private Boolean isAdmin;
}
