package com.jingyan.agri.modules.planting1;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
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
import com.jingyan.agri.entity.sys.ProjectTemplate.WorkflowItem;
import com.jingyan.agri.entity.sys.SettingValue;
import com.jingyan.agri.entity.viewdb1.Diagram;
import com.jingyan.agri.entity.viewdb1.Entry;
import com.jingyan.agri.service.MetaService;

import lombok.SneakyThrows;
import lombok.val;

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
	static final String META_KEY_SUB3 = "企业名称";
	static final String META_KEY_STATUS = "status";
	static final String META_KEY_TASK = "task";
	static final String META_KEY_LOG = "log";

	static final String TITLE_LIST = "数据列表";
	static final String TITLE_ADD = "添加新数据";
	static final String TITLE_MODIFY = "修改数据";
	static final String TITLE_VIEW = "查看数据";
	static final String TITLE_SUMMARY = "数据汇总";
	
	static final String[] defaultVisibleColumns = {
			"行政区划代码", "耕地", "园地", "平地", "缓坡地", "陡坡地",
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

	public interface TaskHelper {
		String stateNameOf(Integer val);
		String statusNameOf(Map<String, Object> row);
		String statusOf(Map<String, Object> row);
		String decorateTags(String tags);
		String operations(Map<String, Object> row, String base);
	}
	
	@RequestMapping(value = "/{projId}/{taskId}/list", method = RequestMethod.GET)
	@Token(init = true)
	public String list(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			Search search, ResultView view,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		final Project proj = projPair.getLeft();
		final ProjectTemplate temp = projPair.getRight();
		val info = temp.getProjectInfo();
		final Task task = info.getTaskMap().get(taskId);
		final WorkflowItem wfitem = info.getWorkflowMap().get(taskId);
		val srcState = info.getStateMap().get(wfitem.getSrcState());
		val dstState = info.getStateMap().get(wfitem.getDstState());
		val hasDst = dstState.getId() != srcState.getId();
		val nextTask = info.nextTaskOf(dstState.getId());

		final Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		final List<Group> groups = metaService.checkUser(user, proj, taskId);
		
		val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/";
		
		var handler = metaService.prepareSearch(proj, temp, groups,
				META_KEY_DATA, META_KEY_STATUS, META_KEY_TASK);
		List<Map<String, Object>> list = handler.search(search, view);
		val keyName = handler.getDataTable().getFilterColumn();
		val sumCol = "模式面积";
		List<String> keys = list.stream()
				.map(r -> r.get(keyName).toString())
				.collect(Collectors.toList());
		if (!keys.isEmpty()) {
			val sumlist = metaDao.querySum(keys,
					metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2).getTableName(),
					keyName, sumCol);
			Map<String, Object> sumMap = Maps.newHashMap();
			for (val item : sumlist) {
				sumMap.put(item.get(keyName).toString(), item.get(sumCol));
			}
			for (val item : list) {
				String key = item.get(keyName).toString();
				item.put(sumCol, sumMap.getOrDefault(key, 0d));
			}
		}

		List<String> visibleColumns = new ArrayList<>();
		visibleColumns.addAll(List.of(defaultVisibleColumns));
		visibleColumns.add(META_KEY_SUB2);
		visibleColumns.addAll(handler.getStatusColumns(taskId));
		
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("taskHelper", new TaskHelper() {
			public String stateNameOf(Integer val) {
				return temp.getProjectInfo().getStateMap().get(val).getName();
			}
			public String statusNameOf(Map<String, Object> row) {
				var stateId = (Integer)row.get(MetaService.COL_STATUS_STATE);
				val state = info.getStateMap().get(stateId);

				val statusId = (Integer)row.get(MetaService.COL_TASK_STATUS + "_" + taskId);
				return Task.Status.values()[statusId].name();
			}
			public String statusOf(Map<String, Object> row) {
				var stateId = (Integer)row.get(MetaService.COL_STATUS_STATE);
				val state = info.getStateMap().get(stateId);
				String res = "<span class='label label-info'>" + state.getName() + "</span> ";
				val curtask = info.nextTaskOf(stateId);
				if (curtask != null) {
					val statusId = (Integer)row.get(MetaService.COL_TASK_STATUS + "_" + curtask.getId());
					if (statusId != null) {
						val status = Task.Status.values()[statusId];
						res += "(<i>" + status.name() + "</i>) ";
					}
				}
				if (hasDst) {
					val statusId = (Integer)row.get(MetaService.COL_TASK_STATUS + "_" + nextTask.getId());
					if (statusId != null) {
						val basename = nextTask.getType().name();
						String tip = "";
						val status = Task.Status.values()[statusId];
						if (status == Task.Status.申请中) {
							tip = "已申请" + basename;
						}
						if (status == Task.Status.拒绝) {
							tip = basename + "已被打回";
						}
						if (status == Task.Status.申请撤回) {
							tip = basename + "已撤回";
						}
						if (StringUtils.isNotEmpty(tip)) {
							res += "<strong>" + tip + "</strong> ";
						}
					}
				}
				
				return res;
			}
			public String decorateTags(String tags) {
				if (StringUtils.isEmpty(tags)) return "无";
				val arr = tags.split(",");
				String res = "";
				for (String tag : arr) {
					String cls = "label";
					if (tag.contains("!")) cls += " label-important";
					if (tag.contains("?")) cls += " label-warning";
					String span = "<span class=\"" + cls + "\">" + tag + "</span> ";
					res += span;
				}
				return res;
			}
			public String operations(Map<String, Object> row, String base) {
				var stateId = (Integer)row.get(MetaService.COL_STATUS_STATE);
				val state = info.getStateMap().get(stateId);

				val statusId = (Integer)row.get(MetaService.COL_TASK_STATUS + "_" + taskId);
				Task.Status status = null;
				if (statusId != null)
					status = Task.Status.values()[statusId];
				Task.Status nextStatus = null;
				if (hasDst) {
					Object nextStatusId = row.getOrDefault(MetaService.COL_TASK_STATUS + "_" + nextTask.getId(), null);
					if (nextStatusId != null)
						nextStatus = Task.Status.values()[(int)nextStatusId];
				}
				
				String btns = "";
				String id = row.get(keyName).toString();
				String tags = row.get(MetaService.COL_STATUS_TAGS).toString();
				String remarks = row.get(MetaService.COL_STATUS_REMARKS).toString();
				
				if (task.getType() == Task.Type.DEFAULT ||
					task.getType() == Task.Type.填报) {
					if ((wfitem.getSrcState() == state.getId() &&
							status == Task.Status.正常)) {
						btns += "<a href='" + base + basepath + "modify/" + id + "' " +
								"class='btn btn-primary btn-mini'>修改</a> ";
						btns += "<button onclick=\"return remove('" + id + "')\" " +
								"class='btn btn-primary btn-mini'>删除</button> ";
					} else {
						btns += "<a href='" + base + basepath + "view/" + id + "' " +
								"class='btn btn-primary btn-mini'>查看</a> ";
					}
				}
				if (task.getType() == Task.Type.审核) {
					btns += "<a href='" + base + basepath + "view/" + id + "' " +
							"class='btn btn-primary btn-mini'>查看</a> ";
					if (wfitem.getSrcState() == state.getId()) {
						if (status == Task.Status.申请中) {
							btns += "<button onclick=\"return accept('" + id +
									"', '审核', '" + tags + "', '" + remarks + "')\" " +
									"class='btn btn-primary btn-mini'>通过</button> ";
							btns += "<button onclick=\"return reject('" + id +
									"', '审核', '" + tags + "', '" + remarks + "')\" " +
									"class='btn btn-primary btn-mini'>打回</button> ";
						} else if (status == Task.Status.通过) {
							btns += "<button onclick=\"return reject('" + id +
									"', '审核', '" + tags + "', '" + remarks + "')\" " +
									"class='btn btn-primary btn-mini'>打回</button> ";
						}
					}
				}
				if (task.getType() == Task.Type.查看 ||
						task.getType() == Task.Type.汇总) {
					btns += "<a href='" + base + basepath + "view/" + id + "' " +
							"class='btn btn-primary btn-mini'>查看</a> ";
				}

				if (hasDst && state.getId() == dstState.getId() &&
						nextStatus == Task.Status.申请中) {
					btns += "<button onclick=\"return withdraw('" + id + "', '" +
						nextTask.getType().name() +
						"', '" + tags + "', '" + remarks + "')\" " +
						"class='btn btn-primary btn-mini'>撤回申请</button> ";
				}
				if (hasDst && state.getId() == srcState.getId() && nextTask != null) {
					String basename = nextTask.getType().name();
					btns += "<button onclick=\"return submit('" + id + "', '" + basename +
							"', '" + tags + "', '" + remarks + "')\" " +
							"class='btn btn-primary btn-mini'>提交" + basename + "</button> ";
				}
				return btns;
			}
		});

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
		model.addAttribute("visibleColumns", visibleColumns);
		model.addAttribute("spancols", visibleColumns.size());
		model.addAttribute("basepath", basepath);

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(true);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(basepath + "list");
		actions.add(listAction);

		if (task.getType() == Task.Type.DEFAULT ||
			task.getType() == Task.Type.填报) {
			ActionUrl addAction = new ActionUrl();
			addAction.setActive(false);
			addAction.setTitle(TITLE_ADD);
			addAction.setIcon("icon-plus");
			addAction.setUrl(basepath + "add");
			actions.add(addAction);
		}
		if (task.getType() == Task.Type.汇总) {
			ActionUrl addAction = new ActionUrl();
			addAction.setActive(false);
			addAction.setTitle(TITLE_SUMMARY);
			addAction.setIcon("icon-eye");
			addAction.setUrl(basepath + "summary");
			actions.add(addAction);
		}
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/list";
	}

	@RequestMapping(value = "/{projId}/{taskId}/add", method = RequestMethod.GET)
	@Token(init = true)
	public String add(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
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
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		model.addAttribute("divcodes", divcodes);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("mode", "add");

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		if (task.getType() == Task.Type.DEFAULT ||
			task.getType() == Task.Type.填报) {
			ActionUrl addAction = new ActionUrl();
			addAction.setActive(true);
			addAction.setTitle(TITLE_ADD);
			addAction.setIcon("icon-plus");
			addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/add");
			actions.add(addAction);
		}
		model.addAttribute("actions", actions);

		//return VIEW_ROOT + "/list";
		return "survey/add1";
	}

	@RequestMapping(value = "/{projId}/{taskId}/add", method = RequestMethod.POST)
	@Token(init = true)
	public String add(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@RequestParam Map<String, String> params,
			ModelMap model, HttpSession session,
			RedirectAttributes redirectModel) throws Exception
	{
		Pair<Project, ProjectTemplate> projPair =
				metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		Project proj = projPair.getLeft();
		ProjectTemplate temp = projPair.getRight();
		Task task = temp.getProjectInfo().getTaskMap().get(taskId);
		Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		try {
			doAdd(params, proj, temp, task, user);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "添加数据失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return add(projId, taskId, model, session);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已修改项目");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:" + PATH_ROOT + "/" + projId + "/" + taskId + "/list";
	}

	@Transactional
	@SneakyThrows
	public void doAdd(Map<String, String> params,
			Project proj, ProjectTemplate temp, Task task, Dealer user){
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
		//Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);

		val keyName = dataTable.getFilterColumn();
		val keyValue = params.get(keyName);
		
		val list = metaDao.get(keyName, keyValue, dataTable.getTableName());
		if (!list.isEmpty())
			throw new Exception("已经存在" + keyName + "【" + keyValue + "】的数据。");

		metaService.addData(params, dataTable);
		String 作物覆膜情况json = new String(Base64.getDecoder().decode(
				params.get(META_KEY_SUB1)), "UTF-8");
		if (StringUtils.isNotEmpty(作物覆膜情况json)) {
			val sublist = JsonUtils.listOfMapFrom(作物覆膜情况json);
			for (val item : sublist) {
				item.put(keyName, keyValue);
				metaService.addData(item, sub1Table);
			}
		}

		String 企业名称json = new String(Base64.getDecoder().decode(
				params.get(META_KEY_SUB3)), "UTF-8");
		if (StringUtils.isNotEmpty(企业名称json)) {
			val sublist = JsonUtils.listOfMapFrom(企业名称json);
			for (val item : sublist) {
				item.put(keyName, keyValue);
				metaService.addData(item, sub3Table);
			}
		}
		metaService.addStatus(keyValue, params, proj, temp, task, user,
				statusTable, taskTable);
	}
	
	@RequestMapping(value = "/{projId}/{taskId}/modify/{id}", method = RequestMethod.GET)
	@Token(init = true)
	public String modify(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
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
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		if (!divcodes.containsKey(id))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		List<Map<String, Object>> list = metaDao.get(dataTable.getFilterColumn(), id, dataTable.getTableName());
		if (list.isEmpty())
			throw new Exception("没找到数据");
		val data = list.get(0);
		list = metaDao.get(MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		val status = list.get(0);

		Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
		//Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
		list = metaDao.get(dataTable.getFilterColumn(), id, sub1Table.getTableName());
		String json1 = "[";
		for (val row : list) {
			if (!json1.equals("[")) json1 += ",";
			json1 += "{";
			String cols = "";
			for (val col : sub1Table.getSchema().getColumns()) {
				if (!cols.equals("")) cols += ",";
				cols += "\"" + col.getName() + "\":\"" + row.get(col.getName()).toString() +"\"";
			}
			json1 += cols;
			json1 += "}";
		}
		json1 += "]";
		
		list = metaDao.get(dataTable.getFilterColumn(), id, sub3Table.getTableName());
		String json2 = "[";
		for (val row : list) {
			if (!json2.equals("[")) json1 += ",";
			json2 += "{";
			String cols = "";
			for (val col : sub3Table.getSchema().getColumns()) {
				if (!cols.equals("")) cols += ",";
				cols += "\"" + col.getName() + "\":\"" + row.get(col.getName()).toString() +"\"";
			}
			json2 += cols;
			json2 += "}";
		}
		json2 += "]";

		model.addAttribute("divcodes", divcodes);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("data", data);
		model.addAttribute("status", status);
		model.addAttribute("作物覆膜情况JSON", json1);
		model.addAttribute("企业名称JSON", json2);
		model.addAttribute("mode", "modify");

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		if (task.getType() == Task.Type.DEFAULT ||
			task.getType() == Task.Type.填报) {
			ActionUrl addAction = new ActionUrl();
			addAction.setActive(true);
			addAction.setTitle(TITLE_MODIFY);
			addAction.setIcon("icon-edit");
			addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/modify/" + id);
			actions.add(addAction);
		}
		model.addAttribute("actions", actions);

		//return VIEW_ROOT + "/list";
		return "survey/add1";
	}

	@RequestMapping(value = "/{projId}/{taskId}/modify/{id}", method = RequestMethod.POST)
	@Token(init = true)
	public String modify(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			@RequestParam Map<String, String> params,
			ModelMap model, HttpSession session,
			RedirectAttributes redirectModel) throws Exception
	{
		Pair<Project, ProjectTemplate> projPair =
				metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		Project proj = projPair.getLeft();
		ProjectTemplate temp = projPair.getRight();
		Task task = temp.getProjectInfo().getTaskMap().get(taskId);
		Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		try {
			doModify(params, proj, temp, task, user);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "添加数据失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return modify(projId, taskId, id, model, session);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已修改项目");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:" + PATH_ROOT + "/" + projId + "/" + taskId + "/list";
	}

	@Transactional
	@SneakyThrows
	public void doModify(Map<String, String> params,
			Project proj, ProjectTemplate temp, Task task, Dealer user){
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
		//Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);

		val keyName = dataTable.getFilterColumn();
		val keyValue = params.get(keyName);
		
		metaService.updateData(params, dataTable);
		metaDao.remove(keyName, keyValue, sub1Table.getTableName());
		String 作物覆膜情况json = new String(Base64.getDecoder().decode(
				params.get(META_KEY_SUB1)), "UTF-8");
		if (StringUtils.isNotEmpty(作物覆膜情况json)) {
			val sublist = JsonUtils.listOfMapFrom(作物覆膜情况json);
			for (val item : sublist) {
				item.put(keyName, keyValue);
				metaService.addData(item, sub1Table);
			}
		}

		metaDao.remove(keyName, keyValue, sub3Table.getTableName());
		String 企业名称json = new String(Base64.getDecoder().decode(
				params.get(META_KEY_SUB3)), "UTF-8");
		if (StringUtils.isNotEmpty(企业名称json)) {
			val sublist = JsonUtils.listOfMapFrom(企业名称json);
			for (val item : sublist) {
				item.put(keyName, keyValue);
				metaService.addData(item, sub3Table);
			}
		}

		Map<String, Object> status = Maps.newLinkedHashMap();
		status.put(MetaService.COL_STATUS_MUID, user.getId());
		status.put(MetaService.COL_STATUS_MTIME, new Date());
		String tags = "";
		if (params.containsKey(MetaService.COL_STATUS_TAGS))
			tags = params.get(MetaService.COL_STATUS_TAGS).toString();
		status.put(MetaService.COL_STATUS_TAGS, tags);
		String remarks = "";
		if (params.containsKey(MetaService.COL_STATUS_REMARKS))
			remarks = params.get(MetaService.COL_STATUS_REMARKS).toString();
		status.put(MetaService.COL_STATUS_REMARKS, remarks);
		metaDao.update(MetaService.COL_STATUS_DATAKEY, keyValue, status, statusTable.getTableName());
	}
	
	@RequestMapping(value = "/{projId}/{taskId}/view/{id}", method = RequestMethod.GET)
	@Token(init = true)
	public String view(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
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
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		if (!divcodes.containsKey(id))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		List<Map<String, Object>> list = metaDao.get(dataTable.getFilterColumn(), id, dataTable.getTableName());
		if (list.isEmpty())
			throw new Exception("没找到数据");
		val data = list.get(0);
		list = metaDao.get(MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		val status = list.get(0);

		Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
		//Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
		list = metaDao.get(dataTable.getFilterColumn(), id, sub1Table.getTableName());
		String json1 = "[";
		for (val row : list) {
			if (!json1.equals("[")) json1 += ",";
			json1 += "{";
			String cols = "";
			for (val col : sub1Table.getSchema().getColumns()) {
				if (!cols.equals("")) cols += ",";
				cols += "\"" + col.getName() + "\":\"" + row.get(col.getName()).toString() +"\"";
			}
			json1 += cols;
			json1 += "}";
		}
		json1 += "]";
		
		list = metaDao.get(dataTable.getFilterColumn(), id, sub3Table.getTableName());
		String json2 = "[";
		for (val row : list) {
			if (!json2.equals("[")) json1 += ",";
			json2 += "{";
			String cols = "";
			for (val col : sub3Table.getSchema().getColumns()) {
				if (!cols.equals("")) cols += ",";
				cols += "\"" + col.getName() + "\":\"" + row.get(col.getName()).toString() +"\"";
			}
			json2 += cols;
			json2 += "}";
		}
		json2 += "]";

		model.addAttribute("divcodes", divcodes);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("data", data);
		model.addAttribute("status", status);
		model.addAttribute("作物覆膜情况JSON", json1);
		model.addAttribute("企业名称JSON", json2);
		model.addAttribute("mode", "view");

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		ActionUrl addAction = new ActionUrl();
		addAction.setActive(true);
		addAction.setTitle(TITLE_VIEW);
		addAction.setIcon("icon-eye");
		addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/modify/" + id);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		//return VIEW_ROOT + "/list";
		return "survey/add1";
	}

	@RequestMapping(value = "/{projId}/{taskId}/newstatus/{id}")
	public String newstatus(Model model) {
		return "survey/newstatus";
	}

	@RequestMapping(value = "/{projId}/{taskId}/remove")
	@Token(init = true)
	@ResponseBody
	@SneakyThrows
	public String remove(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			ModelMap model, HttpSession session,
			String id) {
		try {
			Pair<Project, ProjectTemplate> projPair =
					metaService.checkProject(projId, taskId, VERSION_NAME,
							Task.Type.填报, Task.Type.审核, Task.Type.汇总);
			Project proj = projPair.getLeft();
			ProjectTemplate temp = projPair.getRight();
			Task task = temp.getProjectInfo().getTaskMap().get(taskId);
			Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
			List<Group> groups = metaService.checkUser(user, proj, taskId);
			
			if (task.getType() != Task.Type.填报) return "ok";

			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
			Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
			Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			val keyName = dataTable.getFilterColumn();
			val keyValue = id;
			
			metaDao.remove(keyName, id, dataTable.getTableName());
			metaDao.remove(keyName, id, sub1Table.getTableName());
			metaDao.remove(keyName, id, sub2Table.getTableName());
			metaDao.remove(keyName, id, sub3Table.getTableName());
			metaDao.remove(keyName, id, statusTable.getTableName());
			metaDao.remove(keyName, id, taskTable.getTableName());

			return "ok";
		} catch (Exception ex) {
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/submit")
	@Token(init = true)
	@ResponseBody
	@SneakyThrows
	public String submit(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			ModelMap model, HttpSession session,
			String id, String tags, String remarks) {
		try {
			val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
							Task.Type.填报, Task.Type.审核, Task.Type.汇总);
			final Project proj = projPair.getLeft();
			final ProjectTemplate temp = projPair.getRight();
			val info = temp.getProjectInfo();
			final Task task = info.getTaskMap().get(taskId);
			final WorkflowItem wfitem = info.getWorkflowMap().get(taskId);
			val srcState = info.getStateMap().get(wfitem.getSrcState());
			val dstState = info.getStateMap().get(wfitem.getDstState());
			val hasDst = dstState.getId() != srcState.getId();
			val nextTask = info.nextTaskOf(dstState.getId());

			final Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
			final List<Group> groups = metaService.checkUser(user, proj, taskId);
			
			val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/";
			
			if (!hasDst) return "ok";

			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
			Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
			Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			val keyName = MetaService.COL_STATUS_DATAKEY;
			val keyValue = id;
			
			Map<String, Object> status = Maps.newLinkedHashMap();
			status.put(MetaService.COL_STATUS_TAGS, tags);
			status.put(MetaService.COL_STATUS_REMARKS, remarks);
			status.put(MetaService.COL_STATUS_STATE, dstState.getId());
			metaDao.update(keyName, id, status, statusTable.getTableName());

			String key2Name = MetaService.COL_TASK_TASK;
			String id2 = nextTask.getId().toString();
			val taskstates = metaDao.get2(keyName, id, key2Name, id2, taskTable.getTableName());
			Task.Status taskstatus = Task.Status.正常;
			if (nextTask.getType() == Task.Type.审核)
				taskstatus = Task.Status.申请中;
			if (taskstates.isEmpty()) {
				Map<String, Object> taskstate = Maps.newLinkedHashMap();
				taskstate.put(keyName, id);
				taskstate.put(key2Name, id2);
				taskstate.put(MetaService.COL_TASK_STATUS, taskstatus.ordinal());
				metaDao.add(taskstate, taskTable.getTableName());
			} else {
				Map<String, Object> taskstate = Maps.newLinkedHashMap();
				taskstate.put(MetaService.COL_TASK_STATUS, taskstatus.ordinal());
				metaDao.update2(keyName, id, key2Name, id2, taskstate, taskTable.getTableName());
			}

			return "ok";
		} catch (Exception ex) {
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/accept")
	@Token(init = true)
	@ResponseBody
	@SneakyThrows
	public String accept(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			ModelMap model, HttpSession session,
			String id, String tags, String remarks) {
		try {
			val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
							Task.Type.填报, Task.Type.审核, Task.Type.汇总);
			final Project proj = projPair.getLeft();
			final ProjectTemplate temp = projPair.getRight();
			val info = temp.getProjectInfo();
			final Task task = info.getTaskMap().get(taskId);
			final WorkflowItem wfitem = info.getWorkflowMap().get(taskId);
			val srcState = info.getStateMap().get(wfitem.getSrcState());
			val dstState = info.getStateMap().get(wfitem.getDstState());
			val hasDst = dstState.getId() != srcState.getId();
			val nextTask = info.nextTaskOf(dstState.getId());

			final Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
			final List<Group> groups = metaService.checkUser(user, proj, taskId);
			
			val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/";
			
			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
			Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
			Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			val keyName = MetaService.COL_STATUS_DATAKEY;
			val keyValue = id;
			
			Map<String, Object> status = Maps.newLinkedHashMap();
			status.put(MetaService.COL_STATUS_TAGS, tags);
			status.put(MetaService.COL_STATUS_REMARKS, remarks);
			metaDao.update(keyName, id, status, statusTable.getTableName());

			String key2Name = MetaService.COL_TASK_TASK;
			String id2 = task.getId().toString();
			val taskstates = metaDao.get2(keyName, id, key2Name, id2, taskTable.getTableName());
			Task.Status taskstatus = Task.Status.通过;

			Map<String, Object> taskstate = Maps.newLinkedHashMap();
			taskstate.put(MetaService.COL_TASK_STATUS, taskstatus.ordinal());
			taskstate.put(MetaService.COL_TASK_USERID, user.getId());
			taskstate.put(MetaService.COL_TASK_TIME, new Date());
			if (taskstates.isEmpty()) {
				taskstate.put(keyName, id);
				taskstate.put(key2Name, id2);
				metaDao.add(taskstate, taskTable.getTableName());
			} else {
				metaDao.update2(keyName, id, key2Name, id2, taskstate, taskTable.getTableName());
			}

			return "ok";
		} catch (Exception ex) {
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/reject")
	@Token(init = true)
	@ResponseBody
	@SneakyThrows
	public String reject(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			ModelMap model, HttpSession session,
			String id, String tags, String remarks) {
		try {
			val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
							Task.Type.填报, Task.Type.审核, Task.Type.汇总);
			final Project proj = projPair.getLeft();
			final ProjectTemplate temp = projPair.getRight();
			val info = temp.getProjectInfo();
			final Task task = info.getTaskMap().get(taskId);
			final WorkflowItem wfitem = info.getWorkflowMap().get(taskId);
			val srcState = info.getStateMap().get(wfitem.getSrcState());
			val dstState = info.getStateMap().get(wfitem.getDstState());
			val hasDst = dstState.getId() != srcState.getId();
			val nextTask = info.nextTaskOf(dstState.getId());
			
			val prevTask = info.prevTaskOf(srcState.getId());
			if (prevTask == null) return "";
			val prevState = info.getWorkflowMap().get(prevTask.getId())
					.getSrcState();

			final Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
			final List<Group> groups = metaService.checkUser(user, proj, taskId);
			
			val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/";
			
			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
			Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
			Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			val keyName = MetaService.COL_STATUS_DATAKEY;
			val keyValue = id;
			
			Map<String, Object> status = Maps.newLinkedHashMap();
			status.put(MetaService.COL_STATUS_TAGS, tags);
			status.put(MetaService.COL_STATUS_REMARKS, remarks);
			status.put(MetaService.COL_STATUS_STATE, prevState);
			metaDao.update(keyName, id, status, statusTable.getTableName());

			String key2Name = MetaService.COL_TASK_TASK;
			String id2 = task.getId().toString();
			val taskstates = metaDao.get2(keyName, id, key2Name, id2, taskTable.getTableName());
			Task.Status taskstatus = Task.Status.拒绝;

			Map<String, Object> taskstate = Maps.newLinkedHashMap();
			taskstate.put(MetaService.COL_TASK_STATUS, taskstatus.ordinal());
			taskstate.put(MetaService.COL_TASK_USERID, user.getId());
			taskstate.put(MetaService.COL_TASK_TIME, new Date());
			if (taskstates.isEmpty()) {
				taskstate.put(keyName, id);
				taskstate.put(key2Name, id2);
				metaDao.add(taskstate, taskTable.getTableName());
			} else {
				metaDao.update2(keyName, id, key2Name, id2, taskstate, taskTable.getTableName());
			}

			return "ok";
		} catch (Exception ex) {
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/withdraw")
	@Token(init = true)
	@ResponseBody
	@SneakyThrows
	public String withdraw(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			ModelMap model, HttpSession session,
			String id, String tags, String remarks) {
		try {
			val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
							Task.Type.填报, Task.Type.审核, Task.Type.汇总);
			final Project proj = projPair.getLeft();
			final ProjectTemplate temp = projPair.getRight();
			val info = temp.getProjectInfo();
			final Task task = info.getTaskMap().get(taskId);
			final WorkflowItem wfitem = info.getWorkflowMap().get(taskId);
			val srcState = info.getStateMap().get(wfitem.getSrcState());
			val dstState = info.getStateMap().get(wfitem.getDstState());
			val hasDst = dstState.getId() != srcState.getId();
			val nextTask = info.nextTaskOf(dstState.getId());

			if (!hasDst) return "ok";

			final Dealer user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
			final List<Group> groups = metaService.checkUser(user, proj, taskId);
			
			val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/";
			
			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
			Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
			Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			val keyName = MetaService.COL_STATUS_DATAKEY;
			val keyValue = id;
			
			Map<String, Object> status = Maps.newLinkedHashMap();
			status.put(MetaService.COL_STATUS_TAGS, tags);
			status.put(MetaService.COL_STATUS_REMARKS, remarks);
			status.put(MetaService.COL_STATUS_STATE, srcState.getId());
			metaDao.update(keyName, id, status, statusTable.getTableName());

			String key2Name = MetaService.COL_TASK_TASK;
			String id2 = nextTask.getId().toString();
			val taskstates = metaDao.get2(keyName, id, key2Name, id2, taskTable.getTableName());
			Task.Status taskstatus = Task.Status.申请撤回;

			Map<String, Object> taskstate = Maps.newLinkedHashMap();
			taskstate.put(MetaService.COL_TASK_STATUS, taskstatus.ordinal());
			if (taskstates.isEmpty()) {
				taskstate.put(keyName, id);
				taskstate.put(key2Name, id2);
				metaDao.add(taskstate, taskTable.getTableName());
			} else {
				metaDao.update2(keyName, id, key2Name, id2, taskstate, taskTable.getTableName());
			}

			return "ok";
		} catch (Exception ex) {
			return "failed";
		}
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
