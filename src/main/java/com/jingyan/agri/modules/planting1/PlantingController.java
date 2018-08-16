package com.jingyan.agri.modules.planting1;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.tuple.Pair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.Search;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.utils.JsonUtils;
import com.jingyan.agri.common.web.BaseController;
import com.jingyan.agri.common.web.ProjectTemplateController;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.dao.sys.ManagerDao;
import com.jingyan.agri.dao.sys.MetaDao;
import com.jingyan.agri.dao.sys.SettingsDao;
import com.jingyan.agri.dao.viewdb1.ViewDBDao;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Group;
import com.jingyan.agri.entity.sys.Meta;
import com.jingyan.agri.entity.sys.Project;
import com.jingyan.agri.entity.sys.ProjectTemplate;
import com.jingyan.agri.entity.sys.SettingValue;
import com.jingyan.agri.entity.viewdb1.Diagram;
import com.jingyan.agri.entity.viewdb1.Entry;
import com.jingyan.agri.service.MetaService;

@Controller(PlantingController.VERSION_NAME)
@RequestMapping(value=PlantingController.VIEW_ROOT, produces = MediaType.TEXT_HTML_VALUE)
public class PlantingController extends BaseController implements ProjectTemplateController {
	
	static final String VIEW_ROOT = "/planting-v1";
	static final String PATH_ROOT = "/planting-v1";
	static final String VERSION_NAME = "planting-1.0.0";
	static final String PREFIX = "planting1";
	static final int ACTION_ID_VIEW = 1;
	
	static final String META_KEY_DATA = "清查";
	static final String META_KEY_SUB1 = "作物覆膜情况";
	static final String META_KEY_SUB2 = "模式面积";
	static final String META_KEY_STATUS = "status";
	static final String META_KEY_LOG = "log";

	@Autowired
	ManagerDao sysDao;
	@Autowired
	DealerDao userDao;
	@Autowired
	MetaDao metaDao;
	@Autowired
	MetaService metaService;
	@Autowired
	SettingsDao settingsDao;

	@RequestMapping(value = "/{projId}/{actionId}", method = RequestMethod.GET)
	@Token(init = true)
	public String dispatch(@PathVariable("projId") int projId,
			@PathVariable("actionId") int actionId,
			ModelMap model) throws Exception
	{
		Pair<Project, ProjectTemplate> projPair =
				metaService.checkProject(projId, actionId,
						VERSION_NAME, ACTION_ID_VIEW);
		Project proj = projPair.getLeft();

		return "forward:" + PATH_ROOT + "/" + projId + "/" + actionId + "/list";
	}

	@RequestMapping(value = "/{projId}/{actionId}/list", method = RequestMethod.GET)
	@Token(init = true)
	public String entry(@PathVariable("projId") int projId,
			@PathVariable("actionId") int actionId,
			@PathVariable("key") String keyOrId,
			Search search, ResultView view,
			ModelMap model, HttpSession session) throws Exception
	{
		Pair<Project, ProjectTemplate> projPair =
				metaService.checkProject(projId, actionId,
						VERSION_NAME, ACTION_ID_VIEW);
		Project proj = projPair.getLeft();
		Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		model.addAttribute("proj", proj);

		Meta entrytbl = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
//		Entry entry = viewDBDao.getEntry(keyOrId, entrytbl.getTableName());
//		if (entry == null)
//			throw new Exception("No such entry.");
//		String key = entry.getKey();
//		model.addAttribute("key", key);
		model.addAttribute("entryBase", PATH_ROOT + "/" + projId + "/" + actionId);
		model.addAttribute("diagramBase", PATH_ROOT + "/diagram/" + projId);
//		model.addAttribute("entry", entry);
//		List<Entry> entries = viewDBDao.getAllEntries(entrytbl.getTableName());
//		model.addAttribute("entries", entries);

//		switch (entry.getTypeE()) {
//		case DIAGRAM:
//			return showDiagram(proj, entry, user, model);
//		case TABLE:
//			return showTable(proj, entry, user, search, view, model);
//		default:
//			throw new Exception("");
//		}
		return "";
	}

	private String showTable(Project proj, Entry entry, Dealer user,
			Search search, ResultView view,
			ModelMap model) throws Exception
	{
		List<Group> groups = userDao.getProjectGroupsOfDealer(user.getId(), proj.getId());
		Meta table = metaService.getProjectTableMetaByKey(proj, entry.getKey());
		table = metaService.normalize(table);

		Meta.Schema schema = table.getSchema();
		Meta.ViewConfig viewConfig = table.getViewConfig();
		Meta.SearchConfig searchConfig = table.getSearchConfig();
		Meta.SortConfig sortConfig = table.getSortConfig();
		
		search.normalize(table, groups, metaService.isEscapeInSQLLiteral());
		final int totalCount = metaDao.queryCount(null, table.getTableName());
		final int queryCount = metaDao.queryCount(search, table.getTableName());
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(sortConfig.getSortableColumnsFor(schema));
		
		List<Map<String, Object>> list = metaDao.query(search, view, table.getTableName());

		model.addAttribute("list", list);
		model.addAttribute("entry", entry);
		model.addAttribute("schema", schema);
		model.addAttribute("schemaJson", schema.toJson());
		model.addAttribute("viewConfig", viewConfig);
		model.addAttribute("viewConfigJson", viewConfig.toJson());
		model.addAttribute("searchConfig", searchConfig);
		model.addAttribute("searchConfigJson", searchConfig.toJson());
		model.addAttribute("sortConfig", sortConfig);
		model.addAttribute("sortConfigJson", sortConfig.toJson());
		model.addAttribute("pager", view);
		model.addAttribute("query", JsonUtils.serialize(search.getQuery()));

		return VIEW_ROOT + "/table";
	}

	@Override
	public void initProject(ProjectTemplate temp, Project proj) throws Exception
	{
		metaService.cloneTemplateProtoTablesForProject(temp, proj, PREFIX);
	}

	@Override
	public void handleUserDelete(ProjectTemplate temp, Project proj,
			Dealer user) throws Exception
	{
		// TODO Auto-generated method stub
		
	}

	@Override
	public void handleUserMerge(ProjectTemplate temp, Project proj,
			Dealer user, Dealer target) throws Exception
	{
		// TODO Auto-generated method stub
		
	}
}
