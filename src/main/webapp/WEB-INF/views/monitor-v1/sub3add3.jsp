<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>记录 - 施肥</title>

<script type="text/javascript">
var mode="${mode}";
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
	var 肥料类别及代码list = [
		'== 请选择 ==',
		"氮肥①FN01尿素",
		"氮肥②FN02碳铵",
		"氮肥③FN03硫铵",
		"氮肥④FN04硝铵",
		"氮肥⑤FN05氯铵",
		"氮肥⑥FN06氨水",
		"氮肥⑦FN07缓释尿素",
		"磷肥①FP01普钙",
		"磷肥②FP02钙镁磷肥",
		"磷肥③FP03重钙",
		"磷肥④FP04磷矿粉",
		"钾肥①FK01氯化钾",
		"钾肥②FK02硫酸钾",
		"钾肥③FK03硫酸钾镁",
		"复合肥①FC01磷酸二铵",
		"复合肥②FC02磷酸一铵",
		"复合肥③FC03磷酸二氢钾",
		"复合肥④FC04硝酸钾",
		"复合肥⑤FC05有机无机复合肥",
		"复合肥⑥FC06其它二三元复合肥",
		"有机肥①FM01商品有机肥",
		"有机肥②FM02鸡粪",
		"有机肥③FM03猪粪",
		"有机肥④FM04牛粪",
		"有机肥⑤FM05其他禽粪",
		"有机肥⑥FM06其他畜粪",
		"有机肥⑦FM07其他有机肥",
		"不施肥①FL00不施肥",
	];
	var 施肥方式list = [ '== 请选择 ==', "撒施","条施","沟施","穴施","叶面喷施","冲施","滴灌施" ];
	fillSelect("#处理编码", 处理list);
	fillSelect("#种植季", 种植季list);
	fillSelect("#肥料类别及代码", 肥料类别及代码list);
	fillSelect("#施肥方式", 施肥方式list);
	
	$("#inputForm").validate({
		rules: {
			N: { sumLessThan100: ["#N","#P2O5","#K2O"] },
			P2O5: { sumLessThan100: ["#N","#P2O5","#K2O"] },
			K2O: { sumLessThan100: ["#N","#P2O5","#K2O"] },
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

		<div class="control-group">
			<label for="作物名称" class="control-label">作物名称:</label>
			<div class="controls">
				<input id="作物名称" name="作物名称" class="ignore" readonly type="text"
					value="小麦"></input>
			</div>
		</div>
		<div class="control-group">
			<label for="肥料名称" class="control-label">肥料名称:</label>
			<div class="controls">
				<input id="肥料名称" name="肥料名称" class="required" type="text" value="${data.肥料名称}" maxlength="10" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="肥料类别及代码" class="control-label">肥料类别及代码:</label>
			<div class="controls">
				<select id="肥料类别及代码" name="肥料类别及代码" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="含水率" class="control-label">含水率（烘干基）:</label>
			<div class="controls">
				<span class="input-append">
				<input id="含水率" name="含水率" class="required input-small" type="number"
					value="${data.含水率}" maxlength="4" min="0" max="99.9" step=".1" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="N" class="control-label">N:</label>
			<div class="controls">
				<span class="input-append">
				<input id="N" name="N" class="required input-small" type="number"
					value="${data.N}" maxlength="6" min="0" max="100" step="0.1" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="P2O5" class="control-label">P2O5:</label>
			<div class="controls">
				<span class="input-append">
				<input id="P2O5" name="P2O5" class="required input-small" type="number"
					value="${data.P2O5}" maxlength="6" min="0" max="100" step="0.1" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="K2O" class="control-label">K2O:</label>
			<div class="controls">
				<span class="input-append">
				<input id="K2O" name="K2O" class="required input-small" type="number"
					value="${data.K2O}" maxlength="6" min="0" max="100" step="0.1" />
				<span class="add-on">%</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="施肥日期" class="control-label">施肥日期:</label>
			<div class="controls">
				<input id="施肥日期" name="施肥日期" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value=""
					onchange="return $(this).valid();"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', isShowClear: false,minDate:'2016-01-01',maxDate:'2020-12-31'});" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="施肥方式" class="control-label">施肥方式:</label>
			<div class="controls">
				<select id="施肥方式" name="施肥方式" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="施用量" class="control-label">施用量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="施用量" name="施用量" class="required input-small" type="number"
					value="${data.施用量}" maxlength="8" min="0" max="9999"/>
				<span class="add-on">公斤/小区</span>
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