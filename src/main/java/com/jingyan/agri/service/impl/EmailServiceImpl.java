package com.jingyan.agri.service.impl;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.stereotype.Service;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;

import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.service.BaseService;
import com.jingyan.agri.service.EmailService;

import freemarker.template.Configuration;
import freemarker.template.Template;
import lombok.extern.log4j.Log4j2;

//@Service
@Log4j2
public class EmailServiceImpl extends BaseService implements EmailService {

	// 发件邮箱的server
	private String strServer;
	// server端口
	private int intPort;
	// 发件邮箱
	private String strSender;
	// 编码格式
	private String strCharset;
	// 发件邮箱user登陆名
	private String strUsername;
	// 发件邮箱user密码
	private String strPassword;
	// 发件邮箱用户昵称
	private String strNickname;
	
	private String strArchive;

	public EmailServiceImpl() throws Exception {
		InputStream in = null;
		try {
			Properties pros = new Properties();
			in = EmailServiceImpl.class.getResourceAsStream("/canon.properties");
			pros.load(in);
			strServer = pros.getProperty(Constant.MAIL_SERVER);
			if (pros.getProperty(Constant.MAIL_PORT) != null) {
				intPort = Integer.valueOf(pros.getProperty(Constant.MAIL_PORT));
			} else {
				// 默认端口号
				intPort = Constant.MAIL_DEFAULT_PORT;
			}
			strSender = pros.getProperty(Constant.MAIL_SENDER);
			strCharset = pros.getProperty(Constant.MAIL_CHARSET);
			strUsername = pros.getProperty(Constant.MAIL_USERNAME);
			strPassword = pros.getProperty(Constant.MAIL_PASSWORD);
			strNickname = pros.getProperty(Constant.MAIL_NICKNAME);
			strArchive = pros.getProperty(Constant.MAIL_ARCHIVE);
		} catch (Exception ex) {
			log.error(Constant.SYS_PRO_ERR, ex);
			throw ex;
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * 发送模板邮件
	 * 
	 * @param toMailAddr 收信人地址
	 * @param subject email主题
     * @param templatePath 模板地址
	 * @param msgBodyparam 模板参数
	 * @throws Exception 抛出异常
	 */
	public void sendTemplateMail(String toMailAddr, String subject,
			boolean ccToArchive,
			String templatePath, Map<String, Object> msgBodyparam,
			File ... attachments) throws Exception {
		if (log.isDebugEnabled()) {
			log.debug("param toMailAddr is " + toMailAddr);
		}
		Template template = null;
		Configuration freeMarkerConfig = null;
		HtmlEmail hemail = new HtmlEmail();
		hemail.setHostName(strServer);
		hemail.setSmtpPort(intPort);
		hemail.setCharset(strCharset);
		hemail.addTo(toMailAddr);
		if (ccToArchive)
			hemail.addCc(strArchive);
		hemail.setFrom(strSender, strNickname);
		hemail.setAuthentication(strUsername, strPassword);
		hemail.setSubject(subject);

		freeMarkerConfig = new Configuration(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS);
		File file = new File(templatePath);
		freeMarkerConfig.setDirectoryForTemplateLoading(new File(file.getParent()));
		// 获取模板
		template = freeMarkerConfig.getTemplate(file.getName(),
				new Locale(Constant.MAIL_LOCALE), strCharset);
		// 模板内容转换为string

		String htmlText = FreeMarkerTemplateUtils
				.processTemplateIntoString(template, msgBodyparam);
		hemail.setHtmlMsg(htmlText);

		for (File attachfile : attachments) {
			EmailAttachment attachment = new EmailAttachment();
			attachment.setPath(attachfile.getPath());
			attachment.setDisposition(EmailAttachment.ATTACHMENT);
			attachment.setDescription(attachfile.getName());
			attachment.setName(attachfile.getName());
			hemail.attach(attachment);
		}
		
		hemail.send();
		if (log.isDebugEnabled()) {
			log.debug("send Email success to " + toMailAddr);
		}
	}
	
	/**
	 * 发送普通邮件
	 * 
	 * @param toMailAddr 收信人地址
	 * @param title email主题
	 * @param messageBody 发送email信息
	 * @throws Exception 抛出异常
	 */
	public void sendCommonMail(String toMailAddr, String title,
			String messageBody) throws Exception {
		if (log.isDebugEnabled()) {
			log.debug("param toMailAddr is " + toMailAddr);
		}
		HtmlEmail hemail = new HtmlEmail();
		hemail.setHostName(strServer);
		hemail.setSmtpPort(intPort);
		hemail.setCharset(strCharset);
		hemail.addTo(toMailAddr);
		hemail.setFrom(strSender, strNickname);
		hemail.setAuthentication(strUsername, strPassword);
		hemail.setSubject(title);
		hemail.setContent(messageBody, Constant.MAIL_CONTEXT);
		hemail.send();
		if (log.isDebugEnabled()) {
			log.debug("send Email success to " + toMailAddr);
		}
	}
}