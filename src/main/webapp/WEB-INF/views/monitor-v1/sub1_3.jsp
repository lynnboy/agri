<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>土壤剖面描述 - ${id}</title>

<script type="text/javascript">
var schema = new Schema(JSON.parse('${schemaJson}'));
var searchConfig = new SearchConfig(JSON.parse('${searchConfigJson}'));
var viewConfig = new ViewConfig(JSON.parse('${viewConfigJson}'));

var queryList = JSON.parse('${query}');

var searcher = {}
$(document).ready(function() {
	searcher = new Searcher($('#search'),
		schema, searchConfig, viewConfig, queryList);
});

function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
function search(){
	var query = searcher.collectQuery();
	$("#search_query").val(b64encode(JSON.stringify(query)));
	return pageTo(1);
}
function sort(o){ $("#orderBy").val(o); return pageTo(1); }
function refresh() { return pageTo($("#pageNo").val()); }
function remove(id){
	confirmx('确认要删除该条数据吗？', function(){
		$.post("${base}${basepath}remove/" + id, function(result,status){
			alertx(result, function(){ refresh(); });
		})
	});
	return false;
}

function add() {
	var jbox = top.$.jBox;
	jbox.open("iframe:${base}${basepath}add", "添加种植季与作物对应",
			$(top.document).width()-220, $(top.document).height()-200,{
		id: "施肥dialog",
		buttons:{},
		loaded: function(h) {
			var win = h.find("iframe")[0].contentWindow;
			win.cancel = function() {
				jbox.close("施肥dialog");
			};
			win.save = function(data) {
				$.post("${base}${basepath}add", data, function(result,status){
					alertx(result, function(){
						if (result == "ok") {
							jbox.close("施肥dialog");
							refresh();
						}
					});
				})
			};
		},
		closed: function() { },
	});
}
function modify(id) {
	var jbox = top.$.jBox;
	jbox.open("iframe:${base}${basepath}modify/" + id, "修改种植季与作物对应",
			$(top.document).width()-220, $(top.document).height()-200,{
		id: "施肥modifydialog",
		buttons:{},
		loaded: function(h) {
			var win = h.find("iframe")[0].contentWindow;
			win.cancel = function() {
				jbox.close("施肥modifydialog");
			};
			win.save = function(data) {
				$.post("${base}${basepath}modify/" + id, data, function(result,status){
					alertx(result, function(){
						if (result == "ok") {
							jbox.close("施肥modifydialog");
							refresh();
						}
					});
				})
			};
		},
		closed: function() { },
	});
}
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

	<form class="breadcrumb" id="searchForm" style="">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="queryB64" id="search_query" type="hidden" value="${search.queryB64}">

		<div id="search" class="xcolumns"></div>

		<input class="btn btn-primary pull-right" id="btnSubmit" onclick="return search();" type="submit" value="查询">
		<div class="clearfix"></div>
	</form>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable">
		<thead>
			<tr>
<c:forEach items="${visibleColumns}" var="colName">
<c:set var="column" value="${schema.columnOf(colName)}"/>
<c:set var="sortable" value="${sortConfig.isSortable(colName)}"/>
<c:set var="title" value="${viewConfig.headerOf(colName)}"/>
<c:if test="${sortable}">
				<th class="sort-column" onclick="return sort('${pager.sortActions[colName]}')">
					${title}
					<span class="${pager.sortStates[colName] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates[colName] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
</c:if>
<c:if test="${!sortable}">
				<th>${title}</th>
</c:if>

</c:forEach>

<c:if test="${mode != 'view'}">
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>

<c:forEach items='${list}' var='row'>
			<tr>
<c:forEach items="${visibleColumns}" var="colName">
<c:set var="column" value="${schema.columnOf(colName)}"/>

		<c:choose>
		<c:when test="${column.ext().isDate()}">
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row[column.name]}'/></td>
		</c:when>
		<c:when test="${column.ext().isDateTime()}">
				<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value='${row[column.name]}'/></td>
		</c:when>
		<c:otherwise>
				<td>${row[colName]}</td>
		</c:otherwise>
		</c:choose>

</c:forEach>

<c:if test="${mode != 'view'}">
			<td>
			<button class="btn btn-primary btn-mini"
				onclick="modify('${row['id']}')">修改</button>
			<button class="btn btn-primary btn-mini"
				onclick="remove('${row['id']}')">删除</button>
			</td>
</c:if>
			</tr>
			<tr>
			</tr>
</c:forEach>

		</tbody>
	</table>
<c:if test="${mode != 'view'}">
	<button id="btnAddRow" onclick="add()" class="btn btn-primary btn-small">添加</button>
</c:if>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>