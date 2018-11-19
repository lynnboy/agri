<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>作物覆膜情况</title>

<script type="text/javascript">
function save(data) {
	console.log("save")
}
function ok(data) {
	if ($("#inputForm").valid()) {
		save({
			作物代码:$("#作物代码").val(),
			覆膜面积:$("#覆膜面积").val(),
			覆膜比例:$("#覆膜比例").val(),
			});
		cancel();
	}
}
function cancel() {
	console.log("cancel")
}
function load(data) {
	if (data) {
		$("#作物代码").val(data.作物代码);
		$("#覆膜面积").val(data.覆膜面积);
		$("#覆膜比例").val(data.覆膜比例);
	}
}
$(document).ready(function() {
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
		
		<div class="control-group">
			<label for="作物代码" class="control-label">作物:</label>
			<div class="controls">
				<select id="作物代码" name="作物代码" class="reqselect span5">
				<option value=''>== 请选择 == </option>
				<optgroup label="粮食作物">
				<option value='LC01'>【LC01】 水稻</option>
				<option value='LC02'>【LC02】 小麦</option>
				<option value='LC03'>【LC03】 玉米</option>
				<option value='LC04'>【LC04】 其他谷物</option>
				<option value='LC05'>【LC05】 大豆</option>
				<option value='LC06'>【LC06】 其他豆类</option>
				<option value='LC07'>【LC07】 甘薯</option>
				<option value='LC08'>【LC08】 马铃薯</option>
				</optgroup>
				<optgroup label="经济作物">
				<option value='JC01'>【JC01】 棉花</option>
				<option value='JC02'>【JC02】 麻类</option>
				<option value='JC03'>【JC03】 桑类</option>
				<option value='JC04'>【JC04】 籽用油菜</option>
				<option value='JC05'>【JC05】 其他油料作物</option>
				<option value='JC06'>【JC06】 甘蔗</option>
				<option value='JC07'>【JC07】 甜菜</option>
				<option value='JC08'>【JC08】 烟草</option>
				<option value='JC09'>【JC09】 茶</option>
				<option value='JC10'>【JC10】 花卉</option>
				<option value='JC11'>【JC11】 药材</option>
				<option value='JC12'>【JC12】 落叶果树</option>
				<option value='JC13'>【JC13】 常绿果树</option>
				<option value='JC14'>【JC14】 香蕉</option>
				<option value='JC15'>【JC15】 其他果树</option>
				<option value='JC16'>【JC16】 其他</option>
				</optgroup>
				<optgroup label="蔬菜作物">
				<option value='SC01'>【SC01】 根茎叶类蔬菜</option>
				<option value='SC02'>【SC02】 瓜果类蔬菜</option>
				<option value='SC03'>【SC03】 水生蔬菜</option>
				</optgroup>
				<optgroup label="休闲">
				<option value='XX01'>【XX01】 休闲</option>
				</optgroup>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="覆膜面积" class="control-label">覆膜面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="覆膜面积" name="覆膜面积" class="required input-small" type="text" value="${data.覆膜面积}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="覆膜比例" class="control-label">覆膜比例:</label>
			<div class="controls">
				<span class="input-append">
				<input id="覆膜比例" name="覆膜比例" class="required input-small" type="text" value="${data.覆膜比例}" maxlength="10" min="0" max="100" />
				<span class="add-on">%</span>
				</span>
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