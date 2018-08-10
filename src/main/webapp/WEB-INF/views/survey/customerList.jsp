<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>客户列表</title>

	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_id").val(parseInt($("#ui_id").val()) || '');
			$("#search_name").val($("#ui_name").val());
			$("#search_tenantId").val($("#ui_tenantId").val());
			$("#search_dealerName").val($("#ui_dealerName").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/customerList">客户列表</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/sys/customerList" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="id" id="search_id" type="hidden" value="${search.id}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">
		<input name="tenantId" id="search_tenantId" type="hidden" value="${search.tenantId}">
		<input name="dealerName" id="search_dealerName" type="hidden" value="${search.dealerName}">

		<ul class="ul-form">
			<li><label for="ui_id">客户编号：</label>
				<input name="ui_id" class="input-medium" id="ui_id" type="text" maxlength="50"
				value="${search.id}"></li>
			<li><label for="ui_name">客户名：</label>
				<input name="ui_name" class="input-medium" id="ui_name" type="text" maxlength="50"
				value="${search.name}"></li>
			<li><label for="ui_tenantId">客户ID：</label>
				<input name="ui_tenantId" class="input-medium" id="ui_tenantId" type="text" maxlength="50"
				value="${search.tenantId}"></li>
			<li><label for="ui_dealerName">代理商名：</label>
				<input name="ui_dealerName" class="input-medium" id="ui_dealerName" type="text" maxlength="50"
				value="${search.dealerName}"></li>
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
				<th class="sort-column" onclick="return sort('${pager.sortActions['id']}')">客户编号
					<span class="${pager.sortStates['id'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['id'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">客户名
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>客户ID</th>
				<th>所属经销商</th>
				<th>联系人姓名</th>
				<th>联系人邮箱</th>
				<th>联系人电话</th>
<!-- 
				<th>所属部门</th>
 -->
				<th>客户地址</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>

			<c:forEach items='${customerList}' var='customer'>
				<tr>
					<td><c:out value='${customer.id}' /></td>
					<td><c:out value='${customer.name}' /></td>
					<td><c:out value='${customer.tenantId}' /></td>
					<td><c:out value='${customer.dealerName}' /></td>
					<td><c:out value='${customer.contact.name}' /></td>
					<td><c:out value='${customer.contact.email}' /></td>
					<td><c:out value='${customer.contact.phone}' /></td>
<!--
				<td><c:out value='${customer.contact.division}'/></td>
 -->
					<td><c:out value='${customer.contact.address}' /></td>
					<td><a href="${base}/sys/customerForm?id=${customer.id}">修改</a></td>
				</tr>
			</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>