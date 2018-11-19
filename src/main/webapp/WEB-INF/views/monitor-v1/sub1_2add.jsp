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
				发生层次:$("#发生层次").val(),
		};
		if ($("#土层厚度").val()) data.土层厚度=$("#土层厚度").val();
		if ($("#土壤颜色").val()) data.土壤颜色=$("#土壤颜色").val();
		if ($("#土壤结构").val()) data.土壤结构=$("#土壤结构").val();
		if ($("#新生体类别").val()) data.新生体类别=$("#新生体类别").val();
		if ($("#新生体形态").val()) data.新生体形态=$("#新生体形态").val();
		if ($("#新生体数量").val()) data.新生体数量=$("#新生体数量").val();
		if ($("#坚实度").val()) data.坚实度=$("#坚实度").val();
		if ($("#根系类型").val()) data.根系类型=$("#根系类型").val();
		if ($("#动物穴").val()) data.动物穴=$("#动物穴").val();
		if ($("#石灰反应").val()) data.石灰反应=$("#石灰反应").val();

		save(data);
		cancel();
	}
}
function cancel() {
	console.log("cancel")
}
var mode = '${mode}';
$(document).ready(function() {
	var 发生层次list = {
			0: '== 请选择 ==',
	        "0层": "0层",
	        "A层": "A层",
	        "B层": "B层",
	        "C层": "C层",
	        "D层": "D层",
	        "R层": "R层",
	        "过渡层": "过渡层",
	};
	var 土壤结构list = {
	        "大块状结构": "大块状结构",
	        "小块状结构": "小块状结构",
	        "大团块状结构": "大团块状结构",
	        "团块状结构": "团块状结构",
	        "小团块状结构": "小团块状结构",
	        "大核状结构": "大核状结构",
	        "核状结构": "核状结构",
	        "小核状结构": "小核状结构",
	        "大粒状结构": "大粒状结构",
	        "粒状结构": "粒状结构",
	        "小粒状结构": "小粒状结构",
	        "大柱状结构": "大柱状结构",
	        "柱状结构": "柱状结构",
	        "小柱状结构": "小柱状结构",
	        "大棱柱状结构": "大棱柱状结构",
	        "棱柱状结构": "棱柱状结构",
	        "小棱柱状结构": "小棱柱状结构",
	        "板状结构": "板状结构",
	        "片状结构": "片状结构",
	        "鳞片状结构": "鳞片状结构",
	        "透镜状结构": "透镜状结构",
	};
	var 新生体类别list = {
	        "结核":"结核",
	        "结盘":"结盘",
	        "胶膜":"胶膜",
	        "斑纹":"斑纹",
	        "网纹":"网纹",
	        "结晶体与粉末":"结晶体与粉末",
	};
	var 坚实度list = {
	        "松散":"松散",
	        "稍紧实":"稍紧实",
	        "紧实":"紧实",
	        "极紧实":"极紧实",
	        "坚实":"坚实",
	}
	var 根系类型list = {
	        "毛根":"毛根",
	        "细根":"细根",
	        "中等根":"中等根",
	        "粗根":"粗根",
	}
	var 动物穴list = {
	        "蚯蚓及蚯蚓粪":"蚯蚓及蚯蚓粪",
	        "鼠穴和鼠穴填充物":"鼠穴和鼠穴填充物",
	        "昆虫螨及虫穴":"昆虫螨及虫穴",
	}
	var 石灰反应list = {
	        "无碳酸钙":"无碳酸钙",
	        "轻度碳酸盐":"轻度碳酸盐",
	        "中度碳酸盐":"中度碳酸盐",
	        "强度碳酸盐":"强度碳酸盐",
	        "极强碳酸盐":"极强碳酸盐",
	}

	fillSelect("#发生层次", 发生层次list);
	fillSelect("#土壤结构", 土壤结构list);
	fillSelect("#新生体类别", 新生体类别list);
	fillSelect("#坚实度", 坚实度list);
	fillSelect("#根系类型", 根系类型list);
	fillSelect("#动物穴", 动物穴list);
	fillSelect("#石灰反应", 石灰反应list);

	$("#发生层次").val('${data.发生层次}');
	$("#土壤结构").val('${data.土壤结构}');
	$("#新生体类别").val('${data.新生体类别}');
	$("#坚实度").val('${data.坚实度}');
	$("#根系类型").val('${data.根系类型}');
	$("#动物穴").val('${data.动物穴}');
	$("#石灰反应").val('${data.石灰反应}');

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
			<label for="发生层次" class="control-label">发生层次:</label>
			<div class="controls">
				<select id="发生层次" name="发生层次" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土层厚度" class="control-label">土层厚度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="土层厚度" name="土壤厚度" class="input-small" type="number" value="${data.土层厚度}" maxlength="4" min="0" max="99.9" step="0.1" />
				<span class="add-on">cm</span>
				</span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤颜色" class="control-label">土壤颜色:</label>
			<div class="controls">
				<input id="土壤颜色" name="土壤颜色" type="text" value="${data.土壤颜色}" maxlength="4" />
			</div>
		</div>
		<div class="control-group">
			<label for="土壤结构" class="control-label">土壤结构:</label>
			<div class="controls">
				<select id="土壤结构" name="土壤结构" class=""></select>
			</div>
		</div>
		<div class="control-group">
			<label for="新生体类别" class="control-label">新生体 类别:</label>
			<div class="controls">
				<select id="新生体类别" name="新生体类别" class=""></select>
			</div>
		</div>
		<div class="control-group">
			<label for="新生体形态" class="control-label">新生体 形态:</label>
			<div class="controls">
				<input id="新生体形态" name="新生体形态" type="text" value="${data.新生体形态}" maxlength="10" />
			</div>
		</div>
		<div class="control-group">
			<label for="新生体数量" class="control-label">新生体 数量:</label>
			<div class="controls">
				<input id="新生体数量" name="新生体数量" class="input-small" type="number" value="${data.新生体数量}" maxlength="2" min="0" max="99" />
			</div>
		</div>
		<div class="control-group">
			<label for="坚实度" class="control-label">坚实度:</label>
			<div class="controls">
				<select id="坚实度" name="坚实度" class=""></select>
			</div>
		</div>
		<div class="control-group">
			<label for="根系类型" class="control-label">根系类型:</label>
			<div class="controls">
				<select id="根系类型" name="根系类型" class=""></select>
			</div>
		</div>
		<div class="control-group">
			<label for="动物穴" class="control-label">动物穴:</label>
			<div class="controls">
				<select id="动物穴" name="动物穴" class=""></select>
			</div>
		</div>
		<div class="control-group">
			<label for="石灰反应" class="control-label">石灰反应:</label>
			<div class="controls">
				<select id="石灰反应" name="石灰反应" class=""></select>
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