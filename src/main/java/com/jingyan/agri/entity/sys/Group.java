package com.jingyan.agri.entity.sys;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Getter;
import lombok.Setter;

public class Group extends BaseEntity<Group> {
	
	public static class ConditionItem {
		@Getter @Setter
		private String pattern;
		@Getter @Setter
		private String key;
	}
	
	public static class Condition extends BaseEntity<Condition> {
		private static final long serialVersionUID = 1L;

		@Getter @Setter
		private List<ConditionItem> items = new ArrayList<>();
	}

	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private Integer projId;
	@Getter @Setter
	private String projName;
	@Getter @Setter
	private Integer action;

	@Getter @Setter
	private Integer memberCount;
	@Getter @Setter
	private String remarks;
	@Getter @Setter
	private Date createDate;

	@Getter
	private Condition condition = new Condition();
	
	public String getConditionText() {
		return condition.toJson();
	}
	public void setConditionText(String text) {
		condition = condition.fromJson(text);
	}
	
	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"name",
				"projName",
				"action"
				);
	}
}
