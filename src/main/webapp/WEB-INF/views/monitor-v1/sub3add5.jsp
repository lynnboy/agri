<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>记录 - 产流样品</title>

<script type="text/javascript">
var mode='${mode}';
$(document).ready(function() {
	var 种植季list = {
			0: "== 请选择 ==",
	        "0-": "0 季",
	        "1": "1 季",
	        "2": "2 季",
	        "3": "3 季",
	        "4": "4 季",
	        "5": "5 季",
	        "6": "6 季",
	        "7": "7 季",
	        "8": "8 季",
	        "9": "9 季",
	};
	fillSelect("#种植季", 种植季list);
	
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
<c:forEach var="act" items="${actions}">
		<li class='<c:if test="${act.active}">active</c:if>'>
			<a href="${base}${act.url}">
			<c:if test="${empty act.icon}"><i class='${act.icon}'>&nbsp;</i></c:if>
				${act.title}</a>
		</li>
</c:forEach>
	</ul>

<p>

地块编码: ${id}<br>
承担单位: ${maindata.承担单位}<br>
地块地址: ${maindata.地块地址}

</p>

<%@include file="/WEB-INF/views/common/message.jsp"%>

	<form id="inputForm" class="form-horizontal" method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />

		<div class="control-group">
			<label for="监测年度" class="control-label">监测年度:</label>
			<div class="controls">
<c:if test="${mode == 'add'}">
				<input id="监测年度" name="监测年度" type="text" value="${data.监测年度}"
				 class="required digits" min="1970" max="2099" />
				<span class="help-inline"><font color="red">*</font> </span>
</c:if>
<c:if test="${mode != 'add'}">
				<input id="监测年度" name="监测年度" type="text" value="${data.监测年度}" readonly />
</c:if>
			</div>
		</div>

		<div class="control-group">
			<label for="产流样品编码" class="control-label">产流样品编码:</label>
			<div class="controls">
				<input id="产流样品编码" name="产流样品编码" class="required 产流样品编码 input-small" type="text"
					value="${data.产流样品编码}" maxlength="7" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="种植季" class="control-label">种植季:</label>
			<div class="controls">
<c:if test="${mode == 'add'}">
				<select id="种植季" name="种植季" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
</c:if>
<c:if test="${mode != 'add'}">
				<select id="种植季" name="种植季" class="reqselect" disabled></select>
</c:if>
			</div>
		</div>
		<div class="control-group">
			<label for="产流量" class="control-label">产流量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="产流量" name="产流量" class="required input-small" type="number"
					value="${data.产流量}" maxlength="8" min="0" max="99999" step="1" />
				<span class="add-on">L/检测单元</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="产流日期" class="control-label">产流日期:</label>
			<div class="controls">
				<input id="产流日期" name="产流日期" type="text" readonly="readonly"
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

		<div class="form-actions">
<c:if test="${mode != 'view'}">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="保 存" />&nbsp;
</c:if>
			<input id="btnCancel" class="btn" type="button"
				value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>