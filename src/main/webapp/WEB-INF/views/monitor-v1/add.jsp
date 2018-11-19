<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${mode == "add" ?"添加":"修改"}地块信息</title>

<script type="text/javascript">
var mode = "${mode}";
var 种植模式分区list = {
	0: "== 请选择 ==",
       "北方高原山地区": "北方高原山地区",
       "南方山地丘陵区": "南方山地丘陵区",
       "东北半湿润平原区": "东北半湿润平原区",
       "黄淮海半湿润平原区": "黄淮海半湿润平原区",
       "南方湿润平原区": "南方湿润平原区",
       "西北干旱半干旱平原区": "西北干旱半干旱平原区",
};
var 地貌类型list = {
		0:"== 请选择 ==",
        "高原": "高原",
        "山地": "山地",
        "丘陵": "丘陵",
        "平原": "平原",
        "盆地": "盆地",
		};
var 地貌类型map = {
		0:[0,"高原", "山地", "丘陵", "平原", "盆地",],
		"北方高原山地区":[0,"高原", "山地", "丘陵", "平原", "盆地",],
		"南方山地丘陵区":[0,"高原", "山地", "丘陵", "平原", "盆地",],
		"东北半湿润平原区":["平原"],
		"黄淮海半湿润平原区":["平原"],
		"南方湿润平原区":["平原"],
		"西北干旱半干旱平原区":["平原"]
};
var 地形list = {
		0:"== 请选择 ==",
        "平地": "平地（≤5°）",
        "缓坡地": "缓坡地（5°-15°）",
        "陡坡地": "陡坡地（≥15°）",
		};
var 地形map = {
		0:[0,"平地","缓坡地","陡坡地"],
        "高原": [0,"平地","缓坡地","陡坡地"],
        "山地": [0,"缓坡地","陡坡地"],
        "丘陵": [0,"缓坡地","陡坡地"],
        "平原": ["平地"],
        "盆地": [0,"平地","缓坡地","陡坡地"],
};
var 地形map2 = {
		0:[0,"平地","缓坡地","陡坡地"],
		"北方高原山地区": [0,"缓坡地","陡坡地"],
		"南方山地丘陵区": [0,"缓坡地","陡坡地"],
		"东北半湿润平原区": ["平地"],
		"黄淮海半湿润平原区": ["平地"],
		"南方湿润平原区": ["平地"],
		"西北干旱半干旱平原区": ["平地"]
};
var 是否梯田list = {
		0:"== 请选择 ==",
		"是":"是",
		"否":"否"
		};
var 是否梯田map = {
		0:[0,"是","否"],
        "平地": ["否"],
        "缓坡地": [0,"是","否"],
        "陡坡地": [0,"是","否"],
};
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
var 种植模式map1 = {
		0:[0],
		"北方高原山地区": [0],
		"南方山地丘陵区": [0],
		"东北半湿润平原区": [0, "DB01", "DB02", "DB03", "DB04", "DB05", "DB06", "DB07" ],
		"黄淮海半湿润平原区": [0, "HH01", "HH02", "HH03", "HH04", "HH05", "HH06"],
		"南方湿润平原区": [0, "NS01", "NS02", "NS03", "NS04", "NS05", "NS06", "NS07", "NS08", "NS09", "NS10", "NS11"],
		"西北干旱半干旱平原区": [0, "XB01", "XB02", "XB03", "XB04", "XB05", "XB06", "XB07"],
};
var 种植模式map1a = {
		0:[0],
		"是":[0,"BF03","BF05"],
		"否":[0,"BF01","BF02","BF04"]
};
var 种植模式map1b = {
		0:[0],
		"是":[0,"BF08","BF10"],
		"否":[0,"BF06","BF07","BF09"]
};
var 种植模式map4a = {
		0:[0],
		"是":[0,"NF03","NF05","NF06","NF07"],
		"否":[0,"NF01","NF02","NF04"]
};
var 种植模式map4b = {
		0:[0],
		"是":[0,"NF10","NF12","NF13","NF14"],
		"否":[0,"NF08","NF09","NF11"]
};

