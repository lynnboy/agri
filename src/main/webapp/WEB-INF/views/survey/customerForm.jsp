<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>客户修改</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
$(document).ready(function() {
});
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/sys/customerList">客户列表</a></li>
		<li class="active"><a href="${base}/sys/customerForm?id=${customer.id}">客户修改</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/customerForm?id=${customer.id}" method="post">
		<input id="id" name="id" type="hidden" value="${customer.id}" />

		<div class="control-group">
			<label for="loginName" class="control-label">客户名称:</label>
			<div class="controls">
				<input id="loginName" name="name" class="required userName"
					readonly type="text" value="${customer.name}" maxlength="50" />
			</div>
		</div>
		<div class="control-group">
			<label for="tenantId" class="control-label">客户ID:</label>
			<div class="controls">
				<input id="tenantId" name="tenantId" type="text" value="${customer.tenantId}"
					autocomplete="off"
					class="required" maxlength="20" minlength="3" />
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">联系人姓名:</label>
			<div class="controls">
				<input id="name" name="name" class="required" type="text" value="${customer.contact.name}"
					readonly maxlength="50" />
			</div>
		</div>
		<div class="control-group">
			<label for="email" class="control-label">联系人邮箱:</label>
			<div class="controls">
				<input id="email" name="email" class="email" type="text" value="${customer.contact.email}"
					readonly maxlength="100" />
			</div>
		</div>
		<div class="control-group">
			<label for="phone" class="control-label">联系人电话:</label>
			<div class="controls">
				<input id="phone" name="phone" type="text" value="${customer.contact.phone}"
					readonly maxlength="100" />
			</div>
		</div>
		<!-- 
		<div class="control-group">
			<label for="dept" class="control-label">所属部门:</label>
			<div class="controls">
				<input id="dept" name="dept" type="text" value="${customer.contact.division}"
					readonly maxlength="100" />
			</div>
		</div>
		 -->
		<div class="control-group">
			<label for="address" class="control-label">地址:</label>
			<div class="controls">
				<textarea id="address" name="address" maxlength="200"
					readonly class="input-xlarge" rows="3">${customer.contact.address}</textarea>
			</div>
		</div>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="保 存" />&nbsp; <input id="btnCancel" class="btn"
				type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>