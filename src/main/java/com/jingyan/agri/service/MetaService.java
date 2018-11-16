package com.jingyan.agri.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.EnumSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import javax.annotation.PostConstruct;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.Search;
import com.jingyan.agri.common.persistence.Search.Op;
import com.jingyan.agri.common.service.BaseService;
import com.jingyan.agri.common.utils.JsonUtils;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.dao.sys.ManagerDao;
import com.jingyan.agri.dao.sys.MetaDao;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Group;
import com.jingyan.agri.entity.sys.Meta;
import com.jingyan.agri.entity.sys.Project;
import com.jingyan.agri.entity.sys.ProjectTemplate;
import com.jingyan.agri.entity.sys.ProjectTemplate.Info;
import com.jingyan.agri.entity.sys.ProjectTemplate.State;
import com.jingyan.agri.entity.sys.ProjectTemplate.Task;
import com.jingyan.agri.entity.sys.ProjectTemplate.WorkflowItem;

import lombok.Getter;
import lombok.SneakyThrows;
import lombok.val;

import com.jingyan.agri.entity.sys.Meta.OptionList;
import com.jingyan.agri.entity.sys.Meta.Schema;
import com.jingyan.agri.entity.sys.Meta.SearchConfig;
import com.jingyan.agri.entity.sys.Meta.SortConfig;
import com.jingyan.agri.entity.sys.Meta.ViewConfig;

@Service
public class MetaService extends BaseService {

	public static final String COL_STATUS_DATAKEY = "datakey";
	public static final String COL_STATUS_STATE = "stateId";
	public static final String COL_STATUS_TAGS = "tags";
	public static final String COL_STATUS_MUID = "modifyUserId";
	public static final String COL_STATUS_CUID = "createUserId";
	public static final String COL_STATUS_MUNAME = "modifyUserName";
	public static final String COL_STATUS_CUNAME = "createUserName";
	public static final String COL_STATUS_MTIME = "modifyTime";
	public static final String COL_STATUS_CTIME = "createTime";
	public static final String COL_STATUS_REMARKS = "remarks";

	public static final String COL_TASK_DATAKEY = "datakey";
	public static final String COL_TASK_USERID = "userId";
	public static final String COL_TASK_USERNAME = "userName";
	public static final String COL_TASK_ORGNAME = "organName";
	public static final String COL_TASK_TASK = "taskId";
	public static final String COL_TASK_TIME = "time";
	public static final String COL_TASK_STATUS = "status";

	@Autowired
	ManagerDao sysDao;
	@Autowired
	MetaDao metaDao;
	@Autowired
	DealerDao userDao;
	
	@Getter
	boolean escapeInSQLLiteral;
	
	public static class OptListMap extends LinkedHashMap<String, Meta.OptionList> {
		private static final long serialVersionUID = 1L;
	}
	
	OptListMap optlistMap = new OptListMap();
	Map<String, String> divcode1 = Maps.newLinkedHashMap();
	Map<String, String> divcode2 = Maps.newLinkedHashMap();
	Map<String, String> divcode3 = Maps.newLinkedHashMap();
	Map<String, String> divcodeNames = Maps.newLinkedHashMap();
	OptionList divcodeList = new OptionList();

	@PostConstruct
	@SneakyThrows
	public void init() {
		try (InputStream stream = getClass().getResourceAsStream("/optionLists/default.json")) {
			optlistMap = JsonUtils.deserialize(stream, OptListMap.class);
		}

		loadDivCodeMap();

		escapeInSQLLiteral = metaDao.detectSQLLiteralIsEscaped();
	}

	private void loadDivCodeMap() throws IOException {
		//File file = ResourceUtils.getFile("classpath:divcode.csv");
		File file = new File("C:\\agridata\\divcode.csv");
		//InputStream stream = getClass().getResourceAsStream("/divcode.csv");
		//File file = new File(getClass().getResource("/divcode.csv").getFile());
		for (String line : FileUtils.readLines(file, "UTF-8")) {
			line = line.trim();
			if (StringUtils.isEmpty(line) || line.startsWith("#")) continue;
			String[] parts = line.split(",");
			
			if (parts.length < 3) continue;
			try {
				int level = Integer.parseInt(parts[0].trim());
				String code = parts[1].trim();
				String name = parts[2].trim();
				if (level == 1) divcode1.putIfAbsent(code.substring(0, 2), name);
				if (level == 2) divcode2.putIfAbsent(code.substring(0, 4), name);
				if (level == 3) divcode3.putIfAbsent(code.substring(0, 6), name);
			} catch (Exception ex) { }
		}

		for (String code : divcode3.keySet()) {
			String name1 = divcode1.getOrDefault(code.substring(0,2), "");
			String name2 = divcode2.getOrDefault(code.substring(0,4), "");
			String name3 = divcode3.get(code);
			String name = name1 + name2 + name3;
			divcodeNames.put(code, name);
			divcodeList.put(code, "[" + code + "] " + name);
		}
	}
	
