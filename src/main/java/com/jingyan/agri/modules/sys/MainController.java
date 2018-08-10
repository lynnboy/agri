package com.jingyan.agri.modules.sys;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContext;

import com.google.common.collect.Maps;
import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.utils.EncryptUtil;
import com.jingyan.agri.common.web.BaseController;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.dao.sys.ManagerDao;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Group;
import com.jingyan.agri.entity.sys.Manager;
import com.jingyan.agri.entity.sys.Project;
import com.jingyan.agri.entity.sys.ProjectTemplate;
import com.jingyan.agri.service.DealerService;
import com.jingyan.agri.service.ManagerService;

@Controller
@RequestMapping(value="", produces = MediaType.TEXT_HTML_VALUE)
public class MainController extends BaseController {
	
	@Autowired
	DealerDao userDao;
	@Autowired
	ManagerDao sysDao;
	@Autowired
	private ManagerService managerService;
	@Autowired
	private DealerService dealerService;
	@Autowired
	private MessageSource messages;

	@RequestMapping(value = "login", method = RequestMethod.GET)
	@Token(init = true)
	public String login() {
		return "common/login";
	}
	
	@RequestMapping(value = "login", method = RequestMethod.POST)
	@Token(validate = true)
	public String login(LoginParams params, HttpServletRequest request, ModelMap map,
			RedirectAttributes attr) {
		
		RequestContext requestContext = new RequestContext(request);
		var locale = requestContext.getLocale();
		
		String code = (String)request.getSession().getAttribute(Constant.VALIDATE_CODE);
		String tempPassword = params.getPassword();
		if (params.getIsAdmin() == null)
			params.setIsAdmin(false);
		
		if (StringUtils.isNotBlank(params.getValidateCode()) &&
				StringUtils.isNotBlank(code) &&
				code.equalsIgnoreCase(params.getValidateCode())) {
			request.getSession().removeAttribute(Constant.VALIDATE_CODE);
			
			String password = EncryptUtil.encryptPassword(params.getPassword() + salt);
			params.setPassword(password);
			
			if (params.getIsAdmin()) {
				Manager sysmanager = managerService.login(params.getUserName(), password);
				
				if (sysmanager == null) {
					attr.addFlashAttribute("msg", messages.getMessage("MSG001", null, locale));
					params.setPassword(tempPassword);
					attr.addFlashAttribute("params", params);
					return "redirect:/login";
				}

				request.getSession().invalidate();
				if (request.getCookies() != null && request.getCookies().length > 0) {
					request.getCookies()[0].setMaxAge(0);
				}

				request.getSession(true).setAttribute(Constant.SYS_LOGIN_ADMIN, sysmanager);
			} else {
				Dealer user = dealerService.login(params.getUserName(), password);
				
				if (user == null) {
					attr.addFlashAttribute("msg", messages.getMessage("MSG001", null, locale));
					params.setPassword(tempPassword);
					attr.addFlashAttribute("params", params);
					return "redirect:/login";
				}

				request.getSession().invalidate();
				if (request.getCookies() != null && request.getCookies().length > 0) {
					request.getCookies()[0].setMaxAge(0);
				}

				request.getSession(true).setAttribute(Constant.SYS_LOGIN_USER, user);
			}
			
			request.getSession(true).setAttribute(Constant.SYS_LOGIN, params);
		} else {
			request.getSession().removeAttribute(Constant.VALIDATE_CODE);
			params.setPassword(tempPassword);
			attr.addFlashAttribute("msg", messages.getMessage("MSG002", null, locale));
			params.setPassword(tempPassword);
			attr.addFlashAttribute("params", params);
			return "redirect:/login";
		}
		
		if (params.getIsAdmin())
			return "redirect:/sys";
		else
			return "redirect:/main";
	}
	
