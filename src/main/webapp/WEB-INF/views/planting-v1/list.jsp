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
<c:forEach items="${schema.columns}" var="column">
<c:set var="sortable" value="${sortConfig.isSortable(column.name)}"/>
<c:set var="title" value="${viewConfig.headerOf(column.name)}"/>
<c:if test="${sortable}">
				<th class="sort-column" onclick="return sort('${pager.sortActions[column.name]}')">
					${title}
					<span class="${pager.sortStates[column.name] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates[column.name] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
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
	<c:forEach items="${schema.columns}" var="column">
		<c:choose>
		<c:when test="${column.ext().isDate()}">
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row[column.name]}'/></td>
		</c:when>
		<c:when test="${column.ext().isDateTime()}">
				<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value='${row[column.name]}'/></td>
		</c:when>
		<c:otherwise>
				<td>${row[column.name]}</td>
		</c:otherwise>
		</c:choose>
	</c:forEach>
			</tr>
</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>