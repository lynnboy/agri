package com.jingyan.agri.entity.sys;

import java.util.Date;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.jingyan.agri.common.persistence.BaseEntity;
import com.jingyan.agri.entity.sys.ProjectTemplate.Task;

import lombok.Getter;
import lombok.Setter;
import lombok.val;

public class ProjectTemplate extends BaseEntity<ProjectTemplate> {

	public static class State {
		@Getter @Setter
		private Integer id;
		@Getter @Setter
		private String name;
	}
	public static class Task {
		public static enum Type { DEFAULT, 填报, 审核, 汇总, 查看 }
		public static enum Status { 正常, 申请中, 申请撤回, 通过, 拒绝 }
		public static EnumSet<Task.Status> belowStatus = Sets.newEnumSet(
				List.of(Task.Status.申请撤回, Task.Status.拒绝), Task.Status.class);
		@Getter @Setter
		private Integer id;
		@Getter @Setter
		private String name;
		@Getter @Setter
		private Type type = Type.DEFAULT;
	}
	public static class WorkflowItem {
		@Getter @Setter
		private Integer srcState;
		@Getter @Setter
		private Integer action;
		@Getter @Setter
		private Integer dstState;
	}

	public static class Info extends BaseEntity<Info> {
		private static final long serialVersionUID = 1L;

		@Getter @Setter
		private List<WorkflowItem> workflow = Lists.newArrayList();
		@Getter @Setter
		private List<State> states = Lists.newArrayList();
		@Getter @Setter
		private List<Task> tasks = Lists.newArrayList();
		@JsonIgnore
		@Getter
		private Map<Integer,Task> taskMap = Maps.newTreeMap();
		@JsonIgnore
		@Getter
		private Map<Integer,State> stateMap = Maps.newTreeMap();
		@JsonIgnore
		@Getter
		private Map<Integer,WorkflowItem> workflowMap = Maps.newTreeMap();
		
		@Override
		public Info fromJson(String info) {
			Info p = super.fromJson(info);
			for (Task item : p.getTasks())
				p.getTaskMap().putIfAbsent(item.getId(), item);
			for (State item : p.getStates())
				p.getStateMap().putIfAbsent(item.getId(), item);
			for (WorkflowItem item : p.getWorkflow())
				p.getWorkflowMap().putIfAbsent(item.getAction(), item);
			return p;
		}
		
		public Task nextTaskOf(Integer stateId) {
			for (val item : workflow) {
				if (item.getSrcState() == stateId)
					return getTaskMap().get(item.getAction());
			}
			return null;
		}
		public Task prevTaskOf(Integer stateId) {
			for (val item : workflow) {
				if (item.getDstState() == stateId)
					return getTaskMap().get(item.getAction());
			}
			return null;
		}
	}
	
	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String name;
	@Getter @Setter
	private String desc;
	@Getter @Setter
	private String version;
	@Getter @Setter
	private Date createDate;
	@Getter @Setter
	private String mapRoot;

	@JsonIgnore
	public String getInfo() {
		return projectInfo.toJson();
	}
	public void setInfo(String info) {
		this.projectInfo = this.projectInfo.fromJson(info);
	}

	@Getter
	private Info projectInfo = new Info();

	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"name"
				);
	}
}
