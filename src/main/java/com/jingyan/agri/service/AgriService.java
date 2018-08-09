package com.jingyan.agri.service;

import java.io.File;
import java.util.List;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.entity.E地块;
import com.jingyan.agri.entity.License;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Manager;

public interface AgriService {

	public Manager login(String login, String password); 
	
	int count地块();
	int query地块Count(E地块 search);
	List<E地块> query地块(E地块 search, ResultView view);
	E地块 get地块ById(int id);
	E地块 get地块By地块编码(String 地块编码);
	void add地块(E地块 地块);
	void update地块(E地块 地块);
	void delete地块ById(int id);

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

}
