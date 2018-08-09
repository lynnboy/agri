<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>记录 - 基础土壤样品</title>
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
	$("#样品鲜重,#样品风干重").change(function(){
		var ratio = 1 * $("#样品风干重").val() / $("#样品鲜重").val();
		$("#含水率").val((isNaN(ratio) || ratio > 1) ? "" : (100 * (1-ratio)).toFixed(1));
	});
	
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
		<li><a href="${base}/agri/list">记录</a></li>
		<li class="active"><a href="${base}/agri/add">基础土壤样品</a></li>
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
			<label for="基础土壤样品编码" class="control-label">基础土壤样品编码:</label>
			<div class="controls">
				<input id="基础土壤样品编码" name="基础土壤样品编码" class="required 基础土壤样品编码 input-small" type="text"
					value="${data.基础土壤样品编码}" maxlength="2" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="样品鲜重" class="control-label">样品鲜重:</label>
			<div class="controls">
				<span class="input-append">
				<input id="样品鲜重" name="样品鲜重" class="required input-small" type="number"
					value="${data.样品鲜重}" maxlength="3" min="0" max="9.9" step="0.1" />
				<span class="add-on">g</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="样品风干重" class="control-label">样品风干重<br/>（烘干基）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="样品风干重" name="样品风干重" class="required input-small" type="number"
					value="${data.样品风干重}" maxlength="3" min="0" max="9.9" step="0.1" />
				<span class="add-on">g</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="采样日期" class="control-label">采样日期:</label>
			<div class="controls">
				<input id="采样日期" name="采样日期" type="text" readonly="readonly"
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
			<label for="土壤容重1" class="control-label">土壤容重0-20cm:</label>
			<div class="controls">
				<span class="input-append">
				<input id="土壤容重1" name="土壤容重1" class="required input-small" type="number"
					value="${data.土壤容重1}" maxlength="4" min="0" max="9.99" step="0.01" />
				<span class="add-on">g/m<sup>3</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤容重2" class="control-label">土壤容重20-40cm:</label>
			<div class="controls">
				<span class="input-append">
				<input id="土壤容重2" name="土壤容重2" class="required input-small" type="number"
					value="${data.土壤容重2}" maxlength="4" min="0" max="9.99" step="0.01" />
				<span class="add-on">g/m<sup>3</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤容重3" class="control-label">土壤容重40-60cm:</label>
			<div class="controls">
				<span class="input-append">
				<input id="土壤容重3" name="土壤容重3" class="required input-small" type="number"
					value="${data.土壤容重3}" maxlength="4" min="0" max="9.99" step="0.01" />
				<span class="add-on">g/m<sup>3</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤容重4" class="control-label">土壤容重60-80cm:</label>
			<div class="controls">
				<span class="input-append">
				<input id="土壤容重4" name="土壤容重4" class="required input-small" type="number"
					value="${data.土壤容重4}" maxlength="4" min="0" max="9.99" step="0.01" />
				<span class="add-on">g/m<sup>3</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤容重5" class="control-label">土壤容重80-100cm:</label>
			<div class="controls">
				<span class="input-append">
				<input id="土壤容重5" name="土壤容重5" class="required input-small" type="number"
					value="${data.土壤容重5}" maxlength="4" min="0" max="9.99" step="0.01" />
				<span class="add-on">g/m<sup>3</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="硝态氮" class="control-label">硝态氮（N）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="硝态氮" name="硝态氮" class="required input-small" type="number"
					value="${data.硝态氮}" maxlength="7" min="0" max="999" step="0.1" />
				<span class="add-on">mg/kg</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="铵态氮" class="control-label">铵态氮（N）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="铵态氮" name="铵态氮" class="required input-small" type="number"
					value="${data.铵态氮}" maxlength="7" min="0" max="999" step="0.1" />
				<span class="add-on">mg/kg</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="可溶性总氮" class="control-label">可溶性总氮（N）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="可溶性总氮" name="可溶性总氮" class="required input-small" type="number"
					value="${data.可溶性总氮}" maxlength="6" min="0" max="99" step="0.1" />
				<span class="add-on">mg/kg</span>
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