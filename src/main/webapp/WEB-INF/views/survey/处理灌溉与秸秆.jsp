<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - 灌溉与秸秆</title>
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
	var 是否list = [ '== 请选择 ==','是','否' ];
	var 灌水方式list = [ '== 请选择 ==','大水漫灌','滴灌','畦灌','浇灌','喷灌','无灌溉' ];
	var 作物类别list = [
		'== 请选择 ==',
		'粮食①LC01水稻',
		'粮食②LC02小麦',
		'粮食③LC03玉米',
		'粮食④LC04其他谷物',
		'粮食⑤LC05大豆',
		'粮食⑥LC06其他豆类',
		'粮食⑦LC07甘薯',
		'粮食⑧LC08马铃薯',
		'经济①JC01棉花',
		'经济②JC02麻类',
		'经济③JC03桑类',
		'经济④JC04籽用油菜',
		'经济⑤JC05其他油料作物',
		'经济⑥JC06甘蔗',
		'经济⑦JC07甜菜',
		'经济⑧JC08烟草',
		'经济⑨JC09茶',
		'经济⑩JC10花卉',
		'经济⑪JC11药材',
		'经济⑫JC12落叶果树',
		'经济⑬JC13常绿果树',
		'经济⑭JC14香蕉',
		'经济⑮JC15其他果树',
		'经济⑯JC16其他',
		'蔬菜①SC01根茎叶类蔬菜',
		'蔬菜②SC02瓜果类蔬菜',
		'蔬菜③SC03水生蔬菜',
		'休闲①XX01休闲',
	];
	var 还田方式list = [ '== 请选择 ==',"覆盖","翻压","无还田" ];
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#是否灌溉", 是否list);
	fillSelect("#灌水方式", 灌水方式list);
	fillSelect("#是否还田", 是否list);
	fillSelect("#还田秸秆名称", 作物类别list);
	fillSelect("#还田方式", 还田方式list);
	
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
		<li class="active"><a href="${base}/agri/add">处理灌溉与秸秆</a></li>
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
			<label for="灌水方式" class="control-label">灌水方式:</label>
			<div class="controls">
				<select id="灌水方式" name="灌水方式" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="灌水量" class="control-label">灌水量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="灌水量" name="灌水量" class="required digits input-small" type="number"
					value="${data.灌水量}" min="0" max="9999" maxlength="4"></input>
				<span class="add-on">mm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<br/>
<h4>秸秆还田</h4>
<hr/>

		<div class="control-group">
			<label for="是否还田" class="control-label">是否还田:</label>
			<div class="controls">
				<select id="是否还田" name="是否还田" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="还田秸秆名称" class="control-label">还田秸秆名称:</label>
			<div class="controls">
				<select id="还田秸秆名称" name="还田秸秆名称" class="reqselect"></select>
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
				<span class="add-on">kg/667m<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="秸秆还田比例" class="control-label">秸秆还田比例:</label>
			<div class="controls">
				<span class="input-append">
				<input id="秸秆还田比例" name="秸秆还田比例" class="required digits input-small" type="number"
					value="${data.秸秆还田比例}" min="0" max="100" maxlength="3"></input>
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