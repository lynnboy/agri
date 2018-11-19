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
			监测年度:$("#监测年度").val(),
		};
		if ($("#种植季").val()) {
			var val = $("#种植季").val();
			if (val === "0-") val = "0";
			data.种植季=val;
		}
		if ($("#作物类别及编码").val()) data.作物类别及编码=$("#作物类别及编码").val();
		if ($("#作物名称").val()) data.作物名称=$("#作物名称").val();

		save(data);
		cancel();
	}
}
function cancel() {
	console.log("cancel")
}
var mode = '${mode}';
$(document).ready(function() {
	var 种植季list = {
			0: "== 请选择 ==",
	        "0-": "0 季",
	        "1": "1 季",
	        "2": "2 季",
	        "3": "3 季",
	        "4": "4 季",
	        "5": "5 季",
	        "6": "6 季",
	        "7": "7 季",
	        "8": "8 季",
	        "9": "9 季",
	};
	var 作物类别list = {
			0: "== 请选择 ==",
			"LC01": "LC01-粮食①水稻",
			"LC02": "LC02-粮食②小麦",
			"LC03": "LC03-粮食③玉米",
			"LC04": "LC04-粮食④其他谷物",
			"LC05": "LC05-粮食⑤大豆",
			"LC06": "LC06-粮食⑥其他豆类",
			"LC07": "LC07-粮食⑦甘薯",
			"LC08": "LC08-粮食⑧马铃薯",
			"JC01": "JC01-经济①棉花",
			"JC02": "JC02-经济②麻类",
			"JC03": "JC03-经济③桑类",
			"JC04": "JC04-经济④籽用油菜",
			"JC05": "JC05-经济⑤其他油料作物",
			"JC06": "JC06-经济⑥甘蔗",
			"JC07": "JC07-经济⑦甜菜",
			"JC08": "JC08-经济⑧烟草",
			"JC09": "JC09-经济⑨茶",
			"JC10": "JC10-经济⑩花卉",
			"JC11": "JC11-经济⑪药材",
			"JC12": "JC12-经济⑫落叶果树",
			"JC13": "JC13-经济⑬常绿果树",
			"JC14": "JC14-经济⑭香蕉",
			"JC15": "JC15-经济⑮其他果树",
			"JC16": "JC16-经济⑯其他",
			"SC01": "SC01-蔬菜①根茎叶类蔬菜",
			"SC02": "SC02-蔬菜②瓜果类蔬菜",
			"SC03": "SC03-蔬菜③水生蔬菜",
			"XX01": "XX01-休闲①休闲",
	};

	fillSelect("#种植季", 种植季list);
	fillSelect("#作物类别及编码", 作物类别list);

	var val = '${data.种植季}';
	if (val === "0") val = "0-"
	$("#种植季").val(val);
	$("#作物类别及编码").val('${data.作物类别及编码}');

	if (mode == "view") {
		$("select").attr('disabled', 'disabled');
		$("input,textarea").attr('readonly', 'readonly');
		$("span.help-inline").remove();
	}

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
			<label for="监测年度" class="control-label">监测年度:</label>
			<div class="controls">
<c:if test="${mode == 'add'}">
				<input id="监测年度" name="监测年度" type="text" value="${data.监测年度}"
				 class="required digits" min="1970" max="2099" />
				<span class="help-inline"><font color="red">*</font> </span>
</c:if>
<c:if test="${mode != 'add'}">
				<input id="监测年度" name="监测年度" type="text" value="${data.监测年度}" readonly />
</c:if>
			</div>
		</div>
		<div class="control-group">
			<label for="种植季" class="control-label">种植季:</label>
			<div class="controls">
<c:if test="${mode == 'add'}">
				<select id="种植季" name="种植季" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
</c:if>
<c:if test="${mode != 'add'}">
				<select id="种植季" name="种植季" class="reqselect" disabled></select>
</c:if>
			</div>
		</div>
		<div class="control-group">
			<label for="作物类别及编码" class="control-label">作物类别及编码:</label>
			<div class="controls">
				<select id="作物类别及编码" name="作物类别及编码" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="作物名称" class="control-label">作物名称:</label>
			<div class="controls">
				<input id="作物名称" name="作物名称" type="text" value="${data.作物名称}"
				 class="required" maxlength="8" />
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