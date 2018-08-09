package com.jingyan.agri.common.persistence;

import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.lang3.StringUtils;

import com.jingyan.agri.common.utils.JsonUtils;
import com.jingyan.agri.entity.sys.Group;
import com.jingyan.agri.entity.sys.Meta;
import com.jingyan.agri.entity.sys.Meta.Column;

import lombok.Getter;
import lombok.Setter;

public class Search {
	
	public static enum Op {
		EQ {
			@Override
			public String sql(Column col, String val) throws Exception {
				if (StringUtils.isEmpty(val))
					return "`" + col.getName() + "` IS NULL OR `" + col.getName() + "` = ''";
				else if (col.ext().isNumber())
					return "`" + col.getName() + "` = " + NumberUtils.createNumber(val);
				else if (col.ext().isDate())
					return "CAST(`" + col.getName() + "` as DATE) = CAST('" + val + "' as DATE)";
				//else throw new Exception("Not supported");
				//if (col.isText())
				return "`" + col.getName() + "` = '" + val.replace("'", "''") + "'";
			}
		},
		LE {
			@Override
			public String sql(Column col, String val) throws Exception {
				if (StringUtils.isEmpty(val)) return "";
				if (col.ext().isNumber())
					return "`" + col.getName() + "` <= " + NumberUtils.createNumber(val);
				else if (col.ext().isDate())
					return "CAST(`" + col.getName() + "` as DATE) <= CAST('" + val + "' as DATE)";
				else throw new Exception("Not supported");
			}
		},
		GE {
			@Override
			public String sql(Column col, String val) throws Exception {
				if (StringUtils.isEmpty(val)) return "";
				if (col.ext().isNumber())
					return "`" + col.getName() + "` >= " + NumberUtils.createNumber(val);
				else if (col.ext().isDate())
					return "CAST(`" + col.getName() + "` as DATE) >= CAST('" + val + "' as DATE)";
				else throw new Exception("Not supported");
			}
		},
		STR_BEGIN {
			@Override
			public String sql(Column col, String val) throws Exception {
				if (StringUtils.isEmpty(val)) return "";
				//if (col.isText()) {
					String pat = val.replace("\\", "\\\\").replace("'", "''")
						.replace("_", "\\_").replace("%", "\\%") + '%';
					return "`" + col.getName() + "` LIKE '" + pat + "'";
//				}
//				else throw new Exception("Not supported");
			}
		},
		STR_END {
			@Override
			public String sql(Column col, String val) throws Exception {
				if (StringUtils.isEmpty(val)) return "";
//				if (col.isText()) {
					String pat = '%' + val.replace("\\", "\\\\").replace("'", "''")
						.replace("_", "\\_").replace("%", "\\%");
					return "`" + col.getName() + "` LIKE '" + pat + "'";
//				}
//				else throw new Exception("Not supported");
			}
		},
		STR_MATCH {
			@Override
			public String sql(Column col, String val) throws Exception {
				if (StringUtils.isEmpty(val)) return "";
//				if (col.isText()) {
					String pat = val.replace("\\", "\\\\").replace("'", "''")
						.replace("_", "\\_").replace("%", "\\%")
						.replace("?", "_").replace("*", "%");
					if (pat.replace("\\_", "").contains("_") ||
							pat.replace("\\%", "").contains("%"))
						return "`" + col.getName() + "` LIKE '" + pat + "'";
					else return "`" + col.getName() + "` LIKE '%" + pat + "%'";
//				}
//				else throw new Exception("Not supported");
			}
		},
		STR_REGEX {
			@Override
			public String sql(Column col, String val) throws Exception {
				if (StringUtils.isEmpty(val)) return "";
				//if (col.isText()) {
					String pat = val.replace("\\", "\\\\").replace("'", "''");
					return "`" + col.getName() + "` REGEXP '" + pat + "'";
//				}
//				else throw new Exception("Not supported");
			}
		},
		IS {
			@Override
			public String sql(Column col, String val) throws Exception {
				return EQ.sql(col, val);
			}
		},
		IN {
			@Override
			public String sql(Column col, String val) throws Exception {
				String[] values = val.split(",");
				List<String> list = new ArrayList<>();
				
				for (String item : values) {
					list.add("'" + item.replace("'", "''") + "'");
				}
				String items = String.join(",", list);
				if (StringUtils.isEmpty(items)) return "";
				return "`" + col.getName() + "` IN (" + items + ")";
			}
		};

