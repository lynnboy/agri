package com.jingyan.agri.entity.sys;

import java.util.Date;
import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class Project extends BaseEntity<Project> {

	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String desc;
	@Getter @Setter
	private Date createDate;
	@Getter @Setter
	private Integer tempId;
	@Getter @Setter
	private Boolean deprecated;

	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"name"
				);
	}
}
