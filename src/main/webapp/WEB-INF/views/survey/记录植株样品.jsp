<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>记录 - 植株样品</title>
<meta name="decorator" content="default" />
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
	fillSelect("#种植季", 种植季list);
	
	$("#植物样品鲜重,#植物样品风干重").change(function(){
		var ratio = 1 * $("#植物样品风干重").val() / $("#植物样品鲜重").val();
		$("#含水率").val((isNaN(ratio) || ratio > 1) ? "" : (100 * (1-ratio)).toFixed(1));
	});
	
	$("#inputForm").validate({
		rules: {
			全氮: { sumLessThan100: ["#全氮","#全磷","#全钾"] },
			全磷: { sumLessThan100: ["#全氮","#全磷","#全钾"] },
			全钾: { sumLessThan100: ["#全氮","#全磷","#全钾"] },
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
		<li><a href="${base}/agri/list">记录</a></li>
		<li class="active"><a href="${base}/agri/add">植株样品</a></li>
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
			<label for="植株样品编号" class="control-label">植株样品编号:</label>
			<div class="controls">
				<input id="植株样品编号" name="植株样品编号" class="required 植株样品编号 input-small" type="text"
					value="${data.植株样品编号}" maxlength="5" />
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

		<div class="control-group">
			<label for="作物名称" class="control-label">作物名称:</label>
			<div class="controls">
				<input id="作物名称" name="作物名称" class="ignore" readonly type="text"
					value="小麦"></input>
			</div>
		</div>
		<div class="control-group">
			<label for="产量" class="control-label">产量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="产量" name="产量" class="required input-small" type="number"
					value="${data.产量}" maxlength="7" min="0.00" max="9999.99" step="1" />
				<span class="add-on">公斤/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="植物样品鲜重" class="control-label">植物样品鲜重:</label>
			<div class="controls">
				<span class="input-append">
				<input id="植物样品鲜重" name="植物样品鲜重" class="required input-small" type="number"
					value="${data.植物样品鲜重}" maxlength="3" min="0" max="9.9" step="0.1" />
				<span class="add-on">g</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="植物样品风干重" class="control-label">植物样品风干重<br/>（烘干基）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="植物样品风干重" name="植物样品风干重" class="required input-small" type="number"
					value="${data.植物样品风干重}" maxlength="3" min="0" max="9.9" step="0.1" />
				<span class="add-on">g</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="取样日期" class="control-label">取样日期:</label>
			<div class="controls">
				<input id="取样日期" name="取样日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value=""
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="含水率" class="control-label">含水率:</label>
			<div class="controls">
				<span class="input-append">
				<input id="含水率" name="含水率" class="input-small" type="text" readonly
					value="${data.含水率}" />
				<span class="add-on">%</span>
				</span>
			</div>
		</div>
		<div class="control-group">
			<label for="全氮" class="control-label">全氮（N）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="全氮" name="全氮" class="required input-small" type="number"
					value="${data.全氮}" maxlength="6" min="0" max="100" step="0.1" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="全磷" class="control-label">全磷（P）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="全磷" name="全磷" class="required input-small" type="number"
					value="${data.全磷}" maxlength="6" min="0" max="100" step="0.1" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="全钾" class="control-label">全钾（K）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="全钾" name="全钾" class="required input-small" type="number"
					value="${data.全钾}" maxlength="6" min="0" max="100" step="0.1" />
				<span class="add-on">%</span>
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