/******************************************************
 * (c) Copyright CIB 2017
 * Function : 缁崵绮虹粻锛勬倞閸涳拷
 * Author : Guoyanbin
 * Date : 2017-10-17
 ********************************************************/
package com.jingyan.agri.modules.sys;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.security.Token;
import com.jingyan.agri.common.web.BaseController;
import com.jingyan.agri.entity.Customer;
import com.jingyan.agri.entity.E地块;
import com.jingyan.agri.entity.License;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Manager;
import com.jingyan.agri.modules.obsolete.CreateLicenseParams;
import com.jingyan.agri.service.AgriService;
import com.jingyan.agri.service.ManagerService;
import com.mysql.jdbc.StringUtils;

@Controller
@RequestMapping(value="agri", produces = MediaType.TEXT_HTML_VALUE)
public class AgriController extends BaseController {
	
	@Autowired
	private ManagerService managerService;
	@Autowired
	private AgriService agriService;

	/**
	* 閸掓繂顫愰崠鏍?夐棃锟?
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "", method = RequestMethod.GET)
	@Token(init = true)
	public String init(ModelMap map, HttpServletRequest request) {
		Manager manager = (Manager)request.getSession().getAttribute(Constant.SYS_LOGIN_USER);
		map.addAttribute("manager", manager);
	
		return "agri/main";
	}
	
	@RequestMapping(value = "list")
	@Token(init = true)
	public String 地块List(Model model, HttpServletRequest request,
			ResultView view, E地块 search) {
		final int totalCount = agriService.count地块();
		final int queryCount = agriService.query地块Count(search);
		view.setTotalCount(totalCount);
		view.setQueryCount(queryCount);
		view.normalize(E地块.getSortableFields());

		List<E地块> list = Lists.newArrayList();
		if (queryCount > 0)
			list = agriService.query地块(search, view);
		model.addAttribute("list", list);
		model.addAttribute("pager", view);
		model.addAttribute("search", search);
		
		return "agri/dkList";
	}

	@RequestMapping(value = "add", method = RequestMethod.GET)
	@Token(init = true)
	public String 地块Add(Model model) {
		E地块 地块 = new E地块();
		model.addAttribute("data", 地块);
		model.addAttribute("action", "add");
		model.addAttribute("isAdd", true);
		return "agri/dkAdd";
	}

	@RequestMapping(value = "add", method = RequestMethod.POST)
	@Token(init = true)
	public String 地块Add(E地块 params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		try {
			agriService.add地块(params);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "地块信息添加失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return 地块Add(model);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "地块信息已添加");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/agri/list";
	}
	
	@RequestMapping(value = "edit", method = RequestMethod.GET)
	@Token(init = true)
	public String 地块Modify(int id, Model model) {
		E地块 地块 = agriService.get地块ById(id);
		model.addAttribute("data", 地块);
		model.addAttribute("action", "edit?id=" + id);
		model.addAttribute("isAdd", false);
		return "agri/dkAdd";
	}

	@RequestMapping(value = "edit", method = RequestMethod.POST)
	@Token(init = true)
	public String 地块Modify(E地块 params,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectModel) {
		
		try {
			agriService.update地块(params);
		} catch (Exception ex) {
			model.addAttribute("bubbleMessage", "地块信息修改失败: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return 地块Modify(params.getId(), model);
		}

		redirectModel.addFlashAttribute("bubbleMessage", "地块信息修改成功");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/agri/list";
	}
	
	@RequestMapping(value = "seasons")
	public String seasons() {
		return "agri/种植季List";
	}
	
	@RequestMapping(value = "addSeason")
	public String addSeason() {
		return "agri/种植季";
	}

	@RequestMapping(value = "sections")
	public String sections() {
		return "agri/剖面List";
	}
	
	@RequestMapping(value = "addSection")
	public String addSection() {
		return "agri/剖面";
	}

	@RequestMapping(value = "process")
	public String process() {
		return "agri/处理List";
	}

	@RequestMapping(value = "processMap")
	public String processMap() {
		return "agri/处理映射";
	}

	@RequestMapping(value = "processDesc")
	public String processDesc() {
		return "agri/处理说明";
	}

	@RequestMapping(value = "processAdd1")
	public String processAdd1() {
		return "agri/处理耕作";
	}

	@RequestMapping(value = "processAdd2")
	public String processAdd2() {
		return "agri/处理肥料";
	}

	@RequestMapping(value = "processAdd3")
	public String processAdd3() {
		return "agri/处理灌溉与秸秆";
	}

	@RequestMapping(value = "processAdd4")
	public String processAdd4() {
		return "agri/处理地膜与植物篱";
	}

	@RequestMapping(value = "record")
	public String record(Model model) {
		ResultView view = new ResultView();
		view.setTotalCount(2);
		view.setQueryCount(2);
		view.normalize(Lists.newArrayList("id"));
		model.addAttribute("pager", view);
		return "agri/记录List";
	}

	@RequestMapping(value = "addLog")
	public String addLog() {
		return "agri/试验记录";
	}

	@RequestMapping(value = "recordAdd1")
	public String recordAdd1() {
		return "agri/记录种植";
	}

	@RequestMapping(value = "recordAdd2")
	public String recordAdd2() {
		return "agri/记录植株样品";
	}

	@RequestMapping(value = "recordAdd3")
	public String recordAdd3() {
		return "agri/记录施肥";
	}

	@RequestMapping(value = "recordAdd4")
	public String recordAdd4() {
		return "agri/记录降水灌溉样品";
	}

	@RequestMapping(value = "recordAdd5")
	public String recordAdd5() {
		return "agri/记录产流样品";
	}

	@RequestMapping(value = "recordAdd6")
	public String recordAdd6() {
		return "agri/记录基础土壤样品";
	}

	@RequestMapping(value = "recordAdd7")
	public String recordAdd7() {
		return "agri/记录监测期土壤样品";
	}

	@RequestMapping(value = "userDelete")
	@Token(init = true)
	@ResponseBody
	public String userDelete(int id) {
		managerService.deleteDealerById(id);
		return "ok";
	}

	/**
	 * 閹哄牊娼堥惍渚?銆夐棃锟?
	 * @param map
	 * @return
	 */
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
	 * 閹哄牊娼堥惍浣稿灡瀵ゆ椽銆夐棃锟?
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
	 * 鐎广垺鍩涢崚妤勩?冩い鐢告桨
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
			model.addAttribute("bubbleMessage", "淇敼瀹㈡埛澶辫触: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return customerForm(model, id);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "宸蹭慨鏀瑰鎴?");
		redirectModel.addFlashAttribute("bubbleType", "success");

		return "redirect:/sys/customerList";
	}

	/**
	 * 鐠併垹宕熼崚妤勩?冩い鐢告桨
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
		if (StringUtils.isNullOrEmpty(searchPoNumber))
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
			model.addAttribute("bubbleMessage", "璁㈠崟纭澶辫触: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return orderDeal(model, id);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "宸插彂閫丳O璁㈠崟");
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
			model.addAttribute("bubbleMessage", "瀹屾垚璁㈠崟澶辫触: " + ex.getMessage());
			model.addAttribute("bubbleType", "error");
			return orderDeal(model, id);
		}
		
		redirectModel.addFlashAttribute("bubbleMessage", "璁㈠崟宸插畬鎴?");
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
	 * 娑撳銆夐棃锟?
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "index", method = RequestMethod.GET)
	@Token(init = true)
	public String index(ModelMap map) {
		return "sys/index";
	}
	
	/**
	 * 鐠哄疇娴嗛崚鐨宱ken婢惰鲸鏅ラ悽濠氭桨
	 * @return string 鐠哄疇娴嗛悽濠氭桨
	 */
	@RequestMapping(value = "error",method = RequestMethod.GET)
	@Token(init = true)
	public String error() {
		return "error/error";
	}
}
