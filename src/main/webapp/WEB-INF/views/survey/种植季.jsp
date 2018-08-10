<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${isAdd?"添加":"修改"}地块</title>

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
	var 种植季list = [
			'== 请选择 ==',
			'0 季',
			'1 季',
			'2 季',
			'3 季',
			'4 季',
			'5 季',
			'6 季',
			'7 季',
			'8 季',
			'9 季',
	];
	var 作物类别list = [
			'== 请选择 ==',
			'粮食①LC01水稻',
			'粮食②LC02小麦',
			'粮食③LC03玉米',
			'粮食④LC04其他谷物',
			'粮食⑤LC05大豆',
			'粮食⑥LC06其他豆类',
			'粮食⑦LC07甘薯',
			'粮食⑧LC08马铃薯',
			'经济①JC01棉花',
			'经济②JC02麻类',
			'经济③JC03桑类',
			'经济④JC04籽用油菜',
			'经济⑤JC05其他油料作物',
			'经济⑥JC06甘蔗',
			'经济⑦JC07甜菜',
			'经济⑧JC08烟草',
			'经济⑨JC09茶',
			'经济⑩JC10花卉',
			'经济⑪JC11药材',
			'经济⑫JC12落叶果树',
			'经济⑬JC13常绿果树',
			'经济⑭JC14香蕉',
			'经济⑮JC15其他果树',
			'经济⑯JC16其他',
			'蔬菜①SC01根茎叶类蔬菜',
			'蔬菜②SC02瓜果类蔬菜',
			'蔬菜③SC03水生蔬菜',
			'休闲①XX01休闲',
	];

	fillSelect("#种植季", 种植季list);
	fillSelect("#作物类别", 作物类别list);

	$("#种植模式分区").val('');
	$("#地貌类型").val('');
	
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
	<form id="inputForm" class="form-horizontal"
		action="${base}/agri/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<div class="control-group">
			<label for="种植季" class="control-label">种植季:</label>
			<div class="controls">
				<select id="种植季" name="种植季" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="作物类别" class="control-label">作物类别:</label>
			<div class="controls">
				<select id="作物类别" name="作物类别" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="作物名称" class="control-label">作物名称:</label>
			<div class="controls">
				<input id="作物名称" name="作物名称" class="required" type="text" value="${data.作物名称}" maxlength="8" />
				<span class="help-inline"><font color="red">*</font> </span>
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