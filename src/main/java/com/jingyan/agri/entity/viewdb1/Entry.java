package com.jingyan.agri.entity.viewdb1;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class Entry extends BaseEntity<Entry> {

	public static enum Type { TABLE, DIAGRAM }
	public static enum SearchParam {}
	
	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private Integer type;
	@JsonIgnore
	public Type getTypeE() {
		return Type.values()[type];
	}
	public void setTypeE(Type e) {
		type = e.ordinal();
	}
	@Getter @Setter
	private String key;
	@Getter @Setter
	private String title;
	
	public static List<String> getSortableFields() {
		return List.of();
	}
}
