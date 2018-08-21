package com.jingyan.agri.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.EnumSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
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

import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.Search;
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

	static final String COL_STATUS_STATE = "stateId";
	static final String COL_STATUS_MUID = "modifyUserId";
	static final String COL_STATUS_CUID = "createUserId";
	static final String COL_STATUS_MUNAME = "modifyUserName";
	static final String COL_STATUS_CUNAME = "createUserName";
	static final String COL_TASK_DATAKEY = "datakey";
	static final String COL_TASK_USERID = "userId";
	static final String COL_TASK_USERNAME = "userName";
	static final String COL_TASK_ORGNAME = "organName";
	static final String COL_TASK_TASK = "taskId";
	static final String COL_TASK_STATUS = "status";

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
		File file = new File(getClass().getResource("/divcode.csv").getFile());
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
				if (level == 2) divcode1.putIfAbsent(code.substring(0, 4), name);
				if (level == 3) divcode1.putIfAbsent(code.substring(0, 6), name);
			} catch (Exception ex) { }
		}

		for (String code : divcode3.keySet()) {
			String name1 = divcode1.getOrDefault(code.substring(0,2), "???");
			String name2 = divcode2.getOrDefault(code.substring(0,4), "???");
			String name3 = divcode3.get(code);
			String name = name1 + name2 + name3;
			divcodeNames.put(code, name);
		}
	}
	
	public OptionList getOptList(String name) {
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
	
	@SneakyThrows
	public SearchHandler prepareSearch(
			Project proj, ProjectTemplate temp, List<Group> groups,
			String dataKey, String statusKey, String taskKey) {
		return new SearchHandler(proj, temp, groups, dataKey, statusKey, taskKey);
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
				for (Meta.Column col : taskSchema.getColumns()) {
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
							.get(col.getName()).clone();
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

		@SneakyThrows
		void normalize(Search search, ResultView view) {
			search.normalize(searchView, groups, isEscapeInSQLLiteral());
			final int totalCount = metaDao.queryCount(null, dataTable.getTableName());
			final int queryCount = metaDao.queryWithStatusCount(search, taskIds,
					dataTable.getTableName(), statusTable.getTableName(), taskTable.getTableName());
			view.setTotalCount(totalCount);
			view.setQueryCount(queryCount);
			view.normalize(sortConfig.getSortableColumnsFor(schema));
		}

		@SneakyThrows
		public List<Map<String, Object>> search(Search search, ResultView view) {
			normalize(search, view);
			return metaDao.queryWithStatus(search, taskIds, view,
					dataTable.getTableName(), statusTable.getTableName(), taskTable.getTableName());
		}
	}
}
