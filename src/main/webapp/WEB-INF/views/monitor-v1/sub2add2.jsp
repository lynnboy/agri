<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - 肥料</title>
<script type="text/javascript">
var mode = '${mode}';
$(document).ready(function() {
	var 处理list = {
		0: '== 请选择 ==',
		"CK": "CK",
		"KF": "KF",
		"BMP": "BMP",
		"TR1": "TR1",
		"TR2": "TR2",
		"TR3": "TR3",
		"TR4": "TR4",
		"TR5": "TR5",
		"TR6": "TR6",
		"TR7": "TR7",
		"TR8": "TR8",
		"TR9": "TR9",
		"TR10": "TR10",
		"TR11": "TR11",
		"TR12": "TR12",
		"TR13": "TR13",
		"TR14": "TR14",
	};
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
	var 有机肥类型list = {
			0: '== 请选择 ==',
	        "FM01": "FM01-商品有机肥",
	        "FM02": "FM02-鸡粪",
	        "FM03": "FM03-猪粪",
	        "FM04": "FM04-牛粪",
	        "FM05": "FM05-其他禽粪",
	        "FM06": "FM06-其他畜粪",
	        "FM07": "FM07-其他有机肥",
	        "FL00": "FL00-不施肥",
	}
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#有机肥类型", 有机肥类型list);
	
	if (mode != "add") {
		$("#处理编码").val('${data.处理编码}');
		$("#种植季").val('${data.种植季}');
		$("#有机肥类型").val('${data.有机肥类型}');
		$("#化肥N").val(Math.round('${data.化肥N}'));
		$("#化肥P2O5").val(Math.round('${data.化肥P2O5}'));
		$("#化肥K2O").val(Math.round('${data.化肥K2O}'));
		$("#有机肥").val(Math.round('${data.有机肥}'));
		$("#有机肥含水率").val(Math.round('${data.有机肥含水率}'));
		$("#有机肥N").val(Math.round('${data.有机肥N}'));
		$("#有机肥P2O5").val(Math.round('${data.有机肥P2O5}'));
		$("#有机肥K2O").val(Math.round('${data.有机肥K2O}'));
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
			<label for="处理编码" class="control-label">处理编码:</label>
			<div class="controls">
<c:if test="${mode == 'add'}">
				<select id="处理编码" name="处理编码" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
</c:if>
<c:if test="${mode != 'add'}">
				<select id="处理编码" name="处理编码" class="reqselect" disabled></select>
</c:if>
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

<br/>
<h4>化肥</h4>
<hr/>

		<div class="control-group">
			<label for="化肥N" class="control-label">施用量 N (折纯):</label>
			<div class="controls">
				<span class="input-append">
				<input id="化肥N" name="化肥N" class="required digits input-small" type="number"
					value="${data.化肥N}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="化肥P2O5" class="control-label">施用量 P<sub>2</sub>O<sub>5</sub> (折纯):</label>
			<div class="controls">
				<span class="input-append">
				<input id="化肥P2O5" name="化肥P2O5" class="required digits input-small" type="number"
					value="${data.化肥P2O5}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="化肥K2O" class="control-label">施用量 K<sub>2</sub>O (折纯):</label>
			<div class="controls">
				<span class="input-append">
				<input id="化肥K2O" name="化肥K2O" class="required digits input-small" type="number"
					value="${data.化肥K2O}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
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
			<label for="有机肥" class="control-label">施用量 (实物):</label>
			<div class="controls">
				<span class="input-append">
				<input id="有机肥" name="有机肥" class="required digits input-small" type="number"
					value="${data.有机肥}" min="0" max="9999" maxlength="4"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="有机肥N" class="control-label">施用量 N (折纯):</label>
			<div class="controls">
				<span class="input-append">
				<input id="有机肥N" name="有机肥N" class="required digits input-small" type="number"
					value="${data.有机肥N}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="有机肥P2O5" class="control-label">施用量 P<sub>2</sub>O<sub>5</sub> (折纯):</label>
			<div class="controls">
				<span class="input-append">
				<input id="有机肥P2O5" name="有机肥P2O5" class="required digits input-small" type="number"
					value="${data.有机肥P2O5}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="有机肥K2O" class="control-label">施用量 K<sub>2</sub>O (折纯):</label>
			<div class="controls">
				<span class="input-append">
				<input id="有机肥K2O" name="有机肥K2O" class="required digits input-small" type="number"
					value="${data.有机肥K2O}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
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