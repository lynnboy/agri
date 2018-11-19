package com.jingyan.agri.entity.sys;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;

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
		private boolean isai = false;
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
		
		public Column clone() {
			Column col = new Column();
			col.name = name;
			col.type = type;
			col.isnull = isnull;
			col.as = as;
			col.isai = isai;
			return col;
		}

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
		@JsonIgnore
		private Map<String, Column> map;
		public Map<String, Column> map() {
			if (map == null) {
				map = columns.stream().collect(
						Collectors.toMap(e -> e.getName(), e -> e));
			}
			return map;
		}

		public Column columnOf(String key) {
			return map().getOrDefault(key, null);
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
			if (mode == Mode.EXCLUSIVE && !list.isEmpty())
				return schema.columns.stream().map(c -> c.getName())
						.filter(key -> !list.contains(key))
						.collect(Collectors.toList());
			else
				return schema.getColumns().stream()
						.map(c -> c.getName()).collect(Collectors.toList());
		}
	}

	public static class SearchConfig extends BaseEntity<SearchConfig> {
		private static final long serialVersionUID = 1L;

		public static enum Mode { DEFAULT, INCLUSIVE }
		public static enum OptListMode { NONE, NAMED, SPECIFIED, COLLECT, TAGS }
		
		public static class Item {
			@Getter @Setter
			private String key;
			@Getter @Setter
			private boolean searchable = true;
			@Getter @Setter
			private OptListMode optListMode = OptListMode.NONE;
			@Getter @Setter
			private String optListName = "";
			@Getter @Setter
			private OptionList optList = new OptionList();
			public Item clone() {
				Item item = new Item();
				item.key = key;
				item.optListMode = optListMode;
				item.optListName = optListName;
				item.optList = optList;
				return item;
			}
		}
		
		@Getter @Setter
		private Mode mode = Mode.DEFAULT;
		@Getter @Setter
		private List<Item> items = Lists.newArrayList();
		@JsonIgnore
		private Map<String, Item> map;
		public Map<String, Item> map() {
			if (map == null) {
				map = items.stream().collect(
						Collectors.toMap(e -> e.getKey(), e -> e));
			}
			return map;
		}
		
		public boolean isSearchable(String key) {
			return map().containsKey(key);
		}
	}
	
	public static class EditConfig extends BaseEntity<EditConfig> {
		private static final long serialVersionUID = 1L;
	}

	public static class ViewConfig extends BaseEntity<ViewConfig> {
		private static final long serialVersionUID = 1L;
		public static enum Mode { DEFAULT }
		public static enum OptListMode { NONE, NAMED, SPECIFIED }
		
		public static class Item {
			@Getter @Setter
			private String key;
			@Getter @Setter
			private String header = "";
			@Getter @Setter
			private OptListMode optListMode = OptListMode.NONE;
			@Getter @Setter
			private String optListName = "";
			@Getter @Setter
			private OptionList optList = new OptionList();
			public Item clone() {
				Item item = new Item();
				item.key = key;
				item.header = header;
				item.optListMode = optListMode;
				item.optListName = optListName;
				item.optList = optList;
				return item;
			}
		}
		@Getter @Setter
		private Mode mode = Mode.DEFAULT;
		@Getter @Setter
		private List<Item> items = Lists.newArrayList();
		@JsonIgnore
		private Map<String, Item> map;
		public Map<String, Item> map() {
			if (map == null) {
				map = items.stream().collect(Collectors.toMap(e -> e.getKey(), e -> e));
			}
			return map;
		}

		public String headerOf(String key) {
			if (map().containsKey(key)) {
				String header = map().get(key).getHeader();
				if (StringUtils.isNotEmpty(header))
					return header;
			}
			return key;
		}
		public String textOf(String key, Object value) {
			String valueStr = value.toString();
			if (map().containsKey(key) && map().get(key).getOptListMode() != OptListMode.NONE) {
				OptionList optList = map().get(key).getOptList();
				return optList.getOrDefault(valueStr, valueStr);
			}
			return valueStr;
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
