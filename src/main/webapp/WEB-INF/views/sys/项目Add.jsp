<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>代理商${isAdd?"添加":"修改"}</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
			name: 'required',
		},
		messages: {
			name: '请填写项目名称',
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
		<li><a href="${base}/sys/projList">项目列表</a></li>
		<li class="active"><a href="${base}/sys/${action}">${isAdd?"添加":"修改"}项目</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>

<div class="container-fluid">
项目模板：<i class="icon-edit"></i> <strong><c:out value='${temp.name}'/></strong><br>
版本：<i class="icon-list-alt"></i> <strong><c:out value='${temp.version}'/></strong><br>
工作流：
<c:forEach items='${temp.projectInfo.workflow}' var='flow'>
	<span class="label label-info"><c:out value='${temp.projectInfo.stateMap[flow.srcState]}'/></span>
	<span class="label label-success"><c:out value='${temp.projectInfo.actionMap[flow.action]}'/><span class="icon-arrow-right"></span></span>
</c:forEach>

</div>

<p>
<hr>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${proj.id}" />
		
		<div class="control-group">
			<label for="name" class="control-label">项目名称:</label>
			<div class="controls">
				<input id="name" name="name" class="required userName"
					type="text" value="${proj.name}" maxlength="32" />
			</div>
		</div>
		<div class="control-group">
			<label for="remarks" class="control-label">备注:</label>
			<div class="controls">
				<textarea id="desc" name="desc" maxlength="200"
					class="input-xlarge" rows="3">${proj.desc}</textarea>
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