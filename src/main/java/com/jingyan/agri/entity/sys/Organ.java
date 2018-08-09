package com.jingyan.agri.entity.sys;

import java.util.Date;
import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class Organ extends BaseEntity<Organ> {

	public enum Status { NORMAL, SHADOW }

	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String desc;
	@Getter @Setter
	private String addr;
	@Getter @Setter
	private String phone;
	@Getter @Setter
	private String postal;
	@Getter @Setter
	private String remarks;
	@Getter @Setter
	private Date createDate;
	@Getter @Setter
	private Integer status;

	@Getter @Setter
	private Integer userCount;
	
	public boolean isFixed() { return id == 0; }
	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"name",
				"userCount"
				);
	}
}
