/******************************************************
* (c) Copyright CIB 2017
* Function : 密码加密
* Author : Guoyanbin
* Date : 2017-10-19
********************************************************/
package com.jingyan.agri.common.utils;

import java.security.MessageDigest;

import org.apache.commons.lang3.StringUtils;

/**
 * MD5加密工具类
 * 
 * @author Guoyanbin
 * @version V1.0
 */
public class EncryptUtil {

	/**
	 * MD5加密
	 * 
	 * @param password 密码
	 * @return 加密字符串（密码）
	 */
	public static String encryptPassword(String password) {
		MessageDigest md5 = null;
		try {
			md5 = MessageDigest.getInstance("MD5");
		} catch (Exception e) {
			return StringUtils.EMPTY;
		}
		char[] charArray = password.toCharArray();
		byte[] byteArray = new byte[charArray.length];

		for (int i = 0; i < charArray.length; i++)
			byteArray[i] = (byte) charArray[i];
		byte[] md5Bytes = md5.digest(byteArray);
		StringBuffer hexValue = new StringBuffer();
		for (int i = 0; i < md5Bytes.length; i++) {
			int val = ((int) md5Bytes[i]) & 0xff;
			if (val < 16)
				hexValue.append("0");
			hexValue.append(Integer.toHexString(val));
		}
		return hexValue.toString();
	}
}
