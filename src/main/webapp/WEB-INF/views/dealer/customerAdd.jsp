<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>客户${isAdd?"添加":"修改"}</title>

<script type="text/javascript">
$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
			name: 'required',
			contactName: 'required',
			contactEmail: { required: true, email: true },
			contactPhone: 'required',
			address: 'required'
		},
		messages: {
			name: '请填写客户名称',
			contactName: '请填写联系人姓名',
			contactEmail: { required: '请填写联系人邮箱', email: '邮箱格式不正确' },
			contactPhone: '请填写联系人电话',
			address: '请填写地址'
		},
		unhighlight: function(el, err, valid) {
			var g = $(el).closest('.control-group');
			g.removeClass('error');
		},
		highlight: function (el, err, valid) {
			$(el).closest('.control-group').addClass('error');
		},
	});
});
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/dealer/customerList">客户列表</a></li>
		<li class="active"><a href="${base}/dealer/${action}">客户${isAdd?"添加":"修改"}</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/dealer/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${customer.id}" />

		<div class="alert alert-info "><span class="icon-info-sign"></span> 请填写最终客户的相关信息，而非经销商的信息。</div>

		<div class="control-group">
			<label for="name" class="control-label">客户名称:</label>
			<div class="controls">
				<input id="name" name="name" class="required userName" type="text"
					value="${customer.name}" maxlength="50" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="newPassword" class="control-label">客户ID:</label>
			<div class="controls">
				<input id="tenantId" name="tenantId" type="text" disabled
					value="${customer.tenantId}" class="required" maxlength="50" minlength="3" />
			</div>
		</div>
		<div class="control-group">
			<label for="contactName" class="control-label">联系人姓名:</label>
			<div class="controls">
				<input id="contactName" name="contactName" class="required" type="text"
					value="${customer.contactName}" maxlength="50" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="contactEmail" class="control-label">联系人邮箱:</label>
			<div class="controls">
				<input id="contactEmail" name="contactEmail" class="required email" type="text"
					value="${customer.contactEmail}" maxlength="100" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="contactPhone" class="control-label">联系人电话:</label>
			<div class="controls">
				<input id="contactPhone" name="contactPhone" type="text" class="required"
					value="${customer.contactPhone}" maxlength="100" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<!-- 
		<div class="control-group">
			<label for="contactDivision" class="control-label">所属部门:</label>
			<div class="controls">
				<input id="contactDivision" name="contactDivision" type="text" class="required"
					value="${customer.contactDivision}" maxlength="100" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		 -->
		<div class="control-group">
			<label for="address" class="control-label">地址:</label>
			<div class="controls">
				<textarea id="address" name="address" maxlength="200"
					class="input-xlarge" rows="3">${customer.address}</textarea>
				<span class="help-inline"><font color="red">*</font> </span>
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