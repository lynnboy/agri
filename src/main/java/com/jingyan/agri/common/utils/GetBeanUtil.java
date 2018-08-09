/******************************************************
* (c) Copyright CIB 2017
* Function : 浠巗pring瀹瑰櫒涓幏鍙朆ean鐨勫叡閫氱被
* Author : Guoyanbin
* Date : 2017-10-19
*******************************************************/
package com.jingyan.agri.common.utils;

import org.apache.commons.lang3.Validate;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

/**
 * 浠巗pring瀹瑰櫒涓幏鍙朆ean鐨勫叡閫氱被
 * 
 * @author Guoyanbin
 * @version V1.0
 */
@Component
@Lazy(false)
public class GetBeanUtil implements ApplicationContextAware, DisposableBean {

	private static ApplicationContext applicationContext = null;

	/**
	 * 鍙栧緱鍌ㄥ瓨鍦ㄩ潤鎬佸彉閲忎腑鐨剆pring瀹瑰櫒
	 */
	public static ApplicationContext getApplicationContext() {
		assertContextInjected();
		return applicationContext;
	}

	/**
	 * 浠庡鍣ㄨ幏寰桞ean瀵硅薄
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getBean(String name) {
		assertContextInjected();
		return (T) applicationContext.getBean(name);
	}

	/**
	 * 浠庨潤鎬佸彉閲廰pplicationContext涓彇寰桞ean, 鑷姩杞瀷涓烘墍璧嬪�煎璞＄殑绫诲瀷.
	 */
	public static <T> T getBean(Class<T> requiredType) {
		assertContextInjected();
		return applicationContext.getBean(requiredType);
	}

	/**
	 * 娓呴櫎GetBeanUtil涓殑ApplicationContext涓篘ull.
	 */
	public static void clearHolder() {
		applicationContext = null;
	}

	/**
	 * 瀹炵幇ApplicationContextAware鎺ュ彛, 娉ㄥ叆Context鍒伴潤鎬佸彉閲忎腑.
	 */
	public void setApplicationContext(ApplicationContext applicationContext) {
		setApplicationContextvalue(applicationContext);
	}

	/**
	 * 瀹炵幇ApplicationContextAware鎺ュ彛, 娉ㄥ叆Context鍒伴潤鎬佸彉閲忎腑.
	 */
	public static void setApplicationContextvalue(ApplicationContext applicationContext) {

		GetBeanUtil.applicationContext = applicationContext;

	}
	
	/**
	 * 瀹炵幇DisposableBean鎺ュ彛, 鍦–ontext鍏抽棴鏃舵竻鐞嗛潤鎬佸彉閲�.
	 */
	public void destroy() throws Exception {
		GetBeanUtil.clearHolder();
	}

	/**
	 * 妫�鏌pplicationContext涓嶄负绌�.
	 */
	private static void assertContextInjected() {
		Validate.validState(applicationContext != null, "绯荤粺閿欒锛宻pring瀹瑰櫒鏈垵濮嬪寲");
	}
}