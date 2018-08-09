/******************************************************
* (c) Copyright CIB 2015
* Function : DAO支持类組件
* Author : Zhu Xingang, NRI
* Date : 2015-06-08
********************************************************/
package com.jingyan.agri.common.persistence;

import java.util.List;

/**
 * DAO支持类組件
 * @author Administrator
 *
 * @param <T>
 */
public interface CrudDao<T> extends BaseDao {
	
	/**
	 * 获取单条数据
	 * @param entity
	 * @return 数据实体
	 */
	public T get(T entity);
	
	/**
	 * 查询所有数据列表
	 * @return 数据实体集合
	 */
	public List<T> findAll();
	
	/**
	 * 插入数据
	 * @param entity
	 * @return 插入条数
	 */
	public int insert(T entity);
	
	/**
	 * 更新数据
	 * @param entity
	 * @return 更新条数
	 */
	public int update(T entity);
	
	/**
	 * 删除数据
	 * @param entity
	 * @return 删除条数
	 */
	public int delete(T entity);
	
	/**
	 * 获取更新回数
	 * @param entity
	 * @return 更新回数
	 */
	public int findUpdateCnt(T entity);
	
}