var 种植方式list = {
		0: '== 请选择 ==',
        "大田种植": "大田种植",
        "保护地种植": "保护地种植",
};
var 坡向list = {
		0: '== 请选择 ==',
        "东": "东",
        "南": "南",
        "西": "西",
        "北": "北",
        "东南": "东南",
        "东北": "东北",
        "西南": "西南",
        "西北": "西北",
};
var 土壤质地list = {
		0: '== 请选择 ==',
        "砂土": "砂土",
        "沙壤土": "沙壤土",
        "轻壤": "轻壤",
        "中壤": "中壤",
        "重壤": "重壤",
        "黏土": "黏土",
        "重黏土": "重黏土",
};
var 土壤类型list = {
		0: '== 请选择 ==',
		"TR01": "铁铝土-湿热铁铝土-砖红壤",
		"TR02": "铁铝土-湿热铁铝土-赤红壤",
		"TR03": "铁铝土-湿热铁铝土-红壤",
		"TR04": "铁铝土-湿暖铁铝土-黄壤",
		"TR05": "淋溶土-湿暖淋溶土-黄棕壤",
		"TR06": "淋溶土-湿暖淋溶土-黄褐土",
		"TR07": "淋溶土-湿暖温淋溶土-棕壤",
		"TR08": "淋溶土-湿温淋溶土-暗棕壤",
		"TR09": "淋溶土-湿温淋溶土-白浆土",
		"TR10": "淋溶土-湿寒温淋溶土-棕色针叶林土",
		"TR11": "淋溶土-湿寒温淋溶土-漂灰土",
		"TR12": "淋溶土-湿寒温淋溶土-灰化土",
		"TR13": "半淋溶土-半湿热半淋溶土-燥红土",
		"TR14": "半淋溶土-半湿暖温半淋溶土-褐土",
		"TR15": "半淋溶土-半湿温半淋溶土-灰褐土",
		"TR16": "半淋溶土-半湿温半淋溶土-黑土",
		"TR17": "半淋溶土-半湿温半淋溶土-灰色森林土",
		"TR18": "钙层土-半湿温钙层土-黑钙土",
		"TR19": "钙层土-半干温钙层土-栗钙土",
		"TR20": "钙层土-半干暖温钙层土-栗褐土",
		"TR21": "钙层土-半干暖温钙层土-黑垆土",
		"TR22": "干旱土-干温干旱土-棕钙土",
		"TR23": "干旱土-干温干旱土-灰钙土",
		"TR24": "漠土-干温漠土-灰漠土",
		"TR25": "漠土-干温漠土-灰棕漠土",
		"TR26": "漠土-干暖温漠土-棕漠土",
		"TR27": "初育土-土质初育土-黄绵土",
		"TR28": "初育土-土质初育土-红粘土",
		"TR29": "初育土-土质初育土-新积土",
		"TR30": "初育土-土质初育土-龟裂土",
		"TR31": "初育土-土质初育土-风沙土",
		"TR32": "初育土-石质初育土-石灰（岩）土",
		"TR33": "初育土-石质初育土-火山灰土",
		"TR34": "初育土-石质初育土-紫色土",
		"TR35": "初育土-石质初育土-磷质石灰土",
		"TR36": "初育土-石质初育土-石质土",
		"TR37": "初育土-石质初育土-粗骨土",
		"TR38": "半水成土-暗半水成土-草甸土",
		"TR39": "半水成土-淡半水成土-潮土",
		"TR40": "半水成土-淡半水成土-砂姜黑土",
		"TR41": "半水成土-淡半水成土-林灌草甸土",
		"TR42": "半水成土-淡半水成土-山地草甸土",
		"TR43": "水成土-矿质水成土-沼泽土",
		"TR44": "水成土-有机水成土-泥炭土",
		"TR45": "盐碱土-盐土-草甸盐土",
		"TR46": "盐碱土-盐土-滨海盐土",
		"TR47": "盐碱土-盐土-酸性硫酸盐土",
		"TR48": "盐碱土-盐土-漠境盐土",
		"TR49": "盐碱土-盐土-寒原盐土",
		"TR50": "盐碱土-碱土-碱土",
		"TR51": "人为土-人为水成土-水稻土",
		"TR52": "人为土-灌耕土-灌淤土",
		"TR53": "人为土-灌耕土-灌漠土",
		"TR54": "高山土-湿寒高山土-草毡土（高山草甸土）",
		"TR55": "高山土-湿寒高山土-黑毡土（亚高山草甸土）",
		"TR56": "高山土-半湿寒高山土-寒钙土（高山草原土）",
		"TR57": "高山土-半湿寒高山土-冷钙土（亚高山草原土）",
		"TR58": "高山土-半湿寒高山土-冷棕钙土（山地灌丛草原土）",
		"TR59": "高山土-干寒高山土-寒漠土（高山漠土）",
		"TR60": "高山土-干寒高山土-冷漠土（亚高山漠土）",
		"TR61": "高山土-寒冻高山土-寒冻土（高山寒漠土）",
};
var 肥力水平list = {
		0: '== 请选择 ==',
        "高": "高",
        "中": "中",
        "低": "低",
};
var 有无障碍层list = {
		0: '== 请选择 ==',
        "有": "有",
        "无": "无",
};
var 障碍层类型list = {
		0: '== 请选择 ==',
        "铁盘胶结层": "铁盘胶结层",
        "黏盘层": "黏盘层",
        "潜育层": "潜育层",
        "盐化层": "盐化层",
        "碱化层": "碱化层",
        "夹砂层": "夹砂层",
        "石膏盘层": "石膏盘层",
        "钙积层": "钙积层",
};

