package com.jingyan.agri.modules.sys;

import lombok.Getter;
import lombok.Setter;

public class AddDealerParams {

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String oldLoginName;
	@Getter @Setter
	private String loginName;
	@Getter @Setter
	private String newPassword;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String email;
	@Getter @Setter
	private String phone;
	@Getter @Setter
	private String mobile;
	@Getter @Setter
	private String remarks;
}
