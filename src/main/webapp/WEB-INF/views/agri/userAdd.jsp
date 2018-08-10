<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>代理商${isAdd?"添加":"修改"}</title>

<script type="text/javascript">
$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
			login: { required: true, login: true },
			password: { required: true, passwordStrength: true, },
			confirmNewPassword: { required: true, equalTo: '#newPassword' },
			name: 'required',
			email: { required: true, email: true },
			phone: 'phone',
			mobile: 'mobile',
		},
		messages: {
			login: { required: '请填写登录名' },
			password: { required: '请填写密码' },
			confirmNewPassword: { required: '请填写密码', equalTo: "请填写相同的密码" },
			name: '请填写代理商名',
			email: { required: '请填写邮箱', email: '邮箱格式不正确' },
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
		<li><a href="${base}/sys/userList">代理商列表</a></li>
		<li class="active"><a href="${base}/sys/${action}">代理商${isAdd?"添加":"修改"}</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${dealer.id}" />
		
		
		<div class="control-group">
			<label for="loginName" class="control-label">登录名:</label>
			<div class="controls">
<c:choose>
	<c:when test="${isAdd}">
				<input id="loginName" name="login" class="required userName" style="ime-mode:disabled"
					type="text" value="" maxlength="50" /> <span class="help-inline"><font
					color="red">*</font> </span>
	</c:when>
	<c:otherwise>
				<input id="loginName" name="" class="required userName"
					disabled type="text" value="${dealer.login}" maxlength="50" />
	</c:otherwise>
</c:choose>
			</div>
		</div>
		<div class="control-group">
			<label for="newPassword" class="control-label">密码:</label>
			<div class="controls">
				<input id="newPassword" name="password" type="password" value=""
					maxlength="50" autocomplete="off" minlength="6" class="required" /> <span
					class="help-inline"><font color="red">*</font> </span>

			</div>
		</div>
		<div class="control-group">
			<label for="confirmNewPassword" class="control-label">确认密码:</label>
			<div class="controls">
				<input id="confirmNewPassword" name="confirmNewPassword"
					type="password" autocomplete="off" value="" maxlength="50" minlength=""
					equalTo="#newPassword" /> <span class="help-inline"><font
					color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">代理商名:</label>
			<div class="controls">
				<input id="name" name="name" class="required" type="text" value="${dealer.name }"
					maxlength="50" /> <span class="help-inline"><font
					color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="email" class="control-label">邮箱:</label>
			<div class="controls">
				<input id="email" name="email" class="required email" type="text" value="${dealer.email}"
					maxlength="100" /> <span class="help-inline"><font
					color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="phone" class="control-label">电话:</label>
			<div class="controls">
				<input id="phone" name="phone" type="text" value="${dealer.phone}" maxlength="100" />
			</div>
		</div>
		<div class="control-group">
			<label for="mobile" class="control-label">手机:</label>
			<div class="controls">
				<input id="mobile" name="mobile" type="text" value="${dealer.mobile}"
					maxlength="100" />
			</div>
		</div>
		<div class="control-group">
			<label for="remarks" class="control-label">备注:</label>
			<div class="controls">
				<textarea id="remarks" name="remarks" maxlength="200"
					class="input-xlarge" rows="3">${dealer.remarks}</textarea>
			</div>
		</div>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="保 存" />&nbsp; <input id="btnCancel" class="btn" type="button"
				value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>