</script>
<script type="text/javascript">
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

	fillSelect("#种植模式分区", 种植模式分区list, [
		{ sel: "#地貌类型", list: 地貌类型list, map: 地貌类型map},
		{ sel: "#地形", list: 地形list, map: 地形map2},
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map1},
	]);
	fillSelect("#地貌类型", 地貌类型list, [
		//{ sel: "#地形", list: 地形list, map: 地形map},
	]);
	fillSelect("#地形", 地形list, [{ sel: "#是否梯田", list: 是否梯田list, map: 是否梯田map}]);
	$("#地形").change(function() {
		var l = $("#是否梯田");
		if (!/缓坡|陡坡/.test($(this).val())) {
			l.val("否"); l.valid(); l.val(); 
			l.attr('disabled', 'disabled');
		} else {
			l.removeAttr('disabled');
		}
	});
	fillSelect("#是否梯田", 是否梯田list, [
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map1a,
			cond: function(){return $('#种植模式分区').val() == "北方高原山地区" && $('#地形').val() == "缓坡地";} },
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map1b,
			cond: function(){return $('#种植模式分区').val() == "北方高原山地区" && $('#地形').val() == "陡坡地";} },
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map4a,
			cond: function(){return $('#种植模式分区').val() == "南方山地丘陵区" && $('#地形').val() == "缓坡地";} },
		{ sel: "#种植模式", list: 种植模式list, map: 种植模式map4b,
			cond: function(){return $('#种植模式分区').val() == "南方山地丘陵区" && $('#地形').val() == "陡坡地";} },
	]);
	fillSelect("#种植方式", 种植方式list);
	fillSelect("#坡向", 坡向list);
	fillSelect("#土壤质地", 土壤质地list);
	fillSelect("#土壤类型", 土壤类型list);
	fillSelect("#肥力水平", 肥力水平list);
	fillSelect("#有无障碍层", 有无障碍层list);
	$("#有无障碍层").change(function() {
		if ($(this).val() == "无") {
			$("#障碍层类型").val("潜育层");
			$("#障碍层深度,#障碍层厚度").val(1);
			var l = $("#障碍层类型,#障碍层深度,#障碍层厚度");
			l.valid(); l.val('');
			l.attr('disabled', 'disabled');
		} else {
			$("#障碍层类型,#障碍层深度,#障碍层厚度").removeAttr('disabled');
		}
	});
	fillSelect("#障碍层类型", 障碍层类型list);

	if (mode != "add") {
		$("#种植模式分区").val('${data.种植模式分区}');
		$("#种植模式分区").change();
		$("#地貌类型").val('${data.地貌类型}');
		$("#地形").val('${data.地形}');
		$("#地形").change();
		$("#是否梯田").val('${data.是否梯田}');
		$("#是否梯田").change();
		$("#种植模式").val('${data.种植模式}');
		$("#种植方式").val('${data.种植方式}');
		$("#坡向").val('${data.坡向}');
		$("#坡度").val(Math.round('${data.坡度}'));
		$("#土壤质地").val('${data.土壤质地}');
		$("#土壤类型").val('${data.土壤类型}');
		$("#肥力水平").val('${data.肥力水平}');
		$("#有无障碍层").val('${data.有无障碍层}');
		$("#障碍层深度").val(Math.round('${data.障碍层深度}'));
		$("#障碍层厚度").val(Math.round('${data.障碍层厚度}'));
		$("#有无障碍层").change();
		$("#障碍层类型").val('${data.障碍层类型}');
		$("#监测小区长").val(Math.round('${data.监测小区长}'));
		$("#监测小区宽").val(Math.round('${data.监测小区宽}'));

		$("#田间径流池内侧长").val(Math.round('${data.田间径流池内侧长}'));
		$("#田间径流池内侧宽").val(Math.round('${data.田间径流池内侧宽}'));
		$("#田间径流池内侧深").val(Math.round('${data.田间径流池内侧深}'));
		$("#淋溶装置接收面积").val(Math.round('${data.淋溶装置接收面积}'));
		$("#淋溶液收集桶埋深").val(Math.round('${data.淋溶液收集桶埋深}'));

		$("#inputForm").validate().resetForm();
	} else {
		$("#inputForm select").not("#divcode,#code2").val(0);
	}
	
	$("#divcode,#code2,#code3").change(function() {
		$("#地块编码").val($('#divcode').val() + $('#code2').val() + $('#code3').val());
	});

	$("#监测小区长,#监测小区宽").change(function() {
		$("#监测小区面积").val($('#监测小区长').val() * $('#监测小区宽').val() / 10000);
	});
	
	$("#tags").change(function() { updateTags(); });
	updateTags();
	
	if (mode == "view") {
		$("select").attr('disabled', 'disabled');
		$("input,textarea").attr('readonly', 'readonly');
		$("span.help-inline").remove();
	}
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
		
		<div class="control-group">
			<label for="地块编码" class="control-label">地块编码:</label>
			<div class="controls">
