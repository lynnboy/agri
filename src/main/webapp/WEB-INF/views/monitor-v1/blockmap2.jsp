<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>种植模式面积</title>

<script type="text/javascript">
function save(data) {
	console.log("save")
}
var count = parseInt("${count}");
var repeat = parseInt("${repeat}");
function ok(data) {
	if ($("#inputForm").valid()) {
		var data = {
			地块编码:'${id}',
			count: count,
			repeat: repeat,
		};
		
		$("select").each(function(){
			data[this.name] = $(this).val();
		});
		
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

<c:forEach var="block" items="${blocks}">
		<div class="control-group">
			<label for="block_${block}" class="control-label">${block}[1-${repeat}]:</label>
			<div class="controls">
				<select id="block_${block}" name="${block}" class="reqselect input-mini">
<c:forEach var="code" items="${codelist}">
				<option value="${code.处理编码}">${code.处理编码}</option>
</c:forEach>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
</c:forEach>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="确 定" onclick="ok(); return false;" />&nbsp; 
			<input id="btnCancel" class="btn" type="button"
				value="取 消" onclick="cancel(); return false;" />
		</div>
	</form>
</body>
</html>