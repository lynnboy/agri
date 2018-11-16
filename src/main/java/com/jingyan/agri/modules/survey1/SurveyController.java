package com.jingyan.agri.modules.survey1;

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

@Controller(SurveyController.VERSION_NAME)
@RequestMapping(value=SurveyController.VIEW_ROOT, produces = MediaType.TEXT_HTML_VALUE)
public class SurveyController extends BaseController implements ProjectTemplateController {
	
	static final String VIEW_ROOT = "/survey-v1";
	static final String PATH_ROOT = "/survey-v1";
	static final String VERSION_NAME = "survey-1.0.0";
	static final String PREFIX = "survey1";
	static final int ACTION_ID_VIEW = 1;
	
	static final String META_KEY_DATA = "清查";
	static final String META_KEY_SUB1 = "作物覆膜情况";
	static final String META_KEY_SUB2 = "模式面积";
	static final String META_KEY_SUB3 = "企业名称";
	static final String META_KEY_STATUS = "status";
	static final String META_KEY_TASK = "task";
	static final String META_KEY_LOG = "log";

	static final String SUB2_KEY = "模式代码";

	static final String TITLE_LIST = "数据列表";
	static final String TITLE_ADD = "添加新数据";
	static final String TITLE_MODIFY = "修改数据";
	static final String TITLE_SUB2 = "模式面积";
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

	interface Checker {
		boolean check();
	}

	static class ValidationHelper {
		@SuppressWarnings("serial")
		static Map<String, List<String>> codemap = new LinkedHashMap<>() {{
			put("六大分区旱地", List.of("BF01", "BF02", "BF03", "BF06", "BF07", "BF08",
					"NF01", "NF02", "NF03", "NF08", "NF09", "NF10",
					"DB01", "DB02", "DB03", "DB04", "DB05",
					"HH01", "HH02", "HH03", "HH04",
					"NS01", "NS02", "NS03",
					"XB01", "XB02", "XB03", "XB04", "XB07"));
			put("六大分区水田", List.of("NF06", "NF07", "NF13", "NF14",
					"DB07", "HH05",
					"NS04", "NS05", "NS06", "NS07", "NS08", "NS09", "NS10",
					"XB05"));
			put("六大分区园地", List.of("BF04", "BF05", "BF09", "BF10",
					"NF04", "NF05", "NF11", "NF12",
					"DB06", "HH06", "NS11", "XB06"));
			put("东北半湿润平原区", List.of("DB01", "DB02", "DB03", "DB04", "DB05", "DB06", "DB07"));
			put("黄淮海半湿润平原区", List.of("HH01", "HH02", "HH03", "HH04", "HH05", "HH06"));
			put("西北干旱半干旱平原区", List.of("XB01", "XB02", "XB03", "XB04", "XB05", "XB06", "XB07"));
			put("南方湿润平原区", List.of("NS01", "NS02", "NS03", "NS04", "NS05", "NS06", "NS07", "NS08", "NS09", "NS10", "NS11"));
			put("北方高原区缓坡地", List.of("BF01", "BF02", "BF03", "BF04", "BF05"));
			put("南方山地丘陵区缓坡地", List.of("NF01", "NF02", "NF03", "NF04", "NF05", "NF06", "NF07"));
			put("北方高原区陡坡地", List.of("BF06", "BF07", "BF08", "BF09", "BF10"));
			put("南方山地丘陵区陡坡地", List.of("NF08", "NF09", "NF10", "NF11", "NF12", "NF13", "NF14"));
			put("北方高原区缓坡地梯田", List.of("BF03", "BF05"));
			put("南方山地丘陵区缓坡地梯田", List.of("NF03", "NF05", "NF06", "NF07"));
			put("北方高原区缓坡地非梯田", List.of("BF01", "BF02", "BF04"));
			put("南方山地丘陵区缓坡地非梯田", List.of("NF01", "NF02", "NF04"));
			put("北方高原区缓坡地非梯田顺坡", List.of("BF01"));
			put("南方山地丘陵区缓坡地非梯田顺坡", List.of("NF01"));
			put("北方高原区缓坡地非梯田横坡", List.of("BF02"));
			put("南方山地丘陵区缓坡地非梯田横坡", List.of("NF02"));
			put("北方高原区陡坡地梯田", List.of("BF08", "BF10"));
			put("南方山地丘陵区陡坡地梯田", List.of("NF10", "NF12", "NF13", "NF14"));
			put("北方高原区陡坡地非梯田", List.of("BF06", "BF07", "BF09"));
			put("南方山地丘陵区陡坡地非梯田", List.of("NF08", "NF09", "NF11"));
			put("北方高原区陡坡地非梯田顺坡", List.of("BF06"));
			put("南方山地丘陵区陡坡地非梯田顺坡", List.of("NF08"));
			put("北方高原区陡坡地非梯田横坡", List.of("BF07"));
			put("南方山地丘陵区陡坡地非梯田横坡", List.of("NF09"));
		}};
		static Map<String, Double> getStatistics(List<Map<String,Object>> sub2) {
			Map<String, Double> res = Maps.newLinkedHashMap();
			for (val ent : codemap.entrySet()) {
				res.put(ent.getKey(), sum(sub2, ent.getValue()));
			}
			return res;
		}
		static double sum(List<Map<String,Object>> sub2, List<String> codes) {
			double value = 0;
			for (val code : codes) {
				for (val row : sub2) {
					val obj = row.getOrDefault(code, null);
					if (obj != null) value += (double)obj;
				}
			}
			return value;
		}
		static double sum(List<Map<String,Object>> sub1, String key) {
			double value = 0;
			for (val row : sub1) {
				val obj = row.getOrDefault(key, null);
				if (obj != null) value += (double)obj;
			}
			return value;
		}
		static double get(Map<String,Object> data, String key) {
			double value = 0;
			val obj = data.getOrDefault(key, null);
			if (obj != null) value += (double)obj;
			return value;
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
			val sumlist = metaDao.querySum(keys, keyName, keyName, sumCol,
					metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2).getTableName());
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

