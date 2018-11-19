package com.jingyan.agri.modules.monitor1;

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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Comparators;
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

import lombok.Getter;
import lombok.Setter;
import lombok.SneakyThrows;
import lombok.val;

@Controller(MonitorController.VERSION_NAME)
@RequestMapping(value=MonitorController.VIEW_ROOT, produces = MediaType.TEXT_HTML_VALUE)
public class MonitorController extends BaseController implements ProjectTemplateController {
	
	static final String VIEW_ROOT = "/monitor-v1";
	static final String PATH_ROOT = "/monitor-v1";
	static final String VERSION_NAME = "monitor-1.0.0";
	static final String PREFIX = "monitor1";
	static final int ACTION_ID_VIEW = 1;
	
	static final String META_KEY_1 = "地块信息";
	static final String META_KEY_1_2 = "土壤剖面描述";
	static final String META_KEY_1_3 = "种植季与作物对应";
	static final String META_KEY_1_4 = "处理编码";
	static final String META_KEY_1_4_2 = "处理描述耕作";
	static final String META_KEY_1_4_3 = "处理描述施肥";
	static final String META_KEY_1_4_4 = "处理描述灌溉与秸秆";
	static final String META_KEY_1_4_5 = "处理描述地膜与植物篱";
	static final String META_KEY_1_5 = "小区编码与处理对应";
	static final String META_KEY_2_1 = "种植记录";
	static final String META_KEY_2_2 = "植株样品";
	static final String META_KEY_3 = "施肥记录";
	static final String META_KEY_4_1 = "降水灌溉水样品";
	static final String META_KEY_4_2 = "产流样品";
	static final String META_KEY_5_1 = "基础土壤样品";
	static final String META_KEY_5_2 = "监测期土壤样品";
	static final String META_KEY_6 = "试验进程及操作记录";
	static final String META_KEY_STATUS = "status";
	static final String META_KEY_TASK = "task";
	static final String META_KEY_LOG = "log";
	
	static final String[] META_KEYS = {
			META_KEY_1, META_KEY_1_2, META_KEY_1_3,	META_KEY_1_4,
			META_KEY_1_4_2, META_KEY_1_4_3, META_KEY_1_4_4, META_KEY_1_4_5,
			META_KEY_1_5,
			META_KEY_2_1, META_KEY_2_2, META_KEY_3,
			META_KEY_4_1, META_KEY_4_2, META_KEY_5_1, META_KEY_5_2,
			META_KEY_6,
	};

	static final String SUB_KEY = "id";
	static final String YEAR_KEY = "监测年度";
	static final String CODE_KEY = "处理编码";

	static final String TITLE_LIST = "数据列表";
	static final String TITLE_ADD = "添加新数据";
	static final String TITLE_MODIFY = "修改数据";
	static final String TITLE_SUB1_2 = "土壤剖面";
	static final String TITLE_SUB1_3 = "种植季与作物对应";
	static final String TITLE_SUB2 = "处理";
	static final String TITLE_SUB3 = "记录";
	static final String TITLE_IMAGE = "地块照片";
	static final String TITLE_VIEW = "查看数据";
	static final String TITLE_SUMMARY = "数据汇总";
	
