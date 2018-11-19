<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理编码描述</title>

<script type="text/javascript">
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

	if (mode == "view") {
		$("select").attr('disabled', 'disabled');
		$("input,textarea").attr('readonly', 'readonly');
		$("span.help-inline").remove();
	}
});
</script>
</head>
<body>
	<ul class="nav nav-tabs">
<c:forEach var="act" items="${actions}">
		<li class='<c:if test="${act.active}">active</c:if>'>
			<a href="${base}${act.url}">
			<c:if test="${empty act.icon}"><i class='${act.icon}'>&nbsp;</i></c:if>
				${act.title}</a>
		</li>
</c:forEach>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal" method="post">
		
		<h4>一般处理</h4>
		<br/>
		<div class="control-group">
			<label for="CK" class="control-label">CK:</label>
			<div class="controls">
				<textarea id="CK" name="CK" class="input-xlarge" maxlength="256">${codes.CK}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="KF" class="control-label">KF:</label>
			<div class="controls">
				<textarea id="KF" name="KF" class="input-xlarge" maxlength="256">${codes.KF}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="BMP" class="control-label">BMP:</label>
			<div class="controls">
				<textarea id="BMP" name="BMP" class="input-xlarge" maxlength="256">${codes.BMP}</textarea>
			</div>
		</div>
		<h4>重点处理</h4>
		<br/>
		<div class="control-group">
			<label for="TR1" class="control-label">TR1:</label>
			<div class="controls">
				<textarea id="TR1" name="TR1" class="input-xlarge" maxlength="256">${codes.TR1}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR2" class="control-label">TR2:</label>
			<div class="controls">
				<textarea id="TR2" name="TR2" class="input-xlarge" maxlength="256">${codes.TR2}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR3" class="control-label">TR3:</label>
			<div class="controls">
				<textarea id="TR3" name="TR3" class="input-xlarge" maxlength="256">${codes.TR3}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR4" class="control-label">TR4:</label>
			<div class="controls">
				<textarea id="TR4" name="TR4" class="input-xlarge" maxlength="256">${codes.TR4}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR5" class="control-label">TR5:</label>
			<div class="controls">
				<textarea id="TR5" name="TR5" class="input-xlarge" maxlength="256">${codes.TR5}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR6" class="control-label">TR6:</label>
			<div class="controls">
				<textarea id="TR6" name="TR6" class="input-xlarge" maxlength="256">${codes.TR6}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR7" class="control-label">TR7:</label>
			<div class="controls">
				<textarea id="TR7" name="TR7" class="input-xlarge" maxlength="256">${codes.TR7}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR8" class="control-label">TR8:</label>
			<div class="controls">
				<textarea id="TR8" name="TR8" class="input-xlarge" maxlength="256">${codes.TR8}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR9" class="control-label">TR9:</label>
			<div class="controls">
				<textarea id="TR9" name="TR9" class="input-xlarge" maxlength="256">${codes.TR9}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR10" class="control-label">TR10:</label>
			<div class="controls">
				<textarea id="TR10" name="TR10" class="input-xlarge" maxlength="256">${codes.TR10}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR11" class="control-label">TR11:</label>
			<div class="controls">
				<textarea id="TR11" name="TR11" class="input-xlarge" maxlength="256">${codes.TR11}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR12" class="control-label">TR12:</label>
			<div class="controls">
				<textarea id="TR12" name="TR12" class="input-xlarge" maxlength="256">${codes.TR12}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR13" class="control-label">TR13:</label>
			<div class="controls">
				<textarea id="TR13" name="TR13" class="input-xlarge" maxlength="256">${codes.TR13}</textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR14" class="control-label">TR14:</label>
			<div class="controls">
				<textarea id="TR14" name="TR14" class="input-xlarge" maxlength="256">${codes.TR14}</textarea>
			</div>
		</div>

		<div class="form-actions">
<c:if test="${mode != 'view'}">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="保 存" />&nbsp;
</c:if>
			<input id="btnCancel" class="btn" type="button"
				value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>