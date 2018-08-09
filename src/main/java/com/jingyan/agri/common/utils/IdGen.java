/******************************************************
* (c) Copyright CIB 2017
* Function : 生成ID的共通类
* Author : Guoyanbin
* Date : 2017-10-15
********************************************************/
package com.jingyan.agri.common.utils;

import java.security.SecureRandom;
import java.util.UUID;

import org.apache.commons.lang3.RandomStringUtils;

/**
 * 生成ID的共通类
 * @author Guoyanbin
 * @version V1.0
 */
public class IdGen {

	/** SecureRandom对象*/
	private static SecureRandom random = new SecureRandom();
	
	
	/**
	 * 封装JDK自带的UUID, 通过Random数字生成, 中间无-分割.
	 */
	public static String uuid() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
	
	/**
	 * 生成指定长度的uuid
	 */
	public static String uuid(int length) {
		return UUID.randomUUID().toString().replaceAll("-", "").substring(0,length);
	}
	
	/**
	 * 使用SecureRandom产生任意给定长度的随纯机数字字符串
	 */
	public static String randomLong(int length) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < length; i++) {
			sb.append(Math.abs(random.nextInt(10)));
		}
		return sb.toString();
	}
	
	
	public static String[] chars = new String[] { "a", "b", "c", "d", "e", "f",
        "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",
        "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5",
        "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I",
        "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
        "W", "X", "Y", "Z" };


	/**
	 * 生成八位不相同的英数字
	 * @return String 英数字;
	 */
	public static String generateShortUuid() {
		StringBuffer shortBuffer = new StringBuffer();
		String uuid = UUID.randomUUID().toString().replace("-", "");
		for (int i = 0; i < 8; i++) {
			String str = uuid.substring(i * 4, i * 4 + 4);
			int x = Integer.parseInt(str, 16);
			shortBuffer.append(chars[x % 0x3E]);
		}
		return shortBuffer.toString();
	}
	
	/**
     * 生成一个从0 和 maxValue 之间的一个随机数
     * @param maxValue
     * @return
     */
    public static int getRandomInt(int maxValue) {
        return random.nextInt(maxValue);
    }

	/**
	 * 使用RandomStringUtils(按字母数字顺序随机生成串，包含字母和数字)
	 * 
	 * @return 生成的随机数
	 */
	public static String random(int length) {

		return RandomStringUtils.randomAlphanumeric(length);
	}
}