	public OptionList getOptList(String name) {
		if (name.equals("divcode"))
			return divcodeList;
		if (optlistMap.containsKey(name))
			return optlistMap.get(name);
		InputStream stream = getClass().getResourceAsStream("/optionLists/" + name + ".json");
		if (stream != null)
			return JsonUtils.deserialize(stream, OptionList.class);
		return null;
	}

	public SearchConfig completeSearchConfig(Meta meta) {
		SearchConfig searchConfig = meta.getSearchConfig();
		Schema schema = meta.getSchema();

		searchConfig = searchConfig.fromJson(searchConfig.toJson());

		if (searchConfig.getMode() == SearchConfig.Mode.DEFAULT) {
			for (Meta.Column column : schema.getColumns()) {
				if (!meta.getSearchConfig().isSearchable(column.getName())) {
					SearchConfig.Item item = new SearchConfig.Item();
					item.setKey(column.getName());
					searchConfig.getItems().add(item);
				}
			}
		}

		for (SearchConfig.Item item : searchConfig.getItems()) {
			OptionList list = new OptionList();
			switch (item.getOptListMode()) {
			case NAMED:
				if (StringUtils.isNotBlank(item.getOptListName())) {
					list = getOptList(item.getOptListName());
				}
				item.setOptList(list);
				break;
			case COLLECT:
				List<String> values = metaDao.collectOptList(meta.getTableName(), item.getKey());
				for (String value : values) {
					if (StringUtils.isEmpty(value))
						list.put("", "(空白)");
					else
						list.put(value, value);
				}
				item.setOptList(list);
			case TAGS:
				List<String> listValues = metaDao.collectOptList(meta.getTableName(), item.getKey());
				Set<String> tags = Sets.newHashSet();
				for (String value : listValues) {
					for (String tag : StringUtils.split(value, ',')) {
						tag = StringUtils.trim(tag);
						if (StringUtils.isNotEmpty(tag))
							tags.add(tag);
					}
				}
				for (String tag : tags)
					list.put(tag, tag);
				item.setOptList(list);
			default:
				break;
			}
		}
		
		return searchConfig;
	}
	
	public ViewConfig completeViewConfig(Meta meta) {
		ViewConfig viewConfig = meta.getViewConfig();
		Schema schema = meta.getSchema();

		viewConfig = viewConfig.fromJson(viewConfig.toJson());

		if (viewConfig.getMode() == ViewConfig.Mode.DEFAULT) {
			for (Meta.Column column : schema.getColumns()) {
				if (!meta.getViewConfig().map().containsKey(column.getName())) {
					ViewConfig.Item item = new ViewConfig.Item();
					item.setKey(column.getName());
					viewConfig.getItems().add(item);
				}
			}
		}

		for (ViewConfig.Item item : viewConfig.getItems()) {
			OptionList list = new OptionList();
			switch (item.getOptListMode()) {
			case NAMED:
				if (StringUtils.isNotBlank(item.getOptListName())) {
					list = getOptList(item.getOptListName());
				}
				item.setOptList(list);
				break;
			default:
				break;
			}
		}

		return viewConfig;
	}

	public Meta normalize(Meta table) {
		table.setSearchConfig(this.completeSearchConfig(table));
		return table;
	}

	public Map<String, String> getDivCodeNames() { return divcodeNames; }