	@RequestMapping(value = "account")
	@Token(init = true)
	public String account(HttpSession session, Model model) {

		LoginParams login = (LoginParams) session.getAttribute(Constant.SYS_LOGIN);
		if (login == null) return "redirect:/login";

		model.addAttribute("login", login);
		if (login.getIsAdmin())
			model.addAttribute("admin", session.getAttribute(Constant.SYS_LOGIN_ADMIN));
		else {
			Dealer user = (Dealer) session.getAttribute(Constant.SYS_LOGIN_USER);
			List<Group> groupList = userDao.getGroupsOfDealer(user.getId());
			model.addAttribute("user", user);
			model.addAttribute("groupList", groupList);
		}
		return "common/account";
	}

	@RequestMapping(value = "accountModify", method = RequestMethod.POST)
	@Token(init = true)
	public String accountModify(Dealer params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {

		
		String password = params.getPassword();
		if (StringUtils.isNotEmpty(password)) {
			password = EncryptUtil.encryptPassword(password + salt);
			params.setPassword(password);
		}
		
		try {
			LoginParams login = (LoginParams) request.getSession().getAttribute(Constant.SYS_LOGIN);
			if (login.getIsAdmin()) {
				Manager user = (Manager) request.getSession().getAttribute(Constant.SYS_LOGIN_ADMIN);
				if (StringUtils.isNotEmpty(password))
					user.setPassword(password);
				user.setName(params.getName());
				sysDao.update(user);
			} else {
				managerService.updateDealer(params);
			}
			redirectModel.addFlashAttribute("bubbleMessage", "修改成功");
			redirectModel.addFlashAttribute("bubbleType", "success");
		} catch (Exception ex) {
			redirectModel.addFlashAttribute("bubbleMessage", "修改失败: " + ex.getMessage());
			redirectModel.addFlashAttribute("bubbleType", "error");
		}

		return "redirect:/account";
	}

	@RequestMapping(value = "logout",method = RequestMethod.GET)
	@Token(init = true)
	public String logOut(HttpSession session) {
		// 鍒犻櫎浼氳瘽涓殑鐢ㄦ埛淇℃伅
		session.removeAttribute(Constant.SYS_LOGIN_USER);
		session.removeAttribute(Constant.SYS_LOGIN_ADMIN);
		session.removeAttribute(Constant.SYS_LOGIN);
		return "redirect:/login";
	}

	@RequestMapping(value = {"", "main"}, method = RequestMethod.GET)
	@Token(init = true)
	public String init(ModelMap map, HttpSession session) {
		LoginParams login = (LoginParams) session.getAttribute(Constant.SYS_LOGIN);
		if (login == null)
			return "redirect:/login";
		if (login.getIsAdmin())
			return "redirect:/sys";

		Dealer user = (Dealer) session.getAttribute(Constant.SYS_LOGIN_USER);
		List<Group> groups = userDao.getGroupsOfDealer(user.getId());
		Map<String, Map<Integer, Integer>> menuList = Maps.newLinkedHashMap();
//		Map<Integer, List<Group>> groupMap = Maps.newHashMap();

		List<ProjectTemplate> tempList = sysDao.allTemplates();
		Map<Integer, ProjectTemplate> tempMap = tempList.stream()
				.collect(Collectors.toMap(p -> p.getId(), p -> p));
		
		List<Project> projList = sysDao.getProjectForUser(user.getId());
		Map<Integer, Project> projMap = projList.stream()
				.collect(Collectors.toMap(p -> p.getId(), p -> p));

		for (Group group : groups) {
			Project proj = projMap.get(group.getProjId());
			ProjectTemplate temp = tempMap.get(proj.getTempId());
			Integer actionId = group.getAction();
			String actionName = temp.getProjectInfo().getActionMap().get(actionId);

			menuList.putIfAbsent(actionName, Maps.newLinkedHashMap());
//			groupMap.putIfAbsent(group.getProjId(), Lists.newArrayList());
//			groupMap.get(group.getProjId()).add(group);

			Map<Integer, Integer> list = menuList.get(actionName);
			if (!list.containsKey(proj.getId())) {
				list.put(proj.getId(), actionId);
			}
		}
		
		map.addAttribute("menuList", menuList);
		map.addAttribute("tempMap", tempMap);
		map.addAttribute("projMap", projMap);
		map.addAttribute("user", user);
		
		return "common/main";
	}
	
}
