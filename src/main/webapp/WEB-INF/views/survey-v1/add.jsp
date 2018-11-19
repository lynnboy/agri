<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${mode == "add" ?"添加":"修改"}数据</title>

<script type="text/javascript">
var mode = '${mode}';
function updateTags() {
	var value = $("#tags").val();
	var values = value ? value.split(',') : [];
	var tags = [];
	$.each(values, function(idx,val) {
		var v = val.trim();
		if (v) tags.push(v);
	});
	$("#tags").val(tags.join(","));
	var $taglist = $("#taglist");
	$taglist.empty();
	$.each(tags, function(idx, text) {
		var $tag = $('<span class="label">').text(text).appendTo($taglist);
		if (text.indexOf('?') != -1) $tag.addClass('label-warning');
		if (text.indexOf('!') != -1) $tag.addClass('label-important');
		$taglist.append(" ");
	});
}
$(document).ready(function() {
	var 种植模式分区list = {0:"== 请选择 ==", 1:"北方高原山地区", 2:"东北半湿润平原区", 3:"黄淮海半湿润平原区", 4:"南方山地丘陵区", 5:"南方湿润平原区", 6:"西北干旱半干旱平原区"};
	var 地貌类型list = {0:"== 请选择 ==", 1:"高原", 2:"山地", 3:"丘陵", 4:"平原", 5:"盆地"};
	var 地貌类型map = {0:[0,1,2,3,4,5], 1:[0,1,2,3,4,5], 2:[4], 3:[4], 4:[0,1,2,3,4,5], 5:[4], 6:[4]};
	var 地形list = {0:"== 请选择 ==", 1:"平地（≤5°）", 2:"缓坡（5°-15°）", 3:"陡坡（≥15°）"};
	var 地形map = {0:[0,1,2,3], 1:[0,1,2,3], 2:[0,2,3], 3:[0,2,3], 4:[1], 5:[0,1,2,3]};
	var 是否梯田list = {0:"== 请选择 ==", 1:"是", 2:"否"};
	var 是否梯田map = {0:[0,1,2], 1:[2], 2:[0,1,2], 3:[0,1,2]};
	var 种植模式list = {
		'': "== 请选择 ==",
		'BF01': "【BF01】北方高原山地区-缓坡地-非梯田-顺坡-大田作物",
		'BF02': "【BF02】北方高原山地区-缓坡地-非梯田-横坡-大田作物",
		'BF03': "【BF03】北方高原山地区-缓坡地-梯田-大田作物",
		'BF04': "【BF04】北方高原山地区-缓坡地-非梯田-园地",
		'BF05': "【BF05】北方高原山地区-缓坡地-梯田-园地",
		'BF06': "【BF06】北方高原山地区-陡坡地-非梯田-顺坡-大田作物",
		'BF07': "【BF07】北方高原山地区-陡坡地-非梯田-横坡-大田作物",
		'BF08': "【BF08】北方高原山地区-陡坡地-梯田-大田作物",
		'BF09': "【BF09】北方高原山地区-陡坡地-非梯田-园地",
		'BF10': "【BF10】北方高原山地区-陡坡地-梯田-园地",
		'NF01': "【NF01】南方山地丘陵区-缓坡地-非梯田-顺坡-大田作物",
		'NF02': "【NF02】南方山地丘陵区-缓坡地-非梯田-横坡-大田作物",
		'NF03': "【NF03】南方山地丘陵区-缓坡地-梯田-大田作物",
		'NF04': "【NF04】南方山地丘陵区-缓坡地-非梯田-园地",
		'NF05': "【NF05】南方山地丘陵区-缓坡地-梯田-园地",
		'NF06': "【NF06】南方山地丘陵区-缓坡地-梯田-水旱轮作",
		'NF07': "【NF07】南方山地丘陵区-缓坡地-梯田-其它水田",
		'NF08': "【NF08】南方山地丘陵区-陡坡地-非梯田-顺坡-大田作物",
		'NF09': "【NF09】南方山地丘陵区-陡坡地-非梯田-横坡-大田作物",
		'NF10': "【NF10】南方山地丘陵区-陡坡地-梯田-大田作物",
		'NF11': "【NF11】南方山地丘陵区-陡坡地-非梯田-园地",
		'NF12': "【NF12】南方山地丘陵区-陡坡地-梯田-园地",
		'NF13': "【NF13】南方山地丘陵区-陡坡地-梯田-水旱轮作",
		'NF14': "【NF14】南方山地丘陵区-陡坡地-梯田-其它水田",
		'DB01': "【DB01】东北半湿润平原区-露地蔬菜",
		'DB02': "【DB02】东北半湿润平原区-保护地",
		'DB03': "【DB03】东北半湿润平原区-春玉米",
		'DB04': "【DB04】东北半湿润平原区-大豆",
		'DB05': "【DB05】东北半湿润平原区-其它大田作物",
		'DB06': "【DB06】东北半湿润平原区-园地",
		'DB07': "【DB07】东北半湿润平原区-单季稻",
		'HH01': "【HH01】黄淮海半湿润平原区-露地蔬菜",
		'HH02': "【HH02】黄淮海半湿润平原区-保护地",
		'HH03': "【HH03】黄淮海半湿润平原区-小麦玉米轮作",
		'HH04': "【HH04】黄淮海半湿润平原区-其它大田作物",
		'HH05': "【HH05】黄淮海半湿润平原区-单季稻",
		'HH06': "【HH06】黄淮海半湿润平原区-园地",
		'NS01': "【NS01】南方湿润平原区-露地蔬菜",
		'NS02': "【NS02】南方湿润平原区-保护地",
		'NS03': "【NS03】南方湿润平原区-大田作物",
		'NS04': "【NS04】南方湿润平原区-单季稻",
		'NS05': "【NS05】南方湿润平原区-稻麦轮作",
		'NS06': "【NS06】南方湿润平原区-稻油轮作",
		'NS07': "【NS07】南方湿润平原区-稻菜轮作",
		'NS08': "【NS08】南方湿润平原区-其它水旱轮作",
		'NS09': "【NS09】南方湿润平原区-双季稻",
		'NS10': "【NS10】南方湿润平原区-其它水田",
		'NS11': "【NS11】南方湿润平原区-园地",
		'XB01': "【XB01】西北干旱半干旱平原区-露地蔬菜",
		'XB02': "【XB02】西北干旱半干旱平原区-保护地",
		'XB03': "【XB03】西北干旱半干旱平原区-灌区-棉花",
		'XB04': "【XB04】西北干旱半干旱平原区-灌区-其它大田作物",
		'XB05': "【XB05】西北干旱半干旱平原区-单季稻",
		'XB06': "【XB06】西北干旱半干旱平原区-灌区-园地",
		'XB07': "【XB07】西北干旱半干旱平原区-非灌区",
	};
	var 种植模式map1 = {
			0:[0],
			1:[0],
			2:[0,25,26,27,28,29,30,31],
			3:[0,32,33,34,35,36,37],
			4:[0],
			5:[0,38,39,40,41,42,43,44,45,46,47,48],
			6:[0,49,50,51,52,53,54,55],
	};
	var 种植模式map1a = {0:[0],1:[0,3,5],2:[0,1,2,4]};
	var 种植模式map1b = {0:[0],1:[0,8,10],2:[0,6,7,9]};
	var 种植模式map4a = {0:[0],1:[0,13,15,16,17],2:[0,11,12,14]};
	var 种植模式map4b = {0:[0],1:[0,20,22,23,24],2:[0,18,19,21]};
	
	var 种植方式list = {0: '== 请选择 ==', 1: '大田种植', 2: '保护地种植'};
	var 坡向list = {0: '== 请选择 ==', 1: '东', 2: '南', 3: '西', 4: '北', 5: '东南', 6: '东北', 7: '西南', 8: '西北'};
	var 土壤质地list = {0: '== 请选择 ==', 1: '砂土', 2: '沙壤土', 3: '轻壤', 4: '中壤', 5: '重壤', 6: '粘土', 7: '重粘土'};
	var 土壤类型list = {
			0: '== 请选择 ==',
			1: '铁铝土-湿热铁铝土-砖红壤',
			2: '铁铝土-湿热铁铝土-赤红壤',
			3: '铁铝土-湿热铁铝土-红壤',
			4: '铁铝土-湿暖铁铝土-黄壤',
			5: '淋溶土-湿暖淋溶土-黄棕壤',
			6: '淋溶土-湿暖淋溶土-黄褐土',
			7: '淋溶土-湿暖温淋溶土-棕壤',
			8: '淋溶土-湿温淋溶土-暗棕壤',
			9: '淋溶土-湿温淋溶土-白浆土',
			10: '淋溶土-湿寒温淋溶土-棕色针叶林土',
			11: '淋溶土-湿寒温淋溶土-漂灰土',
			12: '淋溶土-湿寒温淋溶土-灰化土',
			13: '半淋溶土-半湿热半淋溶土-燥红土',
			14: '半淋溶土-半湿暖温半淋溶土-褐土',
			15: '半淋溶土-半湿温半淋溶土-灰褐土',
			16: '半淋溶土-半湿温半淋溶土-黑土',
			17: '半淋溶土-半湿温半淋溶土-灰色森林土',
			18: '钙层土-半湿温钙层土-黑钙土',
			19: '钙层土-半干温钙层土-栗钙土',
			20: '钙层土-半干暖温钙层土-栗褐土',
			21: '钙层土-半干暖温钙层土-黑垆土',
			22: '干旱土-干温干旱土-棕钙土',
			23: '干旱土-干温干旱土-灰钙土',
			24: '漠土-干温漠土-灰漠土',
			25: '漠土-干温漠土-灰棕漠土',
			26: '漠土-干暖温漠土-棕漠土',
			27: '初育土-土质初育土-黄绵土',
			28: '初育土-土质初育土-红粘土',
			29: '初育土-土质初育土-新积土',
			30: '初育土-土质初育土-龟裂土',
			31: '初育土-土质初育土-风沙土',
			32: '初育土-石质初育土-石灰（岩）土',
			33: '初育土-石质初育土-火山灰土',
			34: '初育土-石质初育土-紫色土',
			35: '初育土-石质初育土-磷质石灰土',
			36: '初育土-石质初育土-石质土',
			37: '初育土-石质初育土-粗骨土',
			38: '半水成土-暗半水成土-草甸土',
			39: '半水成土-淡半水成土-潮土',
			40: '半水成土-淡半水成土-砂姜黑土',
			41: '半水成土-淡半水成土-林灌草甸土',
			42: '半水成土-淡半水成土-山地草甸土',
			43: '水成土-矿质水成土-沼泽土',
			44: '水成土-有机水成土-泥炭土',
			45: '盐碱土-盐土-草甸盐土',
			46: '盐碱土-盐土-滨海盐土',
			47: '盐碱土-盐土-酸性硫酸盐土',
			48: '盐碱土-盐土-漠境盐土',
			49: '盐碱土-盐土-寒原盐土',
			50: '盐碱土-碱土-碱土',
			51: '人为土-人为水成土-水稻土',
			52: '人为土-灌耕土-灌淤土',
			53: '人为土-灌耕土-灌漠土',
			54: '高山土-湿寒高山土-草毡土（高山草甸土）',
			55: '高山土-湿寒高山土-黑毡土（亚高山草甸土）',
			56: '高山土-半湿寒高山土-寒钙土（高山草原土）',
			57: '高山土-半湿寒高山土-冷钙土（亚高山草原土）',
			58: '高山土-半湿寒高山土-冷棕钙土（山地灌丛草原土）',
			59: '高山土-干寒高山土-寒漠土（高山漠土）',
			60: '高山土-干寒高山土-冷漠土（亚高山漠土）',
			61: '高山土-寒冻高山土-寒冻土（高山寒漠土）',
	};
	var 肥力水平list = {0: '== 请选择 ==', 1: '高', 2: '中', 3: '低'};
	var 有无障碍层list = {0: '== 请选择 ==', 1: '有', 2: '无'};
	var 障碍层类型list = {0: '== 请选择 ==', 1: '铁盘胶结层', 2: '粘盘层', 3: '潜育层', 4: '盐化层', 5: '碱化层', 6: '夹砂层', 7: '石膏盘层,⑧钙积层'};

	fillSelect("#种植模式", 种植模式list);

	$("#种植模式").val('${data["种植模式"]}');
	
	$("#行政区划,#代码2,#代码3").change(function() {
		$("#行政区划代码").val($('#代码1').val() + $('#代码2').val() + $('#代码3').val());
	});
	$("#行政区划,#地块编码2").change(function() {
		$("#代码1").val($('#行政区划').val());
		$("#地块编码").val($('#行政区划').val() + "DK" + $('#地块编码2').val());
	});
	
	$("#tags").change(function() { updateTags(); });
	updateTags();
	
	if (mode == "view") {
		$("select").attr('disabled', 'disabled');
		$("input,textarea").attr('readonly', 'readonly');
		$("span.help-inline").remove();
	}

	$("#inputForm").validate({
		rules: {
			代码2: { required: true, pattern: /^\d{3}$/ },
			代码3: { required: true, pattern: /^\d{3}$/ },
			地块编码2: { required: true, pattern: /^\d{3}$/ },
		},
		messages: {
			代码2: { pattern: '请输入3位数字编码' },
			代码3: { pattern: '请输入3位数字编码' },
			地块编码2: { pattern: '请输入3位数字编码' },
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
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal" method="post">
		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<div class="control-group">
			<label for="行政区划" class="control-label">行政区划:</label>
			<div class="controls">
<c:choose>
	<c:when test="${mode == 'add'}">
				<select id="行政区划" name="_行政区划代码" class="reqselect">
<c:forEach var="entry" items="${divcodes}">
				<option value="${entry.key}">${entry.key} - ${entry.value}</option>
</c:forEach>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
	</c:when>
	<c:otherwise>
				<input id="行政区划" name="_行政区划代码" class="input-large"
					readonly type="text" value="${divcode} - ${divcodes[divcode]}" maxlength="50" />
	</c:otherwise>
</c:choose>
				<input id="行政区划代码" name="行政区划代码" type="hidden" value="${data['行政区划代码']}"></input>
			</div>
		</div>

		<div class="control-group">
			<label for="乡镇街道" class="control-label">乡、镇、街道:</label>
			<div class="controls">
				<input id="乡镇街道" name="乡镇街道" class="required input-small" type="text"
					value="${data['乡镇街道']}" maxlength="30" />
				编码 <input id="代码2" name="代码2" class="required span1" type="text"
					value="${fn:substring(data['行政区划代码'], 6, 9)}" maxlength="3" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="村" class="control-label">村、居委会:</label>
			<div class="controls">
				<input id="村" name="村" class="required input-small" type="text"
					value="${data['村']}" maxlength="30" />
				编码 <input id="代码3" name="代码3" class="required span1" type="text"
					value="${fn:substring(data['行政区划代码'], 9, 12)}" maxlength="3" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="组" class="control-label">组:</label>
			<div class="controls">
				<input id="组" name="组" class="required input-small" type="text"
					value="${data['组']}" maxlength="5" />
			</div>
		</div>

		<div class="control-group">
			<label for="地块编码2" class="control-label">地块编码:</label>
			<div class="controls">
				<input id="代码1" name="代码1" class="input-small"
					readonly type="text" value="${divcode}" maxlength="50" />
<c:choose>
	<c:when test="${mode == 'add'}">
				<span class="input-prepend">
				<span class="add-on">DK</span>
				<input id="地块编码2" name="地块编码2" class="required span1" style="ime-mode:disabled"
					type="text" value="${fn:substring(id, 8, 11)}" maxlength="3" />
				</span>
					<span class="help-inline"><font color="red">*</font> </span>
	</c:when>
	<c:otherwise>
				<span class="input-prepend">
				<span class="add-on">DK</span>
				<input id="地块编码2" name="地块编码2" class="input-small"
					readonly type="text" value="${fn:substring(id, 8, 11)}" />
				</span>
	</c:otherwise>
</c:choose>
				<input id="地块编码" name="地块编码" class="input-small"
					readonly type="hidden" value="${id}" />
			</div>
		</div>

		<div class="control-group">
			<label for="户主" class="control-label">户主:</label>
			<div class="controls">
				<input id="户主" name="户主" type="text" value="${data['户主']}" maxlength="16" />
			</div>
		</div>
		<div class="control-group">
			<label for="联系电话" class="control-label">联系电话:</label>
			<div class="controls">
				<input id="联系电话" name="联系电话" type="text" value="${data['联系电话']}" class="phoneOrMobile" maxlength="15" />
			</div>
		</div>

		<div class="control-group">
			<label for="经度" class="control-label">经度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="经度" name="经度" class="required input-small" type="text"
				 value="${data['经度']}" maxlength="10" min="70" max="140" />
				<span class="add-on">°</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="纬度" class="control-label">纬度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="纬度" name="纬度" class="required input-small" type="text"
				 value="${data['纬度']}" maxlength="10" min="0" max="55" />
				<span class="add-on">°</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="地块面积" class="control-label">地块面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="地块面积" name="地块面积" class="required input-small" type="text"
				 value="${data['地块面积']}" maxlength="6" max="8000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="种植模式" class="control-label">种植模式:</label>
			<div class="controls">
				<select id="种植模式" name="种植模式" class="reqselect span5"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<h4>杂项</h4>
<hr>

		<div class="control-group">
			<label for="tags" class="control-label">标签:</label>
			<div class="controls">
				<input id="tags" name="tags" class="input-xlarge" type="text" value="${status['tags']}" maxlength="256"/>
			</div>
			<br/>
			<div id="taglist" class="controls">
			</div>
		</div>

		<div class="control-group">
			<label for="remarks" class="control-label">备注:</label>
			<div class="controls">
				<textarea id="remarks" name="remarks" maxlength="200"
					class="input-xlarge" rows="3">${status['remarks']}</textarea>
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