	public Map<String, String> getDivCodeNamesFor(List<Group> groups) {
		Map<String, String> map = Maps.newLinkedHashMap();

		for (Group group : groups) {
			if (group.getCondition().getItems().isEmpty()) {
				return divcodeNames;
			}
			Group.ConditionItem cond = group.getCondition().getItems().get(0);
			String pattern = cond.getPattern();

			Stream<String> codes = Stream.empty();
			if (StringUtils.containsAny(pattern, '*', '?')) {
				String regex = StringUtils.replaceEach(pattern,
						new String[] {"?", "*"}, new String[] {".", ".*"});
				codes = divcodeNames.keySet().stream().filter(
						code -> code.matches(regex));
			} else {
				codes = divcodeNames.keySet().stream().filter(
						code -> code.contains(pattern));
			}

			codes.forEach(code -> map.putIfAbsent(code, divcodeNames.get(code)));
		}
		return map;
	}

	public Pair<Project, ProjectTemplate> checkProject(int projId, int taskId,
			String version, Task.Type... supportedTypes) throws Exception
	{
		Project proj = sysDao.getProject(projId);
		if (proj == null)
			throw new Exception("Project not found.");
		ProjectTemplate temp = sysDao.getTemplate(proj.getTempId());
		if (!temp.getVersion().equals(version))
			throw new Exception("Project doesn't match template version.");
		val info = temp.getProjectInfo();
		if (!info.getTaskMap().containsKey(taskId))
			throw new Exception("Not supported task.");
		Task task = info.getTaskMap().get(taskId);
		EnumSet<Task.Type> supported = EnumSet.of(Task.Type.DEFAULT, supportedTypes);
		if (!supported.contains(task.getType()))
			throw new Exception("Not supported task.");
		
		return Pair.of(proj, temp);
	}

	@SneakyThrows
	public List<Group> checkUser(Dealer user, Project proj, int taskId) {
		List<Group> groups = userDao.getProjectGroupsOfDealer(user.getId(), proj.getId(), taskId);
		if (groups.isEmpty())
			throw new Exception("No permission for this project and task.");
		return groups;
	}

	public Meta getProjectTableMetaByKey(Project project, String key)
			throws Exception
	{
		Meta meta = metaDao.getProjectKeyedTable(project.getId(), key);
		if (meta == null)
			throw new Exception("No such table registered.");
		return meta;
	}
	
	public void cloneTemplateProtoTablesForProject(
			ProjectTemplate temp, Project proj, String prefix)
			throws Exception
	{
		List<Meta> protoTables = metaDao.getTemplateTables(temp.getId());
		for (Meta proto : protoTables) {
			Meta table = new Meta();
			table.setKey(proto.getKey());
			table.setTempId(temp.getId());
			table.setProjId(proj.getId());
			table.setSchemaText(proto.getSchemaText());
			table.setFilterColumn(proto.getFilterColumn());
			table.setSearchConfigText(proto.getSearchConfigText());
			table.setSortConfigText(proto.getSortConfigText());
			table.setViewConfigText(proto.getViewConfigText());
			table.setEditConfigText(proto.getEditConfigText());
			String tableName = prefix + "_p" + proj.getId() + "_" + proto.getKey(); 
			table.setTableName(tableName);
			
			metaDao.addMeta(table);
			metaDao.createTable(table);
		}
	}
	
	public void addData(Map<String, ? extends Object> params, Meta table) {
		Map<String, Object> data = Maps.newLinkedHashMap();
		Schema schema = table.getSchema();
		for (val col : schema.getColumns()) {
			String key = col.getName();
			if (StringUtils.isEmpty(col.getAs()) && params.containsKey(key))
				data.put(key, params.get(key));
		}
		metaDao.add(data, table.getTableName());
	}
	
	@SneakyThrows
	public void updateData(Map<String, ? extends Object> params, Meta table) {
		Map<String, Object> data = Maps.newLinkedHashMap();
		Schema schema = table.getSchema();
		String keycol = table.getFilterColumn();
		String id = params.get(keycol).toString();
		
		val list = metaDao.get(keycol, id, table.getTableName());
		if (list.isEmpty()) {
			throw new Exception("不存在此数据");
		}
		
		for (val col : schema.getColumns()) {
			String key = col.getName();
			if (key.equals(keycol)) continue;

			if (StringUtils.isEmpty(col.getAs()) && params.containsKey(key))
				data.put(key, params.get(key));
		}
		metaDao.update(keycol, id, data, table.getTableName());
	}
	
