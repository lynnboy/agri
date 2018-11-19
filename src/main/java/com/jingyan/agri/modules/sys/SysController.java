package com.jingyan.agri.modules.sys;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.utils.EncryptUtil;
import com.jingyan.agri.common.utils.JsonUtils;
import com.jingyan.agri.common.web.BaseController;
import com.jingyan.agri.common.web.ProjectTemplateController;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.dao.sys.ManagerDao;
import com.jingyan.agri.dao.sys.SettingsDao;
import com.jingyan.agri.entity.Customer;
import com.jingyan.agri.entity.License;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Group;
import com.jingyan.agri.entity.sys.Manager;
import com.jingyan.agri.entity.sys.Organ;
import com.jingyan.agri.entity.sys.Project;
import com.jingyan.agri.entity.sys.ProjectTemplate;
import com.jingyan.agri.entity.sys.ProjectTemplate.Task;
import com.jingyan.agri.entity.sys.SettingValue;
import com.jingyan.agri.modules.obsolete.CreateLicenseParams;
import com.jingyan.agri.service.ManagerService;

import lombok.val;


@Controller
//@Log4j2
@RequestMapping(value="/sys", produces = MediaType.TEXT_HTML_VALUE)
public class SysController extends BaseController {
	
	@Autowired
	private ManagerService managerService;
	@Autowired
	private ManagerDao managerDao; // 系统管理员组件
	@Autowired
	private DealerDao dealerDao;
	@Autowired
	private SettingsDao settingsDao;
	@Autowired
	private ApplicationContext ctx;

	@RequestMapping(value = {"", "main", "index"}, method = RequestMethod.GET)
	@Token(init = true)

	public String init(ModelMap map, HttpServletRequest request) {
		Manager manager = (Manager)request.getSession().getAttribute(Constant.SYS_LOGIN_ADMIN);
		map.addAttribute("manager", manager);
	
		return "sys/main";
	}
	
	@RequestMapping(value = "projList")
	public String projList(Model model) {
		ManagerDao dao = managerService.getManagerDao();
		List<ProjectTemplate> templates = dao.allTemplates();
		Map<Integer, List<Project>> projects = Maps.newHashMap();
		for (ProjectTemplate temp : templates) {
			projects.put(temp.getId(), dao.getProjectOfTemplate(temp.getId()));
		}
		
		model.addAttribute("templates", templates);
		model.addAttribute("projects", projects);
		return "sys/项目List";
	}
	
	@RequestMapping(value = "projectAdd", method = RequestMethod.GET)
	@Token(init = true)
	public String projectAdd(Integer tempId, Model model) {
		Project proj = new Project();
		ManagerDao dao = managerService.getManagerDao();
		ProjectTemplate temp = dao.getTemplate(tempId);
		proj.setTempId(tempId);
		model.addAttribute("tempId", tempId);
		model.addAttribute("temp", temp);
		model.addAttribute("proj", proj);
		model.addAttribute("action", "projectAdd?tempId=" + tempId);
		model.addAttribute("isAdd", true);
		return "sys/项目Add";
	}

