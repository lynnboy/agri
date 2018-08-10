<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>组织机构列表</title>
<script type="text/javascript">
$(document).ready(function() {
	
});
function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
function search(){
	$("#search_name").val($("#ui_name").val());
	$("#search_desc").val($("#ui_desc").val());
	return pageTo(1);
}
function sort(o){ $("#orderBy").val(o); return pageTo(1); }
function refresh() { return pageTo($("#pageNo").val()); }
function remove(id, cnt){
	confirmx('确认要删除组织吗？', function(){
		$.post("${base}/sys/organDelete", {id:id, deleteUser:1}, function(result,status){
			alertx(result, function(){ refresh(); });
		})
	});
	return false;
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/organList">组织机构列表</a></li>
		<li><a href="${base}/sys/organAdd">组织机构添加</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/sys/organList" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">
		<input name="desc" id="search_desc" type="hidden" value="${search.desc}">
		<ul class="ul-form">
			<li><label for="ui_name">名称:</label>
				<input name="ui_name" class="input-medium"	id="ui_name" type="text" maxlength="50"
					value="${search.name}"></li>
			<li><label for="ui_desc">描述:</label>
				<input name="ui_desc" class="input-medium" id="ui_desc" type="text" maxlength="50"
					value="${search.desc}"></li>
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
				<th>描述</th>
				<th>地址</th>
				<th>人员数</th>
				<th>创建时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>

		<c:forEach items='${list}' var='item'>
			<tr>
				<td>${item.name}</td>
				<td>${item.desc}</td>
				<td>${item.addr}</td>
				<td>${item.userCount}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${item.createDate}' /></td>
				<td>
				<c:if test="${item.id != 0}">
					<a href="${base}/sys/organModify?&id=${item.id}"
					 class="btn btn-primary btn-mini">修改</a>
					<button onclick="return remove(${item.id}, ${item.userCount})"
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