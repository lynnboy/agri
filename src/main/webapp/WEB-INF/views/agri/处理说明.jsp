<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块数据列表</title>

<script type="text/javascript">
function fillSelect(sel, list, nestlist) {
	$.each(list, function(i, text) {
		$(sel).append($('<option value="' + i + '">'+ text + '</option>'));
	});
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
	<ul class="nav nav-tabs">
		<li><a href="${base}/agri/list">地块数据列表</a></li>
		<li><a href="${base}/agri/list">处理</a></li>
		<li class="active"><a href="${base}/agri/add">编辑处理说明</a></li>
	</ul>

<p>
地块编码: 13005812<br>
地块地址: 地址 地址 地址  某县 某乡 某村
</p>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

	<form id="inputForm" class="form-horizontal"
		action="${base}/agri/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<h4>一般处理</h4>
		<div class="control-group">
			<label for="CK" class="control-label">CK:</label>
			<div class="controls">
				<textarea id="CK" name="CK" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="KF" class="control-label">KF:</label>
			<div class="controls">
				<textarea id="KF" name="KF" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="BMP" class="control-label">BMP:</label>
			<div class="controls">
				<textarea id="BMP" name="BMP" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<h4>重点处理</h4>
		<div class="control-group">
			<label for="TR1" class="control-label">TR 1:</label>
			<div class="controls">
				<textarea id="TR1" name="TR1" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR2" class="control-label">TR 2:</label>
			<div class="controls">
				<textarea id="TR2" name="TR2" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR3" class="control-label">TR 3:</label>
			<div class="controls">
				<textarea id="TR3" name="TR3" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR4" class="control-label">TR 4:</label>
			<div class="controls">
				<textarea id="TR4" name="TR4" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR5" class="control-label">TR 5:</label>
			<div class="controls">
				<textarea id="TR5" name="TR5" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR6" class="control-label">TR 6:</label>
			<div class="controls">
				<textarea id="TR6" name="TR6" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR7" class="control-label">TR 7:</label>
			<div class="controls">
				<textarea id="TR7" name="TR7" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR8" class="control-label">TR 8:</label>
			<div class="controls">
				<textarea id="TR8" name="TR8" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR9" class="control-label">TR 9:</label>
			<div class="controls">
				<textarea id="TR9" name="TR9" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR10" class="control-label">TR 10:</label>
			<div class="controls">
				<textarea id="TR10" name="TR10" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR11" class="control-label">TR 11:</label>
			<div class="controls">
				<textarea id="TR11" name="TR11" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR12" class="control-label">TR 12:</label>
			<div class="controls">
				<textarea id="TR12" name="TR12" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR13" class="control-label">TR 13:</label>
			<div class="controls">
				<textarea id="TR13" name="TR13" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>
		<div class="control-group">
			<label for="TR14" class="control-label">TR 14:</label>
			<div class="controls">
				<textarea id="TR14" name="TR14" class="input-xlarge" maxlength="256"></textarea>
			</div>
		</div>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="button"
				value="保 存" />&nbsp; <input id="btnCancel" class="btn" type="button"
				value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>