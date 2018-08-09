<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>导出: 地表径流与地下淋溶监测-2018</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
var schema = {
	columns: [
		{name: '数据表', isText: true, isNumber: false, isDateTime: false},
		{name: '数据编号', isText: true, isNumber: false, isDateTime: false},
		{name: '状态', isText: false, isNumber: true, isDateTime: false},
		{name: '提交人', isText: true, isNumber: false, isDateTime: false},
		{name: '单位', isText: true, isNumber: false, isDateTime: false},
		{name: '提交时间', isText: false, isNumber: false, isDateTime: true},
	]
};
var schmap = {};
$.each(schema.columns, function(idx, col) {
	schmap[col.name] = col;
});
var config = {
	search: [
		{key: '数据表', optList: {'1':'地块信息'}},
		{key: '数据编号'},
		{key: '状态', optList: {'1':'草稿','2':'待审核','3':'已审核'}},
		{key: '提交人'},
		{key: '单位'},
		{key: '提交时间'},
	],
	headerMap: {
		'aa':'aa',
	},
};
var cfgsearch = {};
$.each(config.search, function(idx, srch) {
	srch.name = srch.key in config.headerMap ? config.headerMap[srch.key] : srch.key;
	cfgsearch[srch.key] = srch;
});
var queryList = {};