<c:choose>
	<c:when test="${mode == 'add'}">
				<select id="divcode" class="reqselect input-mini">
<c:forEach var="entry" items="${divcodes}">
				<option value="${entry.key}">${entry.key}</option>
</c:forEach>
				</select>
				<select id="code2" class="reqselect input-mini">
				<option value="L">L</option>
				<option value="R">R</option>
				</select>

				<input id="code3" class="required number input-mini" style="ime-mode:disabled"
					type="text" value="" min='1' max='9' maxlength="1" />

				<input id="地块编码" name="地块编码" type="hidden" value="" />
				<span class="help-inline"><font color="red">*</font> </span>
	</c:when>
	<c:otherwise>
				<input id="地块编码" name="地块编码" class="input-small"
					readonly type="text" value="${data.地块编码}" />
	</c:otherwise>
</c:choose>
			</div>
		</div>

<h4>基本信息</h4>
<hr>

		<div class="control-group">
			<label for="承担单位" class="control-label">承担单位:</label>
			<div class="controls">
				<input id="承担单位" name="承担单位" class="required input-large" type="text"
					value="${data.承担单位}" maxlength="30" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="地块地址" class="control-label">地块地址:</label>
			<div class="controls">
				<input id="地块地址" name="地块地址" class="required span5" type="text"
					value="${data.地块地址}" maxlength="30" />
					<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="农户姓名" class="control-label">农户姓名:</label>
			<div class="controls">
				<input id="农户姓名" name="农户姓名" type="text" value="${data.农户姓名}" maxlength="4" />
			</div>
		</div>
		<div class="control-group">
			<label for="农户电话" class="control-label">农户电话:</label>
			<div class="controls">
				<input id="农户电话" name="农户电话" type="text" value="${data.农户电话}" class="phoneOrMobile" maxlength="15" />
			</div>
		</div>
		<div class="control-group">
			<label for="负责人姓名" class="control-label">负责人姓名:</label>
			<div class="controls">
				<input id="负责人姓名" name="负责人姓名" type="text" value="${data.负责人姓名}" class="required" maxlength="4" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="负责人电话" class="control-label">负责人电话:</label>
			<div class="controls">
				<input id="负责人电话" name="负责人电话" type="text" class="required phoneOrMobile" value="${data.负责人电话}" maxlength="15" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="负责人Email" class="control-label">负责人Email:</label>
			<div class="controls">
				<input id="负责人Email" name="负责人Email" class="required email" type="text" value="${data.负责人Email}" maxlength="30" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="联系人姓名" class="control-label">联系人姓名:</label>
			<div class="controls">
				<input id="联系人姓名" name="联系人姓名" type="text" value="${data.联系人姓名}" class="required" maxlength="4" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="联系人电话" class="control-label">联系人电话:</label>
			<div class="controls">
				<input id="联系人电话" name="联系人电话" type="text" class="required phoneOrMobile" value="${data.联系人电话}" maxlength="15" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="联系人Email" class="control-label">联系人Email:</label>
			<div class="controls">
				<input id="联系人Email" name="联系人Email" class="required email" type="text" value="${data.联系人Email}" maxlength="30" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

		<div class="control-group">
			<label for="经度" class="control-label">经度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="经度" name="经度" class="required input-small"
				 type="text" value="${data.经度}" maxlength="10" min="73" max="136" />
				<span class="add-on">°</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="纬度" class="control-label">纬度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="纬度" name="纬度" class="required input-small"
				 type="text" value="${data.纬度}" maxlength="10" min="3" max="54" />
				<span class="add-on">°</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="海拔" class="control-label">海拔:</label>
			<div class="controls">
				<span class="input-append">
				<input id="海拔" name="海拔" class="required input-small"
				 type="text" value="${data.海拔}" maxlength="6" step="0.1" min="-1000" max="8000" />
				<span class="add-on">m</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<h4>地块情况</h4>
