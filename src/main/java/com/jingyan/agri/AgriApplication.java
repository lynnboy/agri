package com.jingyan.agri;

import javax.servlet.Filter;

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
		securityFilter(SecurityFilter securityFilter) {
	    var registration =
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
	public ServletRegistrationBean<ValidateCodeServlet> servletRegistrationBean(){
	    var servlet = new ServletRegistrationBean<>(
	    		new ValidateCodeServlet(), "/servlet/validateCode");
	    servlet.setName("validateCode");
	    return servlet;
	}

	@Bean
	public FilterRegistrationBean<? extends Filter> siteMeshFilter() {

		var filter = new ConfigurableSiteMeshFilter();

	    var registration = new FilterRegistrationBean<>(filter);
	    registration.setName("sitemeshFilter");
	    registration.addUrlPatterns("/*");
	    return registration;
	}

}
