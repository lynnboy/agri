<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${mode == "add" ?"添加":"修改"}数据</title>

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



function show1(data, func) {
	top.$.jBox.open("iframe:${base}/survey/add1and2", "作物覆膜情况",
			$(top.document).width()-320, 360,{
		id: "作物覆膜dialog",
		buttons:{},
		loaded: function(h) {
			var win = h.find("iframe")[0].contentWindow;
			win.cancel = function() {
				top.$.jBox.close("作物覆膜dialog");
			};
			win.save = function(data) {
				func(data);
				top.$.jBox.close("作物覆膜dialog");
			};
			win.load(data);
		}
	});
}
function show2(data, func) {
	var txt = '';
	if (data) txt = data.企业名称;
	promptx("地膜回收企业名称", "企业名称", function(res) {
		func({企业名称: res});
	}, txt);
	return;
	top.$.jBox.open("iframe:${base}/survey/add1and2", "企业名称",
			$(top.document).width()-220, 300,{
		buttons:{},
		loaded: function(h) {
			
		}
	});
}
var mode = '${mode}';
function addRow(data, table, fname) {
	for (var firstkey in data) break;
	var exist = null;
	$(table).find("tbody tr").each(function() {
		var d = $(this).data("data");
		if (d[firstkey] == data[firstkey]) exist = d;
	});
	if (exist) {
		alertx("已经存在" + firstkey + " [" + data[firstkey] + "]");
		return false;
	}

	//console.log(data);
	var $tr = $("<tr>").appendTo($(table).find("tbody"));
	$tr.data('data', data);
	for (var key in data)
		$("<td>").attr("id", key).text(data[key]).appendTo($tr);
	if (mode != "view") {
		var $btns = $("<td>").appendTo($tr);
		$('<a href="javascript:;" onclick="modifyRow(this,' + fname + ')">修改</a>')
			.addClass("btn btn-primary btn-mini").appendTo($btns);
		$btns.append(' ');
		$('<a href="javascript:;" onclick="removeRow(this)">删除</a>')
			.addClass("btn btn-primary btn-mini").appendTo($btns);
	}
	return true;
}
function updateSubtable1() {
	var all = [];
	$("#覆膜情况表 tbody tr").each(function() {
		all.push($(this).data("data"));
	});
	var res = JSON.stringify(all);
	$("#作物覆膜情况").val(b64encode(res));
}
function updateSubtable2() {
	var all = [];
	$("#企业名称表 tbody tr").each(function() {
		all.push($(this).data("data"));
	});
	var res = JSON.stringify(all);
	$("#企业名称").val(b64encode(res));
}
function addRow1(data) {
	addRow(data, "#覆膜情况表", "show1") && updateSubtable1();
}
function addRow2(data) {
	addRow(data, "#企业名称表", "show2") && updateSubtable2();
}
function modifyRow(btn, func) {
	//console.log(btn);
	var $tr = $(btn).parent().parent();
	func($tr.data('data'), function(data) {
		for (var firstkey in data) break;
		var exist = null;
		$tr.siblings().each(function() {
			var d = $(this).data("data");
			if (d[firstkey] == data[firstkey]) exist = d;
		});
		if (exist) {
			alertx("已经存在" + firstkey + " [" + data[firstkey] + "]");
			return;
		}

		$tr.data('data', data);
		for (var key in data)
			$tr.find("#" + key).text(data[key]);
		updateSubtable1();
		updateSubtable2();
	});
}
function removeRow(btn) {
	//console.log(btn);
	$(btn).parent().parent().remove();
}
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
	$('#btnAddRowa').click(function(){
		top.$.jBox.open("iframe:${base}/survey/add1and2",
				"作物覆膜情况",$(top.document).width()-220,$(top.document).height()-200,{
		});
	});
	var 种植模式分区list = {0:"== 请选择 ==", 1:"北方高原山地区", 2:"东北半湿润平原区", 3:"黄淮海半湿润平原区", 4:"南方山地丘陵区", 5:"南方湿润平原区", 6:"西北干旱半干旱平原区"};
	var 地貌类型list = {0:"== 请选择 ==", 1:"高原", 2:"山地", 3:"丘陵", 4:"平原", 5:"盆地"};
	var 地貌类型map = {0:[0,1,2,3,4,5], 1:[0,1,2,3,4,5], 2:[4], 3:[4], 4:[0,1,2,3,4,5], 5:[4], 6:[4]};
	var 地形list = {0:"== 请选择 ==", 1:"平地（≤5°）", 2:"缓坡（5°-15°）", 3:"陡坡（≥15°）"};
	var 地形map = {0:[0,1,2,3], 1:[0,1,2,3], 2:[0,2,3], 3:[0,2,3], 4:[1], 5:[0,1,2,3]};
	var 是否梯田list = {0:"== 请选择 ==", 1:"是", 2:"否"};
	var 是否梯田map = {0:[0,1,2], 1:[2], 2:[0,1,2], 3:[0,1,2]};
	var 种植模式list = {
		0: "== 请选择 ==",
		1: "【BF01】北方高原山地区-缓坡地-非梯田-顺坡-大田作物",
		2: "【BF02】北方高原山地区-缓坡地-非梯田-横坡-大田作物",
		3: "【BF03】北方高原山地区-缓坡地-梯田-大田作物",
		4: "【BF04】北方高原山地区-缓坡地-非梯田-园地",
		5: "【BF05】北方高原山地区-缓坡地-梯田-园地",
		6: "【BF06】北方高原山地区-陡坡地-非梯田-顺坡-大田作物",
		7: "【BF07】北方高原山地区-陡坡地-非梯田-横坡-大田作物",
		8: "【BF08】北方高原山地区-陡坡地-梯田-大田作物",
		9: "【BF09】北方高原山地区-陡坡地-非梯田-园地",
		10: "【BF10】北方高原山地区-陡坡地-梯田-园地",
		11: "【NF01】南方山地丘陵区-缓坡地-非梯田-顺坡-大田作物",
		12: "【NF02】南方山地丘陵区-缓坡地-非梯田-横坡-大田作物",
		13: "【NF03】南方山地丘陵区-缓坡地-梯田-大田作物",
		14: "【NF04】南方山地丘陵区-缓坡地-非梯田-园地",
		15: "【NF05】南方山地丘陵区-缓坡地-梯田-园地",
		16: "【NF06】南方山地丘陵区-缓坡地-梯田-水旱轮作",
		17: "【NF07】南方山地丘陵区-缓坡地-梯田-其它水田",
		18: "【NF08】南方山地丘陵区-陡坡地-非梯田-顺坡-大田作物",
		19: "【NF09】南方山地丘陵区-陡坡地-非梯田-横坡-大田作物",
		20: "【NF10】南方山地丘陵区-陡坡地-梯田-大田作物",
		21: "【NF11】南方山地丘陵区-陡坡地-非梯田-园地",
		22: "【NF12】南方山地丘陵区-陡坡地-梯田-园地",
		23: "【NF13】南方山地丘陵区-陡坡地-梯田-水旱轮作",
		24: "【NF14】南方山地丘陵区-陡坡地-梯田-其它水田",
		25: "【DB01】东北半湿润平原区-露地蔬菜",
		26: "【DB02】东北半湿润平原区-保护地",
		27: "【DB03】东北半湿润平原区-春玉米",
		28: "【DB04】东北半湿润平原区-大豆",
		29: "【DB05】东北半湿润平原区-其它大田作物",
		30: "【DB06】东北半湿润平原区-园地",
		31: "【DB07】东北半湿润平原区-单季稻",
		32: "【HH01】黄淮海半湿润平原区-露地蔬菜",
		33: "【HH02】黄淮海半湿润平原区-保护地",
		34: "【HH03】黄淮海半湿润平原区-小麦玉米轮作",
		35: "【HH04】黄淮海半湿润平原区-其它大田作物",
		36: "【HH05】黄淮海半湿润平原区-单季稻",
		37: "【HH06】黄淮海半湿润平原区-园地",
		38: "【NS01】南方湿润平原区-露地蔬菜",
		39: "【NS02】南方湿润平原区-保护地",
		40: "【NS03】南方湿润平原区-大田作物",
		41: "【NS04】南方湿润平原区-单季稻",
		42: "【NS05】南方湿润平原区-稻麦轮作",
		43: "【NS06】南方湿润平原区-稻油轮作",
		44: "【NS07】南方湿润平原区-稻菜轮作",
		45: "【NS08】南方湿润平原区-其它水旱轮作",
		46: "【NS09】南方湿润平原区-双季稻",
		47: "【NS10】南方湿润平原区-其它水田",
		48: "【NS11】南方湿润平原区-园地",
		49: "【XB01】西北干旱半干旱平原区-露地蔬菜",
		50: "【XB02】西北干旱半干旱平原区-保护地",
		51: "【XB03】西北干旱半干旱平原区-灌区-棉花",
		52: "【XB04】西北干旱半干旱平原区-灌区-其它大田作物",
		53: "【XB05】西北干旱半干旱平原区-单季稻",
		54: "【XB06】西北干旱半干旱平原区-灌区-园地",
		55: "【XB07】西北干旱半干旱平原区-非灌区",
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

	fillSelect("#种植模式分区", 种植模式分区list, [
		{ sel: "#地貌类型", list: 地貌类型list, map: 地貌类型map},
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map1},
	]);
	fillSelect("#地貌类型", 地貌类型list, [
		{ sel: "#地形", list: 地形list, map: 地形map},
	]);
	fillSelect("#地形", 地形list, [{ sel: "#是否梯田", list: 是否梯田list, map: 是否梯田map}]);
	fillSelect("#是否梯田", 是否梯田list, [
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map1a,
			cond: function(){return $('#种植模式分区').val() == 1 && $('#地形').val() == 2;} },
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map1b,
			cond: function(){return $('#种植模式分区').val() == 1 && $('#地形').val() == 3;} },
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map4a,
			cond: function(){return $('#种植模式分区').val() == 4 && $('#地形').val() == 2;} },
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map4b,
			cond: function(){return $('#种植模式分区').val() == 4 && $('#地形').val() == 3;} },
	]);
	fillSelect("#种植方式", 种植方式list);
	fillSelect("#坡向", 坡向list);
	fillSelect("#土壤质地", 土壤质地list);
	fillSelect("#土壤类型", 土壤类型list);
	fillSelect("#肥力水平", 肥力水平list);
	fillSelect("#有无障碍层", 有无障碍层list);
	$("#有无障碍层").change(function() {
		var l = $("#障碍层类型,#障碍层深度,#障碍层厚度");
		if ($(this).val() == 2) {
			l.val(1); l.valid(); l.val(0); 
			l.attr('disabled', 'disabled');
		} else {
			l.removeAttr('disabled');
		}
	});
	fillSelect("#障碍层类型", 障碍层类型list);

	$("#种植模式分区").val('${data["种植模式分区"]}');
	$("#地貌类型").val('${data["地貌类型"]}');
	$("#地形").val('${data["地形"]}');
	$("#是否梯田").val('${data["是否梯田"]}');
	$("#种植模式").val('${data["种植模式"]}');
	$("#种植方式").val('${data["种植方式"]}');
	$("#坡向").val('${data["坡向"]}');
	$("#土壤质地").val('${data["土壤质地"]}');
	$("#土壤类型").val('${data["土壤类型"]}');
	$("#肥力水平").val('${data["肥力水平"]}');
	$("#有无障碍层").val('${data["有无障碍层"]}');
	$("#障碍层类型").val('${data["障碍层类型"]}');
	
	var 覆膜json = '${作物覆膜情况JSON}';
	var 覆膜list = [];
	if (覆膜json) 覆膜list = JSON.parse(覆膜json);
	$.each(覆膜list, function(ind, val) {
		addRow1(val);
	});
	var 企业json = '${企业名称JSON}';
	var 企业list = [];
	if (企业json) 企业list = JSON.parse(企业json);
	$.each(企业list, function(ind, val) {
		addRow2(val);
	});
	
	$("#监测小区长,#监测小区宽").change(function() {
		$("#监测小区面积").val($('#监测小区长').val() * $('#监测小区宽').val());
	});
	
	$("#旱地,#水田").change(function() {
		$("#耕地").val(Number($('#旱地').val()) + Number($('#水田').val()));
	});
	$("#缓坡地梯田,#缓坡地非梯田,#缓坡地顺坡,#缓坡地横坡").change(function() {
		$("#缓坡地非梯田").val(Number($('#缓坡地顺坡').val()) + Number($('#缓坡地横坡').val()));
		$("#缓坡地").val(Number($('#缓坡地梯田').val()) + Number($('#缓坡地非梯田').val()));
	});
	$("#陡坡地梯田,#陡坡地非梯田,#陡坡地顺坡,#陡坡地横坡").change(function() {
		$("#陡坡地非梯田").val(Number($('#陡坡地顺坡').val()) + Number($('#陡坡地横坡').val()));
		$("#陡坡地").val(Number($('#陡坡地梯田').val()) + Number($('#陡坡地非梯田').val()));
	});
	
	$("#tags").change(function() { updateTags(); });
	updateTags();
	
	var mode = '${mode}';
	if (mode == "view") {
		$("input").attr('readonly', 'readonly');
		$("span.help-inline").remove();
	}

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
	<form id="inputForm" class="form-horizontal"
		method="post">

		<input id="id" name="id" type="hidden" value="${data.id}" />
		
		<div class="control-group">
			<label for="行政区划代码" class="control-label">行政区划:</label>
			<div class="controls">
