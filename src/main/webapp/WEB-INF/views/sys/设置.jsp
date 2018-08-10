<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>人员${isAdd?"添加":"修改"}</title>
<script type="text/javascript">
$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
			login: { required: true, login: true },
			password: { passwordStrength: true, },
			confirmNewPassword: { equalTo: '#newPassword' },
			name: 'required',
			email: { required: true, email: true },
			phone: 'phone',
			mobile: 'mobile',
		},
		messages: {
			login: { required: '请填写登录名' },
			password: { required: '请填写密码' },
			confirmNewPassword: { required: '请填写密码', equalTo: "请填写相同的密码" },
			name: '请填写用户名',
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
		<li class="active"><a href="${base}/sys/settings">系统设置</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/settings" method="post">

<c:forEach items="${categories}" var="category">
<h2>${category}</h2>
<hr>

<c:forEach items="${settingMap[category]}" var="setting">
<c:set var="name" value='setting_${setting.id}'/>

		<div class="control-group">
			<label for="${name}" class="control-label">${setting.name}:</label>
			<div class="controls">
				<input id="${name }" name="${name }" type="text" value="${fn:replace(setting.value, '\"', '&quot;')}"
					maxlength="150" class='input-xlarge required' />
					<c:if test="${isAdd}">
					<span class="help-inline"><font color="red">*</font> </span>
					</c:if>

			</div>
		</div>

</c:forEach>

</c:forEach>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="保 存" />&nbsp; <input id="btnCancel" class="btn" type="button"
				value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>