/******************************************************
 * (c) Copyright CIB 2017
 * Function : 系统管理员用户操作
 * Author : Guoyanbin
 * Date : 2017-10-26
 ********************************************************/
package com.jingyan.agri.modules.dealer;


import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.Errors;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContext;

import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.utils.EncryptUtil;
import com.jingyan.agri.common.web.BaseController;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.service.DealerService;

/**
 * 系统管理员用户操作控制类
 * 
 * @author Guoyanbin
 * @version V1.0
 */
//@Controller
//@RequestMapping("d")
public class DealerLoginController extends BaseController {

	/**
	 * 系统管理员业务组件
	 */
	@Autowired
	private DealerService dealerService;

	/**
	 * 初始化页面
	 * 
	 * @return String 跳转画面
	 */
	@RequestMapping(value = "login", method = RequestMethod.GET)
	@Token(init = true)
	public String login() {
		return "dealer/login";
	}

	/**
	 * 初始化页面
	 * 
	 * @return String 跳转画面
	 */
	@RequestMapping(value = "evalu", method = RequestMethod.GET)
	@Token(init = true)
	public String evalu(Model model) {
		model.addAttribute("priceParams", new PriceParams());
		return "dealer/evalu";
	}

	/**
	 * 
	 * @param model
	 * @param params
	 * @param errors
	 * @return
	 */
	@RequestMapping(value = "evalu", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public PriceParams evalu(//Model model,
			@Validated PriceParams params,
			Errors errors
			)
	{
		if (errors.hasErrors()) {
			throw new RuntimeException("输入格式错误");
		}

		int curCustomerCount = ObjectUtils.defaultIfNull(params.getCurCustomerCount(), 0);
		int newCustomerCount = ObjectUtils.defaultIfNull(params.getNewCustomerCount(), 0);
		int totalCustomerCount = curCustomerCount + newCustomerCount;
		int newSuiteCount = ObjectUtils.defaultIfNull(params.getNewSuiteCount(), 0);
		
		if (curCustomerCount < 0 || newCustomerCount < 0 || newSuiteCount < 0)
			throw new RuntimeException("输入格式错误");
		if (totalCustomerCount == 0)
			throw new RuntimeException("用户数量不能为零");

		Date curDueDate = params.getCurDueDate();
		Date activateDate = params.getActivateDate();

		if (curCustomerCount > 0 && curDueDate == null)
			throw new RuntimeException("缺少服务截止日期");
		if (newCustomerCount > 0 && activateDate == null)
			throw new RuntimeException("缺少预计生效日期");
		
		if (newCustomerCount == 0)
			activateDate = ObjectUtils.defaultIfNull(activateDate, curDueDate);

		long leftManday = 0;
		if (curCustomerCount != 0) {
			long interval = Math.max(curDueDate.getTime() - activateDate.getTime(), 0);
			leftManday = curCustomerCount * (interval / (1000 * 3600 * 24));
		}
		long totalManday = leftManday + newSuiteCount * (Constant.MM_PER_PACKAGE * 30);
		long newinterval = totalManday * (1000*3600*24) / totalCustomerCount;
		Date newDueDate = new Date();
		newDueDate.setTime(activateDate.getTime() + newinterval);

		params.setTotalCustomerCount(totalCustomerCount);
		params.setNewDueDate(newDueDate);

//		model.addAttribute("priceParams", params);
//		model.addAttribute("bubbleMessage", "asdf");
//		model.addAttribute("bubbleType", "error");
		//return "dealer/evalu";
		
		return params;
	}

	/**
	 * 初始化页面
	 * 
	 * @param manager
	 *            用户信息实体
	 * @param map
	 *            画面使用值
	 * @return String 跳转画面
	 */
	@RequestMapping(value = "login", method = RequestMethod.POST)
	@Token(validate = true)
	public String login(LoginParams loginData, HttpServletRequest request,
			ModelMap map, RedirectAttributes attr) {

		RequestContext requestContext = new RequestContext(request);
		// 后台验证验证码是否正确
		String code = (String) request.getSession().getAttribute(Constant.VALIDATE_CODE);
		String tempPassword = loginData.getPassword();

		// 判断验证码是否输入正确
		if (StringUtils.isNotBlank(loginData.getValidateCode())
				&& StringUtils.isNotBlank(code)
				&& code.equalsIgnoreCase(loginData.getValidateCode())) {
			// 清除本次验证码
			request.getSession().removeAttribute(Constant.VALIDATE_CODE);

			// 验证用户名或者密码是否输入正确
			String password = EncryptUtil.encryptPassword(loginData.getPassword() + salt);
			//loginData.setPassword(password);
			Dealer dealer = dealerService.login(loginData.getUserName(), password);

			if (dealer == null) {
				attr.addFlashAttribute("msg", requestContext.getMessage("MSG001"));
				loginData.setPassword(tempPassword);
				attr.addFlashAttribute("manager", loginData);
				return "redirect:/d/login";
			}

			// 将userResult对象传到下一页面
			request.getSession().removeAttribute("errorFlg");

			// 将默认session关闭，打开一个新的
			request.getSession().invalidate();
			if (request.getCookies() != null && request.getCookies().length > 0) {
				request.getCookies()[0].setMaxAge(0);
			}

			// 如果没有会话则创建一个会话
			request.getSession(true).setAttribute(Constant.SYS_LOGIN_USER, dealer);

			// 输入不正确反正登录页面
		} else {
			// 清除本次验证码
			request.getSession().removeAttribute(Constant.VALIDATE_CODE);
			loginData.setPassword(tempPassword);
			attr.addFlashAttribute("msg", requestContext.getMessage("MSG002"));
			loginData.setPassword(tempPassword);
			attr.addFlashAttribute("manager", loginData);
			return "redirect:/d/login";
		}
		return "redirect:/dealer";
	}

	/**
	 * 退出
	 * 
	 * @param session
	 *            session会话
	 * @return String 跳转画面
	 */
	@RequestMapping(value = "logout", method = RequestMethod.GET)
	@Token(init = true)
	public String logOut(HttpSession session) {
		// 删除会话中的用户信息
		session.removeAttribute(Constant.SYS_LOGIN_USER);
		return "redirect:/d/login";
	}
}
