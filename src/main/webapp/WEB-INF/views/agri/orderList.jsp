<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>订单列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_poNumber").val($("#ui_poNumber").val());
			$("#search_name").val($("#ui_name").val());
			$("#search_tenantId").val($("#ui_tenantId").val());
			$("#search_dealerName").val($("#ui_dealerName").val());
			$("#search_status").val($("#ui_status").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/orderList">订单列表</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/sys/orderList" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="searchPoNumber" id="search_poNumber" type="hidden" value="${searchPoNumber}">
		<input name="customerName" id="search_name" type="hidden" value="${search.customerName}">
		<input name="tenantId" id="search_tenantId" type="hidden" value="${search.tenantId}">
		<input name="dealerName" id="search_dealerName" type="hidden" value="${search.dealerName}">
		<input name="status" id="search_status" type="hidden" value="${search.status}">

		<ul class="ul-form">
			<li><label for="ui_poNumber">订单编号：</label>
				<input name="ui_poNumber" class="input-medium" id="ui_poNumber" type="text" maxlength="50"
				value="${searchPoNumber}"></li>
			<li><label for="ui_name">客户名：</label>
				<input name="ui_name" class="input-medium" id="ui_name" type="text" maxlength="50"
				value="${search.customerName}"></li>
			<li><label for="ui_tenantId">客户ID：</label>
				<input name="ui_tenantId" class="input-medium" id="ui_tenantId" type="text" maxlength="50"
				value="${search.tenantId}"></li>
			<li><label for="ui_dealerName">代理商名：</label>
				<input name="ui_dealerName" class="input-medium" id="ui_dealerName" type="text" maxlength="50"
				value="${search.dealerName}"></li>
			<li><label for="ui_status">状态：</label>
				<select id="ui_status" name="ui_status" class="input-small">
					<option value=""></option>
					<option value="0" ${search.status == 0?'selected':''}>待确认</option>
					<option value="1" ${search.status == 1?'selected':''}>已确认</option>
					<option value="2" ${search.status == 2?'selected':''}>已完成</option>
					<option value="3" ${search.status == 3?'selected':''}>已废弃</option>
				</select></li>
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
				<th class="sort-column" onclick="return sort('${pager.sortActions['id']}')">订单编号
					<span class="${pager.sortStates['id'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['id'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['customerName']}')">客户名
					<span class="${pager.sortStates['customerName'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['customerName'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>客户ID</th>
				<th>代理商</th>
				<th>创建时间</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['status']}')">状态
					<span class="${pager.sortStates['status'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['status'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>

			<c:forEach items='${orderList}' var='order'>
				<tr>
					<td><c:out value='${order.poNumber}' /></td>
					<td><c:out value='${order.customerName}' /></td>
					<td><c:out value='${order.tenantId}' /></td>
					<td><c:out value='${order.dealerName}' /></td>
					<td><fmt:formatDate pattern="yyyy-MM-dd hh:mm" value='${order.createDate}' /></td>
					<td><c:out value='${order.status == 0 ? "待确认" : order.status == 1 ? "已确认" : order.status == 2 ? "已完成" : "已废弃"}' /></td>
					<td><a href="${base}/sys/orderDeal?id=${order.id}">处理</a></td>
				</tr>
			</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>