<hr>

		<div class="control-group">
			<label for="种植模式分区" class="control-label">种植模式分区:</label>
			<div class="controls">
				<select id="种植模式分区" name="种植模式分区" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="地貌类型" class="control-label">地貌类型:</label>
			<div class="controls">
				<select id="地貌类型" name="地貌类型" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="地形" class="control-label">地形:</label>
			<div class="controls">
				<select id="地形" name="地形" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="是否梯田" class="control-label">是否梯田:</label>
			<div class="controls">
				<select id="是否梯田" name="是否梯田" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="最高地下水位" class="control-label">最高地下水位:</label>
			<div class="controls">
				<span class="input-append">
				<input id="最高地下水位" name="最高地下水位" class="required input-small"
				 type="number" value="${data.最高地下水位}" step='0.1' min="0" max="100" />
				<span class="add-on">m</span>
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
		<div class="control-group">
			<label for="种植方式" class="control-label">种植方式:</label>
			<div class="controls">
				<select id="种植方式" name="种植方式" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="坡向" class="control-label">坡向:</label>
			<div class="controls">
				<select id="坡向" name="坡向" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="坡度" class="control-label">坡度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="坡度" name="坡度" class="required digits input-small"
				 type="number" value="${data.坡度}" maxlength="2" min="0" max="90" />
				<span class="add-on">°</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤质地" class="control-label">土壤质地:</label>
			<div class="controls">
				<select id="土壤质地" name="土壤质地" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="土壤类型" class="control-label">土壤类型:</label>
			<div class="controls">
				<select id="土壤类型" name="土壤类型" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="地方土名" class="control-label">地方土名:</label>
			<div class="controls">
				<input id="地方土名" name="地方土名" class="" type="text" value="${data.地方土名}" maxlength="8" />
			</div>
		</div>
		<div class="control-group">
			<label for="肥力水平" class="control-label">肥力水平:</label>
			<div class="controls">
				<select id="肥力水平" name="肥力水平" class=""></select>
			</div>
		</div>
		<div class="control-group">
			<label for="有无障碍层" class="control-label">有无障碍层:</label>
			<div class="controls">
				<select id="有无障碍层" name="有无障碍层" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="障碍层类型" class="control-label">障碍层类型:</label>
			<div class="controls">
				<select id="障碍层类型" name="障碍层类型" class="reqselect"></select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="障碍层深度" class="control-label">障碍层深度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="障碍层深度" name="障碍层深度" class="required digits input-small"
				 type="number" value="${data.障碍层深度}" maxlength="2" min="0" max="99" />
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="障碍层厚度" class="control-label">障碍层厚度:</label>
			<div class="controls">
				<span class="input-append">
				<input id="障碍层厚度" name="障碍层厚度" class="required digits input-small"
				 type="number" value="${data.障碍层厚度}" maxlength="2" min="0" max="99" />
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<h4>监测小区情况</h4>
<hr>

		<div class="control-group">
			<label for="监测小区长" class="control-label">监测小区长:</label>
			<div class="controls">
				<span class="input-append">
				<input id="监测小区长" name="监测小区长" class="required digits input-small"
				 type="number" value="${data.监测小区长}" maxlength="4" min="0" max="9999" />
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="监测小区宽" class="control-label">监测小区宽:</label>
			<div class="controls">
				<span class="input-append">
				<input id="监测小区宽" name="监测小区宽" class="required digits input-small"
				 type="number" value="${data.监测小区宽}" maxlength="4" min="0" max="9999" />
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="监测小区面积" class="control-label">监测小区面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="监测小区面积" readonly class="input-small"
				 type="text" value="${data.监测小区面积}" />
				<span class="add-on">m<sup>2</sup></span>
				</span>
			</div>
		</div>

