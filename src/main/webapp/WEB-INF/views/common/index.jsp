<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>客户授权管理系统</title>
<%@include file="/WEB-INF/views/common/header.jsp"%>
</head>
<body>
<div>
    <ul>
	   <li><a href="${base}/d/login">dealer入口 </a></li>
       <li><a href="${base}/s/login">管理员入口</a></li>      
    </ul>
    <ul>
	   <li>projId: ${projId}</li>
       <li>actionId: ${actionId}</li>      
    </ul>
</div>	
</body>
</html>