	@SneakyThrows
	public void updateData2(Map<String, ? extends Object> params, Meta table,
			String key, String id, String subkey, String subid) {
		Map<String, Object> data = Maps.newLinkedHashMap();

		val list = metaDao.get2(key, id, subkey, subid, table.getTableName());
		if (list.isEmpty()) {
			throw new Exception("不存在此数据");
		}
		
		for (val col : table.getSchema().getColumns()) {
			String colname = col.getName();
			if (colname.equals(key) || colname.equals(subkey)) continue;

			if (StringUtils.isEmpty(col.getAs()) && params.containsKey(colname))
				data.put(colname, params.get(colname));
		}
		metaDao.update2(key, id, subkey, subid, data, table.getTableName());
	}
	
	public void addStatus(String key, Map<String, ? extends Object> params, 
			Project proj, ProjectTemplate temp, Task task, Dealer user,
			Meta statusTable, Meta taskTable) {
		val info = temp.getProjectInfo();
		val wfitem = info.getWorkflowMap().get(task.getId());
		val state = info.getStateMap().get(wfitem.getSrcState());
		
		val now = new Date();

		Map<String, Object> status = Maps.newLinkedHashMap();
		status.put(COL_STATUS_DATAKEY, key);
		status.put(COL_STATUS_CUID, user.getId());
		status.put(COL_STATUS_CTIME, now);
		status.put(COL_STATUS_STATE, state.getId());

		String tags = "";
		if (params.containsKey(COL_STATUS_TAGS))
			tags = params.get(COL_STATUS_TAGS).toString();
		status.put(COL_STATUS_TAGS, tags);
		String remarks = "";
		if (params.containsKey(COL_STATUS_REMARKS))
			remarks = params.get(COL_STATUS_REMARKS).toString();
		status.put(COL_STATUS_REMARKS, remarks);
		addData(status, statusTable);

		Map<String, Object> taskdata = Maps.newLinkedHashMap();
		taskdata.put(COL_TASK_DATAKEY, key);
		taskdata.put(COL_TASK_TASK, task.getId());
		taskdata.put(COL_TASK_USERID, user.getId());
		taskdata.put(COL_TASK_TIME, now);
		taskdata.put(COL_TASK_STATUS, Task.Status.正常.ordinal());
		addData(taskdata, taskTable);
	}
	
	public void updateStatus(String id, Meta statusTable, Dealer user) {
		Map<String, Object> status = Maps.newLinkedHashMap();
		status.put(MetaService.COL_STATUS_MUID, user.getId());
		status.put(MetaService.COL_STATUS_MTIME, new Date());
		metaDao.update(MetaService.COL_STATUS_DATAKEY, id, status, statusTable.getTableName());
	}
	
	@SneakyThrows
	public SearchHandler prepareSearch(
			Project proj, ProjectTemplate temp, List<Group> groups,
			String dataKey, String statusKey, String taskKey) {
		return new SearchHandler(proj, temp, groups, dataKey, statusKey, taskKey);
	}
	@SneakyThrows
	public SubSearchHandler prepareSubSearch(
			Project proj, ProjectTemplate temp, List<Group> groups,
			String dataKey, String subKey,
			String key, String dataId) {
		return new SubSearchHandler(proj, temp, groups, dataKey, subKey, key, dataId);
	}

	public class SearchHandler {
		@Getter
		Project proj;
		@Getter
		ProjectTemplate temp;
		@Getter
		List<Group> groups;
		@Getter
		Meta dataTable;
		@Getter
		Meta statusTable;
		@Getter
		Meta taskTable;
		@Getter
		List<Integer> taskIds;

		@Getter
		Meta searchView;
		@Getter
		Schema schema;
		@Getter
		ViewConfig viewConfig;
		@Getter
		SearchConfig searchConfig;
		@Getter
		SortConfig sortConfig;

		@SneakyThrows
		public SearchHandler(Project proj, ProjectTemplate temp,
				List<Group> groups,
				String dataKey, String statusKey, String taskKey) {
			this.proj = proj;
			this.temp = temp;
			this.groups = groups;
			dataTable = getProjectTableMetaByKey(proj, dataKey);
			statusTable = getProjectTableMetaByKey(proj, statusKey);
			taskTable = getProjectTableMetaByKey(proj, taskKey);
			
			synthesisSearchView();
		}

