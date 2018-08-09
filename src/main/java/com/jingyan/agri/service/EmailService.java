package com.jingyan.agri.service;

import java.io.File;
import java.util.Map;

public interface EmailService {

	public void sendTemplateMail(String toMailAddr, String title,
			boolean ccToArchive,
			String templatePath, Map<String, Object> msgBodyparam,
			File ... attachments) throws Exception;
	
	public void sendCommonMail(String toMailAddr, String title,
			String messageBody) throws Exception;
	
}