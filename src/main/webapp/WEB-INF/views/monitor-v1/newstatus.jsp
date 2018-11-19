<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>更改状态</title>

<script type="text/javascript">
function save(data) {
	console.log("save")
}
function ok(data) {
	if ($("#inputForm").valid()) {
		save({
			tags:$("#tags").val(),
			remarks:$("#remarks").val(),
			});
		cancel();
	}
}
function cancel() {
	console.log("cancel")
}
function load(data) {
	if (data) {
		$("#message").text(data.message);
		$("#tags").val(data.tags);
		$("#remarks").val(data.remarks);
		updateTags();
	}
}
function updateTags() {
	var value = $("#tags").val();
	var values = value ? value.split(',') : [];
	var tags = [];
	$.each(values, function(idx,val) {
		var v = val.trim();
		if (v) tags.push(v);
	});
	$("#tags").val(tags.join(","));
	var $taglist = $("#taglist");
	$taglist.empty();
	$.each(tags, function(idx, text) {
		var $tag = $('<span class="label">').text(text).appendTo($taglist);
		if (text.indexOf('?') != -1) $tag.addClass('label-warning');
		if (text.indexOf('!') != -1) $tag.addClass('label-important');
		$taglist.append(" ");
	});
}
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
	
	$("#tags").change(function() { updateTags(); });
	updateTags();

	$("#inputForm").validate({
		rules: {
			地块编码: { required: true, pattern: /^\d{8}$/ },
		},
		messages: {
			地块编码: { pattern: '请输入8位数字编码' },
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
	<form id="inputForm" class="form-horizontal"
		action="${base}/agri/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<h3 id="message"></h3>
		<hr/>
		<div class="control-group">
			<label for="tags" class="control-label">标签:</label>
			<div class="controls">
				<input id="tags" name="tags" class="input-small" type="text" value="${status.tags}" maxlength="256"/>
			</div>
			<br/>
			<div id="taglist" class="controls">
			</div>
		</div>

		<div class="control-group">
			<label for="remarks" class="control-label">备注:</label>
			<div class="controls">
				<textarea id="remarks" name="remarks" maxlength="200"
					class="input-xlarge" rows="3">${status.remarks}</textarea>
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