package com.jingyan.agri.entity.sys;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class SettingValue extends BaseEntity<SettingValue> {
	
	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String value;
	@Getter @Setter
	private String category;
	
	public Integer asInteger() {
		if (value == null) return null;
		try {
			return Integer.parseInt(value);
		} catch (NumberFormatException ex) {
			return null;
		}
	}
	
	public void setInteger(Integer v) {
		if (v != null) value = v.toString();
		else value = null;
	}
	
	static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public Date asDate() {
		if (value == null) return null;
		try {
			return sdf.parse(value);
		} catch (ParseException ex) {
			return null;
		}
	}
	
	public void setDate(Date v) {
		if (v != null) value = sdf.format(v);
		else value = null;
	}

	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"name"
				);
	}
}
