<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>工作组列表</title>
<script type="text/javascript">
$(document).ready(function() {
	
});
function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
function search(){
	$("#search_name").val($("#ui_name").val());
	$("#search_proj").val($("#ui_proj").val());
	$("#search_action").val($("#ui_action").val());
	return pageTo(1);
}
function sort(o){ $("#orderBy").val(o); return pageTo(1); }
function refresh() { return pageTo($("#pageNo").val()); }
function remove(id){
	confirmx('确认要删除该工作组吗？', function(){
		$.post("${base}/sys/wgDelete", {id:id}, function(result,status){
			alertx(result, function(){ refresh(); });
		})
	});
	return false;
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/wgList">工作组列表</a></li>
		<li><a href="${base}/sys/wgAdd">工作组添加</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/sys/wgList" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">
		<input name="projName" id="search_proj" type="hidden" value="${search.projName}">
		<input name="action" id="search_action" type="hidden" value="${search.action}">
		<ul class="ul-form">
			<li><label for="ui_name">名称:</label>
				<input name="ui_name" class="input-small"	id="ui_name" type="text" maxlength="50"
					value="${search.name}"></li>
			<li><label for="ui_proj">项目:</label>
				<input name="ui_proj" class="input-small" id="ui_proj" type="text" maxlength="50"
					value="${search.projName}"></li>
			<li><label for="ui_action">任务:</label>
				<input name="ui_action" class="input-small" id="ui_action" type="text" maxlength="50"
					value="${search.action}"></li>
			<li class="btns">
				<input class="btn btn-primary" id="btnSubmit" onclick="return search();" type="submit" value="查询"></li>
			<li class="clearfix"></li>
		</ul>
	</form>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable">
		<thead>
			<tr>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">名称
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['projName']}')">项目
					<span class="${pager.sortStates['projName'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['projName'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['action']}')">任务
					<span class="${pager.sortStates['action'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['action'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>条件</th>
				<th>成员</th>
				<th>创建时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>

		<c:forEach items='${list}' var='item'>
			<tr>
				<td>${item.name}</td>
				<td><i class="icon-list-alt"></i> ${item.projName}</td>
				<td><span class="label label-success">${projActionMap[item.projId][item.action].name}</span></td>
				<td>
					<c:if test="${item.condition.items.size() != 0}">
					${item.condition.items[0].key} [${item.condition.items[0].pattern}]
					</c:if>
					<c:if test="${item.condition.items.size() == 0}">
					无
					</c:if>
				</td>
				<td>${item.memberCount} <a class="btn btn-primary btn-mini" href="${base}/sys/wgMember?id=${item.id}">管理</a></td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${item.createDate}' /></td>
				<td>
				<c:if test="${item.id != 0}">
					<a href="${base}/sys/wgModify?&id=${item.id}"
					 class="btn btn-primary btn-mini">修改</a>
					<button onclick="return remove(${item.id})"
					 class="btn btn-primary btn-mini">删除</button>
				</c:if>
				</td>
			</tr>
		</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>