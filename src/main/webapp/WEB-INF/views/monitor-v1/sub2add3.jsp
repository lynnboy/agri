<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - 灌溉与秸秆</title>

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
	var 灌水方式list = {
			0: '== 请选择 ==',
	        "大水漫灌": "大水漫灌",
	        "滴灌": "滴灌",
	        "畦灌": "畦灌",
	        "浇灌": "浇灌",
	        "喷灌": "喷灌",
	        "无灌溉": "无灌溉",
	};
	var 作物类别list = {
		0: '== 请选择 ==',
		"LC01": "LC01-粮食①水稻",
		"LC02": "LC02-粮食②小麦",
		"LC03": "LC03-粮食③玉米",
		"LC04": "LC04-粮食④其他谷物",
		"LC05": "LC05-粮食⑤大豆",
		"LC06": "LC06-粮食⑥其他豆类",
		"LC07": "LC07-粮食⑦甘薯",
		"LC08": "LC08-粮食⑧马铃薯",
		"JC01": "JC01-经济①棉花",
		"JC02": "JC02-经济②麻类",
		"JC03": "JC03-经济③桑类",
		"JC04": "JC04-经济④籽用油菜",
		"JC05": "JC05-经济⑤其他油料作物",
		"JC06": "JC06-经济⑥甘蔗",
		"JC07": "JC07-经济⑦甜菜",
		"JC08": "JC08-经济⑧烟草",
		"JC09": "JC09-经济⑨茶",
		"JC10": "JC10-经济⑩花卉",
		"JC11": "JC11-经济⑪药材",
		"JC12": "JC12-经济⑫落叶果树",
		"JC13": "JC13-经济⑬常绿果树",
		"JC14": "JC14-经济⑭香蕉",
		"JC15": "JC15-经济⑮其他果树",
		"JC16": "JC16-经济⑯其他",
		"SC01": "SC01-蔬菜①根茎叶类蔬菜",
		"SC02": "SC02-蔬菜②瓜果类蔬菜",
		"SC03": "SC03-蔬菜③水生蔬菜",
		"XX01": "XX01-休闲①休闲",
	};
	var 还田方式list = {
			0: '== 请选择 ==',
	        "覆盖": "覆盖",
	        "翻压": "翻压",
	        "无还田": "无还田",
	}
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#是否灌溉", 是否list);
	fillSelect("#灌溉方式", 灌水方式list);
	fillSelect("#是否秸秆还田", 是否list);
	fillSelect("#秸秆名称", 作物类别list);
	fillSelect("#还田方式", 还田方式list);
	
	if (mode != "add") {
		$("#处理编码").val('${data.处理编码}');
		$("#种植季").val('${data.种植季}');
		$("#是否灌溉").val('${data.是否灌溉}');
		$("#灌溉方式").val('${data.灌溉方式}');
		$("#是否秸秆还田").val('${data.是否秸秆还田}');
		$("#秸秆名称").val('${data.秸秆名称}');
		$("#还田方式").val('${data.还田方式}');
		$("#灌溉量").val(Math.round('${data.灌溉量}'));
		$("#还田量").val(Math.round('${data.还田量}'));
		$("#还田比例").val(Math.round('${data.还田比例}'));
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
<h4>灌溉</h4>
<hr/>

		<div class="control-group">
			<label for="是否灌溉" class="control-label">是否灌溉:</label>
			<div class="controls">
				<select id="是否灌溉" name="是否灌溉" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="灌溉方式" class="control-label">灌溉方式:</label>
			<div class="controls">
				<select id="灌溉方式" name="灌溉方式" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="灌溉量" class="control-label">灌溉量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="灌溉量" name="灌溉量" class="required digits input-small" type="number"
					value="${data.灌溉量}" min="0" max="9999" maxlength="4"></input>
				<span class="add-on">mm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<br/>
<h4>秸秆还田</h4>
<hr/>

		<div class="control-group">
			<label for="是否秸秆还田" class="control-label">是否秸秆还田:</label>
			<div class="controls">
				<select id="是否秸秆还田" name="是否秸秆还田" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="秸秆名称" class="control-label">秸秆名称:</label>
			<div class="controls">
				<select id="秸秆名称" name="秸秆名称" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="还田方式" class="control-label">还田方式:</label>
			<div class="controls">
				<select id="还田方式" name="还田方式" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="还田量" class="control-label">还田量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="还田量" name="还田量" class="required digits input-small" type="number"
					value="${data.还田量}" min="0" max="9999" maxlength="4"></input>
				<span class="add-on">kg/666.7m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="还田比例" class="control-label">还田比例:</label>
			<div class="controls">
				<span class="input-append">
				<input id="还田比例" name="还田比例" class="required digits input-small" type="number"
					value="${data.还田比例}" min="0" max="100" maxlength="3"></input>
				<span class="add-on">%</span>
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