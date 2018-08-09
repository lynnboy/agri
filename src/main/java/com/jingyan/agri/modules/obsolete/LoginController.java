/******************************************************
 * (c) Copyright CIB 2017
 * Function : 绯荤粺绠＄悊鍛樼敤鎴锋搷浣�
 * Author : Guoyanbin
 * Date : 2017-10-26
 ********************************************************/
package com.jingyan.agri.modules.obsolete;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContext;

import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.utils.EncryptUtil;
import com.jingyan.agri.common.web.BaseController;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Manager;
import com.jingyan.agri.modules.sys.LoginParams;
import com.jingyan.agri.service.DealerService;
import com.jingyan.agri.service.ManagerService;

/**
 * 绯荤粺绠＄悊鍛樼敤鎴锋搷浣滄帶鍒剁被
 * 
 * @author Guoyanbin
 * @version V1.0
 */
//@Controller
//@RequestMapping("account")
public class LoginController extends BaseController {
	
	/**
	 * 绯荤粺绠＄悊鍛樹笟鍔＄粍浠�
	 */
	@Autowired
	private ManagerService managerService;
	@Autowired
	private DealerService dealerService;
	
	@RequestMapping(value = "login", method = RequestMethod.POST)
	@Token(validate = true)
	public String login(LoginParams params, HttpServletRequest request, ModelMap map,
			RedirectAttributes attr) {
		
		RequestContext requestContext = new RequestContext(request);
		
		String code = (String)request.getSession().getAttribute(Constant.VALIDATE_CODE);
		String tempPassword = params.getPassword();
		if (params.getIsAdmin() == null)
			params.setIsAdmin(false);
		
		// 鍒ゆ柇楠岃瘉鐮佹槸鍚﹁緭鍏ユ纭�
		if (StringUtils.isNotBlank(params.getValidateCode()) &&
				StringUtils.isNotBlank(code) &&
				code.equalsIgnoreCase(params.getValidateCode())) {
			// 娓呴櫎鏈楠岃瘉鐮�
			request.getSession().removeAttribute(Constant.VALIDATE_CODE);
			
			// 楠岃瘉鐢ㄦ埛鍚嶆垨鑰呭瘑鐮佹槸鍚﹁緭鍏ユ纭�
			String password = EncryptUtil.encryptPassword(params.getPassword() + salt);
			params.setPassword(password);
			
			if (params.getIsAdmin()) {
				Manager sysmanager = managerService.login(params.getUserName(), password);
				
				if (sysmanager == null) {
					attr.addFlashAttribute("msg", requestContext.getMessage("MSG001"));
					params.setPassword(tempPassword);
					attr.addFlashAttribute("params", params);
					return "redirect:/login";
				}

				// 灏嗛粯璁ession鍏抽棴锛屾墦寮�涓�涓柊鐨� 
				request.getSession().invalidate();
				if (request.getCookies() != null && request.getCookies().length > 0) {
					request.getCookies()[0].setMaxAge(0);
				}

				request.getSession(true).setAttribute(Constant.SYS_LOGIN_ADMIN, sysmanager);
			} else {
				Dealer user = dealerService.login(params.getUserName(), password);
				
				if (user == null) {
					attr.addFlashAttribute("msg", requestContext.getMessage("MSG001"));
					params.setPassword(tempPassword);
					attr.addFlashAttribute("params", params);
					return "redirect:/login";
				}

				// 灏嗛粯璁ession鍏抽棴锛屾墦寮�涓�涓柊鐨� 
				request.getSession().invalidate();
				if (request.getCookies() != null && request.getCookies().length > 0) {
					request.getCookies()[0].setMaxAge(0);
				}

				request.getSession(true).setAttribute(Constant.SYS_LOGIN_USER, user);
			}
			
			request.getSession(true).setAttribute(Constant.SYS_LOGIN, params);
		// 杈撳叆涓嶆纭弽姝ｇ櫥褰曢〉闈�
		} else {
			// 娓呴櫎鏈楠岃瘉鐮�
			request.getSession().removeAttribute(Constant.VALIDATE_CODE);
			params.setPassword(tempPassword);
			attr.addFlashAttribute("msg", requestContext.getMessage("MSG002"));
			params.setPassword(tempPassword);
			attr.addFlashAttribute("params", params);
			return "redirect:/login";
		}
		
		if (params.getIsAdmin())
			return "redirect:/sys";
		else
			return "redirect:/";
	}
	
	
	/**
	 * 閫�鍑�
	 * @param session session浼氳瘽
	 * @return String 璺宠浆鐢婚潰
	 */
	@RequestMapping(value = "logout",method = RequestMethod.GET)
	@Token(init = true)
	public String logOut(HttpSession session) {
		// 鍒犻櫎浼氳瘽涓殑鐢ㄦ埛淇℃伅
		session.removeAttribute(Constant.SYS_LOGIN_USER);
		session.removeAttribute(Constant.SYS_LOGIN_ADMIN);
		session.removeAttribute(Constant.SYS_LOGIN);
		return "redirect:/login";
	}
}