	static final String[] defaultVisibleColumns = {
			"地块编码", "承担单位", "地块地址", "种植模式", "种植季", "土壤", "监测小区", "处理", "记录"
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
	
	@Getter @Setter
	static class HelperSubRow {
		boolean isFM;
		double N;
		double P2O5;
		double K2O;
		
		HelperSubRow(Map<String, Object> row) {
			this.isFM = row.get("肥料代码").toString().contains("FM");
			Double amount = (Double)row.get("施用量");
			if (amount == null) amount = 0d;
			Double n = (Double)row.get("N");
			if (n != null) this.N = amount * n / 100;
			Double p2o5 = (Double)row.get("P2O5");
			if (p2o5 != null) this.P2O5 = amount * p2o5 / 100;
			Double k2o = (Double)row.get("K2O");
			if (k2o != null) this.K2O = amount * k2o / 100;
		}
	}

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
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/";
		
		val codeMap = metaService.getOptList("土壤类型代码");
		
		var handler = metaService.prepareSearch(proj, temp, groups,
				META_KEY_1, META_KEY_STATUS, META_KEY_TASK);
		List<Map<String, Object>> list = handler.search(search, view);
		val keyName = handler.getDataTable().getFilterColumn();
		List<String> keys = list.stream()
				.map(r -> r.get(keyName).toString())
				.collect(Collectors.toList());
		if (!keys.isEmpty()) {
			val sumlist = metaDao.queryGroupCount(keys, keyName, keyName,
					metaService.getProjectTableMetaByKey(proj, META_KEY_1_3).getTableName());
			Map<String, Object> sumMap = Maps.newHashMap();
			for (val item : sumlist) {
				sumMap.put(item.get(keyName).toString(), item.get("count"));
			}
			for (val item : list) {
				String key = item.get(keyName).toString();
				item.put("种植季Count", sumMap.getOrDefault(key, 0));
			}
		}

		List<String> visibleColumns = new ArrayList<>();
		visibleColumns.addAll(List.of(defaultVisibleColumns));
		visibleColumns.addAll(handler.getStatusColumns(taskId));

		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("divcodes", divcodes);
		model.addAttribute("codeMap", codeMap);
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
				if (hasDst && state.getId() == srcState.getId() &&
						(status == Task.Status.正常  || status == Task.Status.通过) &&
						nextTask != null) {
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
		model.addAttribute("divcode", divcodes.keySet().stream().findFirst().get());
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

		return VIEW_ROOT + "/add";
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
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "添加数据失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return add(projId, taskId, model, session);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已添加项目");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:" + PATH_ROOT + "/" + projId + "/" + taskId + "/list";
	}

	@SuppressWarnings("serial")
	static Map<String, String> initData1 = new LinkedHashMap<>() {{
		put("CK", "常规对照处理");
		put("KF", "主因子优化处理");
		put("BMP", "综合优化处理");
		put("TR1", "");
		put("TR2", "");
		put("TR3", "");
		put("TR4", "");
		put("TR5", "");
		put("TR6", "");
		put("TR7", "");
		put("TR8", "");
		put("TR9", "");
		put("TR10", "");
		put("TR11", "");
		put("TR12", "");
		put("TR13", "");
		put("TR14", "");
	}};
	
