<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>记录 - 降水/灌溉样品</title>
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
	var 是否list = [ '== 请选择 ==', "撒施","条施","沟施","穴施","叶面喷施","冲施","滴灌施" ];
	fillSelect("#是否产流", 是否list);
	
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
		<li class="active"><a href="${base}/agri/add">降水/灌溉样品</a></li>
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
			<label for="水样编码" class="control-label">灌溉/降水水样编码:</label>
			<div class="controls">
				<input id="水样编码" name="水样编码" class="required 水样编码 input-small" type="text"
					value="${data.水样编码}" maxlength="5" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="灌溉降水日期" class="control-label">灌溉/降水日期:</label>
			<div class="controls">
				<input id="灌溉降水日期" name="灌溉降水日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value=""
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="水量" class="control-label">水量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="水量" name="水量" class="required input-small" type="number"
					value="${data.水量}" maxlength="6" min="0" max="999" step="1" />
				<span class="add-on">mm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="生育时期" class="control-label">生育时期:</label>
			<div class="controls">
				<input id="生育时期" name="生育时期" class="required" type="text"
					value="${data.生育时期}" maxlength="10" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="是否产流" class="control-label">是否产流:</label>
			<div class="controls">
				<select id="是否产流" name="是否产流" class="reqselect"></select>
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
			<label for="总氮" class="control-label">总氮（N）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="总氮" name="总氮" class="required input-small" type="number"
					value="${data.总氮}" maxlength="6" min="0" max="99" step="0.1" />
				<span class="add-on">mg/L</span>
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
				<span class="add-on">mg/L</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="硝态氮" class="control-label">硝态氮（N）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="硝态氮" name="硝态氮" class="required input-small" type="number"
					value="${data.硝态氮}" maxlength="6" min="0" max="99" step="0.1" />
				<span class="add-on">mg/L</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="铵态氮" class="control-label">铵态氮（N）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="铵态氮" name="铵态氮" class="required input-small" type="number"
					value="${data.铵态氮}" maxlength="6" min="0" max="99" step="0.1" />
				<span class="add-on">mg/L</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="总磷" class="control-label">总磷（P）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="总磷" name="总磷" class="required input-small" type="number"
					value="${data.总磷}" maxlength="6" min="0" max="99" step="0.1" />
				<span class="add-on">mg/L</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="可溶性总磷" class="control-label">可溶性总磷（P）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="可溶性总磷" name="可溶性总磷" class="required input-small" type="number"
					value="${data.可溶性总磷}" maxlength="5" min="0" max="9.9" step="0.1" />
				<span class="add-on">mg/L</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="pH" class="control-label">pH:</label>
			<div class="controls">
				<input id="pH" name="pH" class="required input-small" type="number"
					value="${data.pH}" maxlength="3" min="5" max="9" step="0.1"/>
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