		public Item of(String key) {
			return of(key, "");
		}
		public Item of(String key, String val) {
			Item item = new Item();
			item.setOp(this);
			item.setKey(key);
			item.setVal(val);
			return item;
		}
		
		public String sql(Item item, Column col) throws Exception {
			return sql(col, item.getVal());
		}
		public String sql(Column col, String val) throws Exception {
			return "`" + col.getName() + "` = '" + val.replace("'", "''") + "'";
		}
	}

	public static class Item {
		@Getter @Setter
		private String key = "";
		@Getter @Setter
		private Op op = Op.EQ;
		@Getter @Setter
		private String val = "";
	}
	
	public static class Query extends ArrayList<Item> {
		private static final long serialVersionUID = 1L;
	}
	
	public static class Or extends ArrayList<String> {
		private static final long serialVersionUID = 1L;
	}
	public static class And extends ArrayList<Or> {
		public Or add(String condition) {
			Or or = new Or();
			or.add(condition);
			return this.add(or) ? or : null;
		}
		private static final long serialVersionUID = 1L;
	}

	@Getter @Setter
	private String queryB64 = "W10="; // "[]"
	
	@Getter @Setter
	private And conditions = new And();
	
	@Getter @Setter
	private Query query = new Query();
	
	public void normalize(Meta meta, List<Group> groups) throws Exception {
		String queryText = new String(Base64.getDecoder().decode(getQueryB64()), "UTF-8");
		if (StringUtils.isEmpty(queryText)) return;
		
		Meta.Schema schema = meta.getSchema();
		Meta.SearchConfig searchConfig = meta.getSearchConfig();

		conditions.clear();
		this.query.clear();
		Query query = JsonUtils.deserialize(queryText, Query.class);
		for (Item item : query) {
			if (StringUtils.isEmpty(item.getKey())) continue;
			if (!searchConfig.isSearchable(item.getKey())) continue;

			Column column = schema.columnOf(item.getKey());
			if (column == null) continue;

			this.query.add(item);
			try {
				String sql = item.op.sql(item, column);
				if (StringUtils.isNotEmpty(sql))
					conditions.add(sql);
			} catch (Exception e) { }
		}

		Meta.Column filterColumn = schema.columnOf(meta.getFilterColumn());
		if (filterColumn == null) return;
		Or groupFilter = new Or();
		for (Group group : groups) {
			if (group.getCondition().getItems().isEmpty()) {
				groupFilter.clear(); break;
			}
			//TODO: only 1 filters is now supported.
			Group.ConditionItem cond = group.getCondition().getItems().get(0);
			String sql = Op.STR_MATCH.sql(filterColumn, cond.getPattern());
			groupFilter.add(sql);
		}
		if (!groupFilter.isEmpty())
			conditions.add(groupFilter);
	}
	
	public static void main(String[] args) {
		And and = new And();
		and.add("asdf");
		and.add("1234");
		and.get(0).add("xxyy");
		String text = JsonUtils.serialize(and);
		And back = JsonUtils.deserialize(text, And.class);
		System.out.println(text);
		System.out.println(back);
		System.out.println(Base64.getEncoder().encodeToString("[]".getBytes()));
		System.out.println(new String(Base64.getDecoder().decode("W10=")));
		//System.out.println(back.get(0).getClass());
		System.out.println(new String(Base64.getDecoder().decode("5oiRYeWTiOWTiDEyMw==")));
	}
}