	@RequestMapping(value = "projectAdd", method = RequestMethod.POST)
	@Token(init = true)
	@Transactional
	public String projectAdd(Project params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		ManagerDao dao = managerService.getManagerDao();
		params.setCreateDate(new Date());
		try {
			ProjectTemplate temp = managerDao.getTemplate(params.getTempId());
			dao.addProject(params);
			
			ProjectTemplateController controller =
					ctx.getBean(temp.getVersion(), ProjectTemplateController.class);
			controller.initProject(temp, params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "创建项目失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return projectAdd(params.getTempId(), model);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "已创建项目");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/projList";
	}
	
	@RequestMapping(value = "projectModify", method = RequestMethod.GET)
	@Token(init = true)
	public String projectModify(Integer tempId, Integer id, Model model) {
		ManagerDao dao = managerService.getManagerDao();
		ProjectTemplate temp = dao.getTemplate(tempId);
		Project proj = dao.getProject(id);
		model.addAttribute("tempId", tempId);
		model.addAttribute("temp", temp);
		model.addAttribute("proj", proj);
		model.addAttribute("action", "projectModify?tempId=" + tempId);
		model.addAttribute("isAdd", false);
		return "sys/项目Add";
	}

	@RequestMapping(value = "projectModify", method = RequestMethod.POST)
	@Token(init = true)
	public String projectModify(Project params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		ManagerDao dao = managerService.getManagerDao();
		
		try {
			dao.updateProject(params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改项目失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return projectModify(params.getTempId(), params.getId(), model);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已修改项目");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/projList";
	}

	@RequestMapping(value = "projectDeprecate")
	@Token(init = true)
	@ResponseBody
	public String projectDeprecate(int id) {
		
		ManagerDao dao = managerService.getManagerDao();
		dao.deprecateProject(id);
		return "ok";
	}

	@RequestMapping(value = "tempList")
	public String tempList(Model model) {
		ManagerDao dao = managerService.getManagerDao();
		List<ProjectTemplate> templates = dao.allTemplates();
		Map<Integer, List<Project>> projects = Maps.newHashMap();
		for (ProjectTemplate temp : templates) {
			projects.put(temp.getId(), dao.getProjectOfTemplate(temp.getId()));
		}
		
		model.addAttribute("templates", templates);
		model.addAttribute("projects", projects);
		return "sys/项目模板List";
	}
	
	@RequestMapping(value = "organList")
	@Token(init = true)
	public String organList(Model model, HttpServletRequest request,
			Organ search, ResultView view) {
		Organ all = new Organ();
		all.setStatus(Organ.Status.NORMAL.ordinal());
		final int totalCount = managerDao.queryOrganCount(all);
		search.setStatus(Organ.Status.NORMAL.ordinal());
		final int queryCount = managerDao.queryOrganCount(search);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(Customer.getSortableFields());

		List<Organ> list = Lists.newArrayList();
		if (queryCount > 0)
			list = managerDao.queryOrgan(search, view);
		model.addAttribute("list", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);

		return "sys/组织List";
	}

	@RequestMapping(value = "organAdd", method = RequestMethod.GET)
	@Token(init = true)
	public String organAdd(Model model) {
		Organ organ = new Organ();
		model.addAttribute("organ", organ);
		model.addAttribute("action", "organAdd");
		model.addAttribute("isAdd", true);
		return "sys/组织Add";
	}

	@RequestMapping(value = "organAdd", method = RequestMethod.POST)
	@Token(init = true)
	public String organAdd(Organ params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {

		params.setCreateDate(new Date());
		params.setStatus(Organ.Status.NORMAL.ordinal());
		try {
			managerDao.addOrgan(params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "添加组织机构失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return userAdd(model);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "已添加组织机构");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/organList";
	}
	
	@RequestMapping(value = "organModify", method = RequestMethod.GET)
	@Token(init = true)
	public String organModify(int id, Model model) {
		Organ organ = managerDao.getOrgan(id);
		model.addAttribute("organ", organ);
		model.addAttribute("action", "organModify?id=" + id);
		model.addAttribute("isAdd", false);
		return "sys/组织Add";
	}

	@RequestMapping(value = "organModify", method = RequestMethod.POST)
	@Token(init = true)
	public String organModify(Organ params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		try {
			managerDao.updateOrgan(params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改组织机构失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return organModify(params.getId(), model);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已修改组织机构");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/organList";
	}

	@RequestMapping(value = "organDelete")
	@Token(init = true)
	@ResponseBody
	@Transactional
	public String organDelete(int id, int deleteUser) {
		
		Organ org = managerDao.getOrgan(id);
		Organ noorg = managerDao.getOrgan(0);
		if (org == null) return "ok";

		Dealer search = new Dealer();
		search.setOrganId(id);
		List<Dealer> found = dealerDao.query(search, null);
		if (deleteUser == 0) {
			for (Dealer user : found) {
				user.setOrganId(0); // change to "no such org"
				String remarks = user.getRemarks();
				if (!remarks.endsWith("\n"))
					remarks += "\n";
				remarks += new Date() + ":" +
					org.getName() + " is deleted, change to " + noorg.getName() + "\n";
				user.setRemarks(remarks);
				dealerDao.update(user);
			}
		} else {
			for (Dealer user : found) {
				user.setOrganId(0); // change to "no such org"
				user.setStatus(Dealer.Status.SHADOW.ordinal());
				dealerDao.update(user);
			}
		}
		org.setStatus(Organ.Status.SHADOW.ordinal());
		managerDao.updateOrgan(org);
		return "ok";
	}

	@RequestMapping(value = {"userList", "selectMergeUser"})
	@Token(init = true)
	public String userList(Model model, HttpServletRequest request,
			ResultView view, Dealer search) {
		final int totalCount = managerService.countDealer();
		final int queryCount = managerService.queryDealerCount(search);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(Dealer.getSortableFields());
		
		boolean isSelecting = request.getRequestURL().toString()
				.contains("selectMergeUser");

		List<Dealer> list = Lists.newArrayList();
		if (queryCount > 0)
			list = managerService.queryDealer(search, view);
		model.addAttribute("dealerList", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);
		model.addAttribute("isSelecting", isSelecting);
		
		return "sys/人员List";
	}

	@RequestMapping(value = "userAdd", method = RequestMethod.GET)
	@Token(init = true)
	public String userAdd(Model model) {
		Dealer dealer = new Dealer();
		List<Organ> organList = managerDao.allOrgan(true);
		List<Group> groupList = Lists.newArrayList();
		model.addAttribute("dealer", dealer);
		model.addAttribute("organList", organList);
		model.addAttribute("groupList", groupList);
		model.addAttribute("action", "userAdd");
		model.addAttribute("isAdd", true);
		return "sys/人员Add";
	}

	@RequestMapping(value = "userAdd", method = RequestMethod.POST)
	@Token(init = true)
	public String userAdd(Dealer params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		String realPassword = params.getPassword();
		
		String password = EncryptUtil.encryptPassword(realPassword + salt);
		params.setPassword(password);

		try {
			managerService.addDealer(params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "添加人员失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return userAdd(model);
		}
		
//		String login = params.getLogin();
//		String email = params.getEmail();
//		managerService.sendDealerCreatedMail(email, login, realPassword);
		
		redirectModel.addFlashAttribute("bubbleMessage", "已添加人员");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/userList";
	}
	
	@RequestMapping(value = "userModify", method = RequestMethod.GET)
	@Token(init = true)
	public String userModify(int id, Model model) {
		Dealer dealer = managerService.getDealerById(id);
		List<Organ> organList = managerDao.allOrgan(true);
		List<Group> groupList = dealerDao.getGroupsOfDealer(id);
		model.addAttribute("dealer", dealer);
		model.addAttribute("organList", organList);
		model.addAttribute("groupList", groupList);
		model.addAttribute("action", "userModify?id=" + id);
		model.addAttribute("isAdd", false);
		return "sys/人员Add";
	}

	@RequestMapping(value = "userModify", method = RequestMethod.POST)
	@Token(init = true)
	public String userModify(Dealer params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		String password = params.getPassword();
		if (password != null && !password.isEmpty()) {
			password = EncryptUtil.encryptPassword(password + salt);
			params.setPassword(password);
		}
		
		try {
			managerService.updateDealer(params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改人员失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return userModify(params.getId(), model);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已修改人员");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/userList";
	}

	@RequestMapping(value = "userDelete")
	@Token(init = true)
	@ResponseBody
	@Transactional
	public String userDelete(int id) {
		Dealer dealer = dealerDao.getById(id);
		if (dealer == null) return "ok";
		
		List<ProjectTemplate> tempList = managerDao.allTemplates();
		Map<Integer, ProjectTemplate> tempMap =
				tempList.stream().collect(
						Collectors.toMap(temp -> temp.getId(), temp -> temp));
		Map<Integer, ProjectTemplateController> controllers = Maps.newHashMap();
		for (ProjectTemplate temp : tempList) {
			try {
				ProjectTemplateController controller =
						ctx.getBean(temp.getVersion(), ProjectTemplateController.class);
				controllers.put(temp.getId(), controller);
			} catch (Exception ex) {
				controllers.put(temp.getId(), null);
				log.warn(ex);
			}
		}

		List<Project> projList = managerDao.allProjects();
		for (Project proj : projList) {
			try {
				ProjectTemplateController controller = controllers.get(proj.getTempId());
				if (controller == null) continue;
				ProjectTemplate temp = tempMap.get(proj.getTempId());
				controller.handleUserDelete(temp, proj, dealer);
			} catch (Exception ex) {
				log.warn(ex);
			}
		}
		
		List<Group> groups = dealerDao.getGroupsOfDealer(id);
		for (Group group : groups) {
			dealerDao.deleteMemberFromGroup(group.getId(), id);
		}

		dealer.setModifyDate(new Date());
		String newRemark = "人员删除，原属组织单位 [" + dealer.getOrganName() + "]\n";
		String remarks = dealer.getRemarks();
		if (StringUtils.isBlank(remarks))
			remarks = newRemark;
		else remarks = remarks + "\n" + newRemark;
		dealer.setRemarks(remarks);
		dealerDao.update(dealer);
		dealerDao.deleteById(id);
		return "ok";
	}

	@RequestMapping(value = "userMerge")
	@Token(init = true)
	@ResponseBody
	@Transactional
	public String userMerge(int id, int targetId) {
		Dealer dealer = dealerDao.getById(id);
		if (dealer == null) return "ok";
		if (id == targetId) return "ok";
		Dealer target = dealerDao.getById(targetId);
		
		List<ProjectTemplate> tempList = managerDao.allTemplates();
		Map<Integer, ProjectTemplate> tempMap =
				tempList.stream().collect(
						Collectors.toMap(temp -> temp.getId(), temp -> temp));
		Map<Integer, ProjectTemplateController> controllers = Maps.newHashMap();
		for (ProjectTemplate temp : tempList) {
			try {
				ProjectTemplateController controller =
						ctx.getBean(temp.getVersion(), ProjectTemplateController.class);
				controllers.put(temp.getId(), controller);
			} catch (Exception ex) {
				controllers.put(temp.getId(), null);
				log.warn(ex);
			}
		}

		List<Project> projList = managerDao.allProjects();
		for (Project proj : projList) {
			try {
				ProjectTemplateController controller = controllers.get(proj.getTempId());
				if (controller == null) continue;
				ProjectTemplate temp = tempMap.get(proj.getTempId());
				controller.handleUserMerge(temp, proj, dealer, target);
			} catch (Exception ex) {
				log.warn(ex);
			}
		}
		
		List<Group> groups = dealerDao.getGroupsOfDealer(id);
		for (Group group : groups) {
			dealerDao.deleteMemberFromGroup(group.getId(), id);
			if (!dealerDao.isMemberInGroup(group.getId(), targetId))
				dealerDao.addGroupMembers(group.getId(), Lists.newArrayList(targetId));
		}
		
		dealer.setModifyDate(new Date());
		String newRemark = "合并到人员 [" + target.getName() + "]\n" +
				"原属组织单位 [" + dealer.getOrganName() + "]\n";
		String remarks = dealer.getRemarks();
		if (StringUtils.isBlank(remarks))
			remarks = newRemark;
		else remarks = remarks + "\n" + newRemark;
		dealer.setRemarks(remarks);
		dealerDao.update(dealer);
		
		dealerDao.deleteById(id);
		return "ok";
	}

	@RequestMapping(value = "wgList")
	@Token(init = true)
	public String wgList(Model model, HttpServletRequest request,
			ResultView view, Group search) {
		Group all = new Group();
		final int totalCount = dealerDao.queryGroupCount(all);
		final int queryCount = dealerDao.queryGroupCount(search);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(Dealer.getSortableFields());
		
		List<ProjectTemplate> allTemp = managerDao.allTemplates();
		Map<Integer, Map<Integer,Task>> tempActionMap =
				allTemp.stream().collect(Collectors.toMap(
						t -> t.getId(), t -> t.getProjectInfo().getTaskMap()));
		List<Project> projs = managerDao.getProjectOfTemplate(null);
		Map<Integer, Map<Integer,Task>> projActionMap =
				projs.stream().collect(Collectors.toMap(
						p -> p.getId(), p -> tempActionMap.get(p.getTempId())));

		List<Group> list = dealerDao.queryGroup(search, view);
		model.addAttribute("list", list);
		model.addAttribute("projActionMap", projActionMap);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);
		return "sys/工作组List";
	}
	
	@RequestMapping(value = "wgAdd", method = RequestMethod.GET)
	@Token(init = true)
	public String wgAdd(Model model) {
		Group group = new Group();
		group.setProjId(0);
		List<Project> projList = managerDao.getProjectOfTemplate(null);
		List<ProjectTemplate> tempList = managerDao.allTemplates();
		Map<Integer, ProjectTemplate> tempMap = Maps.newLinkedHashMap();
		for (ProjectTemplate temp : tempList)
			tempMap.put(temp.getId(), temp);

		Map<Integer, String> projJsList = Maps.newLinkedHashMap();
		projJsList.put(0, "== 请选择 ==");
		for (Project proj : projList)
			projJsList.put(proj.getId(), proj.getName());

		Map<String, String> actionJsList = Maps.newLinkedHashMap();
		actionJsList.put("", "== 请选择 ==");
		for (ProjectTemplate temp : tempList)
			for (ProjectTemplate.Task action : temp.getProjectInfo().getTasks())
				actionJsList.putIfAbsent(
						action.getId() + "|" + action.getName(),
						action.getName());
		
		Map<Integer, List<String>> actionJsMap = Maps.newLinkedHashMap();
		actionJsMap.put(0, Lists.newArrayList(actionJsList.keySet()));
		for (Project proj : projList) {
			ProjectTemplate temp = tempMap.get(proj.getTempId());
			List<String> list = Lists.newArrayList( 
					temp.getProjectInfo().getTasks().stream()
						.map(action -> action.getId() + "|" + action.getName())
						.iterator());
			list.add(0, "");
			actionJsMap.put(proj.getId(), list);
		}

		model.addAttribute("group", group);
		model.addAttribute("projList", projJsList);
		model.addAttribute("projJsList", JsonUtils.serialize(projJsList));
		model.addAttribute("tempMap", tempMap);
		model.addAttribute("actionList", actionJsList);
		model.addAttribute("actionJsList", JsonUtils.serialize(actionJsList));
		model.addAttribute("actionJsMap", JsonUtils.serialize(actionJsMap));

		model.addAttribute("action", "wgAdd");
		model.addAttribute("isAdd", true);
		return "sys/工作组Add";
	}
	
	@RequestMapping(value = "wgAdd", method = RequestMethod.POST)
	@Token(init = true)
	public String wgAdd(Group params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		params.setCreateDate(new Date());
		try {
			dealerDao.addGroup(params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "添加工作组失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return userAdd(model);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "已添加工作组");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/wgList";
	}
	
	@RequestMapping(value = "wgModify", method = RequestMethod.GET)
	@Token(init = true)
	public String wgModify(int id, Model model) {
		Group group = dealerDao.getGroup(id);
		List<Project> projList = managerDao.getProjectOfTemplate(null);
		List<ProjectTemplate> tempList = managerDao.allTemplates();
		Map<Integer, ProjectTemplate> tempMap = Maps.newHashMap();
		for (ProjectTemplate temp : tempList)
			tempMap.put(temp.getId(), temp);

		Map<Integer, String> projJsList = Maps.newLinkedHashMap();
		projJsList.put(0, "== 请选择 ==");
		for (Project proj : projList)
			projJsList.put(proj.getId(), proj.getName());

		Map<String, String> actionJsList = Maps.newLinkedHashMap();
		actionJsList.put("", "== 请选择 ==");
		for (ProjectTemplate temp : tempList)
			for (ProjectTemplate.Task action : temp.getProjectInfo().getTasks())
				actionJsList.putIfAbsent(
						action.getId() + "|" + action.getName(),
						action.getName());
		
		Map<Integer, List<String>> actionJsMap = Maps.newLinkedHashMap();
		actionJsMap.put(0, Lists.newArrayList(actionJsList.keySet()));
		for (Project proj : projList) {
			ProjectTemplate temp = tempMap.get(proj.getTempId());
			List<String> list = Lists.newArrayList( 
					temp.getProjectInfo().getTasks().stream()
						.map(action -> action.getId() + "|" + action.getName())
						.iterator());
			list.add(0, "");
			actionJsMap.put(proj.getId(), list);
		}

		model.addAttribute("group", group);
		model.addAttribute("projList", projJsList);
		model.addAttribute("projJsList", JsonUtils.serialize(projJsList));
		model.addAttribute("tempMap", tempMap);
		model.addAttribute("actionList", actionJsList);
		model.addAttribute("actionJsList", JsonUtils.serialize(actionJsList));
		model.addAttribute("actionJsMap", JsonUtils.serialize(actionJsMap));

		model.addAttribute("action", "wgModify?id=" + id);
		model.addAttribute("isAdd", false);
		return "sys/工作组Add";
	}

	@RequestMapping(value = "wgModify", method = RequestMethod.POST)
	@Token(init = true)
	public String wgModify(Group params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		try {
			dealerDao.updateGroup(params);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改工作组失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return wgModify(params.getId(), model);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已修改工作组");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/wgList";
	}

	@RequestMapping(value = "wgDelete")
	@Token(init = true)
	@ResponseBody
	@Transactional
	public String wgDelete(int id) {
//		Group group = dealerDao.getGroup(id);
//		if (group == null) return "ok";
		
		dealerDao.clearGroupMembers(id);
		dealerDao.deleteGroup(id);
		return "ok";
	}

	@RequestMapping(value = "wgMember", method = RequestMethod.GET)
	@Token(init = true)
	public String wgMember(int id, Model model) {
		Group group = dealerDao.getGroup(id);
		Dealer search = new Dealer();
		List<Dealer> dealerList = dealerDao.query(search, null);
		List<Dealer> memberList = dealerDao.getGroupMembers(id);
		model.addAttribute("dealerList", dealerList);
		model.addAttribute("memberList", memberList);
		Project proj = managerDao.getProject(group.getProjId());
		ProjectTemplate temp = managerDao.getTemplate(proj.getTempId());
		String actionName = temp.getProjectInfo().getTaskMap()
				.get(group.getAction()).getName();
		model.addAttribute("group", group);
		model.addAttribute("actionName", actionName);
		return "sys/工作组成员";
	}
	
	@RequestMapping(value = "wgMemberList", produces = "application/json; charset=utf-8")
	@ResponseBody
	public String wgMemberList(int id) {
		List<Dealer> memberList = dealerDao.getGroupMembers(id);
		List<Map<String, String>> members = Lists.newArrayList();
		for (Dealer dealer : memberList) {
			Map<String, String> obj = Maps.newHashMap();
			obj.put("id", dealer.getId().toString());
			obj.put("organId", dealer.getOrganId().toString());
			obj.put("organName", dealer.getOrganName());
			obj.put("name", dealer.getName());
			members.add(obj);
		}
		return JsonUtils.serialize(members);
	}
	
	@RequestMapping(value = "wgSearchUser", produces = "application/json; charset=utf-8")
	@ResponseBody
	public String wgSearchUser(String pattern) {
		Dealer search = new Dealer();
		if (pattern != null) search.setName(pattern);
		List<Dealer> dealerList = dealerDao.query(search, null);
		List<Map<String, String>> list = Lists.newArrayList();
		for (Dealer dealer : dealerList) {
			Map<String, String> obj = Maps.newHashMap();
			obj.put("id", dealer.getId().toString());
			obj.put("organId", dealer.getOrganId().toString());
			obj.put("organName", dealer.getOrganName());
			obj.put("name", dealer.getName());
			list.add(obj);
		}
		String res = JsonUtils.serialize(list);
		return res;
	}
	
	@RequestMapping(value = "wgMember", method = RequestMethod.POST)
	@Token(init = true)
	@Transactional
	public String wgMember(int id, String memberList,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		try {
			dealerDao.clearGroupMembers(id);
			Collection<Integer> ids = parseIDs(memberList);
			if (ids.size() > 0)
				dealerDao.addGroupMembers(id, ids);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改工作组成员失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return wgMember(id, model);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "已修改工作组成员");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/wgList";
	}

	Collection<Integer> parseIDs(String text) {
		Set<Integer> keys = Sets.newTreeSet();
		for(String code : text.split(",")) {
			String key = code.replaceAll("'", "").toUpperCase().trim();
			if (StringUtils.isNotBlank(key))
				keys.add(Integer.parseInt(key));
		}
		return keys;
	}

	@RequestMapping(value = "settings", method = RequestMethod.GET)
	@Token(init = true)
	public String settings(Model model, HttpServletRequest request,
			ResultView view, Group search) {

		List<SettingValue> settings = settingsDao.allSettings();
		List<String> categories = Lists.newArrayList();
		Map<String, List<SettingValue>> settingMap = Maps.newLinkedHashMap();
		for (SettingValue setting : settings) {
			String category = setting.getCategory();
			if (!categories.contains(category)) {
				categories.add(category);
				settingMap.put(category, Lists.newArrayList());
			}
			settingMap.get(category).add(setting);
		}

		model.addAttribute("categories", categories);
		model.addAttribute("settingMap", settingMap);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);
		return "sys/设置";
	}
	
	@RequestMapping(value = "settings", method = RequestMethod.POST)
	@Token(init = true)
	public String settings(@RequestParam Map<String, String> map,
			Model model, HttpServletRequest request) {

		List<SettingValue> settings = settingsDao.allSettings();
		for (SettingValue setting : settings) {
			String key = "setting_" + setting.getId();
			if (map.containsKey(key)) {
				String value = map.get(key);
				setting.setValue(value);
			}
		}

		try {
			settingsDao.updateSettings(settings);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改系统设置失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return settings(model, request, null, null);
		}

		model.addAttribute("bubbleMessage", "修改系统设置成功。");
		model.addAttribute("bubbleType", "success");
		return settings(model, request, null, null);
	}
	
	@RequestMapping(value = "import")
	public String importList(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(4);
		view.setQueryCount(4);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/importList";
	}
	
	@RequestMapping(value = "importAdd")
	public String importAdd(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(4);
		view.setQueryCount(4);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/importAdd";
	}

	@RequestMapping(value = "importNewProj")
	public String importNewProj(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(4);
		view.setQueryCount(4);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/importNewProj";
	}

	@RequestMapping(value = "importToProj")
	public String importToProj(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(4);
		view.setQueryCount(4);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/importToProj";
	}

	@RequestMapping(value = "export")
	public String exportList(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(8);
		view.setQueryCount(8);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/exportList";
	}

	@RequestMapping(value = "exportAdd")
	public String exportAdd(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(1);
		view.setQueryCount(1);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/exportAdd";
	}

	@RequestMapping(value = "exportProj")
	public String exportProj(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(3);
		view.setQueryCount(3);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/exportProj";
	}

	@RequestMapping(value = "conflict")
	public String conflictList(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(4);
		view.setQueryCount(4);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/conflictList";
	}

	@RequestMapping(value = "conflictResolve")
	public String conflictResolve(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(3);
		view.setQueryCount(3);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/conflictResolve";
	}
	
	@RequestMapping(value = "conflictData1")
	public String conflictData1(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(3);
		view.setQueryCount(3);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/conflictData1";
	}

	@RequestMapping(value = "conflictData2")
	public String conflictData2(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(3);
		view.setQueryCount(3);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/conflictData2";
	}

	@RequestMapping(value = "aList")
	public String aList(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(4);
		view.setQueryCount(4);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "sys/aList";
	}
	
	@RequestMapping(value = "licenseList")
	@Token(init = true)
	public String licenseList(Model model, HttpServletRequest request,
			License search, ResultView view) {
		final int totalCount = managerService.countLicense();
		final int queryCount = managerService.queryLicenseCount(search);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(License.getSortableFields());

		List<License> list = Lists.newArrayList();
		if (queryCount > 0)
			list = managerService.queryLicense(search, view);
		model.addAttribute("licenseList", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);
		

		return "sys/licenseList";
	}
	
	/**
	 * 鎺堟潈鐮佸垱寤洪〉闈�
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "licenseCreate", method = RequestMethod.GET)
	@Token(init = true)
	public String licenseCreate(Model model) {
		CreateLicenseParams params = new CreateLicenseParams();
		model.addAttribute("params", params);
		return "sys/licenseCreate";
	}

	private static List<String> makeLicenseKeys(int count) {
		final Random random = new Random();
		final String pool = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		final List<String> list = new ArrayList<String>();
		
		for (int n = 0; n < count; n++)
		{
			StringBuilder buf = new StringBuilder();
			for (int i = 0; i < 25; i++)
			{
				if (i > 0 && i%5 == 0)
					buf.append('-');
				int idx = random.nextInt(36);
				buf.append(pool.charAt(idx));
			}
			String key = buf.toString();
			list.add(key);
		}
		return list;
	}

	@RequestMapping(value = "licenseCreate", method = RequestMethod.POST,
			produces = MediaType.APPLICATION_JSON_VALUE)
	@Token(init = true)
	@ResponseBody
	public String licenseCreate(CreateLicenseParams params,
			HttpServletRequest request, Model model) {
		int count = params.getCount();
		List<String> keys = makeLicenseKeys(count);
		
		managerService.addLicenseByKeys(keys);
		
		//return "redirect:/sys/licenseList";
		return String.join("\n\r", keys);
	}

	/**
	 * 瀹㈡埛鍒楄〃椤甸潰
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "customerList")
	@Token(init = true)
	public String customerList(Model model, HttpServletRequest request,
			Customer search, ResultView view) {
		final int totalCount = managerService.countCustomer();
		final int queryCount = managerService.queryCustomerCount(search);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(Customer.getSortableFields());

		List<Customer> list = Lists.newArrayList();
		if (queryCount > 0)
			list = managerService.queryCustomer(search, view);
		model.addAttribute("customerList", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);

		return "sys/customerList";
	}

	@RequestMapping(value = "customerForm", method = RequestMethod.GET)
	@Token(init = true)
	public String customerForm(Model model, int id) {
		Customer customer = managerService.getCustomerById(id);
		model.addAttribute("customer", customer);
		return "sys/customerForm";
	}
	
	@RequestMapping(value = "customerForm", method = RequestMethod.POST)
	@Token(init = true)
	public String customerForm(int id, String tenantId,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {

		try {
			managerService.updateCustomerTenantId(id, tenantId);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "修改客户失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return customerForm(model, id);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "已修改客户");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/customerList";
	}

	/**
	 * 璁㈠崟鍒楄〃椤甸潰
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "orderList")
	@Token(init = true)
	public String orderList(Model model, HttpServletRequest request,
			OrderInfo search, String searchPoNumber, ResultView view) {

		search.setId(getIdFromPoNumber(searchPoNumber));
		
		final int totalCount = managerService.countOrder();
		final int queryCount = managerService.queryOrderInfoCount(search);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(OrderInfo.getSortableFields());
		
		List<OrderInfo> list = Lists.newArrayList();
		if (queryCount > 0)
			list = managerService.queryOrderInfo(search, view);
		model.addAttribute("orderList", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);
		model.addAttribute("searchPoNumber", searchPoNumber);

		return "sys/orderList";
	}
	
	Pattern rePo = Pattern.compile("^(?:UFOP)?(\\d{5})$|^(\\d{1,5})$");
	Integer getIdFromPoNumber(String searchPoNumber) {
		if (StringUtils.isBlank(searchPoNumber))
				return null;
		Matcher m = rePo.matcher(searchPoNumber);
		if (!m.matches())
			return null;
		String textId = m.group(1) != null ? m.group(1) : m.group(2);
		int id = Integer.parseInt(textId);
		return id;
	}
	
	@RequestMapping(value = "orderDeal", method = RequestMethod.GET)
	@Token(init = true)
	public String orderDeal(Model model, int id) {
		
		Order order = managerService.getOrderById(id);
		if (order == null)
			throw new RuntimeException("not found.");
		Customer customer = managerService.getCustomerById(order.getCustomerId());
		if (customer == null)
			throw new RuntimeException("not found.");
		List<String> keys = managerService.getKeysOfOrder(order.getId());

		model.addAttribute("order", order);
		model.addAttribute("customer", customer);
		model.addAttribute("keys", keys);

		return "sys/orderDeal";
	}
	
	@RequestMapping(value = "orderConfirm")
	@Token(init = true)
	public String orderConfirm(int id,
			Model model, HttpServletRequest request,
			RedirectAttributes redirectModel) {
		
		Order order = managerService.getOrderById(id);
		//Customer customer = managerService.getCustomerById(order.getCustomerId());
		//int manMonthCount = order.getMonthCount();
		File attachPDF = new File(
				request.getServletContext().getClassLoader()
				.getResource("test.pdf").getPath()
				);
		try {
			managerService.sendPOMail(order, attachPDF);

			managerService.confirmOrder(id);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "订单确认失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return orderDeal(model, id);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "已发送PO订单");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/orderList";
	}
	
	//@RequestMapping(value = "orderDiscard")
	@Token(init = true)
	public String orderDiscard(Model model, int id) {
		
		managerService.discardOrder(id);

		return "redirect:/sys/orderList";
	}
	
	@RequestMapping(value = "orderFinish")
	@Token(init = true)
	public String orderFinish(Model model, int id,
			RedirectAttributes redirectModel) {

		try {
			managerService.finishOrder(id);
		} catch (Exception ex) {
			ex.printStackTrace();
			model.addAttribute("bubbleMessage", "完成订单失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return orderDeal(model, id);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "订单已完成");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/orderList";
	}
	
	@RequestMapping(value = "orderView")
	@Token(init = true)
	public void orderView(int id,
			HttpServletResponse response,
			HttpServletRequest request) {
		try (InputStream input = request.getServletContext()
				.getClassLoader().getResourceAsStream("test.pdf"))
		{
			byte[] data = IOUtils.toByteArray(input);
			response.reset();
			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition","inline;filename=order.pdf");
			response.setContentLength(data.length);
			FileCopyUtils.copy(data, response.getOutputStream());;
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 涓婚〉闈�
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "index", method = RequestMethod.GET)
	@Token(init = true)
	public String index(ModelMap map) {
		return "sys/index";
	}
	
	/**
	 * 璺宠浆鍒皌oken澶辨晥鐢婚潰
	 * @return string 璺宠浆鐢婚潰
	 */
	@RequestMapping(value = "error",method = RequestMethod.GET)
	@Token(init = true)
	public String error() {
		return "error/error";
	}
}
