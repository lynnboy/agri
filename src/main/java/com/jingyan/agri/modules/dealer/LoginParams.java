package com.jingyan.agri.modules.dealer;

import lombok.Getter;
import lombok.Setter;

public class LoginParams {
	@Getter @Setter
	private String userName;
	@Getter @Setter
	private String password;
	@Getter @Setter
	private String validateCode;
}
