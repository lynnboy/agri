package com.jingyan.agri.common.security;

import java.io.IOException;
import java.lang.reflect.Method;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.utils.IdGen;

@Component
public class CsrfAndRepeatInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 在方法开始前执行的方法
	 * @param request http请求 
	 * @param response http响应
	 * @param handler 参数绑定Object
	 */
	 @Override
     public boolean preHandle(HttpServletRequest request, 
    		 HttpServletResponse response, Object handler) throws Exception {
         if (!(handler instanceof HandlerMethod)) {
             return super.preHandle(request, response, handler);
         }

         boolean checkTokenFlg = true;
         HandlerMethod handlerMethod = (HandlerMethod) handler;
         
         // 获取method
         Method method = handlerMethod.getMethod();
         
         // 获取注解值
         Token annotation = method.getAnnotation(Token.class);
         if (annotation == null ) {
        	 return checkTokenFlg;
         }

         boolean needSaveSession = annotation.init();
         
         // 获取token值
         String token = (String)request.getSession().getAttribute(Constant.CSRF_TOKEN);
         
         // 如果需要验证token，则往session存放一个token随机数
         if (needSaveSession) {
        	 if (StringUtils.isBlank(token)) {
        		 request.getSession().setAttribute(Constant.CSRF_TOKEN, IdGen.uuid());
        	 }
         }
         
         if (!request.getMethod().equalsIgnoreCase("post")) {
             // 忽略非POST请求
             return true;
         }
         
         // 如果注解remove是true的话，则需要验证服务器端token和客户端是否一致
         boolean needRemoveSession = annotation.validate();
         if (needRemoveSession && !isBadRequest(request)) {
             checkTokenFlg = false;
         }
         
         // 如果验证不通过
         if (!checkTokenFlg) {
        	 pageTo(request,response);
         }

         return checkTokenFlg;
     }

	/**
	  * 验证token方法
	  * @param request http 请求
	  * @return boolean 验证结果
	  */
     private boolean isBadRequest(HttpServletRequest request) {
         String serverToken = (String) request.getSession().getAttribute(Constant.CSRF_TOKEN);
         
         // 如果server端为空的话返回true
         if (serverToken == null ) {
             return true;
         }
         
         // 客户端没有取得token
         String clinetToken = request.getParameter(Constant.CSRF_TOKEN);
          if (clinetToken == null ) {
             return false;
         }
         
         // 客户端取得token了，则验证是否和客户端一致
         if (serverToken.equals(clinetToken)) {
             return true;
         }
         return false;
     } 
     
 	/**
 	 * 如果用户信息出现问题页面跳转 
 	 * @param request Http请求
 	 * @param response Http响应
 	 * @throws IOException 
 	 */
 	private void pageTo(HttpServletRequest request, 
 			HttpServletResponse response) throws IOException {
 		
 		boolean isAjaxRequest = isAjaxRequest(request);

 		// 验证失败
 		if (isAjaxRequest) {
 			response.setHeader(Constant.CSRF_TOKEN, Constant.FAIL_FLG);
 		} else {
 			response.sendRedirect("/system/error");
 		}
 		return;
 	}
 	
 	/**
 	 * 判断是否是ajax请求
 	 * @param request Http请求
 	 */
 	private boolean isAjaxRequest(HttpServletRequest request) {
         //判断session里是否有用户信息  
         if (request.getHeader("x-requested-with") != null  
                 && request.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")) {  
             return true;  
         }  
 		return false;
 	}
}
