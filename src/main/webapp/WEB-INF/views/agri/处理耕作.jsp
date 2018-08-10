<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - 耕作</title>

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
	var 处理list = [
		'== 请选择 ==',
		"CK", "KF", "BMP",
		"TR1", "TR2", "TR3", "TR4", "TR5", "TR6", "TR7", "TR8", "TR9", "TR10", "TR11", "TR12", "TR13", "TR14",
	];
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
	var 是否list = [ '== 请选择 ==','是','否' ];
	var 有无list = [ '== 请选择 ==','有','无' ];
	var 种植方向list = [ '== 请选择 ==','横坡','顺坡' ];
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#是否翻耕", 是否list);
	fillSelect("#有无排水沟", 有无list);
	fillSelect("#种植方向1", 种植方向list);
	fillSelect("#种植方向2", 种植方向list);
	
	$("#tabs a").click(function(e) {
		e.preventDefault();
		$(this).tab('show');
	});
	
	$("#tabs a:first").tab('show');

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
		<li class="active"><a href="${base}/agri/add">处理耕作</a></li>
	</ul>

<p>
地块编码: 13005812<br>
地块地址: 地址 地址 地址  某县 某乡 某村
</p>

<%@include file="/WEB-INF/views/common/message.jsp"%>

	<form id="inputForm" class="form-horizontal"
		action="${base}/agri/${action}" method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<div class="control-group">
			<label for="处理编码" class="control-label">处理编码:</label>
			<div class="controls">
				<select id="处理编码" name="处理编码" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="种植季" class="control-label">种植季:</label>
			<div class="controls">
				<select id="种植季" name="种植季" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<ul id="tabs" class="nav nav-pills">
	<li><a href="#g1">平地或梯田平作</a></li>
	<li><a href="#g2">平地或梯田垄作</a></li>
	<li><a href="#g3">坡地非梯田平作</a></li>
	<li><a href="#g4">坡地非梯田垄作</a></li>
</ul>

<div class="tab-content">
<div class="tab-pane" id="g1">
		<div class="control-group">
			<label for="是否翻耕" class="control-label">是否翻耕:</label>
			<div class="controls">
				<select id="是否翻耕" name="是否翻耕" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="翻耕深度" class="control-label">翻耕深度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="翻耕深度" name="翻耕深度" class="required digits input-small" type="number"
					value="${data.翻耕深度}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="有无排水沟" class="control-label">有无排水沟:</label>
			<div class="controls">
				<select id="有无排水沟" name="有无排水沟" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="排水沟深" class="control-label">排水沟深:</label>
			<div class="controls">
				<span class="input-append">
				<input id="排水沟深" name="排水沟深" class="required digits input-small" type="number"
					value="${data.排水沟深}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="排水沟宽" class="control-label">排水沟宽:</label>
			<div class="controls">
				<span class="input-append">
				<input id="排水沟宽" name="排水沟宽" class="required digits input-small" type="number"
					value="${data.排水沟宽}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="排水沟间距" class="control-label">排水沟间距:</label>
			<div class="controls">
				<span class="input-append">
				<input id="排水沟间距" name="排水沟间距" class="required digits input-small" type="number"
					value="${data.排水沟间距}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">m</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
</div>
<div class="tab-pane" id="g2">
		<div class="control-group">
			<label for="垄高1" class="control-label">垄高:</label>
			<div class="controls">
				<span class="input-append">
				<input id="垄高1" name="垄高1" class="required digits input-small" type="number"
					value="${data.垄高1}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="垄宽1" class="control-label">垄宽:</label>
			<div class="controls">
				<span class="input-append">
				<input id="垄宽1" name="垄宽1" class="required digits input-small" type="number"
					value="${data.垄宽1}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="垄间距1" class="control-label">垄间距:</label>
			<div class="controls">
				<span class="input-append">
				<input id="垄间距1" name="垄间距1" class="required digits input-small" type="number"
					value="${data.垄间距1}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
</div>
<div class="tab-pane" id="g3">
		<div class="control-group">
			<label for="种植方向1" class="control-label">种植方向:</label>
			<div class="controls">
				<select id="种植方向1" name="种植方向1" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
</div>
<div class="tab-pane" id="g4">
		<div class="control-group">
			<label for="种植方向2" class="control-label">种植方向:</label>
			<div class="controls">
				<select id="种植方向2" name="种植方向2" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="垄高2" class="control-label">垄高:</label>
			<div class="controls">
				<span class="input-append">
				<input id="垄高2" name="垄高2" class="required digits input-small" type="number"
					value="${data.垄高2}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="垄宽2" class="control-label">垄宽:</label>
			<div class="controls">
				<span class="input-append">
				<input id="垄宽2" name="垄宽2" class="required digits input-small" type="number"
					value="${data.垄宽2}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="垄间距2" class="control-label">垄间距:</label>
			<div class="controls">
				<span class="input-append">
				<input id="垄间距2" name="垄间距2" class="required digits input-small" type="number"
					value="${data.垄间距2}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
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