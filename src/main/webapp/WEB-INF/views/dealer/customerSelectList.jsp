<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>客户列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_id").val(parseInt($("#ui_id").val())||'');
			$("#search_name").val($("#ui_name").val());
			$("#search_tenantId").val($("#ui_tenantId").val());
			//$("#search_dealerName").val($("#ui_dealerName").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
		function choose(o) {
			console.log(o);
		}
</script>
</head>
<body>

	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/dealer/customerSelectList" method="post">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="id" id="search_id" type="hidden" value="${search.id}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">

		<ul class="ul-form">
			<li><label for="ui_id">客户编号：</label>
				<input name="ui_id" class="input-medium" id="ui_id" type="text" maxlength="50"
				value="${search.id}"></li>
			<li><label for="ui_name">客户名：</label>
				<input name="ui_name" class="input-medium" id="ui_name" type="text" maxlength="50"
				value="${search.name}"></li>
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
				<th style="text-align:center;"></th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['id']}')">客户编号
					<span class="${pager.sortStates['id'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['id'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">客户名
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>客户ID</th>
				<th>联系人姓名</th>
				<th>联系人邮箱</th>
				<th>联系人电话</th>
<!--
				<th>所属部门</th>
 -->
				<th>客户地址</th>
			</tr>
		</thead>
		<tbody>

<c:forEach items='${customerList}' var='customer'>
			<tr>
				<td style="text-align:center;">
					<a href="javascript:;" class="btn btn-primary btn-mini"
						onclick="choose({id:${customer.id},name:'${customer.name}',tenantId:'${customer.tenantId}'})">选择</a>
				</td>
				<td><c:out value='${customer.id}'/></td>
				<td><c:out value='${customer.name}'/></td>
				<td><c:out value='${customer.tenantId}'/></td>
				<td><c:out value='${customer.contact.name}'/></td>
				<td><c:out value='${customer.contact.email}'/></td>
				<td><c:out value='${customer.contact.phone}'/></td>
<!--
				<td><c:out value='${customer.contact.division}'/></td>
 -->
				<td><c:out value='${customer.contact.address}'/></td>
			</tr>

</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>