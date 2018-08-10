<%@ include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<html style="overflow-x:auto;overflow-y:auto;">
<head>
	<title><sitemesh:write property='title'/></title>
	<%@include file="/WEB-INF/views/common/header.jsp" %>		
	<sitemesh:write property='head'/>
</head>
<body>
	<sitemesh:write property='body'/>
</body>
</html>