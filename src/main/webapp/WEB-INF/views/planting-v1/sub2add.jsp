<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>种植模式面积</title>

<script type="text/javascript">
function save(data) {
	console.log("save")
}
function ok(data) {
	if ($("#inputForm").valid()) {
		save({
			行政区划代码: '${id}',
			模式代码:$("#模式代码").val(),
			模式面积:$("#模式面积").val(),
			});
		cancel();
	}
}
function cancel() {
	console.log("cancel")
}
var mode = '${mode}';
$(document).ready(function() {
	var 种植模式list = {
		0: "== 请选择 ==",
		"BF01": "【BF01】北方高原山地区-缓坡地-非梯田-顺坡-大田作物",
		"BF02": "【BF02】北方高原山地区-缓坡地-非梯田-横坡-大田作物",
		"BF03": "【BF03】北方高原山地区-缓坡地-梯田-大田作物",
		"BF04": "【BF04】北方高原山地区-缓坡地-非梯田-园地",
		"BF05": "【BF05】北方高原山地区-缓坡地-梯田-园地",
		"BF06": "【BF06】北方高原山地区-陡坡地-非梯田-顺坡-大田作物",
		"BF07": "【BF07】北方高原山地区-陡坡地-非梯田-横坡-大田作物",
		"BF08": "【BF08】北方高原山地区-陡坡地-梯田-大田作物",
		"BF09": "【BF09】北方高原山地区-陡坡地-非梯田-园地",
		"BF10": "【BF10】北方高原山地区-陡坡地-梯田-园地",
		"NF01": "【NF01】南方山地丘陵区-缓坡地-非梯田-顺坡-大田作物",
		"NF02": "【NF02】南方山地丘陵区-缓坡地-非梯田-横坡-大田作物",
		"NF03": "【NF03】南方山地丘陵区-缓坡地-梯田-大田作物",
		"NF04": "【NF04】南方山地丘陵区-缓坡地-非梯田-园地",
		"NF05": "【NF05】南方山地丘陵区-缓坡地-梯田-园地",
		"NF06": "【NF06】南方山地丘陵区-缓坡地-梯田-水旱轮作",
		"NF07": "【NF07】南方山地丘陵区-缓坡地-梯田-其它水田",
		"NF08": "【NF08】南方山地丘陵区-陡坡地-非梯田-顺坡-大田作物",
		"NF09": "【NF09】南方山地丘陵区-陡坡地-非梯田-横坡-大田作物",
		"NF10": "【NF10】南方山地丘陵区-陡坡地-梯田-大田作物",
		"NF11": "【NF11】南方山地丘陵区-陡坡地-非梯田-园地",
		"NF12": "【NF12】南方山地丘陵区-陡坡地-梯田-园地",
		"NF13": "【NF13】南方山地丘陵区-陡坡地-梯田-水旱轮作",
		"NF14": "【NF14】南方山地丘陵区-陡坡地-梯田-其它水田",
		"DB01": "【DB01】东北半湿润平原区-露地蔬菜",
		"DB02": "【DB02】东北半湿润平原区-保护地",
		"DB03": "【DB03】东北半湿润平原区-春玉米",
		"DB04": "【DB04】东北半湿润平原区-大豆",
		"DB05": "【DB05】东北半湿润平原区-其它大田作物",
		"DB06": "【DB06】东北半湿润平原区-园地",
		"DB07": "【DB07】东北半湿润平原区-单季稻",
		"HH01": "【HH01】黄淮海半湿润平原区-露地蔬菜",
		"HH02": "【HH02】黄淮海半湿润平原区-保护地",
		"HH03": "【HH03】黄淮海半湿润平原区-小麦玉米轮作",
		"HH04": "【HH04】黄淮海半湿润平原区-其它大田作物",
		"HH05": "【HH05】黄淮海半湿润平原区-单季稻",
		"HH06": "【HH06】黄淮海半湿润平原区-园地",
		"NS01": "【NS01】南方湿润平原区-露地蔬菜",
		"NS02": "【NS02】南方湿润平原区-保护地",
		"NS03": "【NS03】南方湿润平原区-大田作物",
		"NS04": "【NS04】南方湿润平原区-单季稻",
		"NS05": "【NS05】南方湿润平原区-稻麦轮作",
		"NS06": "【NS06】南方湿润平原区-稻油轮作",
		"NS07": "【NS07】南方湿润平原区-稻菜轮作",
		"NS08": "【NS08】南方湿润平原区-其它水旱轮作",
		"NS09": "【NS09】南方湿润平原区-双季稻",
		"NS10": "【NS10】南方湿润平原区-其它水田",
		"NS11": "【NS11】南方湿润平原区-园地",
		"XB01": "【XB01】西北干旱半干旱平原区-露地蔬菜",
		"XB02": "【XB02】西北干旱半干旱平原区-保护地",
		"XB03": "【XB03】西北干旱半干旱平原区-灌区-棉花",
		"XB04": "【XB04】西北干旱半干旱平原区-灌区-其它大田作物",
		"XB05": "【XB05】西北干旱半干旱平原区-单季稻",
		"XB06": "【XB06】西北干旱半干旱平原区-灌区-园地",
		"XB07": "【XB07】西北干旱半干旱平原区-非灌区",
	};
	fillSelect("#模式代码", 种植模式list);
	$("#模式代码").val('${data.模式代码}');
	$("#模式面积").val('${data.模式面积}');

	$("#inputForm").validate({
		rules: {
			地块编码: { required: true, pattern: /^\d{8}$/ },
		},
		messages: {
			地块编码: { pattern: '请输入8位数字编码' },
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
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<div class="control-group">
			<label for="模式代码" class="control-label">种植模式:</label>
			<div class="controls">
<c:if test="${mode == 'add'}">
				<select id="模式代码" name="模式代码" class="reqselect span5"></select>
				<span class="help-inline"><font color="red">*</font> </span>
</c:if>
<c:if test="${mode != 'add'}">
				<select id="模式代码" disabled name="模式代码" class="span5"></select>
</c:if>
			</div>
		</div>
		<div class="control-group">
			<label for="模式面积" class="control-label">模式面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="模式面积" name="模式面积" class="required input-small" type="text" value="${data.模式面积}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="确 定" onclick="ok(); return false;" />&nbsp; 
			<input id="btnCancel" class="btn" type="button"
				value="取 消" onclick="cancel(); return false;" />
		</div>
	</form>
</body>
</html>