		return VIEW_ROOT + "/add1";
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
		model.addAttribute("id", id);
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
			addAction.setTitle(TITLE_MODIFY + " - " + divcodes.get(id) + "(" + id + ")");
			addAction.setIcon("icon-edit");
			addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/modify/" + id);
			actions.add(addAction);
		}
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/add1";
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
		model.addAttribute("id", id);
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
		addAction.setTitle(TITLE_VIEW + " - " + divcodes.get(id) + "(" + id + ")");
		addAction.setIcon("icon-eye");
		addAction.setUrl(PATH_ROOT + "/" + projId + "/" + taskId + "/view/" + id);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/add1";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}", method = RequestMethod.GET)
	@Token(init = true)
	public String sub2(@PathVariable("projId") int projId,
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
		
		val basepath = PATH_ROOT + "/" + projId + "/" + taskId + "/sub2/" + id + "/";
		
		if (!divcodes.containsKey(id))
			throw new Exception("没有权限");
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
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
				META_KEY_DATA, META_KEY_SUB2, keyName, id);
		List<Map<String, Object>> list = handler.search(search, view);

		List<String> visibleColumns = handler.getSchema().getColumns()
				.stream().map(c -> c.getName())
				.filter(n -> !n.equals(keyName))
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
		addAction.setTitle(TITLE_SUB2 + " - " + divcodes.get(id));
		if (mode == "view")
			addAction.setIcon("icon-eye");
		else
			addAction.setIcon("icon-edit");
		addAction.setUrl(basepath);
		actions.add(addAction);
		model.addAttribute("actions", actions);

		return VIEW_ROOT + "/sub2";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/add", method = RequestMethod.GET)
	public String sub2add(
			@PathVariable("projId") int projId,
			@PathVariable("taskId") int taskId,
			@PathVariable("id") String id,
			ModelMap model, HttpSession session) throws Exception
	{
		model.addAttribute("id", id);
		model.addAttribute("mode", "add");
		return VIEW_ROOT + "/sub2add";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/add",
			method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub2add(@PathVariable("projId") int projId,
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

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id))
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

			val code = params.get(SUB2_KEY);
			val list = metaDao.get2(keyName, id, SUB2_KEY, code, sub2Table.getTableName());
			if (!list.isEmpty())
				throw new Exception("已经存在" + SUB2_KEY + "【" + code + "】的数据。");
			
			metaService.addData(params, sub2Table);

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			return "failed: " + ex.getMessage();
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/modify/{subId}", method = RequestMethod.GET)
	public String sub2modify(
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
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta subTable = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		
		val list = metaDao.get2(dataTable.getFilterColumn(), id,
				SUB2_KEY, subId, subTable.getTableName());
		if (list.isEmpty())
			throw new Exception("未找到数据");
		
		model.addAttribute("id", id);
		model.addAttribute("subId", subId);
		model.addAttribute("mode", "modify");
		model.addAttribute("data", list.get(0));
		return VIEW_ROOT + "/sub2add";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/modify/{subId}",
			method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub2modify(@PathVariable("projId") int projId,
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

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id))
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

			metaService.updateData2(params, sub2Table, keyName, id, SUB2_KEY, subId);

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			return "failed: " + ex.getMessage();
		}

		return "ok";
	}

	@RequestMapping(value = "/{projId}/{taskId}/sub2/{id}/remove/{subId}",
			produces = MediaType.TEXT_PLAIN_VALUE)
	@Token(init = true)
	@ResponseBody
	public String sub2remove(@PathVariable("projId") int projId,
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

		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		val keyName = dataTable.getFilterColumn();
		
		try {
			if (!divcodes.containsKey(id))
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
			
			metaDao.remove2(keyName, id, SUB2_KEY, subId, sub2Table.getTableName());

			metaService.updateStatus(id, statusTable, user);
		} catch (Exception ex) {
			return "failed: " + ex.getMessage();
		}

		return "ok";
	}

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
		
		Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
		Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
		Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
		
		val info = temp.getProjectInfo();
		val wfitem = info.getWorkflowMap().get(task.getId());
		val stateid = wfitem.getSrcState();

		String keyName = dataTable.getFilterColumn();
		List<Map<String, Object>> list = metaDao.getAll(dataTable.getTableName());
		List<Map<String, Object>> slist = metaDao.getAll(statusTable.getTableName());
		List<String> filteredids = Lists.newArrayList();
		for (val map : slist) {
			if (map.containsKey(MetaService.COL_STATUS_STATE)) {
				val act = (Integer)map.get(MetaService.COL_STATUS_STATE);
				val id = map.get(MetaService.COL_STATUS_DATAKEY).toString();
				if (divcodes.containsKey(id) && act.equals(stateid)) {
					filteredids.add(id);
				}
			}
		}
		
		List<String> headers1 = Lists.newArrayList();
		headers1.add("区县");
		headers1.add("耕地");
		headers1.add("水田");
		headers1.add("旱地");
		headers1.add("园地");
		headers1.add("平地");
		headers1.add("缓坡地");
		headers1.add("陡坡地");
		List<Map<String,Object>> table1 = Lists.newArrayList();
		for (val obj : list) {
			val id = obj.get(keyName).toString();
			if (filteredids.contains(id)) {
				Map<String,Object> row = Maps.newLinkedHashMap();
				table1.add(row);
				row.put("区县", id + " - " + divcodes.get(id));
				row.put("耕地", 0d);
				row.put("水田", 0d);
				row.put("旱地", 0d);
				row.put("园地", 0d);
				row.put("平地", 0d);
				row.put("缓坡地", 0d);
				row.put("陡坡地", 0d);

				Object value = obj.getOrDefault("耕地", null);
				if (value != null) {
					row.put("耕地", value);
				}
				value = obj.getOrDefault("水田", null);
				if (value != null) {
					row.put("水田", value);
				}
				value = obj.getOrDefault("旱地", null);
				if (value != null) {
					row.put("旱地", value);
				}
				value = obj.getOrDefault("园地", null);
				if (value != null) {
					row.put("园地", value);
				}
				value = obj.getOrDefault("平地", null);
				if (value != null) {
					row.put("平地", value);
				}
				value = obj.getOrDefault("缓坡地", null);
				if (value != null) {
					row.put("缓坡地", value);
				}
				value = obj.getOrDefault("陡坡地", null);
				if (value != null) {
					row.put("陡坡地", value);
				}
			}
		}

		val sumCol = "模式面积";
		List<String> headers2 = Lists.newArrayList();
		headers2.add("模式代码");
		headers2.add("模式面积");
		List<Map<String,Object>> table2 = Lists.newArrayList();
		if (!filteredids.isEmpty()) {
			table2 = metaDao.querySum(filteredids, keyName,
					SUB2_KEY, sumCol, sub2Table.getTableName());
		}

		Map<Integer, String> tablenames = Maps.newLinkedHashMap();
		tablenames.put(1, "农用地面积");
		tablenames.put(2, "模式面积");
		Map<Integer,List<String>> headers = Maps.newLinkedHashMap();
		headers.put(1, headers1);
		headers.put(2, headers2);
		Map<Integer,List<Map<String,Object>>> tables = Maps.newLinkedHashMap();
		tables.put(1, table1);
		tables.put(2, table2);

		model.addAttribute("divcodes", divcodes);
		model.addAttribute("proj", proj);
		model.addAttribute("temp", temp);
		model.addAttribute("tableids", List.of(1, 2));
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

	@RequestMapping(value = "/sub1add")
	public String sub1add(Model model) {
		return VIEW_ROOT + "/sub1add";
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

			Meta dataTable = metaService.getProjectTableMetaByKey(proj, META_KEY_DATA);
			Meta sub1Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB1);
			Meta sub2Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB2);
			Meta sub3Table = metaService.getProjectTableMetaByKey(proj, META_KEY_SUB3);
			Meta statusTable = metaService.getProjectTableMetaByKey(proj, META_KEY_STATUS);
			Meta taskTable = metaService.getProjectTableMetaByKey(proj, META_KEY_TASK);
			
			val errors = validate(id, dataTable, sub1Table, sub2Table);
			if (!errors.isEmpty()) {
				return "数据校验未通过:<br><ul>" +
						String.join("", (Iterable<String>)errors.stream()
								.map(e -> "<li>" + e + "</li>")
								::iterator) +
						"</ul>";
			}
			
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
			return "failed";
		}
	}

	private List<String> validate(String id, Meta dataTable, Meta sub1Table, Meta sub2Table) {
		List<String> errors = Lists.newArrayList();
		{
			class H extends ValidationHelper {}; // type alias for short

			val keyName = dataTable.getFilterColumn();

			val list = metaDao.get(keyName, id, dataTable.getTableName());
			val data = list.get(0);
			val sub1 = metaDao.get(keyName, id, sub1Table.getTableName());
			val sub2 = metaDao.get(keyName, id, sub2Table.getTableName());
			val sub2stat = H.getStatistics(sub2);
			
			@SuppressWarnings("serial")
			val checkers = new LinkedHashMap<String, Checker>() {{
				put("耕地面积=旱地+水田", () -> true);
				put("旱地>露地菜田面积+保护地菜田面积", () -> {
					return H.get(data, "旱地") >
						H.get(data, "露地菜田") + H.get(data, "保护地菜田");
				});
				put("耕地面积+园地面积=平地+缓坡地+陡坡地", () -> {
					return H.get(data, "耕地") + H.get(data, "园地") ==
							H.get(data, "平地") + H.get(data, "缓坡地") + H.get(data, "陡坡地");
				});
				put("缓坡地面积=缓坡地梯田面积+缓坡地非梯田面积", () -> true);
				put("陡坡地面积=陡坡地梯田面积+陡坡地非梯田面积", () -> true);
				put("缓坡地非梯田面积=缓坡地非梯田顺坡种植面积+缓坡地非梯田横坡种植面积", () -> true);
				put("陡坡地非梯田面积=陡坡地非梯田顺坡种植面积+陡坡地非梯田横坡种植面积", () -> true);
				put("耕地面积≥六大分区旱地模式面积+六大分区水田模式面积", () -> {
					return H.get(data, "耕地") >=
							sub2stat.get("六大分区旱地") + sub2stat.get("六大分区水田");
				});
				put("旱地≥六大分区旱地模式面积", () -> {
					return H.get(data, "旱地") >=
							sub2stat.get("六大分区旱地");
				});
				put("水田≥六大分区水田模式面积", () -> {
					return H.get(data, "水田") >=
							sub2stat.get("六大分区水田");
				});
				put("园地面积≥六大分区园地模式面积", () -> {
					return H.get(data, "园地") >=
							sub2stat.get("六大分区园地");
				});
				put("平地≥东北半湿润平原区模式面积+黄淮海半湿润平原区模式面积+西北干旱半干旱平原区模式面积+南方湿润平原区模式面积", () -> {
					return H.get(data, "平地") >=
							sub2stat.get("东北半湿润平原区") +
							sub2stat.get("黄淮海半湿润平原区") +
							sub2stat.get("西北干旱半干旱平原区") +
							sub2stat.get("南方湿润平原区");
				});
				put("缓坡地≥北方高原区缓坡地模式面积+南方山地丘陵区缓坡地模式面积", () -> {
					return H.get(data, "缓坡地") >=
							sub2stat.get("北方高原区缓坡地") +
							sub2stat.get("南方山地丘陵区缓坡地");
				});
				put("陡坡地≥北方高原区陡坡地模式面积+南方山地丘陵区陡坡地模式面积", () -> {
					return H.get(data, "陡坡地") >=
							sub2stat.get("北方高原区陡坡地") +
							sub2stat.get("南方山地丘陵区陡坡地");
				});
				put("陡坡地≥北方高原区陡坡地模式面积+南方山地丘陵区陡坡地模式面积", () -> {
					return H.get(data, "陡坡地") >=
							sub2stat.get("北方高原区陡坡地") +
							sub2stat.get("南方山地丘陵区陡坡地");
				});
				put("缓坡地梯田面积≥北方高原区缓坡地梯田模式面积+南方山地丘陵区缓坡地梯田模式面积", () -> {
					return H.get(data, "缓坡地梯田") >=
							sub2stat.get("北方高原区缓坡地梯田") +
							sub2stat.get("南方山地丘陵区缓坡地梯田");
				});
				put("缓坡地非梯田面积≥北方高原区缓坡地非梯田模式面积+南方山地丘陵区缓坡地非梯田模式面积", () -> {
					return H.get(data, "缓坡地非梯田") >=
							sub2stat.get("北方高原区缓坡地非梯田") +
							sub2stat.get("南方山地丘陵区缓坡地非梯田");
				});
				put("缓坡地非梯田顺坡种植面积≥北方高原区缓坡地非梯田顺坡模式面积+南方山地丘陵区缓坡地非梯田顺坡模式面积", () -> {
					return H.get(data, "缓坡地顺坡") >=
							sub2stat.get("北方高原区缓坡地非梯田顺坡") +
							sub2stat.get("南方山地丘陵区缓坡地非梯田顺坡");
				});
				put("缓坡地非梯田横坡种植面积≥北方高原区缓坡地非梯田横坡模式面积+南方山地丘陵区缓坡地非梯田横坡模式面积", () -> {
					return H.get(data, "缓坡地横坡") >=
							sub2stat.get("北方高原区缓坡地非梯田横坡") +
							sub2stat.get("南方山地丘陵区缓坡地非梯田横坡");
				});
				put("陡坡地梯田面积≥北方高原区陡坡地梯田模式面积+南方山地丘陵区陡坡地梯田模式面积", () -> {
					return H.get(data, "陡坡地梯田") >=
							sub2stat.get("北方高原区陡坡地梯田") +
							sub2stat.get("南方山地丘陵区陡坡地梯田");
				});
				put("陡坡地非梯田面积≥北方高原区陡坡地非梯田模式面积+南方山地丘陵区陡坡地非梯田模式面积", () -> {
					return H.get(data, "陡坡地非梯田") >=
							sub2stat.get("北方高原区陡坡地非梯田") +
							sub2stat.get("南方山地丘陵区陡坡地非梯田");
				});
				put("陡坡地非梯田顺坡种植面积≥北方高原区陡坡地非梯田顺坡模式面积+南方山地丘陵区陡坡地非梯田顺坡模式面积", () -> {
					return H.get(data, "陡坡地顺坡") >=
							sub2stat.get("北方高原区陡坡地非梯田顺坡") +
							sub2stat.get("南方山地丘陵区陡坡地非梯田顺坡");
				});
				put("陡坡地非梯田横坡种植面积≥北方高原区陡坡地非梯田横坡模式面积+南方山地丘陵区陡坡地非梯田横坡模式面积", () -> {
					return H.get(data, "陡坡地横坡") >=
							sub2stat.get("北方高原区陡坡地非梯田横坡") +
							sub2stat.get("南方山地丘陵区陡坡地非梯田横坡");
				});
				put("地膜覆盖面积≥主要作物覆膜情况中覆膜面积之和", () -> {
					return H.get(data, "地膜覆盖") >= H.sum(sub1, "覆膜面积");
				});
				put("地膜用量≥厚度大于等于0.008mm地膜用量", () -> {
					return H.get(data, "地膜用量") >= H.sum(sub1, "厚地膜用量");
				});
				put("主要作物覆膜情况中覆膜比例<=100", () -> {
					return sub1.stream().map(row -> H.get(row, "覆膜比例"))
							.max(Double::compare).orElse(0d) <= 100d;
				});
			}};

			for (val entry : checkers.entrySet()) {
				if (!entry.getValue().check())
					errors.add(entry.getKey());
			}
		}
		return errors;
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
