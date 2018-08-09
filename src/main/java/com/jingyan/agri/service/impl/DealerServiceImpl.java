package com.jingyan.agri.service.impl;

import java.text.SimpleDateFormat;
import java.util.Collection;
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
import com.jingyan.agri.dao.LicenseDao;
import com.jingyan.agri.dao.OrderDao;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.entity.Customer;
import com.jingyan.agri.entity.License;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.service.DealerService;
import com.jingyan.agri.service.EmailService;

@Service("dealerServiceImpl")
public class DealerServiceImpl extends BaseService implements DealerService {

	@Autowired
	private DealerDao dealerDao; // 系统管理员组件
	@Autowired
	private CustomerDao customerDao;
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
	//@Value("${managerEmail}")
	protected String managerEmail;

	/**
	 * 登陆 
	 * @return 登陆者信息
	 */
	public Dealer login(String login, String hashedPassword) {
		return dealerDao.login(login, hashedPassword);
	}

	public int countCustomer(Dealer dealer) {
		return customerDao.countForDealer(dealer.getId());
	}

	public int queryCustomerCount(Customer search, Dealer dealer) {
		return customerDao.queryCountForDealer(dealer.getId(), search);
	}

	public List<Customer> queryCustomer(
			Customer search, ResultView view, Dealer dealer) {
		List<Customer> list = customerDao.queryForDealer(dealer.getId(),
				search, view);
//		for(Customer customer : list) {
//			customer.loadContact();
//		}
		return list;
	}

	public Customer getCustomerById(int id, Dealer dealer) {
		Customer customer = customerDao.getById(id);
		if (customer.getDealerId() != (int)dealer.getId())
			throw new RuntimeException("not owning dealer.");
//		customer.loadContact();
		return customer;
	}

	//@Transactional
	public void addCustomer(Customer customer, Dealer dealer) {

		customer.setDealerId(dealer.getId());
		customer.setTenantId(null);
		customer.setCreateDate(new Date());

		customerDao.add(customer);
	}

	@Transactional
	public void updateCustomer(Customer customer, Dealer dealer) {
		Customer dbCustomer = customerDao.getById(customer.getId());
		if (dbCustomer == null)
			throw new RuntimeException("not found.");
		if (dbCustomer.getDealerId() != (int)dealer.getId())
			throw new RuntimeException("not owner dealer.");
		
		dbCustomer.setName(customer.getName());
		dbCustomer.setContactInfo(customer.getContactInfo());
		
		customerDao.update(customer);
	}

	@Transactional
	public void deleteCustomerById(int id, Dealer dealer) {
		Customer customer = customerDao.getById(id);
		if (customer.getDealerId() != (int)dealer.getId())
			throw new RuntimeException("not owning dealer.");
//		int orderCount = orderDao.countForCustomer(id);
		if (customer.isHasOrder())
			throw new RuntimeException("customer having orders.");
		customerDao.deleteById(id);
	}

	public int countOrder(Dealer dealer) {
		return orderDao.countForDealer(dealer.getId());
	}

	public int queryOrderInfoCount(OrderInfo search, Dealer dealer) {
		return orderDao.queryCountForDealer(dealer.getId(), search);
	}

	public List<OrderInfo> queryOrderInfo(OrderInfo search, ResultView view, Dealer dealer) {
		return orderDao.queryForDealer(dealer.getId(), search, view);
	}

	public Order getOrderById(int id, Dealer dealer) {
		Order order = orderDao.getById(id);
		if (order.getDealerId() != (int)dealer.getId())
			throw new RuntimeException("not owning dealer.");
			
		return order;
	}
	
	public List<String> getKeysOfOrder(Integer orderId) {
		return orderDao.getKeysOfOrder(orderId);
	}

	@Transactional
	public void addOrder(Order order, Collection<String> keys, Dealer dealer) {
		
		Customer customer = customerDao.getById(order.getCustomerId());
		if (customer == null)
			throw new RuntimeException("customer not found.");
		if (customer.getDealerId() != (int)dealer.getId())
			throw new RuntimeException("not owning dealer.");

		List<License> liclist = licenseDao.getByKeys(keys);
		if (keys.size() != liclist.size()) {
			throw new RuntimeException("license key error");
		}
		for (License lic : liclist) {
			if (lic.getStatus() != License.Status.FREE.ordinal())
				throw new RuntimeException("license key error");
			lic.setStatus(License.Status.IN_USE.ordinal());
		}

		order.setDealerId(dealer.getId());
		order.setCreateDate(new Date());
		order.setStatus(Order.Status.NEW.ordinal());

		orderDao.add(order);
		orderDao.addKeysToOrder(order.getId(), keys);
		licenseDao.update(liclist);
	}

	@Transactional
	public void discardOrder(int id, Dealer dealer) {
		Order order = orderDao.getById(id);
		if (order == null)
			throw new RuntimeException("not found.");
		if (order.getDealerId() != (int)dealer.getId())
			throw new RuntimeException("not owning dealer.");
		if (order.getStatus() != Order.Status.NEW.ordinal())
			throw new RuntimeException("Invalid order status.");
		
		List<String> keys = orderDao.getKeysOfOrder(id);
		if (keys.size() > 0) {
			List<License> liclist = licenseDao.getByKeys(keys);
			for (License lic : liclist) {
				lic.setStatus(License.Status.FREE.ordinal());
			}
			licenseDao.update(liclist);
		}
		
		order.setStatus(Order.Status.DISCARDED.ordinal());
		orderDao.update(order);
	}

	@Override
	public void sendOrderCreatedMail(Order order, Dealer dealer) {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
		String date = sdf.format(new Date());
		
		Customer customer = this.getCustomerById(order.getCustomerId(), dealer);

		String orderDate = sdf.format(order.getCreateDate());
		String templatePath = this.getClass().getResource("/template/po_request.ftl").getPath();
		String title = "确认订单-" + systemName;
		String url = webHost + "/s/login";

		Map<String, Object> params = Maps.newHashMap();
		params.put("systemName", systemName);
		params.put("dealerName", dealer.getName());
		params.put("customerName", customer.getName());
		params.put("orderDate", orderDate);
		params.put("websiteSysUrl", url);
		params.put("date", date);
		try {
			emailService.sendTemplateMail(managerEmail, title, false,
					templatePath, params);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
