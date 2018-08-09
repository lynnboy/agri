<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>代理商列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_login").val($("#ui_login").val());
			$("#search_name").val($("#ui_name").val());
			$("#search_email").val($("#ui_email").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
		function refresh() { return pageTo($("#pageNo").val()); }
		function remove(id){
			confirmx('确认要删除该用户吗？', function(){
				$.post("${base}/sys/userDelete", {id:id}, function(result,status){
					alertx(result, function(){ refresh(); });
				})
			});
			return false;
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/userList">代理商列表</a></li>
		<li><a href="${base}/sys/userAdd">代理商添加</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/sys/userList" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="login" id="search_login" type="hidden" value="${search.login}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">
		<input name="email" id="search_email" type="hidden" value="${search.email}">
		<ul class="ul-form">
			<li><label for="ui_login">登录名：</label>
				<input name="ui_login"	class="input-medium" id="ui_login" type="text" maxlength="50"
					value="${search.login}"></li>
			<li><label for="ui_name">代理商名：</label>
				<input name="ui_name" class="input-medium"	id="ui_name" type="text" maxlength="50"
					value="${search.name}"></li>
			<li><label for="ui_email">邮箱：</label>
				<input name="ui_email" class="input-medium" id="ui_email" type="text" maxlength="50"
					value="${search.email}"></li>
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
				<th class="sort-column" onclick="return sort('${pager.sortActions['login']}')">登录名
					<span class="${pager.sortStates['login'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['login'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">代理商名
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>邮箱</th>
				<th>电话</th>
				<th>手机</th>
				<th>注册时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>

<c:forEach items='${dealerList}' var='dealer'>
			<tr>
				<td><c:out value='${dealer.login}'/></td>
				<td><c:out value='${dealer.name}'/></td>
				<td><c:out value='${dealer.email}'/></td>
				<td><c:out value='${dealer.phone}'/></td>
				<td><c:out value='${dealer.mobile}'/></td>
				<td><fmt:formatDate pattern="yyyy-MM-dd hh:mm" value='${dealer.createDate}'/></td>
				<td><a href="${base}/sys/userModify?id=${dealer.id}">修改</a> <a
					onclick="return remove(${dealer.id})" href="javascript:;">删除</a></td>
			</tr>
</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>