	@Transactional
	@SneakyThrows
	public void doAdd(Map<String, String> params,
			Project proj, ProjectTemplate temp, Task task, Dealer user){
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta codeTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_4);
		Meta mapTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_5);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);

		val keyName = dataTable.getFilterColumn();
		val keyValue = params.get(keyName);

		val list = metaDao.get(keyName, keyValue, dataTable.getTableName());
		if (!list.isEmpty())
			throw new Exception("已经存在" + keyName + "【" + keyValue + "】的数据。");

		metaService.addData(params, dataTable);

		val initData = initData1;
		for (val ent : initData.entrySet()) {
			Map<String, Object> row = Maps.newLinkedHashMap();
			row.put(keyName, keyValue);
			row.put("处理编码", ent.getKey());
			row.put("描述", ent.getValue());
			metaService.addData(params, codeTable);
		}
		for (val code : List.of("A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3")) {
			Map<String, Object> row = Maps.newLinkedHashMap();
			row.put(keyName, keyValue);
			row.put("小区编码", code);
			row.put("处理编码", "CK");
			metaService.addData(params, mapTable);
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

		if (!divcodes.containsKey(id.substring(0, 6)))
			throw new Exception("没有权限");

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		List<Map<String, Object>> list = metaDao.get(dataTable.getFilterColumn(), id, dataTable.getTableName());
		if (list.isEmpty())
			throw new Exception("没找到数据");
		val data = list.get(0);
		list = metaDao.get(MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		val status = list.get(0);

		model.addAttribute("divcodes", divcodes);
		model.addAttribute("id", id);
		model.addAttribute("divcode", id.substring(0, 6));
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("data", data);
		model.addAttribute("status", status);
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
			addAction.setTitle(TITLE_MODIFY + " - " + id);
			addAction.setIcon("icon-edit");
			addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/modify/" + id);
			actions.add(addAction);
		}
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/add";
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
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改数据失败: " + ex.getMessage());
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
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);

		val keyName = dataTable.getFilterColumn();
		val keyValue = params.get(keyName);

		metaService.updateData(params, dataTable);

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
		
		if (!divcodes.containsKey(id.substring(0, 6)))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		List<Map<String, Object>> list = metaDao.get(dataTable.getFilterColumn(), id, dataTable.getTableName());
		if (list.isEmpty())
			throw new Exception("没找到数据");
		val data = list.get(0);
		list = metaDao.get(MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		val status = list.get(0);

		model.addAttribute("divcodes", divcodes);
		model.addAttribute("id", id);
		model.addAttribute("divcode", id.substring(0, 6));
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("data", data);
		model.addAttribute("status", status);
		model.addAttribute("mode", "view");

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		ActionUrl addAction = new ActionUrl();
		addAction.setActive(true);
		addAction.setTitle(TITLE_VIEW + " - " + id);
		addAction.setIcon("icon-eye");
		addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/view/" + id);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/add";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_2/{id}", method = RequestMethod.GET)
	@Token(init = true)
	public String sub1_2(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			Search search, ResultView view,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/sub1_2/" + id + "/";
		
		if (!divcodes.containsKey(id.substring(0, 6)))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		List<Map<String, Object>> find = metaDao.get(
				MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		if (find.isEmpty())
			throw new Exception("没找到数据");
		val statusObj = find.get(0);
		val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
		String mode = "view";
		if ((task.getType() == Task.Type.DEFAULT || task.getType() == Task.Type.填报) &&
				wfitem.getSrcState() == stateid)
			mode = "edit";

		val keyName = dataTable.getFilterColumn();
		var handler = metaService.prepareSubSearch(proj, temp, groups,
				META_KEY_1, META_KEY_1_2, keyName, id);
		List<Map<String, Object>> list = handler.search(search, view);

		Set<String> hidden = Set.of(keyName, SUB_KEY);
		List<String> visibleColumns = handler.getSchema().getColumns()
				.stream().map(c -> c.getName())
				.filter(n -> !hidden.contains(n))
				.collect(Collectors.toList());

		model.addAttribute("id", id);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("mode", mode);
		model.addAttribute("basepath", basepath);
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

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		ActionUrl addAction = new ActionUrl();
		addAction.setActive(true);
		addAction.setTitle(TITLE_SUB1_2 + " - " + id);
		if (mode == "view")
			addAction.setIcon("icon-eye");
		else
			addAction.setIcon("icon-edit");
		addAction.setUrl(basepath);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/sub1_2";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_2/{id}/add", method = RequestMethod.GET)
	public String sub1_2add(
			@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		model.addAttribute("id", id);
		model.addAttribute("mode", "add");
		return VIEW_ROOT + "/sub1_2add";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_2/{id}/add",
			method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub1_2add(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@RequestParam Map<String, String> params,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id.substring(0, 6)))
				throw new Exception("没有权限");

			List<Map<String, Object>> find = metaDao.get(
					MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
			if (find.isEmpty())
				throw new Exception("没找到数据");
			val statusObj = find.get(0);
			val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
			if ((task.getType() != Task.Type.DEFAULT && task.getType() != Task.Type.填报) ||
					wfitem.getSrcState() != stateid)
				throw new Exception("不能修改数据");

			params.remove(SUB_KEY);
			
			metaService.addData(params, subTable);

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_2/{id}/modify/{subId}", method = RequestMethod.GET)
	public String sub1_2modify(
			@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			@PathVariable("subId") String subId,
			ModelMap model, HttpSession session) throws Exception
	{
		Pair<Project, ProjectTemplate> projPair =
				metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		Project proj = projPair.getLeft();
		ProjectTemplate temp = projPair.getRight();
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);

		val list = metaDao.get2(dataTable.getFilterColumn(), id,
				SUB_KEY, subId, subTable.getTableName());
		if (list.isEmpty())
			throw new Exception("未找到数据");

		model.addAttribute("id", id);
		model.addAttribute("subId", subId);
		model.addAttribute("mode", "modify");
		model.addAttribute("data", list.get(0));
		return VIEW_ROOT + "/sub1_2add";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_2/{id}/modify/{subId}",
			method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub1_2modify(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@RequestParam Map<String, String> params,
			@PathVariable("id") String id,
			@PathVariable("subId") String subId,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id.substring(0, 6)))
				throw new Exception("没有权限");

			List<Map<String, Object>> find = metaDao.get(
					MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
			if (find.isEmpty())
				throw new Exception("没找到数据");
			val statusObj = find.get(0);
			val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
			if ((task.getType() != Task.Type.DEFAULT && task.getType() != Task.Type.填报) ||
					wfitem.getSrcState() != stateid)
				throw new Exception("不能修改数据");

			metaService.updateData2(params, subTable, keyName, id, SUB_KEY, subId);

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_2/{id}/remove/{subId}",
			produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub1_2remove(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			@PathVariable("subId") String subId,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id.substring(0, 6)))
				throw new Exception("没有权限");

			List<Map<String, Object>> find = metaDao.get(
					MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
			if (find.isEmpty())
				throw new Exception("没找到数据");
			val statusObj = find.get(0);
			val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
			if ((task.getType() != Task.Type.DEFAULT && task.getType() != Task.Type.填报) ||
					wfitem.getSrcState() != stateid)
				throw new Exception("不能修改数据");
			
			metaDao.remove2(keyName, id, SUB_KEY, subId, subTable.getTableName());

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_3/{id}", method = RequestMethod.GET)
	@Token(init = true)
	public String sub1_3(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			Search search, ResultView view,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/sub1_3/" + id + "/";
		
		if (!divcodes.containsKey(id.substring(0, 6)))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		List<Map<String, Object>> find = metaDao.get(
				MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		if (find.isEmpty())
			throw new Exception("没找到数据");
		val statusObj = find.get(0);
		val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
		String mode = "view";
		if ((task.getType() == Task.Type.DEFAULT || task.getType() == Task.Type.填报) &&
				wfitem.getSrcState() == stateid)
			mode = "edit";

		val keyName = dataTable.getFilterColumn();
		var handler = metaService.prepareSubSearch(proj, temp, groups,
				META_KEY_1, META_KEY_1_3, keyName, id);
		List<Map<String, Object>> list = handler.search(search, view);

		Set<String> hidden = Set.of(keyName, SUB_KEY);
		List<String> visibleColumns = handler.getSchema().getColumns()
				.stream().map(c -> c.getName())
				.filter(n -> !hidden.contains(n))
				.collect(Collectors.toList());

		model.addAttribute("id", id);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("mode", mode);
		model.addAttribute("basepath", basepath);
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

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		ActionUrl addAction = new ActionUrl();
		addAction.setActive(true);
		addAction.setTitle(TITLE_SUB1_3 + " - " + id);
		if (mode == "view")
			addAction.setIcon("icon-eye");
		else
			addAction.setIcon("icon-edit");
		addAction.setUrl(basepath);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/sub1_3";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_3/{id}/add", method = RequestMethod.GET)
	public String sub1_3add(
			@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		model.addAttribute("id", id);
		model.addAttribute("mode", "add");
		return VIEW_ROOT + "/sub1_3add";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_3/{id}/add",
			method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub1_3add(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@RequestParam Map<String, String> params,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_3);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id.substring(0, 6)))
				throw new Exception("没有权限");

			List<Map<String, Object>> find = metaDao.get(
					MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
			if (find.isEmpty())
				throw new Exception("没找到数据");
			val statusObj = find.get(0);
			val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
			if ((task.getType() != Task.Type.DEFAULT && task.getType() != Task.Type.填报) ||
					wfitem.getSrcState() != stateid)
				throw new Exception("不能修改数据");

			val KEY = "种植季";
			val year = params.get(YEAR_KEY);
			val n = params.get(KEY);
			
			find = metaDao.get3(keyName, id, YEAR_KEY, year, KEY, n, subTable.getTableName());
			if (!find.isEmpty())
				throw new Exception("已经存在" + YEAR_KEY + "为" + year +
						"的【" + KEY + ":" + n + "】数据");
			
			params.remove(SUB_KEY);
			
			metaService.addData(params, subTable);

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed " + ex.getMessage();
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_3/{id}/modify/{subId}", method = RequestMethod.GET)
	public String sub1_3modify(
			@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			@PathVariable("subId") String subId,
			ModelMap model, HttpSession session) throws Exception
	{
		Pair<Project, ProjectTemplate> projPair =
				metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		Project proj = projPair.getLeft();
		ProjectTemplate temp = projPair.getRight();
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_3);

		val list = metaDao.get2(dataTable.getFilterColumn(), id,
				SUB_KEY, subId, subTable.getTableName());
		if (list.isEmpty())
			throw new Exception("未找到数据");

		model.addAttribute("id", id);
		model.addAttribute("subId", subId);
		model.addAttribute("mode", "modify");
		model.addAttribute("data", list.get(0));
		return VIEW_ROOT + "/sub1_3add";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_3/{id}/modify/{subId}",
			method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub1_3modify(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@RequestParam Map<String, String> params,
			@PathVariable("id") String id,
			@PathVariable("subId") String subId,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_3);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id.substring(0, 6)))
				throw new Exception("没有权限");

			List<Map<String, Object>> find = metaDao.get(
					MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
			if (find.isEmpty())
				throw new Exception("没找到数据");
			val statusObj = find.get(0);
			val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
			if ((task.getType() != Task.Type.DEFAULT && task.getType() != Task.Type.填报) ||
					wfitem.getSrcState() != stateid)
				throw new Exception("不能修改数据");

			metaService.updateData2(params, subTable, keyName, id, SUB_KEY, subId);

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub1_3/{id}/remove/{subId}",
			produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub1_3remove(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			@PathVariable("subId") String subId,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_3);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id.substring(0, 6)))
				throw new Exception("没有权限");

			List<Map<String, Object>> find = metaDao.get(
					MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
			if (find.isEmpty())
				throw new Exception("没找到数据");
			val statusObj = find.get(0);
			val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
			if ((task.getType() != Task.Type.DEFAULT && task.getType() != Task.Type.填报) ||
					wfitem.getSrcState() != stateid)
				throw new Exception("不能修改数据");
			
			metaDao.remove2(keyName, id, SUB_KEY, subId, subTable.getTableName());

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}", method = RequestMethod.GET)
	@Token(init = true)
	public String sub2(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/sub2/" + id + "/";
		
		if (!divcodes.containsKey(id.substring(0, 6)))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();

		List<Map<String, Object>> find = metaDao.get(
				MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		if (find.isEmpty())
			throw new Exception("没找到数据");
		val statusObj = find.get(0);
		val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
		String mode = "view";
		if ((task.getType() == Task.Type.DEFAULT || task.getType() == Task.Type.填报) &&
				wfitem.getSrcState() == stateid)
			mode = "edit";

		find = metaDao.get(keyName, id, dataTable.getTableName());
		val maindata = find.get(0);

		Meta codeTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_4);
		Meta blockTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_5);

		val blocklist = metaDao.get(keyName, id, blockTable.getTableName());
		val codelist = metaDao.get(keyName, id, codeTable.getTableName());
		val codes = blocklist.stream()
				.map(row -> row.get(CODE_KEY).toString())
				.distinct()
				.collect(Collectors.toSet());
		val usedCodeList = codelist.stream()
				.filter(row -> codes.contains(row.get(CODE_KEY)))
				.collect(Collectors.toList());

		Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_4_2);
		Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_4_3);
		Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_4_4);
		Meta sub4Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_4_5);

		val sublist1 = metaDao.get(keyName, id, sub1Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist2 = metaDao.get(keyName, id, sub2Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist3 = metaDao.get(keyName, id, sub3Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist4 = metaDao.get(keyName, id, sub4Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		
		model.addAttribute("id", id);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("mode", mode);
		model.addAttribute("basepath", basepath);
		model.addAttribute("maindata", maindata);

		model.addAttribute("blocklist", blocklist);
		model.addAttribute("usedCodeList", usedCodeList);

		model.addAttribute("sublist1", sublist1);
		model.addAttribute("sublist2", sublist2);
		model.addAttribute("sublist3", sublist3);
		model.addAttribute("sublist4", sublist4);

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		ActionUrl addAction = new ActionUrl();
		addAction.setActive(true);
		addAction.setTitle(TITLE_SUB2 + " - " + id);
		if (mode == "view")
			addAction.setIcon("icon-eye");
		else
			addAction.setIcon("icon-edit");
		addAction.setUrl(basepath);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/sub2";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/blockmap1")
	@Token(init = true)
	public String blockmap1(
			ModelMap model, HttpSession session) throws Exception
	{

		return VIEW_ROOT + "/blockmap1";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/blockmap2")
	@Token(init = true)
	public String blockmap2(int c, int r,
			@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();

		Meta codeTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_4);
		val keyName = codeTable.getFilterColumn();
		val codelist = metaDao.get(keyName, id, codeTable.getTableName());

		List<String> blocks = Lists.newArrayList();
		for (int i = 0; i < c; i++) {
			blocks.add(String.valueOf((char)('A' + i)));
		}
		model.addAttribute("blocks", blocks);
		model.addAttribute("count", c);
		model.addAttribute("repeat", r);
		model.addAttribute("codelist", codelist);

		return VIEW_ROOT + "/blockmap2";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/blockmap",
			method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String blockmap(
			@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@RequestParam Map<String, String> params,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
				Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta blockTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_5);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id.substring(0, 6)))
				throw new Exception("没有权限");

			List<Map<String, Object>> find = metaDao.get(
					MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
			if (find.isEmpty())
				throw new Exception("没找到数据");
			val statusObj = find.get(0);
			val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
			if ((task.getType() != Task.Type.DEFAULT && task.getType() != Task.Type.填报) ||
					wfitem.getSrcState() != stateid)
				throw new Exception("不能修改数据");

			metaDao.remove(keyName, id, blockTable.getTableName());

			val count = Integer.valueOf(params.getOrDefault("count","3"));
			val repeat = Integer.valueOf(params.getOrDefault("repeat","3"));
			for (int i = 0; i < count; i++) {
				String block = String.valueOf((char)('A' + i));
				val code = params.getOrDefault(block, "CK");
				for (int j = 1; j <= repeat; j++) {
					Map<String, Object> row = Maps.newLinkedHashMap();
					row.put(keyName, id);
					row.put("小区编码", block + j);
					row.put("处理编码", code);
					metaService.addData(row, blockTable);
				}
			}
			
			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub3/{id}", method = RequestMethod.GET)
	@Token(init = true)
	public String sub3(@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		val projPair = metaService.checkProject(projId, taskId, VERSION_NAME,
						Task.Type.填报, Task.Type.审核, Task.Type.汇总);
		val proj = projPair.getLeft();
		val temp = projPair.getRight();
		val info = temp.getProjectInfo();
		val task = info.getTaskMap().get(taskId);
		val wfitem = info.getWorkflowMap().get(taskId);
		val user = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = metaService.checkUser(user, proj, taskId);
		Map<String, String> divcodes = metaService.getDivCodeNamesFor(groups);
		
		val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/sub3/" + id + "/";
		
		if (!divcodes.containsKey(id.substring(0, 6)))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();

		List<Map<String, Object>> find = metaDao.get(
				MetaService.COL_STATUS_DATAKEY, id, statusTable.getTableName());
		if (find.isEmpty())
			throw new Exception("没找到数据");
		val statusObj = find.get(0);
		val stateid = (Integer)statusObj.get(MetaService.COL_STATUS_STATE);
		String mode = "view";
		if ((task.getType() == Task.Type.DEFAULT || task.getType() == Task.Type.填报) &&
				wfitem.getSrcState() == stateid)
			mode = "edit";

		find = metaDao.get(keyName, id, dataTable.getTableName());
		val maindata = find.get(0);

		Meta recordTable = metaService.getProjectTableMetaByKey(proj, META_KEY_6);

		val recordlist = metaDao.get(keyName, id, recordTable.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));

		Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_2_1);
		Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_2_1);
		Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_3);
		Meta sub4Table = metaService.getProjectTableMetaByKey(proj, META_KEY_4_1);
		Meta sub5Table = metaService.getProjectTableMetaByKey(proj, META_KEY_4_2);
		Meta sub6Table = metaService.getProjectTableMetaByKey(proj, META_KEY_5_1);
		Meta sub7Table = metaService.getProjectTableMetaByKey(proj, META_KEY_5_2);

		val sublist1 = metaDao.get(keyName, id, sub1Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist2 = metaDao.get(keyName, id, sub2Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist3 = metaDao.get(keyName, id, sub3Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist4 = metaDao.get(keyName, id, sub4Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist5 = metaDao.get(keyName, id, sub5Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist6 = metaDao.get(keyName, id, sub6Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		val sublist7 = metaDao.get(keyName, id, sub7Table.getTableName())
				.stream().collect(Collectors.groupingBy(
						row -> row.get(YEAR_KEY)));
		
		model.addAttribute("id", id);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("mode", mode);
		model.addAttribute("basepath", basepath);
		model.addAttribute("maindata", maindata);

		model.addAttribute("recordlist", recordlist);

		model.addAttribute("sublist1", sublist1);
		model.addAttribute("sublist2", sublist2);
		model.addAttribute("sublist3", sublist3);
		model.addAttribute("sublist4", sublist4);
		model.addAttribute("sublist5", sublist5);
		model.addAttribute("sublist6", sublist6);
		model.addAttribute("sublist7", sublist7);

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		ActionUrl addAction = new ActionUrl();
		addAction.setActive(true);
		addAction.setTitle(TITLE_SUB3 + " - " + id);
		if (mode == "view")
			addAction.setIcon("icon-eye");
		else
			addAction.setIcon("icon-edit");
		addAction.setUrl(basepath);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/sub3";
	}

	static String[] headerList1 = {
		"种植模式",
		"化肥 N 平均用量(公斤/亩)",
		"化肥 P<sub>2</sub>O<sub>5</sub> 平均用量(公斤/亩)",
		"化肥 K<sub>2</sub>O 平均用量(公斤/亩)",
		"有机肥 N 平均用量(公斤/亩)",
		"有机肥 P<sub>2</sub>O<sub>5</sub> 平均用量(公斤/亩)",
		"有机肥 K<sub>2</sub>O 平均用量(公斤/亩)",
	};

	@RequestMapping(value = "/{projId}/{taskId}/summary", method = RequestMethod.GET)
	@Token(init = true)
	public String summary(@PathVariable("projId") int projId,
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
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
		
		val info = temp.getProjectInfo();
		val wfitem = info.getWorkflowMap().get(task.getId());
		val stateid = wfitem.getSrcState();

		String keyName = dataTable.getFilterColumn();
		List<Map<String, Object>> slist = metaDao.getAll(statusTable.getTableName());
		Set<String> filteredids = Sets.newHashSet();
		for (val map : slist) {
			if (map.containsKey(MetaService.COL_STATUS_STATE)) {
				val act = (Integer)map.get(MetaService.COL_STATUS_STATE);
				val id = map.get(MetaService.COL_STATUS_DATAKEY).toString();
				if (divcodes.containsKey(id.substring(0, 6)) && act.equals(stateid)) {
					filteredids.add(id);
				}
			}
		}
		
		List<String> headers1 = List.of(headerList1);

		val sumCol = "模式面积";
		List<Map<String,Object>> table1 = Lists.newArrayList();
		if (!filteredids.isEmpty()) {
		}

		Map<Integer, String> tablenames = Maps.newLinkedHashMap();
		tablenames.put(1, "施肥情况统计");
		Map<Integer,List<String>> headers = Maps.newLinkedHashMap();
		headers.put(1, headers1);
		Map<Integer,List<Map<String,Object>>> tables = Maps.newLinkedHashMap();
		tables.put(1, table1);

		model.addAttribute("divcodes", divcodes);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("tableids", List.of());
		model.addAttribute("tablenames", tablenames);
		model.addAttribute("headers", headers);
		model.addAttribute("tables", tables);

		List<ActionUrl> actions = new ArrayList<>();
		ActionUrl listAction = new ActionUrl();
		listAction.setActive(false);
		listAction.setTitle(TITLE_LIST);
		listAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/list");
		actions.add(listAction);

		ActionUrl addAction = new ActionUrl();
		addAction.setActive(true);
		addAction.setTitle(TITLE_SUMMARY);
		addAction.setIcon("icon-eye");
		addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/summary");
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/summary";
	}

	@RequestMapping(value = "/{projId}/{taskId}/newstatus/{id}")
	public String newstatus(Model model) {
		return VIEW_ROOT + "/newstatus";
	}

	@RequestMapping(value = "/{projId}/{taskId}/remove",
			produces = MediaType.TEXT_PLAIN_VALUE)
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

			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			val keyName = dataTable.getFilterColumn();
			val keyValue = id;
			
			metaDao.remove(keyName, id, dataTable.getTableName());
			metaDao.remove(keyName, id, sub1Table.getTableName());
			metaDao.remove(keyName, id, statusTable.getTableName());
			metaDao.remove(keyName, id, taskTable.getTableName());

			return "ok";
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/submit",
			produces = MediaType.TEXT_PLAIN_VALUE)
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

			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			
			Map<String, Object> status = Maps.newLinkedHashMap();
			status.put(MetaService.COL_STATUS_TAGS, tags);
			status.put(MetaService.COL_STATUS_REMARKS, remarks);
			status.put(MetaService.COL_STATUS_STATE, dstState.getId());
			metaDao.update(MetaService.COL_STATUS_DATAKEY, id, status, statusTable.getTableName());

			String id2 = nextTask.getId().toString();
			val taskstates = metaDao.get2(MetaService.COL_TASK_DATAKEY, id,
					MetaService.COL_TASK_TASK, id2, taskTable.getTableName());
			Task.Status taskstatus = Task.Status.正常;
			if (nextTask.getType() == Task.Type.审核)
				taskstatus = Task.Status.申请中;
			if (taskstates.isEmpty()) {
				Map<String, Object> taskstate = Maps.newLinkedHashMap();
				taskstate.put(MetaService.COL_STATUS_DATAKEY, id);
				taskstate.put(MetaService.COL_TASK_TASK, id2);
				taskstate.put(MetaService.COL_TASK_STATUS, taskstatus.ordinal());
				metaDao.add(taskstate, taskTable.getTableName());
			} else {
				Map<String, Object> taskstate = Maps.newLinkedHashMap();
				taskstate.put(MetaService.COL_TASK_STATUS, taskstatus.ordinal());
				metaDao.update2(MetaService.COL_STATUS_DATAKEY, id,
						MetaService.COL_TASK_TASK, id2, taskstate, taskTable.getTableName());
			}

			return "ok";
		} catch (Exception ex) {
			ex.printStackTrace();
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/accept",
			produces = MediaType.TEXT_PLAIN_VALUE)
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
			
			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
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
			ex.printStackTrace();
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/reject",
			produces = MediaType.TEXT_PLAIN_VALUE)
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
			
			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
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
			ex.printStackTrace();
			return "failed";
		}
	}

	@RequestMapping(value = "/{projId}/{taskId}/withdraw",
			produces = MediaType.TEXT_PLAIN_VALUE)
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
			
			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_1);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_1_2);
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
			ex.printStackTrace();
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
