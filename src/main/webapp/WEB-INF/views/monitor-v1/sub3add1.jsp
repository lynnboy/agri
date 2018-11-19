<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>记录 - 种植</title>

<script type="text/javascript">
var mode='${mode}';
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
	var 种植方式list = { 0:'== 请选择 ==',"播种":"播种","移栽":"移栽" };
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#种植方式", 种植方式list);
	
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

		<div class="control-group">
			<label for="作物名称" class="control-label">作物名称:</label>
			<div class="controls">
				<input id="作物名称" name="作物名称" class="ignore" readonly type="text"
					value="小麦"></input>
			</div>
		</div>
		<div class="control-group">
			<label for="作物品种" class="control-label">作物品种:</label>
			<div class="controls">
				<input id="作物品种" name="作物品种" class="input-xlarge required" type="text" value="${data.作物品种}" maxlength="20" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="种植方式" class="control-label">种植方式:</label>
			<div class="controls">
				<select id="种植方式" name="种植方式" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="种植日期" class="control-label">种植日期:</label>
			<div class="controls">
				<input id="种植日期" name="种植日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value=""
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="收获日期" class="control-label">收获日期:</label>
			<div class="controls">
				<input id="收获日期" name="收获日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value=""
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
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