		void synthesisSearchView() {
			Info info = temp.getProjectInfo();

			taskIds = info.getTasks().stream().map(t -> t.getId())
					.collect(Collectors.toList());

			Schema dataSchema = dataTable.getSchema();
			Schema statusSchema = statusTable.getSchema();
			Schema taskSchema = taskTable.getSchema();

			SearchConfig dataSearchConfig = completeSearchConfig(dataTable);
			SearchConfig statusSearchConfig = completeSearchConfig(statusTable);
			SearchConfig taskSearchConfig = completeSearchConfig(taskTable);

			ViewConfig dataViewConfig = completeViewConfig(dataTable);
			ViewConfig statusViewConfig = completeViewConfig(statusTable);
			ViewConfig taskViewConfig = completeViewConfig(taskTable);

			for (State item : info.getStates()) {
				statusSearchConfig.map().get(COL_STATUS_STATE).getOptList()
					.putIfAbsent(item.getId().toString(), item.getName());
				statusViewConfig.map().get(COL_STATUS_STATE).getOptList()
					.putIfAbsent(item.getId().toString(), item.getName());
			}
			for (Task.Status status : Task.Status.values()) {
				taskSearchConfig.map().get(COL_TASK_STATUS).getOptList()
					.putIfAbsent(Integer.toString(status.ordinal()), status.name());
				taskViewConfig.map().get(COL_TASK_STATUS).getOptList()
					.putIfAbsent(Integer.toString(status.ordinal()), status.name());
			}
			for (Task task : info.getTasks()) {
				taskSearchConfig.map().get(COL_TASK_TASK).getOptList()
					.putIfAbsent(task.getId().toString(), task.getName());
				taskViewConfig.map().get(COL_TASK_TASK).getOptList()
					.putIfAbsent(task.getId().toString(), task.getName());
			}

			schema = new Schema();
			schema.getColumns().addAll(dataSchema.getColumns());
			for (Meta.Column col : statusSchema.getColumns()) {
				if (col.getName().equals(COL_STATUS_MUID) ||
					col.getName().equals(COL_STATUS_CUID))
					continue;
				schema.getColumns().add(col);
			}
			Meta.Column munameCol = new Meta.Column();
			munameCol.setName(COL_STATUS_MUNAME);
			munameCol.setType("TEXT");
			schema.getColumns().add(munameCol);
			Meta.Column cunameCol = new Meta.Column();
			cunameCol.setName(COL_STATUS_CUNAME);
			cunameCol.setType("TEXT");
			schema.getColumns().add(cunameCol);

			searchConfig = new SearchConfig();
			searchConfig.getItems().addAll(dataSearchConfig.getItems());
			searchConfig.getItems().addAll(statusSearchConfig.getItems());

			viewConfig = new ViewConfig();
			viewConfig.getItems().addAll(dataViewConfig.getItems());
			viewConfig.getItems().addAll(statusViewConfig.getItems());
			
			for (Task task : info.getTasks()) {
				int id = task.getId();
				String name = task.getName();
				List<Meta.Column> columns = new ArrayList<>(taskSchema.getColumns());
				Meta.Column userCol = new Meta.Column();
				userCol.setName(COL_TASK_USERNAME);
				columns.add(userCol);
				Meta.Column orgCol = new Meta.Column();
				orgCol.setName(COL_TASK_ORGNAME);
				columns.add(orgCol);
				for (Meta.Column col : columns) {
					if (col.getName().equals(COL_TASK_DATAKEY) ||
						col.getName().equals(COL_TASK_USERID))
						continue;
					String colName = col.getName() + "_" + id;
					String header = name + taskViewConfig.headerOf(col.getName());

					Meta.Column newCol = col.clone();
					newCol.setName(colName);
					schema.getColumns().add(newCol);

					ViewConfig.Item vitem = taskViewConfig.map()
							.get(col.getName()).clone();
					vitem.setKey(colName);
					vitem.setHeader(header);
					viewConfig.getItems().add(vitem);
					
					SearchConfig.Item sitem = taskSearchConfig.map()
							.get(col.getName());
					if (sitem == null) {
						sitem = new SearchConfig.Item();
					} else {
						sitem = sitem.clone();
					}
					sitem.setKey(colName);
					searchConfig.getItems().add(sitem);
				}
			}

			sortConfig = dataTable.getSortConfig();

			searchView = new Meta();
			searchView.setSchema(schema);
			searchView.setSearchConfig(searchConfig);
			searchView.setFilterColumn(dataTable.getFilterColumn());
			searchView.setViewConfig(viewConfig);
			searchView.setSortConfig(sortConfig);
		}
		
