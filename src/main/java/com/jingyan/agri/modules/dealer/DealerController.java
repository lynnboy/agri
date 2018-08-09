/******************************************************
 * (c) Copyright CIB 2017
 * Function : 绯荤粺绠＄悊鍛�
 * Author : Guoyanbin
 * Date : 2017-10-17
 ********************************************************/
package com.jingyan.agri.modules.dealer;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.web.BaseController;
import com.jingyan.agri.entity.Customer;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.service.DealerService;
import com.mysql.jdbc.StringUtils;

/**
 * 绯荤粺绠＄悊鍛�
 * 
 * @author Guoyanbin
 * @version V1.0
 */
@Controller
@RequestMapping(value = "dealer", produces = MediaType.TEXT_HTML_VALUE)
public class DealerController extends BaseController {

	/**
	 * 
	 */
	@Autowired
	private DealerService dealerService;

	/**
	 * 鍒濆鍖栭〉闈�
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "", method = RequestMethod.GET)
	@Token(init = true)
	public String init(ModelMap map, HttpSession session) {
		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		map.addAttribute("dealer", dealer);

		return "dealer/main";
	}

	/**
	 * 瀹㈡埛鍒楄〃椤甸潰
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "customerList")
	@Token(init = true)
	public String customerList(Model model, HttpSession session,
			Customer search, ResultView view) {

		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		final int totalCount = dealerService.countCustomer(dealer);
		final int queryCount = dealerService.queryCustomerCount(search, dealer);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(Customer.getSortableFields());

		List<Customer> list = Lists.newArrayList();
		if (queryCount > 0)
			list = dealerService.queryCustomer(search, view, dealer);
		model.addAttribute("customerList", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);

		return "dealer/customerList";
	}
	
	/**
	 * 瀹㈡埛鍒楄〃椤甸潰
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "customerSelectList")
	@Token(init = true)
	public String customerSelectList(Model model, HttpSession session,
			Customer search, ResultView view) {

		customerList(model, session, search, view);

		return "dealer/customerSelectList";
	}

	/**
	 * 瀹㈡埛鍒涘缓椤甸潰
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "customerAdd", method = RequestMethod.GET)
	@Token(init = true)
	public String customerAdd(Model model) {
		Customer customer = new Customer();
		model.addAttribute("customer", customer);
		model.addAttribute("action", "customerAdd");
		model.addAttribute("isAdd", true);

		return "dealer/customerAdd";
	}

	@RequestMapping(value = "customerAdd", method = RequestMethod.POST)
	@Token(init = true)
	public String customerAdd(Customer params,
			HttpSession session, 
			Model model, RedirectAttributes redirectModel) {
		
		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		
		try {
			dealerService.addCustomer(params, dealer);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "添加客户失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return customerAdd(model);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "已添加客户");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/dealer/customerList";
	}
	
	@RequestMapping(value = "customerModify", method = RequestMethod.GET)
	@Token(init = true)
	public String customerModify(int id, Model model, HttpSession session) {

		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		Customer customer = dealerService.getCustomerById(id, dealer);
		
		model.addAttribute("customer", customer);
		model.addAttribute("action", "customerModify?id=" + id);
		model.addAttribute("isAdd", false);

		return "dealer/customerAdd";
	}

	@RequestMapping(value = "customerModify", method = RequestMethod.POST)
	@Token(init = true)
	public String customerModify(Customer params,
			HttpSession session, Model model,
			RedirectAttributes redirectModel) {

		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		
		try {
			dealerService.updateCustomer(params, dealer);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "修改客户失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return customerModify(params.getId(), model, session);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "已修改客户");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/dealer/customerList";
	}

	@RequestMapping(value = "customerDelete")
	@Token(init = true)
	@ResponseBody
	public String customerDelete(int id, HttpSession session) {

		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);
		
		dealerService.deleteCustomerById(id, dealer);

		return "ok";
	}

	/**
	 * 璁㈠崟鍒楄〃椤甸潰
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "orderList")
	@Token(init = true)
	public String orderList(Model model, HttpSession session,
			OrderInfo search, String searchPoNumber, ResultView view) {

		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		search.setId(getIdFromPoNumber(searchPoNumber, model));

		final int totalCount = dealerService.countOrder(dealer);
		final int queryCount = dealerService.queryOrderInfoCount(search, dealer);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(OrderInfo.getSortableFields());

		List<OrderInfo> list = Lists.newArrayList();
		if (queryCount > 0)
			list = dealerService.queryOrderInfo(search, view, dealer);

		model.addAttribute("orderList", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);
		model.addAttribute("searchPoNumber", searchPoNumber);

		return "dealer/orderList";
	}
	
	static Pattern rePo = Pattern.compile("^(?:UFOP)?(\\d{5})$|^(\\d{1,5})$");
	static Integer getIdFromPoNumber(String searchPoNumber, Model model) {
		if (StringUtils.isNullOrEmpty(searchPoNumber))
				return null;
		Matcher m = rePo.matcher(searchPoNumber);
		if (!m.matches()) {
			model.addAttribute("bubbleMessage", "订单编号格式错误");
			model.addAttribute("bubbleType", "error");
			return null;
		}
		String textId = m.group(1) != null ? m.group(1) : m.group(2);
		int id = Integer.parseInt(textId);
		return id;
	}
	
	/**
	 * 璁㈠崟鍒楄〃椤甸潰
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "orderCreate", method = RequestMethod.GET)
	@Token(init = true)
	public String orderCreate(Model model) {
		//log.debug("orderCreate");
		CreateOrderParams params = new CreateOrderParams();
		model.addAttribute("params", params);
		return "dealer/orderCreate";
	}

	@RequestMapping(value = "orderCreate", method = RequestMethod.POST)
	@Token(init = true)
	public String orderCreate(CreateOrderParams params,
			HttpSession session, Model model,
			RedirectAttributes redirectModel) {
		
		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		Order order = new Order();
		order.setUserCount(params.getUserAddNum());
		order.setIssueDate(params.getUsedDate());
		order.setRemarks(params.getRemark());
		order.setCustomerId(params.getCustomerId());
		
		Collection<String> keys = parseKeys(params.getCode());
		order.setMonthCount(keys.size() * Constant.MM_PER_PACKAGE);

		try {
			dealerService.addOrder(order, keys, dealer);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "创建订单失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return orderCreate(model);
		}
		
		dealerService.sendOrderCreatedMail(order, dealer);
		
		redirectModel.addFlashAttribute("bubbleMessage", "成功下单");
		redirectModel.addFlashAttribute("bubbleType", "success");
		
		return "redirect:/dealer/orderList";
	}
	
	Collection<String> parseKeys(String text) {
		Set<String> keys = Sets.newTreeSet();
		for(String code : text.split(",")) {
			String key = code.replaceAll("'", "").toUpperCase().trim();
			if (!StringUtils.isNullOrEmpty(key))
				keys.add(key);
		}
		return keys;
	}

	@RequestMapping(value = "orderDeal", method = RequestMethod.GET)
	@Token(init = true)
	public String orderDeal(HttpSession session, Model model, int id) {
		
		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		Order order = dealerService.getOrderById(id, dealer);
		if (order == null)
			throw new RuntimeException("not found.");
		Customer customer = dealerService.getCustomerById(order.getCustomerId(), dealer);
		if (customer == null)
			throw new RuntimeException("not found.");
		List<String> keys = dealerService.getKeysOfOrder(order.getId());

		model.addAttribute("order", order);
		model.addAttribute("customer", customer);
		model.addAttribute("keys", keys);

		return "dealer/orderDeal";
	}
	
	@RequestMapping(value = "orderDiscard")
	@Token(init = true)
	public String orderDiscard(HttpSession session, Model model, int id,
			RedirectAttributes redirectModel) {
		
		Dealer dealer = (Dealer)session.getAttribute(Constant.SYS_LOGIN_USER);

		try {
			dealerService.discardOrder(id, dealer);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "订单废弃失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return orderDeal(session, model, id);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "订单已废弃");
		redirectModel.addFlashAttribute("bubbleType", "success");
		
		return "redirect:/dealer/orderList";
	}
	
	/**
	 * 璺宠浆鍒皌oken澶辨晥鐢婚潰
	 * 
	 * @return string 璺宠浆鐢婚潰
	 */
	@RequestMapping(value = "error", method = RequestMethod.GET)
	@Token(init = true)
	public String error() {
		return "error/error";
	}
}