<c:choose>
	<c:when test="${mode == 'add'}">
				<select id="行政区划代码" name="行政区划代码" class="reqselect">
<c:forEach var="entry" items="${divcodes}">
				<option value="${entry.key}">${entry.key} - ${entry.value}</option>
</c:forEach>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
	</c:when>
	<c:otherwise>
				<input id="行政区划代码" name="行政区划代码" class="input-small"
					readonly type="text" value="${data['行政区划代码']}" maxlength="50" />
	</c:otherwise>
</c:choose>
			</div>
		</div>

		<div class="control-group">
			<label for="耕地" class="control-label">耕地面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="耕地" name="耕地" class="input-small" readonly type="text" value="${data['耕地']}"/>
				<span class="add-on">亩</span>
				</span>
			</div>
		</div>

		<div class="control-group">
			<label for="旱地" class="control-label">旱地:</label>
			<div class="controls">
				<span class="input-append">
				<input id="旱地" name="旱地" class="required input-small" type="text" value="${data['旱地']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="水田" class="control-label">水田:</label>
			<div class="controls">
				<span class="input-append">
				<input id="水田" name="水田" class="required input-small" type="text" value="${data['水田']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="露地菜田" class="control-label">露地菜田面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="露地菜田" name="露地菜田" class="required input-small" type="text" value="${data['露地菜田']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="保护地菜田" class="control-label">保护地菜田面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="保护地菜田" name="保护地菜田" class="required input-small" type="text" value="${data['保护地菜田']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="园地" class="control-label">园地面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="园地" name="园地" class="required input-small" type="text" value="${data['园地']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<h4>坡地梯田</h4>
<hr>

		<div class="control-group">
			<label for="平地" class="control-label">平地面积（耕地、园地）:<br>坡度≤5°</label>
			<div class="controls">
				<span class="input-append">
				<input id="平地" name="平地" class="required input-small" type="text" value="${data['平地']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="缓坡地" class="control-label">缓坡地面积（耕地、园地）:<br>坡度5～15°</label>
			<div class="controls">
				<span class="input-append">
				<input id="缓坡地" name="缓坡地" readonly class="input-small" type="text" value="${data['缓坡地']}"/>
				<span class="add-on">亩</span>
				</span>
			</div>
		</div>

		<div class="control-group">
			<label for="陡坡地" class="control-label">陡坡地面积（耕地、园地）:<br>坡度>5°</label>
			<div class="controls">
				<span class="input-append">
				<input id="陡坡地" name="陡坡地" readonly class="input-small" type="text" value="${data['陡坡地']}"/>
				<span class="add-on">亩</span>
				</span>
			</div>
		</div>

		<div class="control-group">
			<label for="缓坡地梯田" class="control-label">缓坡地梯田面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="缓坡地梯田" name="缓坡地梯田" class="required input-small" type="text" value="${data['缓坡地梯田']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="缓坡地非梯田" class="control-label">缓坡地非梯田面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="缓坡地非梯田" name="缓坡地非梯田" readonly class="input-small" type="text" value="${data['缓坡地非梯田']}"/>
				<span class="add-on">亩</span>
				</span>
			</div>
		</div>

		<div class="control-group">
			<label for="缓坡地顺坡" class="control-label">缓坡地非梯田<br>顺坡种植面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="缓坡地顺坡" name="缓坡地顺坡" class="required input-small" type="text" value="${data['缓坡地顺坡']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="缓坡地横坡" class="control-label">缓坡地非梯田<br>横坡种植面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="缓坡地横坡" name="缓坡地横坡" class="required input-small" type="text" value="${data['缓坡地横坡']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="陡坡地梯田" class="control-label">陡坡地梯田面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="陡坡地梯田" name="陡坡地梯田" class="required input-small" type="text" value="${data['陡坡地梯田']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="陡坡地非梯田" class="control-label">陡坡地非梯田面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="陡坡地非梯田" name="陡坡地非梯田" readonly class="input-small" type="text" value="${data['陡坡地非梯田']}" />
				<span class="add-on">亩</span>
				</span>
			</div>
		</div>

		<div class="control-group">
			<label for="陡坡地顺坡" class="control-label">陡坡地非梯田<br>顺坡种植面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="陡坡地顺坡" name="陡坡地顺坡" class="required input-small" type="text" value="${data['陡坡地顺坡']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="陡坡地横坡" class="control-label">陡坡地非梯田<br>横坡种植面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="陡坡地横坡" name="陡坡地横坡" class="required input-small" type="text" value="${data['陡坡地横坡']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<h4>地膜</h4>
<hr>

		<div class="control-group">
			<label for="地膜覆盖" class="control-label">地膜覆盖面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="地膜覆盖" name="地膜覆盖" class="required input-small" type="text" value="${data['地膜覆盖']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">亩</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="地膜用量" class="control-label">地膜用量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="地膜用量" name="地膜用量" class="required input-small" type="text" value="${data['地膜用量']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">吨</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="厚地膜用量" class="control-label">厚度≥0.008mm的地膜用量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="厚地膜用量" name="厚地膜用量" class="required input-small" type="text" value="${data['厚地膜用量']}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">吨</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="" class="control-label">主要作物覆膜情况:</label>
			<div class="controls">

	<table class="table table-striped table-condensed table-bordered"
		id="覆膜情况表">
		<thead>
			<tr>
				<th>作物</th>
				<th>覆膜面积（亩）</th>
				<th>覆膜比例</th>
<c:if test="${mode != 'view'}">
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
<c:if test="${mode != 'view'}">
	<button id="btnAddRow" onclick="show1(null, addRow1); return false;" class="btn btn-primary btn-small">添加</button>
</c:if>
	<input type="hidden" id="作物覆膜情况" name="作物覆膜情况" value=""/>

			</div>
		</div>

		<div class="control-group">
			<label for="地膜回收总量" class="control-label">地膜企业回收总量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="地膜回收总量" name="地膜回收总量" class="required input-small" type="text" value="${data.地膜回收总量}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">吨</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="地膜利用总量" class="control-label">地膜利用总量:</label>
			<div class="controls">
				<span class="input-append">
				<input id="地膜利用总量" name="地膜利用总量" class="required input-small" type="text" value="${data.地膜利用总量}" maxlength="10" min="0" max="1000000" />
				<span class="add-on">吨</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="" class="control-label">主要地膜回收企业名称:</label>
			<div class="controls">

	<table class="table table-striped table-condensed table-bordered"
		id="企业名称表">
		<thead>
			<tr>
				<th>企业名称</th>
<c:if test="${mode != 'view'}">
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
<c:if test="${mode != 'view'}">
	<button id="btnAddRow" onclick="show2(null, addRow2); return false;" class="btn btn-primary btn-small">添加</button>
</c:if>
	<input type="hidden" id="企业名称" name="企业名称" value=""/>

			</div>
		</div>

<h4>杂项</h4>
<hr>

		<div class="control-group">
			<label for="tags" class="control-label">标签:</label>
			<div class="controls">
				<input id="tags" name="tags" class="input-small" type="text" value="${status['tags']}" maxlength="256"/>
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