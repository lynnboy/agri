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
	var 发生层次list = [ '== 请选择 ==', "0层","A层","B层","C层","D层","R层","过渡层" ];
	var 土壤结构list = [
			'== 请选择 ==',
			"大块状结构",
			"小块状结构",
			"大团块状结构",
			"团块状结构",
			"小团块状结构",
			"大核状结构",
			"核状结构",
			"小核状结构",
			"大粒状结构",
			"粒状结构",
			"小粒状结构",
			"大柱状结构",
			"柱状结构",
			"小柱状结构",
			"大棱柱状结构",
			"棱柱状结构",
	];
	var 新生体类别list = [ '== 请选择 ==', "结核","结盘","胶膜","斑纹","网纹","结晶体与粉末" ];
	var 坚实度list = [ "== 请选择 ==", "松散","稍紧实","紧实","极紧实","坚实"];
	var 根系类型list = [ "== 请选择 ==", "毛根","细根","中等根","粗根"];
	var 动物穴list = [ "== 请选择 ==", "蚯蚓及蚯蚓粪","鼠穴和鼠穴填充物","昆虫螨及虫穴"];
	var 石灰反应list = [ "== 请选择 ==", "无碳酸钙","轻度碳酸盐","中度碳酸盐","强度碳酸盐","极强碳酸盐"];

	fillSelect("#发生层次", 发生层次list);
	fillSelect("#土壤结构", 土壤结构list);
	fillSelect("#新生体类别", 新生体类别list);
	fillSelect("#坚实度", 坚实度list);
	fillSelect("#根系类型", 根系类型list);
	fillSelect("#动物穴", 动物穴list);
	fillSelect("#石灰反应", 石灰反应list);

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
			<label for="发生层次" class="control-label">发生层次:</label>
			<div class="controls">
				<select id="发生层次" name="发生层次" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤厚度" class="control-label">土壤厚度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="土壤厚度" name="土壤厚度" class="input-small" type="number" value="${data.土壤厚度}" maxlength="4" min="0" max="99.9" step="0.1" />
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
			<input id="btnSubmit" class="btn btn-primary" type="button"
				value="保 存" />&nbsp; <input id="btnCancel" class="btn" type="button"
				value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>