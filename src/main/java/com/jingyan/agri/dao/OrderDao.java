/******************************************************
* (c) Copyright CIB 2017
* Function : 系统管理员持久层
* Author : Guoyanbin
* Date : 2017-10-11
********************************************************/
package com.jingyan.agri.dao;

import java.util.Collection;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.Order;
import com.jingyan.agri.entity.OrderInfo;

@Dao("orderDao")
@Mapper
public interface OrderDao {

	int count();
	int queryCount(@Param("search") OrderInfo search);
	List<OrderInfo> query(@Param("search") OrderInfo search,
			@Param("view") ResultView view);
	
	int countForDealer(@Param("dealerId") int dealerId);
	int queryCountForDealer(@Param("dealerId") int dealerId,
			@Param("search") OrderInfo search);
	List<OrderInfo> queryForDealer(@Param("dealerId") int dealerId,
			@Param("search") OrderInfo search,
			@Param("view") ResultView view);

	int countForCustomer(@Param("customerId") int customerId);

	Order getById(@Param("id") int id);
	List<String> getKeysOfOrder(@Param("orderId") int orderId);
	void add(Order order);
	void addKeysToOrder(@Param("orderId") int orderId,
			@Param("keys") Collection<String> keys);
	void update(Order order);
}
