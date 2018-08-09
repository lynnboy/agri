package com.jingyan.agri.common.manager;

public class Constant {
	
	// ***********************系统*****************************
	public static final String SYS_LOGIN = "sysLogin";
	public static final String SYS_LOGIN_USER = "sysLoginUser";
	public static final String SYS_LOGIN_ADMIN = "sysLoginAdmin";

	public static final String VALIDATE_CODE = "validateCode"; // 用户输入验证码接收的参数
	// 0:解禁 1:禁用 
	public static final String FRZEE_LOCK = "1";
	public static final String FRZEE_UNLOCK = "0";
	
	public static final String FAIL_FLG = "0"; // 失败
	public static final String SUCCESS_FLG = "1"; // 成功
	// 读取信息不正时msg
	public static final String SYS_PRO_ERR = "配置信息不正确，请确认配置文件";
	
	// ************************** Token ********************** 
	public static final String CSRF_TOKEN = "token"; // 失败
	
	// **************** email 设定 ****************
	// 发件邮箱的server
	public static final String MAIL_SERVER = "mail.server";

	// server端口
	public static final String MAIL_PORT = "mail.port";

	// 默认端口号
	public static final int MAIL_DEFAULT_PORT = 25;
	// 发件邮箱
	public static final String MAIL_SENDER = "mail.sender";
	// 编码格式
	public static final String MAIL_CHARSET = "mail.charset";
	// 发件邮箱user登陆名
	public static final String MAIL_USERNAME = "mail.username";
	// 发件邮箱user密码
	public static final String MAIL_PASSWORD = "mail.password";
	// 发件邮箱用户昵称
	public static final String MAIL_NICKNAME = "mail.nickname";
	// 邮件发送成功1
	public static final int SEND_SUCCESS_FLG = 1;
	// email 模板格式
	public static final String MAIL_CONTEXT = "text/html;charset=UTF-8";
	// email 模板读写时所用语言
	public static final String MAIL_LOCALE = "Zh_cn";

	public static final int MM_PER_PACKAGE = 60;

	public static final String MAIL_ARCHIVE = "mail.archive";
}
