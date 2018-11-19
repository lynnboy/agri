<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - 耕作</title>

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
	var 是否list = { 0: '== 请选择 ==','是':'是','否':'否' };
	var 有无list = { 0: '== 请选择 ==','有':'有','无':'无' };
	var 种植方向list = [ '== 请选择 ==','横坡','顺坡' ];
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#是否翻耕", 是否list);
	fillSelect("#有无排水沟", 有无list);
	fillSelect("#种植方向1", 种植方向list);
	fillSelect("#种植方向2", 种植方向list);

	if (mode != "add") {
		$("#处理编码").val('${data.处理编码}');
		$("#种植季").val('${data.种植季}');
		$("#是否翻耕").val('${data.是否翻耕}');
		$("#有无排水沟").val('${data.有无排水沟}');
		$("#种植方向1").val('${data.种植方向1}');
		$("#种植方向2").val('${data.种植方向2}');
		$("#翻耕深度").val(Math.round('${data.翻耕深度}'));
		$("#排水沟深").val(Math.round('${data.排水沟深}'));
		$("#排水沟宽").val(Math.round('${data.排水沟宽}'));
		$("#排水沟间距").val(Math.round('${data.排水沟间距}'));
		$("#垄高1").val(Math.round('${data.垄高1}'));
		$("#垄宽1").val(Math.round('${data.垄宽1}'));
		$("#垄间距1").val(Math.round('${data.垄间距1}'));
		$("#垄高2").val(Math.round('${data.垄高2}'));
		$("#垄宽2").val(Math.round('${data.垄宽2}'));
		$("#垄间距2").val(Math.round('${data.垄间距2}'));
	}

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