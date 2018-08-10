package com.jingyan.agri;

import javax.servlet.Filter;
import javax.servlet.Servlet;

import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;

import com.jingyan.agri.common.filter.SecurityFilter;
import com.jingyan.agri.common.servlet.ValidateCodeServlet;

@SpringBootApplication
public class AgriApplication {

	public static void main(String[] args) {
		SpringApplication.run(AgriApplication.class, args);
	}

	@Bean
	@Autowired 
	public FilterRegistrationBean<? extends Filter>
		registerSecurityFilter(SecurityFilter securityFilter) {
		FilterRegistrationBean<SecurityFilter> registration =
    			new FilterRegistrationBean<>(securityFilter);
	    registration.setName("securityFilter");
	    registration.addUrlPatterns("/*");
	    return registration;
	}
	@Bean
	public SecurityFilter securityFilter() {
		return new SecurityFilter();
	}

	@Bean
	public ServletRegistrationBean<? extends Servlet> servletRegistrationBean(){
		ServletRegistrationBean<? extends Servlet> servlet =
				new ServletRegistrationBean<>(
						new ValidateCodeServlet(), "/servlet/validateCode");
	    servlet.setName("validateCode");
	    return servlet;
	}

	@Bean
	public FilterRegistrationBean<? extends Filter> registerSiteMeshFilter() {

		Filter filter = new ConfigurableSiteMeshFilter();

		FilterRegistrationBean<? extends Filter> registration =
				new FilterRegistrationBean<>(filter);
	    registration.setName("sitemeshFilter");
	    registration.addUrlPatterns("/*");
	    return registration;
	}

}
