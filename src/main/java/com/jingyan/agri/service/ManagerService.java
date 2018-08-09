package com.jingyan.agri.service;

import java.io.File;
import java.util.List;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.dao.sys.DealerDao;
import com.jingyan.agri.dao.sys.ManagerDao;
import com.jingyan.agri.entity.Customer;
import com.jingyan.agri.entity.License;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Manager;

public interface ManagerService {

	public Manager login(String login, String password); 
	
	int countCustomer();
	int queryCustomerCount(Customer search);
	List<Customer> queryCustomer(Customer search, ResultView view);
	Customer getCustomerById(int id);
	void updateCustomerTenantId(int id, String tenantId);

	int countDealer();
	int queryDealerCount(Dealer search);
	List<Dealer> queryDealer(Dealer search, ResultView view);
	Dealer getDealerById(int id);
	void addDealer(Dealer dealer);
	void updateDealer(Dealer dealer);
	void deleteDealerById(int id);

	int countOrder();
	int queryOrderInfoCount(OrderInfo search);
	List<OrderInfo> queryOrderInfo(OrderInfo search, ResultView view);
	Order getOrderById(int id);
	List<String> getKeysOfOrder(int orderId);

	int countLicense();
	int queryLicenseCount(License search);
	List<License> queryLicense(License search, ResultView view);
	void addLicenseByKeys(List<String> keys);

	void confirmOrder(int id);
	void finishOrder(int id);
	void discardOrder(int id);

	void sendDealerCreatedMail(String email, String login, String password);

	void sendPOMail(Order order, File attachPDF);
	
	ManagerDao getManagerDao();
	DealerDao getDealerDao();

}
