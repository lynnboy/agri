<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>组织机构${isAdd?"添加":"修改"}</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
			name: 'required',
			addr: 'required',
			phone: 'phone',
			mobile: 'mobile',
		},
		messages: {
			name: '请填写组织机构名称',
			addr: '请填写地址',
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
		<li><a href="${base}/sys/organList">组织机构列表</a></li>
		<li class="active"><a href="${base}/sys/${action}">组织机构${isAdd?"添加":"修改"}</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${organ.id}" />
		<input id="status" name="status" type="hidden" value="${organ.status}" />
		
		<div class="control-group">
			<label for="name" class="control-label">名称:</label>
			<div class="controls">
				<input id="name" name="name" class="required" type="text" value="${organ.name}"
					maxlength="40" /> <span class="help-inline"><font
					color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="desc" class="control-label">描述:</label>
			<div class="controls">
				<input id="desc" name="desc" class="" type="text" value="${organ.desc}"
					maxlength="250" />
			</div>
		</div>
		<div class="control-group">
			<label for="addr" class="control-label">地址:</label>
			<div class="controls">
				<input id="addr" name="addr" class="required" type="text" value="${organ.addr}"
					maxlength="250" /> <span class="help-inline"><font
					color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="phone" class="control-label">电话:</label>
			<div class="controls">
				<input id="phone" name="phone" type="text" value="${dealer.phone}" maxlength="40" />
			</div>
		</div>
		<div class="control-group">
			<label for="postal" class="control-label">邮政编码:</label>
			<div class="controls">
				<input id="postal" name="postal" type="text" value="${dealer.postal}"
					maxlength="40" />
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