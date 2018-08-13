package com.jingyan.agri.common.aop;

import org.aspectj.lang.ProceedingJoinPoint;
//import org.aspectj.lang.annotation.Around;
//import org.aspectj.lang.annotation.Aspect;
//import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j2;

@Component
//@Aspect
@Log4j2
public class Log {
	
//	@Pointcut("execution(public * com.jingyan.agri.service..*.*(..))")
    public void recordLog(){}
	
	/**
	 * 给所有service层加上方法开始和结束log
	 * @param pjp
	 * @throws Throwable
	 */
//	@Around("recordLog()")
	public Object around(ProceedingJoinPoint pjp) throws Throwable {
		// 代理对象
		String strClassName = pjp.getTarget().getClass().getName();
		
		// 执行方法名
		String strMethodName = pjp.getSignature().getName();
		
		if (log.isDebugEnabled()) {
			log.debug(strClassName + ":" + strMethodName + " is start");
		}
		
		// 返回结果
	    Object o = pjp.proceed();
	    
	    if (log.isDebugEnabled()) {
			log.debug(strClassName + ":" + strMethodName + " is end");
		}
	    return o;
	}
}