var nextNo = 0;
function addQueryCommon(key, name, type, idkey, idtype, idval) {
	var $sch = $('#search');
	var $row = $('<fieldset>').appendTo($sch);
	$('<input type="hidden">').attr('id', idkey).val(key).appendTo($row);
	$('<input type="hidden">').attr('id', idtype).val(type).appendTo($row);
	$('<a href="javascript:;" onclick="$(this).parent().remove()"><i class="icon-minus">&nbsp;</i></a>').appendTo($row);
	$row.append(" ");
	$('<label>').css('display','inline-block').attr('for', idval).text(name).appendTo($row);
	$row.append(" ");
	return $row;
}
function addQueryTypeMenu($row, type, idtypename, idtype, typemenu, typenames) {
	var $typediv = $('<div class="btn-group">').appendTo($row);
	var $btn = $('<a class="btn dropdown-toggle" data-toggle="dropdown" href="javascript:;">').appendTo($typediv);
	$('<span>').attr('id', idtypename).text(typenames[type] + ' ').appendTo($btn);
	$('<span class="caret">').appendTo($btn);
	var $menu = $('<ul class="dropdown-menu">').appendTo($typediv);
	$.each(typemenu, function(idx, t) {
		if (!t) {
			$('<li class="divider">').appendTo($menu); return;
		}
		var $li = $('<li>').appendTo($menu);
		var act = "$('#" + idtype + "').val('" + t.type + "'); " +
			"$('#" + idtypename + "').text('" + typenames[t.type] + "');"
		var $a = $('<a href="javascript:;" onclick="' + act + '">').text(t.text).appendTo($li);
	});
}
function addOptListQuery(key, type, value) {
	if (!key in cfgsearch) return;
	var srch = cfgsearch[key];
	type = type || "IS";
	if (type != "IS") return;

	if ($.isEmptyObject(srch.optList)) return;

	var idkey = "qkey_" + nextNo, idtype = "qtype_" + nextNo, idval = "query_" + nextNo;
	nextNo ++;
	var $row = addQueryCommon(key, srch.name, type, idkey, idtype, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	$('<span class="add-on">').text("为").appendTo($div);
	var $sel = $('<select>').attr('id', idval).addClass('input-medium').appendTo($div);
	for (var val in srch.optList) {
		$opt = $('<option>').val(val).text(srch.optList[val]).appendTo($sel);
		if (value == val) $opt.attr('selected', 'selected');
	}
}
function addOptMultiQuery(key, type, value) {
	if (!key in cfgsearch) return;
	var srch = cfgsearch[key];
	type = type || "IN";
	if (type != "IN") return;

	if ($.isEmptyObject(srch.optList)) return;

	var idkey = "qkey_" + nextNo, idtype = "qtype_" + nextNo, idval = "query_" + nextNo;
	nextNo ++;
	var $row = addQueryCommon(key, srch.name, type, idkey, idtype, idval);

	var $div = $('<div>').css({
		display: "inline-block",
		verticalAlign: "middle",
		padding: "0 10px 4px 10px",
		marginBottom: 10,
		border: "solid 1px #ccc",
		borderRadius: 4,
	}).appendTo($row);

	var values = value ? value.split(',') : [];
	for (var val in srch.optList) {
		$lbl = $('<label>').addClass("checkbox inline").text(srch.optList[val]).appendTo($div);
		$chk = $('<input type="checkbox">').val(val).prependTo($lbl);
		if ($.inArray(val, values) != -1) $chk.attr('checked', 'checked');
	}
}
function addTextQuery(key, type, value) {
	if (!key in cfgsearch) return;
	var srch = cfgsearch[key];
	type = type || "STR_MATCH";
	if ($.inArray(type, ["EQ", "STR_MATCH", "STR_BEGIN", "STR_END", "STR_REGEX"]) == -1) return;

	var idkey = "qkey_" + nextNo, idtype = "qtype_" + nextNo, idval = "query_" + nextNo;
	var idtypename = "qtypename_" + nextNo;
	nextNo ++;

	var $row = addQueryCommon(key, srch.name, type, idkey, idtype, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	var typenames = {"STR_MATCH":"匹配","EQ":"为","STR_BEGIN":"开始为","STR_END":"末尾为","STR_REGEX":"正则"};
	var typemenu = [{type:"STR_MATCH",text:"匹配"}, null,{type:"EQ",text:"为"},{type:"STR_BEGIN",text:"开始为"},{type:"STR_END",text:"末尾为"},null,{type:"STR_REGEX",text:"正则表达式匹配"}];
	addQueryTypeMenu($div, type, idtypename, idtype, typemenu, typenames);

	$input = $('<input type="text" class="input-small" maxlength="50">')
		.attr('id', idval).val(value).appendTo($div);
}
function addNumQuery(key, type, value) {
	if (!key in cfgsearch) return;
	var srch = cfgsearch[key];
	type = type || "EQ";
	if ($.inArray(type, ["EQ", "LE", "GE"]) == -1) return;

	var idkey = "qkey_" + nextNo, idtype = "qtype_" + nextNo, idval = "query_" + nextNo;
	var idtypename = "qtypename_" + nextNo;
	nextNo ++;

	var $row = addQueryCommon(key, srch.name, type, idkey, idtype, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	var typenames = {"EQ":"等于","GE":"至少为","LE":"最大为"};
	var typemenu = [{type:"EQ",text:"等于"},{type:"GE",text:"至少为"},{type:"LE",text:"最大为"}];
	addQueryTypeMenu($div, type, idtypename, idtype, typemenu, typenames);

	$input = $('<input type="number" class="input-small" maxlength="50">')
		.attr('id', idval).val(value).appendTo($div);
}
function addDateQuery(key, type, value) {
	if (!key in cfgsearch) return;
	var srch = cfgsearch[key];
	type = type || "EQ";
	if ($.inArray(type, ["EQ", "LE", "GE"]) == -1) return;

	var idkey = "qkey_" + nextNo, idtype = "qtype_" + nextNo, idval = "query_" + nextNo;
	var idtypename = "qtypename_" + nextNo;
	nextNo ++;

	var $row = addQueryCommon(key, srch.name, type, idkey, idtype, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	var typenames = {"EQ":"为","GE":"不早于","LE":"不晚于"};
	var typemenu = [{type:"EQ",text:"日期为"},{type:"GE",text:"日期不早于"},{type:"LE",text:"日期不晚于"}];
	addQueryTypeMenu($div, type, idtypename, idtype, typemenu, typenames);

	$input = $('<input type="text" class="input-small Wdate" maxlength="50">')
		.attr('onchange',"return $(this).valid();")
		.attr('onfocus', "WdatePicker(datePickerSettings());")
		.attr('id', idval).val(value).appendTo($div);
}
function addQuery(key, type, value) {
	if (!key in schmap) return;
	var column = schmap[key];
	
	if (type == "IS") return addOptListQuery(key, type, value);
	if (type == "IN") return addOptMultiQuery(key, type, value);
	if ($.inArray(type, ["EQ", "LE", "GE"]) != -1) {
		if (column.isNumber) return addNumQuery(key, type, value);
		if (column.isDateTime) return addDateQuery(key, type, value);
	}
	return addTextQuery(key, type, value);
}

function addSearchMenu($ul, key, name, column, hasOptList) {
	var submenu = [];
	if (hasOptList) {
		submenu.push({act:"addOptListQuery",type:"IS",text:"选项"});
		submenu.push({act:"addOptMultiQuery",type:"IN",text:"多选"});
		submenu.push(false);
	}
	if (column.isText) {
		submenu.push({act:"addTextQuery",type:'STR_MATCH',text:"匹配"});
		submenu.push(false);
		submenu.push({act:"addTextQuery",type:'EQ',text:"为"});
		submenu.push({act:"addTextQuery",type:'STR_BEGIN',text:"开始为"});
		submenu.push({act:"addTextQuery",type:'STR_END',text:"末尾为"});
		submenu.push(false);
		submenu.push({act:"addTextQuery",type:'STR_REGEX',text:"正则表达式匹配"});
	}
	if (column.isNumber) {
		submenu.push({act:"addNumQuery",type:'EQ',text:"等于"});
		submenu.push({act:"addNumQuery",type:'GE',text:"至少为"});
		submenu.push({act:"addNumQuery",type:'LE',text:"最大为"});
		submenu.push(false);
		submenu.push({act:"addTextQuery",type:'STR_MATCH',text:"文字匹配"});
	}
	if (column.isDateTime) {
		submenu.push({act:"addDateQuery",type:'EQ',text:"等于"});
		submenu.push({act:"addDateQuery",type:'GE',text:"日期不晚于"});
		submenu.push({act:"addDateQuery",type:'LE',text:"日期不早于"});
		submenu.push(false);
		submenu.push({act:"addTextQuery",type:'STR_MATCH',text:"文字匹配"});
	}
	if (submenu.length == 0) return;
	
	var $li = $('<li class="dropdown-submenu"></li>').appendTo($ul);
	var act = submenu[0].act + "('" + key + "', '" + submenu[0].type + "')";
	$('<a href="javascript:;" onclick="' + act + '">' + name + '</a>').appendTo($li);
	var $subul = $('<ul class="dropdown-menu"></ul>').appendTo($li);
	$.each(submenu, function(idix, item) {
		if (!item) {
			$('<li class="divider"></li>').appendTo($subul);
			return;
		}
		var $subli = $('<li></li>').appendTo($subul);
		var act = item.act + "('" + key + "', '" + item.type + "')";
		$('<a href="javascript:;" onclick="' + act + '">' + item.text + '</a>').appendTo($subli);
	});
}
function datePickerSettings() {
	return {
		dateFmt:'yyyy-MM-dd', isShowClear: false,
		minDate: '1970-01-01', maxDate: '2099-12-31',
	};
}


function showData() {
	top.$.jBox.open("iframe:${base}/sys/conflictData1",
			"查看数据: 典型地块监测-2018 编号 110111L1",
		$(top.document).width()-220,
		$(top.document).height()-200,
		{ opacity:0 });
}
$(document).ready(function() {
	var $ul = $("#menuAddQuery");
	$.each(config.search, function(idx, srch) {
		if (!srch.key in schmap) return;
		var column = schmap[srch.key];
		var hasOptList = !$.isEmptyObject(srch.optList);
		addSearchMenu($ul, srch.key, srch.name, column, hasOptList);
	});
});
function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
function search(){
	$("#search_login").val($("#ui_login").val());
	$("#search_name").val($("#ui_name").val());
	$("#search_organ").val($("#ui_organ").val());
	return pageTo(1);
}
function sort(o){ $("#orderBy").val(o); return pageTo(1); }
function refresh() { return pageTo($("#pageNo").val()); }
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/sys/export">导出任务</a></li>
		<li><a href="${base}/sys/exportAdd">新建导出</a></li>
		<li class="active"><a href="${base}/sys/exportProj">导出: <i class="icon-list-alt"></i> 地表径流与地下淋溶监测-2018</a></li>
	</ul>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<div class="container-fluid">

	<form class="breadcrumb" id="searchForm">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="login" id="search_login" type="hidden" value="${search.login}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">
		<input name="organName" id="search_organ" type="hidden" value="${search.organName}">

<h4>导出数据条件</h4>
<br>
		<div id="search" class="xcolumns"></div>

		<div class="btn-group pull-left">
		<a class="btn dropdown-toggle btn-primary pull-left" data-toggle="dropdown"
			id="btnAddQuery" href="javascript:;">
			<i class="icon-plus">&nbsp;</i>
			添加条件
			<span class="caret"></span></a>
		<ul id="menuAddQuery" class="dropdown-menu"></ul>
		</div>
		<input class="btn btn-primary pull-right" id="btnSubmit" onclick="return search();" type="submit" value="查询">

		<div class="clearfix"></div>
	</form>

	<form class="breadcrumb" id="searchForm">
			<a href="javascript:;" onclick="newExport()" class="btn btn-primary">创建导出任务</a>
	</form>
</div>

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable">
		<thead>
			<tr>
				<th class="sort-column">数据表</th>
				<th class="sort-column">数据编号</th>
				<th class="sort-column">状态</th>
				<th class="sort-column">提交人</th>
				<th class="sort-column">单位</th>
				<th class="sort-column">提交时间</th>
				<th></th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td>地块信息</td>
				<td>110111L1</td>
				<td><span class="label label-info">已审核</span></td>
				<td>崔庆</td>
				<td>房山区农业环境和生产监测站</td>
				<td>2017-05-24 14:30</td>
				<td>
					<a href="${base}/sys/conflictData1"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">修改日志</button>
				</td>
			</tr>

			<tr>
				<td>地块信息</td>
				<td>110112L1</td>
				<td><span class="label label-info">已审核</span></td>
				<td>周永香</td>
				<td>通州区农业技术推广站</td>
				<td>2017-07-09 08:27</td>
				<td>
					<a href="javascript:;" onclick="showData()"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">修改日志</button>
				</td>
			</tr>

			<tr>
				<td>地块信息</td>
				<td>110111L2</td>
				<td><span class="label label-info">已审核</span></td>
				<td>崔庆</td>
				<td>房山区农业环境和生产监测站</td>
				<td>2017-05-26 12:23</td>
				<td>
					<a href="javascript:;" onclick="showData()"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">修改日志</button>
				</td>
			</tr>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>