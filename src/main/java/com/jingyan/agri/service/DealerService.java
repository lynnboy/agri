package com.jingyan.agri.service;

import java.util.Collection;
import java.util.List;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.entity.Customer;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;
import com.jingyan.agri.entity.sys.Dealer;

public interface DealerService {

	Dealer login(String login, String hashedPassword); 

	int countCustomer(Dealer dealer);
	int queryCustomerCount(Customer search, Dealer dealer);
	List<Customer> queryCustomer(Customer search, ResultView view, Dealer dealer);
	Customer getCustomerById(int id, Dealer dealer);
	void addCustomer(Customer customer, Dealer dealer);
	void updateCustomer(Customer customer, Dealer dealer);
	void deleteCustomerById(int id, Dealer dealer);

	int countOrder(Dealer dealer);
	int queryOrderInfoCount(OrderInfo search, Dealer dealer);
	List<OrderInfo> queryOrderInfo(OrderInfo search, ResultView view, Dealer dealer);
	void addOrder(Order order, Collection<String> keys, Dealer dealer);
	Order getOrderById(int id, Dealer dealer);
	List<String> getKeysOfOrder(Integer id);
	void discardOrder(int id, Dealer dealer);

	void sendOrderCreatedMail(Order order, Dealer dealer);

}
