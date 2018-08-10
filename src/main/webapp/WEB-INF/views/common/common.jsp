<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf"%>
<c:set var="baseStatic" value="${pageContext.request.contextPath}"/>
<c:set var="base" value="${pageContext.request.contextPath}"/>
<fmt:bundle basename="application">
<fmt:message key="systemName" var="systemName"/>
</fmt:bundle>
