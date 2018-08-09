<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块数据列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_地块编码").val($("#ui_地块编码").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/agri/list">地块数据列表</a></li>
		<li><a href="${base}/agri/add">添加地块</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/agri/list" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="地块编码" id="search_地块编码" type="hidden" value="${search.地块编码}">

		<ul class="ul-form">
			<li><label for="ui_地块编码">地块编码：</label>
				<input name="ui_地块编码" class="input-medium" id="ui_地块编码" type="text" maxlength="50"
				value="${search.地块编码}"></li>
<%-- 
			<li><label for="ui_name">客户名：</label>
				<input name="ui_name" class="input-medium" id="ui_name" type="text" maxlength="50"
				value="${search.name}"></li>
			<li><label for="ui_tenantId">客户ID：</label>
				<input name="ui_tenantId" class="input-medium" id="ui_tenantId" type="text" maxlength="50"
				value="${search.tenantId}"></li>
			<li><label for="ui_dealerName">代理商名：</label>
				<input name="ui_dealerName" class="input-medium" id="ui_dealerName" type="text" maxlength="50"
				value="${search.dealerName}"></li>
 --%>
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
				<th class="sort-column" onclick="return sort('${pager.sortActions['地块编码']}')">地块编码
					<span class="${pager.sortStates['地块编码'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['地块编码'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>地块地址</th>
				<th>种植模式</th>
				<th>种植季</th>
				<th>土壤</th>
				<th>肥力</th>
				<th>障碍层</th>
				<th>监测小区</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>

			<c:forEach items='${list}' var='item'>
				<tr>
					<td><c:out value='${item.地块编码}' /></td>
					<td><c:out value='${item.地块地址}' /></td>
					<td><c:out value='${item.种植模式text}' /></td>
					<td><c:out value='${"3"} 季' />
						<a class="btn btn-primary btn-mini" href="${base}/agri/seasons?id=${item.id}">填写</a>
					</td>
					<td><c:out value='${item.土壤text}' />
						<a class="btn btn-primary btn-mini" href="${base}/agri/sections?id=${item.id}">剖面表</a>
					</td>
					<td><c:out value='${item.肥力水平text}' /></td>
					<td><c:out value='${item.障碍层text}' /></td>

					<td>${item.监测小区text}</td>
					<td>
						<a class="btn btn-primary btn-mini" href="${base}/agri/edit?id=${item.id}">修改</a>
						<a class="btn btn-primary btn-mini" href="${base}/agri/process?id=${item.id}">处理</a>
						<a class="btn btn-primary btn-mini" href="${base}/agri/record?id=${item.id}">记录</a>
					</td>
				</tr>
			</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>