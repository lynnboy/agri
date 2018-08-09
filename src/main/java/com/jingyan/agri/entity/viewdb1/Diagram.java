package com.jingyan.agri.entity.viewdb1;

import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class Diagram extends BaseEntity<Diagram> {

	public static enum DiagramType { SVG }
	
	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private Integer type;
	@Getter @Setter
	private String divCode;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String filename;
	@Getter @Setter
	private String group;
	
	public static List<String> getSortableFields() {
		return List.of();
	}
}
