package com.jingyan.agri.common.filter;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.jingyan.agri.common.manager.Constant;
import com.jingyan.agri.common.utils.GetBeanUtil;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Manager;
import com.jingyan.agri.modules.sys.LoginParams;
import com.jingyan.agri.service.DealerService;
import com.jingyan.agri.service.ManagerService;

import lombok.val;

@Component
public class SecurityFilter implements Filter {

	@Value("${filter.unInterceptUrl}")
	private String unInterceptUrl;
	private String[] unInterceptUrls;

	public void init(FilterConfig filterConfig) throws ServletException {
		if (!StringUtils.isEmpty(unInterceptUrl)) {
			this.unInterceptUrls = unInterceptUrl.split(",");
		}
	} 
	
	public void destroy() {
	}

	public void doFilter(ServletRequest pRquest, ServletResponse pResponse,
			FilterChain filterChain) throws IOException, ServletException {
		
  		HttpServletRequest request = (HttpServletRequest)pRquest;
		HttpServletResponse response = (HttpServletResponse)pResponse;
		
		String url = request.getServletPath();

		boolean isInterceptFlg = false;

		for (int i = 0; i < unInterceptUrls.length; i++) {
			if (url.toLowerCase().startsWith(unInterceptUrls[i].toLowerCase())) {
				isInterceptFlg = true;
				break;
			}
		}
		
		if (!isInterceptFlg) {
			val params =
					(LoginParams) request.getSession().getAttribute(Constant.SYS_LOGIN);

			if (url.toLowerCase().startsWith("/sys")) {

				if (params == null || !params.getIsAdmin()) {
					pageTo(request, response, "/login");
					return;
				}

				ManagerService managerService = GetBeanUtil.getBean("managerServiceImpl");
				Manager result = managerService.login(params.getUserName(), params.getPassword());
				if (result == null) {
					pageTo(request, response, "/login");
					return;
				}
			}
			
			else {// if (url.toLowerCase().startsWith("/dealer/")) {

				if (params == null || params.getIsAdmin()) {
					pageTo(request, response, "/login");
					return;
				}
				DealerService dealerService = GetBeanUtil.getBean("dealerServiceImpl");
				Dealer result = dealerService.login(params.getUserName(), params.getPassword());
				if (result == null) {
					pageTo(request, response, "/login");
					return;
				}
			}
		}
		
		filterChain.doFilter(request, response);
	}
	
	private void pageTo(HttpServletRequest request, HttpServletResponse response,
			String loginPath) throws IOException {
		boolean isAjaxRequest = isAjaxRequest(request);

		if (isAjaxRequest) {
			response.setHeader("msgType", Constant.FAIL_FLG);
		} else {
			PrintWriter out = response.getWriter();

			out.write("<script type='text/javascript'>"
			 		+ "window.parent.frames.location.href = "
			 		+ "'" + request.getContextPath() + loginPath + "';</script>"); 
		}

		return;
	}

	private boolean isAjaxRequest(HttpServletRequest request) {
	    String requestedWithHeader = request.getHeader("X-Requested-With");
	    return "XMLHttpRequest".equals(requestedWithHeader);
	}
}