package com.jingyan.agri.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Maps;
import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.service.BaseService;
import com.jingyan.agri.dao.CustomerDao;
import com.jingyan.agri.dao.E地块Dao;
import com.jingyan.agri.dao.LicenseDao;
import com.jingyan.agri.dao.OrderDao;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.dao.sys.ManagerDao;
import com.jingyan.agri.entity.Customer;
import com.jingyan.agri.entity.E地块;
import com.jingyan.agri.entity.License;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Manager;
import com.jingyan.agri.service.AgriService;
import com.jingyan.agri.service.EmailService;
import com.mysql.jdbc.StringUtils;

@Service
public class AgriServiceImpl extends BaseService implements AgriService {

	@Autowired
	private ManagerDao managerDao; // 系统管理员组�?
	@Autowired
	private E地块Dao e地块Dao;
	@Autowired
	private CustomerDao customerDao;
	@Autowired
	private DealerDao dealerDao;
	@Autowired 
	private OrderDao orderDao;
	@Autowired
	private LicenseDao licenseDao;
	
	//@Autowired
	private EmailService emailService;

	/**
	 * 网站访问url
	 */
	//@Value("${webHost}")
	protected String webHost;
	@Value("${systemName}")
	protected String systemName;
	//@Value("${orderEmail}")
	protected String orderEmail;

	/**
	 * 登陆 
	 * @return 登陆者信�?
	 */
	public Manager login(String login, String password) {
		return managerDao.login(login, password);
	}

	public int count地块() {
		return e地块Dao.count();
	}
	public int query地块Count(E地块 search) {
		return e地块Dao.queryCount(search);
	}
	public List<E地块> query地块(E地块 search, ResultView view) {
		return e地块Dao.query(search, view);
	}
	public E地块 get地块ById(int id) {
		return e地块Dao.getById(id);
	}
	public E地块 get地块By地块编码(String 地块编码) {
		return e地块Dao.getBy地块编码(地块编码);
	}
	public void add地块(E地块 地块) {
		e地块Dao.add(地块);
	}
	public void update地块(E地块 地块) {
		e地块Dao.update(地块);
	}
	public void delete地块ById(int id) {
		e地块Dao.deleteById(id);
	}

	@Transactional
	public void updateCustomerTenantId(int id, String tenantId) {
		Customer customer = customerDao.getById(id);
		if (customer == null)
			throw new RuntimeException("not found.");
		
		customer.setTenantId(tenantId);
		customerDao.update(customer);
	}

	public int countDealer() {
		return dealerDao.count();
	}

	public int queryDealerCount(Dealer search) {
		return dealerDao.queryCount(search);
	}

	public List<Dealer> queryDealer(Dealer search, ResultView view) {
		return dealerDao.query(search, view);
	}
	
	public Dealer getDealerById(int id) {
		return dealerDao.getById(id);
	}

	@Transactional
	public void addDealer(Dealer dealer) {
		Dealer check = dealerDao.getByLogin(dealer.getLogin());
		if (check != null)
			throw new RuntimeException("login exists.");

		dealer.setCreateDate(new Date());
		dealer.setModifyDate(null);
		dealer.setStatus(Dealer.Status.NORMAL.ordinal());

		dealerDao.add(dealer);
	}

	@Transactional
	public void updateDealer(Dealer dealer) {
		Dealer dbDealer = dealerDao.getById(dealer.getId());
		if (dbDealer == null)
			throw new RuntimeException("not found.");

		dbDealer.setName(dealer.getName());
		dbDealer.setEmail(dealer.getEmail());
		dbDealer.setPhone(dealer.getPhone());
		dbDealer.setMobile(dealer.getMobile());
		dbDealer.setRemarks(dealer.getRemarks());
		
		final String pwd = dealer.getPassword();
		if (!StringUtils.isNullOrEmpty(pwd)) {
			dbDealer.setPassword(pwd);
		}
		
		dbDealer.setModifyDate(new Date());
		dealerDao.update(dbDealer);
	}

	@Transactional
	public void deleteDealerById(int id) {
		Dealer dbDealer = dealerDao.getById(id);
		if (dbDealer == null)
			throw new RuntimeException("not found.");
		dealerDao.deleteById(id);
	}

