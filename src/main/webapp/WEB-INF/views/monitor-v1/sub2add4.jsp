<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - 地膜与植物篱</title>
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
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#是否覆膜", 是否list);
	fillSelect("#是否揭膜", 是否list);
	fillSelect("#植物篱是否种植", 是否list);
	
	if (mode != "add") {
		$("#处理编码").val('${data.处理编码}');
		$("#种植季").val('${data.种植季}');
		$("#是否覆膜").val('${data.是否覆膜}');
		$("#是否揭膜").val('${data.是否揭膜}');
		$("#植物篱是否种植").val('${data.植物篱是否种植}');
		$("#覆膜量").val(Math.round('${data.覆膜量}'));
		$("#覆膜比例").val(Math.round('${data.覆膜比例}'));
		$("#植物篱带宽").val(Math.round('${data.植物篱带宽}'));
		$("#植物篱间距").val(Math.round('${data.植物篱间距}'));
		$("#植物篱条带数量").val(Math.round('${data.植物篱条带数量}'));
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
<h4>地膜</h4>
<hr/>

		<div class="control-group">
			<label for="是否覆膜" class="control-label">是否覆膜:</label>
			<div class="controls">
				<select id="是否覆膜" name="是否覆膜" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="地膜厚度" class="control-label">地膜厚度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="地膜厚度" name="地膜厚度" class="required input-small" type="number"
					value="${data.地膜厚度}" min="0" max="9。999" step="0.001" maxlength="5"></input>
				<span class="add-on">mm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="覆膜日期" class="control-label">覆膜日期:</label>
			<div class="controls">
				<input id="覆膜日期" name="覆膜日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value="${data.覆膜日期}"
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="覆膜量" class="control-label">覆膜量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="覆膜量" name="覆膜量" class="required digits input-small" type="number"
					value="${data.覆膜量}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="覆膜比例" class="control-label">覆膜比例:</label>
			<div class="controls">
				<span class="input-append">
				<input id="覆膜比例" name="覆膜比例" class="required digits input-small" type="number"
					value="${data.覆膜比例}" min="0" max="100" maxlength="3"></input>
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="是否揭膜" class="control-label">是否揭膜:</label>
			<div class="controls">
				<select id="是否揭膜" name="是否揭膜" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="揭膜日期" class="control-label">揭膜日期:</label>
			<div class="controls">
				<input id="揭膜日期" name="揭膜日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value="${data.揭膜日期}"
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<br/>
<h4>植物篱</h4>
<hr/>

		<div class="control-group">
			<label for="植物篱是否种植" class="control-label">是否种植:</label>
			<div class="controls">
				<select id="植物篱是否种植" name="植物篱是否种植" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="植物篱种类" class="control-label">种类:</label>
			<div class="controls">
				<input id="植物篱种类" name="植物篱种类" class="required" type="text"
					value="${data.植物篱种类}" maxlength="10"></input>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="栽种日期" class="control-label">栽种日期:</label>
			<div class="controls">
				<input id="栽种日期" name="栽种日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value="${data.栽种日期 }"
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="植物篱带宽" class="control-label">带宽:</label>
			<div class="controls">
				<span class="input-append">
				<input id="植物篱带宽" name="植物篱带宽" class="required digits input-small" type="number"
					value="${data.植物篱带宽}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="植物篱间距" class="control-label">间距:</label>
			<div class="controls">
				<span class="input-append">
				<input id="植物篱间距" name="植物篱间距" class="required digits input-small" type="number"
					value="${data.植物篱间距}" min="0" max="999" maxlength="3"></input>
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="植物篱条带数量" class="control-label">条带数量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="植物篱条带数量" name="植物篱条带数量" class="required digits input-small" type="number"
					value="${data.植物篱条带数量}" min="0" max="99" maxlength="2"></input>
				<span class="add-on">条</span>
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