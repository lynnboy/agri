<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${proj.name}</title>
<%@include file="/WEB-INF/views/common/header.jsp"%>
</head>
<body>
	<div class="container-fluid">
		<div class="page-header">
			<h1>项目 <strong>${proj.name}</strong> 没有可以查看的数据。</h1>
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