		public List<String> getStatusColumns(int taskId) {
			//Task task = temp.getProjectInfo().getTaskMap().get(taskId);
			//Optional<WorkflowItem> item = temp.getProjectInfo()
			//		.getWorkflow().stream()
			//	.filter(i -> i.getAction() == taskId).findFirst();
			
			return List.of(
					//COL_STATUS_STATE,
					//COL_STATUS_TAGS,
					COL_STATUS_MUNAME,
					COL_STATUS_MTIME,
					COL_TASK_USERNAME + "_" + taskId,
					COL_TASK_ORGNAME + "_" + taskId,
					COL_TASK_TIME + "_" + taskId
					);
		}

		@SneakyThrows
		void normalize(Search search, ResultView view) {
			search.normalize(searchView, groups, isEscapeInSQLLiteral());
			final int totalCount = metaDao.queryCount(null, dataTable.getTableName());
			final int queryCount = metaDao.queryWithStatusCount(search, taskIds,
					dataTable.getFilterColumn(),
					dataTable.getTableName(), statusTable.getTableName(), taskTable.getTableName());
			view.setTotalCount(totalCount);
			view.setQueryCount(queryCount);
			view.normalize(sortConfig.getSortableColumnsFor(schema));
		}

		@SneakyThrows
		public List<Map<String, Object>> search(Search search, ResultView view) {
			normalize(search, view);
			return metaDao.queryWithStatus(search, taskIds, view,
					dataTable.getFilterColumn(),
					dataTable.getTableName(), statusTable.getTableName(), taskTable.getTableName());
		}
	}

	public class SubSearchHandler {
		@Getter
		Project proj;
		@Getter
		ProjectTemplate temp;
		@Getter
		List<Group> groups;
		@Getter
		Meta dataTable;
		@Getter
		Meta subTable;
		@Getter
		String key;
		@Getter
		String dataId;

		@Getter
		Schema schema;
		@Getter
		ViewConfig viewConfig;
		@Getter
		SearchConfig searchConfig;
		@Getter
		SortConfig sortConfig;

		@SneakyThrows
		public SubSearchHandler(Project proj, ProjectTemplate temp,
				List<Group> groups,
				String dataKey, String subKey,
				String key, String dataId) {
			this.proj = proj;
			this.temp = temp;
			this.groups = groups;
			dataTable = getProjectTableMetaByKey(proj, dataKey);
			subTable = getProjectTableMetaByKey(proj, subKey);
			this.key = key;
			this.dataId = dataId;
			
			synthesisSearchView();
		}

		void synthesisSearchView() {
			Schema subSchema = subTable.getSchema();
			SearchConfig subSearchConfig = completeSearchConfig(subTable);
			ViewConfig subViewConfig = completeViewConfig(subTable);

			schema = new Schema();
			schema.getColumns().addAll(subSchema.getColumns());

			searchConfig = new SearchConfig();
			searchConfig.getItems().addAll(subSearchConfig.getItems());

			viewConfig = new ViewConfig();
			viewConfig.getItems().addAll(subViewConfig.getItems());
			
			sortConfig = subTable.getSortConfig();
		}
		
		@SneakyThrows
		void normalize(Search search, ResultView view) {
			boolean escapeInLiteral = isEscapeInSQLLiteral();
			search.normalize(subTable, groups, isEscapeInSQLLiteral());

			val column = schema.columnOf(key);
			String sql = Op.EQ.sql(column, dataId, escapeInLiteral);
			search.getConditions().add(sql);

			final int totalCount = metaDao.queryCount(null, subTable.getTableName());
			final int queryCount = metaDao.queryCount(search, subTable.getTableName());
			view.setTotalCount(totalCount);
			view.setQueryCount(queryCount);
			view.normalize(sortConfig.getSortableColumnsFor(schema));
		}

		@SneakyThrows
		public List<Map<String, Object>> search(Search search, ResultView view) {
			normalize(search, view);
			return metaDao.query(search, view, subTable.getTableName());
		}
	}
}
