package com.jingyan.agri.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.Customer;

@Mapper
public interface CustomerDao {
	int count();
	int queryCount(@Param("search") Customer search);
	List<Customer> query(@Param("search") Customer search,
			@Param("view") ResultView view);

	int countForDealer(@Param("dealerId")int dealerId);
	int queryCountForDealer(@Param("dealerId")int dealerId,
			@Param("search") Customer search);
	List<Customer> queryForDealer(@Param("dealerId")int dealerId,
			@Param("search") Customer search, @Param("view") ResultView view);

	void add(Customer customer);
	Customer getById(int id);
	void update(Customer customer);
	void deleteById(int id);
}
