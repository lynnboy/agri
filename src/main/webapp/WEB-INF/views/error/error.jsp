<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>客户授权管理系统</title>
<%@include file="/WEB-INF/views/common/header.jsp"%>
</head>
<body>
	<div class="container-fluid">
		<div class="page-header">
			<h1>系统出现异常，暂时无法访问，请您稍后再试！</h1>
		</div>
		<div>
			<a href="javascript:" onclick="history.go(-1);" class="btn">返回上一页</a>
		</div>
		<script>
			try {
				top.$.jBox.closeTip();
			} catch (e) {
			}
		</script>
	</div>
</body>
</html>

