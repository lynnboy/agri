/******************************************************
 * (c) Copyright CIB 2017
 * Function : 身份令牌验证器
 * Author : Guoyanbin
 * Date : 2017-10-19
 ********************************************************/
package com.jingyan.agri.common.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 身份令牌验证器
 * @author Guoyanbin
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Token {
	
	/**
	 * 保存token的方法
	 * @return
	 */
	boolean init() default false;

	/**
	 * token
	 * @return
	 */
    boolean validate() default false;
}