<h4>田间径流池</h4>
<hr>

		<div class="control-group">
			<label for="田间径流池内侧长" class="control-label">田间径流池内侧长:</label>
			<div class="controls">
				<span class="input-append">
				<input id="田间径流池内侧长" name="田间径流池内侧长" class="required digits input-small"
				 type="number" value="${data.田间径流池内侧长}" maxlength="4" min="0" max="9999" />
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="田间径流池内侧宽" class="control-label">田间径流池内侧宽:</label>
			<div class="controls">
				<span class="input-append">
				<input id="田间径流池内侧宽" name="田间径流池内侧宽" class="required digits input-small"
				 type="number" value="${data.田间径流池内侧宽}" maxlength="3" min="0" max="999" />
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="田间径流池内侧深" class="control-label">田间径流池内侧深:</label>
			<div class="controls">
				<span class="input-append">
				<input id="田间径流池内侧深" name="田间径流池内侧深" class="required digits input-small"
				 type="number" value="${data.田间径流池内侧深}" maxlength="3" min="0" max="999" />
				<span class="add-on">cm</span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>

<h4>地下淋溶装置</h4>
<hr>

		<div class="control-group">
			<label for="淋溶装置接收面积" class="control-label">淋溶装置接收面积:</label>
			<div class="controls">
				<span class="input-append">
				<input id="淋溶装置接收面积" name="淋溶装置接收面积" class="required digits input-small"
				 type="number" value="${data.淋溶装置接收面积}" maxlength="4" min="0" max="9999" />
				<span class="add-on">cm<sup>2</sup></span>
				</span>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="淋溶液收集桶埋深" class="control-label">淋溶液收集桶埋深:</label>
			<div class="controls">
				<span class="input-append">
				<input id="淋溶液收集桶埋深" name="淋溶液收集桶埋深" class="required digits input-small"
				 type="number" value="${data.淋溶液收集桶埋深}" maxlength="3" min="0" max="999" />
				<span class="add-on">cm</span>
				</span>
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