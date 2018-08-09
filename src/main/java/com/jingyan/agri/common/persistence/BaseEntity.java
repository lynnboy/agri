/******************************************************
* (c) Copyright CIB 2015
* Function : Entity基础类
* Author : Zhu Xingang, NRI
* Date : 2015-05-19
********************************************************/
package com.jingyan.agri.common.persistence;

import java.io.Serializable;

import com.jingyan.agri.common.utils.JsonUtils;

/**
 * Entity基础类
 * @author Administrator
 *
 * @param <T>
 */
public abstract class BaseEntity<T extends BaseEntity<T>> implements Serializable {

	private static final long serialVersionUID = 1L;
	
	public static <T extends BaseEntity<T>> T fromJson(String text, Class<T> clazz) {
		return JsonUtils.deserialize("{}", clazz).fromJson(text);
	}
	
	@SuppressWarnings("unchecked")
	public T fromJson(String text) {
		BaseEntity<T> t = JsonUtils.deserialize(text, getClass());
		return (T)t;
	}
	
	public String toJson() {
		return JsonUtils.serialize(this);
	}
	@Override
	public String toString() {
		return toJson();
	}
}
