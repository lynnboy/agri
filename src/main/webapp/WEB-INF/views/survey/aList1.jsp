<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块数据列表</title>

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
		function commit() {
			
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/survey/list">数据列表</a></li>
		<li><a href="${base}/survey/add1">添加数据</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/agri/list" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="地块编码" id="search_地块编码" type="hidden" value="${search.地块编码}">

		<ul class="ul-form">
			<li><label for="ui_地块编码">区划代码：</label>
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
				<th>行政区划代码</th>
				<th>行政区划</th>
				<th>种植模式（亩）</th>
				<th>耕地面积（亩）</th>
				<th>菜田面积（亩）</th>
				<th>园地面积（亩）</th>
				<th>填报人</th>
				<th>状态</th>
				<th>填写时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>

				<tr>
					<td>110114</td>
					<td>北京市昌平区</td>
					<td>
						2 种 <a class="btn btn-primary btn-mini" href="${base}/survey/modelist">填写</a>
					</td>
					<td>3600</td>
					<td>6470</td>
					<td>1729.5</td>
					<td>张三</td>
					<td>草稿</td>
					<td>2018-01-12</td>
					<td>
						<a class="btn btn-primary btn-mini" href="${base}/agri/edit?id=${item.id}">修改</a>
						<a class="btn btn-primary btn-mini" href="${base}/agri/process?id=${item.id}">删除</a>
						<a class="btn btn-primary btn-mini" href="${base}/agri/edit?id=${item.id}">提交审核</a>
						<button class="btn btn-primary btn-mini" onclick="commit()" >提交审核</button>
					</td>
				</tr>

				<tr>
					<td>110115</td>
					<td>北京市大兴区</td>
					<td>
						1 种 <a class="btn btn-primary btn-mini" href="${base}/survey/modelist">填写</a>
					</td>
					<td>10000</td>
					<td>10000</td>
					<td>10000</td>
					<td>某人</td>
					<td>待审核</td>
					<td>2018-01-12</td>
					<td>
						<a class="btn btn-primary btn-mini" href="${base}/agri/edit?id=${item.id}">修改</a>
						<a class="btn btn-primary btn-mini" href="${base}/agri/process?id=${item.id}">删除</a>
						<a class="btn btn-primary btn-mini" href="${base}/agri/edit?id=${item.id}">撤回审核</a>
					</td>
				</tr>

				<tr>
					<td>110115</td>
					<td>北京市大兴区</td>
					<td>
						3 种 <a class="btn btn-primary btn-mini" href="${base}/survey/modelist">查看</a>
					</td>
					<td>12000</td>
					<td>25000</td>
					<td>50000</td>
					<td>张三</td>
					<td>已审核</td>
					<td>2018-01-08</td>
					<td>
						<a class="btn btn-primary btn-mini" href="${base}/agri/edit?id=${item.id}">查看</a>
					</td>
				</tr>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>