	public int countOrder() {
		return orderDao.count();
	}

	public int queryOrderInfoCount(OrderInfo search) {
		return orderDao.queryCount(search);
	}

	public List<OrderInfo> queryOrderInfo(OrderInfo search, ResultView view) {
		return orderDao.query(search, view);
	}

	public Order getOrderById(int id) {
		return orderDao.getById(id);
	}
	
	public List<String> getKeysOfOrder(int orderId) {
		return orderDao.getKeysOfOrder(orderId);
	}
	
	public int countLicense() {
		return licenseDao.count();
	}

	public int queryLicenseCount(License search) {
		return licenseDao.queryCount(search);
	}

	public List<License> queryLicense(License search, ResultView view) {
		return licenseDao.query(search, view);
	}

	public void addLicenseByKeys(List<String> keys) {
		licenseDao.addByKeys(keys, new Date());
	}
	
	@Transactional
	public void confirmOrder(int id) {
		Order order = orderDao.getById(id);
		if (order == null)
			throw new RuntimeException("not found.");
		if (order.getStatus() != Order.Status.NEW.ordinal())
			throw new RuntimeException("Invalid order status.");
		
		Customer customer = customerDao.getById(order.getCustomerId());
		if (customer == null)
			throw new RuntimeException("not found.");
		if (StringUtils.isNullOrEmpty(customer.getTenantId()))
			throw new RuntimeException("No tenant ID.");
		
		order.setStatus(Order.Status.CONFIRMED.ordinal());
	
		orderDao.update(order);
	}
	
	@Transactional
	public void finishOrder(int id) {
		Order order = orderDao.getById(id);
		if (order == null)
			throw new RuntimeException("not found.");
		if (order.getStatus() != Order.Status.CONFIRMED.ordinal())
			throw new RuntimeException("Invalid order status.");
		
		Customer customer = customerDao.getById(order.getCustomerId());
		if (customer == null)
			throw new RuntimeException("not found.");
		if (StringUtils.isNullOrEmpty(customer.getTenantId()))
			throw new RuntimeException("No tenant ID.");
		
		List<String> keys = orderDao.getKeysOfOrder(id);
		List<License> liclist = licenseDao.getByKeys(keys);
		for (License lic : liclist) {
			lic.setStatus(License.Status.CONSUMED.ordinal());
		}
		licenseDao.update(liclist);
		
		order.setStatus(Order.Status.FINISHED.ordinal());
		orderDao.update(order);
	}

	@Transactional
	public void discardOrder(int id) {
		Order order = orderDao.getById(id);
		if (order == null)
			throw new RuntimeException("not found.");
		if (order.getStatus() == Order.Status.FINISHED.ordinal() ||
				order.getStatus() == Order.Status.DISCARDED.ordinal())
			throw new RuntimeException("Invalid order status.");
		
		List<String> keys = orderDao.getKeysOfOrder(id);
		List<License> liclist = licenseDao.getByKeys(keys);
		for (License lic : liclist) {
			lic.setStatus(License.Status.FREE.ordinal());
		}
		licenseDao.update(liclist);
		
		order.setStatus(Order.Status.DISCARDED.ordinal());
		orderDao.update(order);
	}

	public void sendDealerCreatedMail(String email, String login, String password) {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd�?");
		String date = sdf.format(new Date());
		String templatePath = this.getClass().getResource("/template/dealer_create.ftl").getPath();
		String title = "账号已经创建-" + systemName;
		String url = webHost + "/d/login";

		Map<String, Object> params = Maps.newHashMap();
		params.put("systemName", systemName);
		params.put("loginName", login);
		params.put("password", password);
		params.put("websiteDealerUrl", url);
		params.put("date", date);
		try {
			emailService.sendTemplateMail(email, title, false,
					templatePath, params);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void sendPOMail(Order order, File attachPDF) {

		String templatePath = this.getClass().getResource("/template/po_confirm.ftl").getPath();
		String poNumber = order.getPoNumber();
		String title = "CCN Purchase order to NT-ware (uniFLOW online) - " + poNumber;

		Map<String, Object> params = Maps.newHashMap();
		params.put("poNumber", poNumber);
		try {
			emailService.sendTemplateMail(orderEmail, title, true,
					templatePath, params, attachPDF);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
