package com.jingyan.agri.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import javax.annotation.PostConstruct;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Maps;
import com.jingyan.agri.common.service.BaseService;
import com.jingyan.agri.common.utils.JsonUtils;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.dao.sys.ManagerDao;
import com.jingyan.agri.dao.sys.MetaDao;
import com.jingyan.agri.entity.sys.Group;
import com.jingyan.agri.entity.sys.Meta;
import com.jingyan.agri.entity.sys.Project;
import com.jingyan.agri.entity.sys.ProjectTemplate;

import lombok.Getter;
import lombok.SneakyThrows;

import com.jingyan.agri.entity.sys.Meta.OptionList;

@Service
public class MetaService extends BaseService {

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

	public Meta.SearchConfig completeSearchConfig(Meta meta) {
		Meta.SearchConfig searchConfig = meta.getSearchConfig();
		Meta.Schema schema = meta.getSchema();

		searchConfig = searchConfig.fromJson(searchConfig.toJson());

		if (searchConfig.getMode() == Meta.SearchConfig.Mode.DEFAULT) {
			for (Meta.Column column : schema.getColumns()) {
				if (!searchConfig.isSearchable(column.getName())) {
					Meta.SearchConfig.Item item = new Meta.SearchConfig.Item();
					item.setKey(column.getName());
					searchConfig.getItems().add(item);
				}
			}
		}

		for (Meta.SearchConfig.Item item : searchConfig.getItems()) {
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
			default:
				break;
			}
		}
		
		return searchConfig;
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

	public Project checkProject(int projId, int actionId,
			String version, int... actionIds) throws Exception
	{
		Project proj = sysDao.getProject(projId);
		if (proj == null)
			throw new Exception("Project not found.");
		ProjectTemplate temp = sysDao.getTemplate(proj.getTempId());
		if (!temp.getVersion().equals(version))
			throw new Exception("Project doesn't match template version.");
		if (IntStream.of(actionIds).noneMatch(id -> id == actionId))
			throw new Exception("Not supported action.");
		
		return proj;
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

	
}
