<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>种植模式面积</title>

<script type="text/javascript">
function save(data) {
	console.log("save")
}
function ok(data) {
	if ($("#inputForm").valid()) {
		var data = {
			地块编码:'${id}',
			count: $("#count").val(),
			repeat: $("#repeat").val(),
		};
		save(data);
		cancel();
	}
}
function cancel() {
	console.log("cancel")
}
var mode = '${mode}';
$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
		},
		messages: {
		},
		unhighlight: function(el, err, valid) {
			var g = $(el).closest('.control-group');
			g.removeClass('error');
		},
		highlight: function (el, err, valid) {
			$(el).closest('.control-group').addClass('error');
		},
		errorPlacement: function (err, el) {
			if (el.parent().hasClass('input-append')) el = el.siblings().last();
			err.insertAfter(el);
		},
	});
});
</script>
</head>
<body>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal" method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<div class="control-group">
			<label for="count" class="control-label">小区处理数量:</label>
			<div class="controls">
				<input id="count" name="count" type="number" value="3"
				 class="required digits" maxlength="2" min="1" max="26" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="repeat" class="control-label">重复:</label>
			<div class="controls">
				<input id="repeat" name="repeat" type="number" value="3"
				 class="required digits" maxlength="1" min="1" max="9" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="确 定" onclick="ok(); return false;" />&nbsp; 
			<input id="btnCancel" class="btn" type="button"
				value="取 消" onclick="cancel(); return false;" />
		</div>
	</form>
</body>
</html>