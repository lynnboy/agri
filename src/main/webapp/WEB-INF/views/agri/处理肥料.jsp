<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - 肥料</title>
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
	var 有机肥类型list = [ '== 请选择 ==',"【FM01】商品有机肥","【FM02】鸡粪","【FM03】猪粪","【FM04】牛粪","【FM05】其他禽粪","【FM06】其他畜粪","【FM07】其他有机肥","【FL00】不施肥" ];
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#有机肥类型", 有机肥类型list);
	
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
		<li class="active"><a href="${base}/agri/add">处理肥料</a></li>
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

<br/>
<h4>化肥</h4>
<hr/>

		<div class="control-group">
			<label for="化肥N" class="control-label">N:</label>
			<div class="controls">
				<span class="input-append">
				<input id="化肥N" name="化肥N" class="required digits input-small" type="number"
					value="${data.化肥N}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="化肥P2O5" class="control-label">P<sub>2</sub>O<sub>5</sub>:</label>
			<div class="controls">
				<span class="input-append">
				<input id="化肥P2O5" name="化肥P2O5" class="required digits input-small" type="number"
					value="${data.化肥P2O5}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="化肥K2O" class="control-label">K<sub>2</sub>O:</label>
			<div class="controls">
				<span class="input-append">
				<input id="化肥K2O" name="化肥K2O" class="required digits input-small" type="number"
					value="${data.化肥K2O}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<br/>
<h4>有机肥</h4>
<hr/>

		<div class="control-group">
			<label for="有机肥类型" class="control-label">有机肥类型:</label>
			<div class="controls">
				<select id="有机肥类型" name="有机肥类型" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="含水率" class="control-label">含水率:</label>
			<div class="controls">
				<span class="input-append">
				<input id="含水率" name="有机肥含水率" class="required digits input-small" type="number"
					value="${data.有机肥含水率}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="投入量" class="control-label">投入量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="投入量" name="有机肥投入量" class="required digits input-small" type="number"
					value="${data.有机肥投入量}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="有机肥N" class="control-label">N:</label>
			<div class="controls">
				<span class="input-append">
				<input id="有机肥N" name="有机肥N" class="required digits input-small" type="number"
					value="${data.有机肥N}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="有机肥P2O5" class="control-label">P<sub>2</sub>O<sub>5</sub>:</label>
			<div class="controls">
				<span class="input-append">
				<input id="有机肥P2O5" name="有机肥P2O5" class="required digits input-small" type="number"
					value="${data.有机肥P2O5}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="有机肥K2O" class="control-label">K<sub>2</sub>O:</label>
			<div class="controls">
				<span class="input-append">
				<input id="有机肥K2O" name="有机肥K2O" class="required digits input-small" type="number"
					value="${data.有机肥K2O}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
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