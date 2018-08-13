package com.jingyan.agri.entity.sys;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jingyan.agri.common.persistence.BaseEntity;
import com.jingyan.agri.common.utils.JsonUtils;

import lombok.Getter;
import lombok.Setter;

public class Meta extends BaseEntity<Meta> {
	
	public static class Column {
		@Getter @Setter
		private String name;
		@Getter @Setter
		private String type = "VARCHAR(45)";
		@Getter @Setter
		private boolean isnull = true;
		@Getter @Setter
		private String as = "";

		public class Ext {
			@JsonProperty("isText")
			public boolean isText() {
				String sqltype = type.toUpperCase();
				return sqltype.contains("CHAR") || sqltype.contains("TEXT");
			}
			public void setIsText(boolean ignore) {}
			@JsonProperty("isInt")
			public boolean isInt() {
				String sqltype = type.toUpperCase();
				return sqltype.contains("INT");
			}
			public void setIsInt(boolean ignore) {}
			@JsonProperty("isNumber")
			public boolean isNumber() {
				String sqltype = type.toUpperCase();
				return sqltype.contains("INT") ||
						sqltype.contains("FLOAT") || sqltype.contains("DOUBLE") ||
						sqltype.contains("REAL") || sqltype.contains("DECIMAL");
			}
			public void setIsNumber(boolean ignore) {}
			@JsonProperty("isDate")
			public boolean isDate() {
				String sqltype = type.toUpperCase();
				return sqltype.equals("DATE");
			}
			public void setIsDate(boolean ignore) {}
			@JsonProperty("isDateTime")
			public boolean isDateTime() {
				String sqltype = type.toUpperCase();
				return sqltype.contains("DATE") || sqltype.contains("TIME");
			}
			public void setIsDateTime(boolean ignore) {}
			@JsonProperty("isBinary")
			public boolean isBinary() {
				String sqltype = type.toUpperCase();
				return sqltype.contains("BINARY") || sqltype.contains("BLOB");
			}
			public void setIsBinary(boolean ignore) {}
			
			public String eqVal(String val) {
				if (isText()) {
					return "'" + val.replace("'", "''") + "'";
				} else if (isInt()) {
					return Long.toString(Long.parseLong(val));
				} else if (isNumber()) {
					return Double.toString(Double.parseDouble(val));
				} else if (isDate()) { // 
					
				}
				return "";
			}
		}
		public Ext ext() { return new Ext(); }

		public static void main(String args[]) {
			Date d = new Date();
			System.out.println(JsonUtils.serialize(d));
			System.out.println(d.getTime());
			Column col = new Column();
			col.setIsnull(false);
			col.setName("id");
			col.setType("VARCHAR(24)");
			System.out.println(JsonUtils.serialize(col));
			col = JsonUtils.deserialize("{\"name\":\"id\"}", Column.class);
			System.out.println(JsonUtils.serialize(col));
		}
	}
	public static class Schema extends BaseEntity<Schema> {
		private static final long serialVersionUID = 1L;
		@Getter @Setter
		private List<Column> columns = Lists.newArrayList();
		@Getter @Setter
		private List<String> pk = Lists.newArrayList();

		public Column columnOf(String key) {
			for (Column column : getColumns()) {
				if (column.getName().equals(key)) return column;
			}
			return null;
		}
	}

	public static class OptionList extends LinkedHashMap<String, String> {
		private static final long serialVersionUID = 1L;
	}

	public static class SortConfig extends BaseEntity<SortConfig> {
		public static enum Mode { EXCLUSIVE, INCLUSIVE }

		private static final long serialVersionUID = 1L;
		
		@Getter @Setter
		private static Mode mode = Mode.EXCLUSIVE;
		@Getter @Setter
		private List<String> list = Lists.newArrayList();
		
		public boolean isSortable(String key) {
			return mode == Mode.EXCLUSIVE ?
					!list.contains(key) : list.contains(key);
		}
		public List<String> getSortableColumnsFor(Schema schema) {
			if (mode == Mode.EXCLUSIVE)
				return schema.columns.stream().map(c -> c.getName())
						.filter(key -> !list.contains(key))
						.collect(Collectors.toList());
			else
				return list;
		}
	}

	public static class SearchConfig extends BaseEntity<SearchConfig> {
		private static final long serialVersionUID = 1L;

		public static enum Mode { DEFAULT, INCLUSIVE }
		public static enum OptListMode { NONE, NAMED, SPECIFIED, COLLECT }
		
		public static class Item {
			@Getter @Setter
			private String key;
			@Getter @Setter
			private OptListMode optListMode = OptListMode.NONE;
			@Getter @Setter
			private String optListName = "";
			@Getter @Setter
			private OptionList optList = new OptionList();
		}
		
		@Getter @Setter
		private Mode mode = Mode.DEFAULT;
		@Getter @Setter
		private List<Item> items = Lists.newArrayList();
		
		public boolean isSearchable(String key) {
			return items.stream().anyMatch(i -> i.getKey().equals(key));
		}
	}
	
	public static class EditConfig extends BaseEntity<EditConfig> {
		private static final long serialVersionUID = 1L;
	}

	public static class ViewConfig extends BaseEntity<ViewConfig> {
		private static final long serialVersionUID = 1L;
		@Getter @Setter
		private Map<String, String> headerMap = Maps.newHashMap();
		
		public String headerOf(String key) {
			return headerMap.getOrDefault(key, key);
		}
	}
	
	private static final long serialVersionUID = 1L;

	@Getter @Setter
	private Integer id;
	@Getter @Setter
	private String tableName;
	@Getter @Setter
	private Integer tempId;
	@Getter @Setter
	private Integer projId;
	@Getter @Setter
	private String key;
	@Getter @Setter
	private String filterColumn;
	
	@Getter @Setter
	private Schema schema = new Schema();
	@JsonIgnore
	public String getSchemaText() {
		return schema.toJson();
	}
	public void setSchemaText(String schemaText) {
		this.schema = schema.fromJson(schemaText);
	}
	
	@Getter @Setter
	private SortConfig sortConfig = new SortConfig();
	@JsonIgnore
	public String getSortConfigText() {
		return sortConfig.toJson();
	}
	public void setSortConfigText(String sortConfigText) {
		sortConfig = sortConfig.fromJson(sortConfigText);
	}

	@Getter @Setter
	private SearchConfig searchConfig = new SearchConfig();
	@JsonIgnore
	public String getSearchConfigText() {
		return searchConfig.toJson();
	}
	public void setSearchConfigText(String searchConfigText) {
		this.searchConfig = searchConfig.fromJson(searchConfigText);
	}
	
	@Getter @Setter
	private EditConfig editConfig = new EditConfig();
	@JsonIgnore
	public String getEditConfigText() {
		return editConfig.toJson();
	}
	public void setEditConfigText(String editConfigText) {
		this.editConfig = editConfig.fromJson(editConfigText);
	}

	@Getter @Setter
	private ViewConfig viewConfig = new ViewConfig();
	@JsonIgnore
	public String getViewConfigText() {
		return viewConfig.toJson();
	}
	public void setViewConfigText(String viewConfigText) {
		this.viewConfig = viewConfig.fromJson(viewConfigText);
	}

	public static List<String> getSortableFields() {
		return List.of();
	}
}
