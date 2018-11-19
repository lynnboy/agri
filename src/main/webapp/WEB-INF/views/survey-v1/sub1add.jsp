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
		save({
			地块编码: '${id}',
			作物代码:$("#作物代码").val(),
			肥料代码:$("#肥料代码").val(),
			施用量:$("#施用量").val(),
			N:$("#N").val(),
			P2O5:$("#P2O5").val(),
			K2O:$("#K2O").val(),
			});
		cancel();
	}
}
function cancel() {
	console.log("cancel")
}
var mode = '${mode}';
$(document).ready(function() {
	$("#作物代码").val('${data.作物代码}');
	$("#肥料代码").val('${data.肥料代码}');

	if (mode == "view") {
		$("select").attr('disabled', 'disabled');
		$("input,textarea").attr('readonly', 'readonly');
		$("span.help-inline").remove();
	}

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
		method="post">
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
			<label for="肥料代码" class="control-label">肥料:</label>
			<div class="controls">
				<select id="肥料代码" name="肥料代码" class="reqselect span5">
				<option value=''>== 请选择 == </option>
				<optgroup label="氮肥">
				<option value='FN01'>【FN01】 尿素</option>
				<option value='FN02'>【FN02】 碳铵</option>
				<option value='FN03'>【FN03】 硫铵</option>
				<option value='FN04'>【FN04】 硝铵</option>
				<option value='FN05'>【FN05】 氯铵</option>
				<option value='FN06'>【FN06】 氨水</option>
				<option value='FN07'>【FN07】 缓释尿素</option>
				</optgroup>
				<optgroup label="磷肥">
				<option value='FP01'>【FP01】 普钙</option>
				<option value='FP02'>【FP02】 钙镁磷肥</option>
				<option value='FP03'>【FP03】 重钙</option>
				<option value='FP04'>【FP04】 磷矿粉</option>
				</optgroup>
				<optgroup label="钾肥">
				<option value='FK01'>【FK01】 氯化钾</option>
				<option value='FK02'>【FK02】 硫酸钾</option>
				<option value='FK03'>【FK03】 硫酸钾镁</option>
				</optgroup>
				<optgroup label="复合肥">
				<option value='FC01'>【FC01】 磷酸二铵</option>
				<option value='FC02'>【FC02】 磷酸一铵</option>
				<option value='FC03'>【FC03】 磷酸二氢钾</option>
				<option value='FC04'>【FC04】 硝酸钾</option>
				<option value='FC05'>【FC05】 有机无机复合肥</option>
				<option value='FC06'>【FC06】 其它二三元复合肥</option>
				</optgroup>
				<optgroup label="有机肥">
				<option value='FM01'>【FM01】 商品有机肥</option>
				<option value='FM02'>【FM02】 鸡粪</option>
				<option value='FM03'>【FM03】 猪粪</option>
				<option value='FM04'>【FM04】 牛粪</option>
				<option value='FM05'>【FM05】 其他禽粪</option>
				<option value='FM06'>【FM06】 其他畜粪</option>
				<option value='FM07'>【FM07】 其他有机肥</option>
				</optgroup>
				<optgroup label="不施肥">
				<option value='FL00'>【FL00】 不施肥</option>
				</optgroup>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="施用量" class="control-label">施用量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="施用量" name="施用量" class="required input-small" type="text" value="${data.施用量}" maxlength="10" min="0" max="1000" />
				<span class="add-on">公斤/亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="N" class="control-label">养分含量-N:</label>
			<div class="controls">
				<span class="input-append">
				<input id="N" name="N" class="required input-small" type="text" value="${data.N}" maxlength="5" min="0" max="100" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="P2O5" class="control-label">养分含量-P<sub>2</sub>O<sub>5</sub>:</label>
			<div class="controls">
				<span class="input-append">
				<input id="P2O5" name="P2O5" class="required input-small" type="text" value="${data.P2O5}" maxlength="5" min="0" max="100" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="K2O" class="control-label">养分含量-K<sub>2</sub>O:</label>
			<div class="controls">
				<span class="input-append">
				<input id="K2O" name="K2O" class="required input-small" type="text" value="${data.K2O}" maxlength="5" min="0" max="100" />
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