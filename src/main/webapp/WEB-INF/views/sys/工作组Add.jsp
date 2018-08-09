<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>工作组${isAdd?"添加":"修改"}</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
function fillSelect(sel, list, nestlist) {
	var oldsel = $(sel).val();
	$(sel).find("option").remove();
	$.each(list, function(i, text) {
		$(sel).append($('<option value="' + i + '">'+ text + '</option>'));
	});
	$(sel).val(oldsel);
	if (Array.isArray(nestlist)) {
	  $.each(nestlist, function(_, nest){
		$(sel).change(function(){
			if (nest.cond && !nest.cond()) return;
			var ids = nest.map[$(this).val()];
			var oldval = $(nest.sel).val();
			$(nest.sel).find("option").remove();
			$.each(ids, function(_, i) {
				$(nest.sel).append($('<option value="' + i + '">'+ nest.list[i] + '</option>'));
			});
			$(nest.sel).val(oldval);
			$(nest.sel).change();
			$(nest.sel).valid();
		});
	  });
	}
}
$(document).ready(function() {
	var projList = JSON.parse('${projJsList}');
	var actionList = JSON.parse('${actionJsList}');
	var actionMap = JSON.parse('${actionJsMap}');
	fillSelect("#projId", projList, [
		{ sel: "#action", list: actionList, map: actionMap },
	]);
	
	$("#condkey").change(function(){
		var key = $(this).val();
		if (key == "") {
			$("#condpat").attr("disabled", "disabled");
		} else {
			$("#condpat").removeAttr("disabled");
		}

		var condition = { items: []};
		if (key != "") {
			condition.items.push({key: key, pattern: $("#condpat").val()});
		}
		$("#conditionText").val(JSON.stringify(condition));
	});
	$("#condpat").change(function(){
		var condition = { items: []};
		var key = $("#condkey").val();
		if (key != "") {
			condition.items.push({key: key, pattern: $("#condpat").val()});
		}
		$("#conditionText").val(JSON.stringify(condition));
	});
	
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
			name: '请填写工作组名称',
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
		<li><a href="${base}/sys/wgList">工作组列表</a></li>
		<li class="active"><a href="${base}/sys/${action}">工作组${isAdd?"添加":"修改"}</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${group.id}" />
		<input id="conditionText" name="conditionText" type="hidden" value='${group.conditionText}' />
		
		
		<div class="control-group">
			<label for="name" class="control-label">工作组名称:</label>
			<div class="controls">
				<input id="name" name="name" class="required"
					type="text" value="${group.name}" maxlength="50" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">工作项目:</label>
			<div class="controls">
				<select id="projId" name="projId" class="reqselect">
				<c:set var="projId" value="${group.projId}" scope="request"/>
				<c:forEach items="${projList}" var="proj">
				<option value="${proj.key}"
					<c:if test="${proj.key == group.projId}">selected</c:if>
					>${proj.value}</option>
				</c:forEach>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="action" class="control-label">任务:</label>
			<div class="controls">
				<select id="action" name="action" class="reqselect">
				<c:forEach items="${actionList}" var="action">
				<option value="${action.key}"
					<c:if test="${action.key == group.action}">selected</c:if>
					>${action.value}</option>
				</c:forEach>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="condkey" class="control-label">授权条件:</label>
			<div class="controls">
				<select id="condkey" name="condkey" class="input-small">
				<option value="行政区划"
					<c:if test="${group.condition.items.size() > 0}">selected</c:if>
					>行政区划</option>
				<option value=""
					<c:if test="${group.condition.items.size() == 0}">selected</c:if>
					>无</option>
				</select>
				<input id="condpat" name="condpat" type="text" class="required input-small"
					value='${group.condition.items.size() == 0 ? "" : group.condition.items[0].pattern}'
					<c:if test="${group.condition.items.size() == 0}">disabled</c:if>
					maxlength="30" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="remarks" class="control-label">备注:</label>
			<div class="controls">
				<textarea id="remarks" name="remarks" maxlength="512"
					class="input-xlarge" rows="3">${group.remarks}</textarea>
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