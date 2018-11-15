<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${entry.title}</title>
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
		$.post("${base}${basepath}remove", {id:id}, function(result,status){
			alertx(result, function(){ refresh(); });
		})
	});
	return false;
}
function newstatus(data, func) {
	top.$.jBox.open("iframe:${base}${basepath}newstatus/" + data.id, "作物覆膜情况",
			$(top.document).width()-320, 500,{
		id: "newstatusdialog",
		buttons:{},
		loaded: function(h) {
			var win = h.find("iframe")[0].contentWindow;
			win.cancel = function() {
				top.$.jBox.close("newstatusdialog");
			};
			win.save = function(data) {
				func(data);
				top.$.jBox.close("newstatusdialog");
			};
			win.load(data);
		}
	});
}
function submit(id, subject, tags, remarks) {
	var data = {
		id: id,
		message: "是否将数据提交" + subject + "?",
		tags: tags,
		remarks: remarks,
	};
	newstatus(data, function(newdata) {
		$.post("${base}${basepath}submit", {id:id, tags:newdata.tags, remarks:newdata.remarks},
				function(result, status) {
			alertx(result, function(){ refresh(); });
		})
	})
}
function accept(id, subject, tags, remarks) {
	var data = {
			id: id,
			message: "是否接受" + subject + "?",
			tags: tags,
			remarks: remarks,
		};
		newstatus(data, function(newdata) {
			$.post("${base}${basepath}accept", {id:id, tags:newdata.tags, remarks:newdata.remarks},
					function(result, status) {
				alertx(result, function(){ refresh(); });
			})
		})
}
function reject(id, subject, tags, remarks) {
	var data = {
			id: id,
			message: "是否打回" + subject + "?",
			tags: tags,
			remarks: remarks,
		};
		newstatus(data, function(newdata) {
			$.post("${base}${basepath}reject", {id:id, tags:newdata.tags, remarks:newdata.remarks},
					function(result, status) {
				alertx(result, function(){ refresh(); });
			})
		})
}
function withdraw(id, subject, tags, remarks) {
	var data = {
			id: id,
			message: "是否撤回" + subject + "?",
			tags: tags,
			remarks: remarks,
		};
		newstatus(data, function(newdata) {
			$.post("${base}${basepath}withdraw", {id:id, tags:newdata.tags, remarks:newdata.remarks},
					function(result, status) {
				alertx(result, function(){ refresh(); });
			})
		})
}
</script>
<style type="text/css">
.columns {
	-moz-columns:300px;
	-webkit-columns:300px;
	columns:300px;
}
.divider { height:5px; }
</style>
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
		<c:when test="${colName == '模式面积'}">
				<td>${row[colName]}
					<a class="btn btn-primary btn-mini" href="${base}${basepath}sub2/${row['行政区划代码']}">打开</a>
				</td>
		</c:when>
		<c:otherwise>
				<td>${row[colName]}</td>
		</c:otherwise>
		</c:choose>

</c:forEach>
			</tr>
			<tr>
			<td colspan="${spancols}">
			<strong>状态</strong>: ${taskHelper.statusOf(row)}
			|
			<strong>标签</strong>: ${taskHelper.decorateTags(row.get("tags"))}
			<span class="pull-right">
			<strong>操作</strong>: ${taskHelper.operations(row, base)}
			</span>
			</td>
			</tr>
</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>