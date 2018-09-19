package com.jingyan.agri.modules.planting1;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;
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
import com.jingyan.agri.common.persistence.PageEntry;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.Search;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.utils.JsonUtils;
import com.jingyan.agri.common.web.ActionUrl;
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
import com.jingyan.agri.entity.sys.ProjectTemplate.Task;
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
	static final String META_KEY_TASK = "task";
	static final String META_KEY_LOG = "log";

	static final String TITLE_LIST = "数据列表";
	static final String TITLE_ADD = "添加新数据";
	
	static final String[] DefaultVisibleColumns = {
			"行政区划代码", "状态", "修改时间", ""
	};

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
		metaService.checkProject(projId, actionId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);

		return "forward:" + PATH_ROOT + "/" + projId + "/" + actionId + "/list";
	}

	@RequestMapping(value = "/{projId}/{taskId}/list", method = RequestMethod.GET)
	@Token(init = true)
	public String entry(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			Search search, ResultView view,
			ModelMap model, HttpSession session) throws Exception
	{
		Pair<Project, ProjectTemplate> projPair =
				metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		Project proj = projPair.getLeft();
		ProjectTemplate temp = projPair.getRight();
		Task task = temp.getProjectInfo().getTaskMap().get(taskId);
		Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		
		var handler = metaService.prepareSearch(proj, temp, groups,
				META_KEY_DATA, META_KEY_STATUS, META_KEY_TASK);
		List<Map<String, Object>> list = handler.search(search, view);

		List<PageEntry> entries = List.of(
				new PageEntry(true, "/" + projId + "/" + taskId + "/list", "数据列表"),
				new PageEntry(false, "/" + projId + "/" + taskId + "/add", "填报新数据")
				);
		
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);

		model.addAttribute("list", list);
		model.addAttribute("schema", handler.getSchema());
		model.addAttribute("schemaJson", handler.getSchema().toJson());
		model.addAttribute("viewConfig", handler.getViewConfig());
		model.addAttribute("viewConfigJson", handler.getViewConfig().toJson());
		model.addAttribute("searchConfig", handler.getSearchConfig());
		model.addAttribute("searchConfigJson", handler.getSearchConfig().toJson());
		model.addAttribute("sortConfig", handler.getSortConfig());
		model.addAttribute("sortConfigJson", handler.getSortConfig().toJson());
		model.addAttribute("pager", view);
		model.addAttribute("query", JsonUtils.serialize(search.getQuery()));

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(true);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(VIEW_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		if (task.getType() == Task.Type.DEFAULT ||
			task.getType() == Task.Type.填报) {
			ActionUrl addAction = new ActionUrl();
			addAction.setActive(false);
			addAction.setTitle(TITLE_ADD);
			addAction.setIcon("icon-plus");
			addAction.setUrl(VIEW_ROOT + "/" + projId + "/" + taskId + "/add");
			actions.add(addAction);
		}
		model.addAttribute("entries", entries);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/list";
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
