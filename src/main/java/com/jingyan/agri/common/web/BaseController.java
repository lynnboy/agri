package com.jingyan.agri.common.web;

import java.beans.PropertyEditorSupport;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;

public class BaseController {

	public Logger log = LogManager.getLogger(getClass());  

	@Value("${password.salt}")
	protected String salt;
	
//	@ExceptionHandler({Throwable.class})
//    public String exceptionHandler(Throwable e)  {  
//		logger.error("Exception",e);
//        return "error/500";
//    }
	@ExceptionHandler({Throwable.class})
    public ResponseEntity<Map<?,?>> exceptionHandler(Throwable e)  {  
		log.error("Exception",e);

		Map<String, Object> map = new HashMap<>();
		if (e instanceof RuntimeException) {
			map.put("error", e.getMessage());
		}
		else {
			map.put("error", "系统出现异常，暂时无法访问，请您稍后再试！");
		}
		ResponseEntity<Map<?,?>> res = new ResponseEntity<>(map, HttpStatus.INTERNAL_SERVER_ERROR);
		return res;
        //return new ResponseEntity<>(map, HttpStatus.INTERNAL_SERVER_ERROR);
	}
    	
	/**
	 * 1.将所有传递进来的String进行HTML编码，防止XSS攻击
	 * 2.初始化参数
	 * @param binder
	 */
	//@InitBinder
	protected void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(String.class, new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) {
				
				// 对输入端字符进行过滤
				setValue(StringEscapeUtils.escapeHtml4(text));
			}
			
			@Override
			public String getAsText() {
				String value = Objects.toString(getValue(), "");

				// 对特殊字符进行过滤
				return StringEscapeUtils.escapeHtml4(value);
			}
		});
		
		binder.registerCustomEditor(Date.class, new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) {
				SimpleDateFormat sdf = new SimpleDateFormat();
				try {
					setValue(sdf.parse(text));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			
			@Override
			public String getAsText() {
				Object value = getValue();
				return value != null ? value.toString() : "";
			}
		});
	}
}
