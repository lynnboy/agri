<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>人员列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			$("#ui_status").val($("#search_status").val());
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_login").val($("#ui_login").val());
			$("#search_name").val($("#ui_name").val());
			$("#search_organ").val($("#ui_organ").val());
			$("#search_status").val($("#ui_status").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
		function refresh() { return pageTo($("#pageNo").val()); }
		function merge(user){
			top.$.jBox.open("iframe:${base}/sys/selectMergeUser", "选择合并的目标人员",
				$(top.document).width()-220,$(top.document).height()-200,{
				id:"targetSelectDialog",
				buttons:{}, 
				loaded:function(h){
					var dialogwin = h.find("iframe")[0].contentWindow;
					dialogwin.$("#user_" + user.id).remove();
					dialogwin.choose = function(target) {
						confirmx('是否将人员 "' + user.name + '" 及其相关数据合并到人员 "' + target.name + '" 之中？',
						function() {
							top.$.jBox.close("targetSelectDialog");
							$.post("${base}/sys/userMerge", {id:user.id,targetId:target.id}, function(result,status) {
								alertx(result, function() { refresh(); });
							});
						});
					};
				}
			});
			return false;
		}
		function remove(id){
			confirmx('确认要删除该用户吗？', function(){
				$.post("${base}/sys/userDelete", {id:id}, function(result,status){
					alertx(result, function(){ refresh(); });
				})
			});
			return false;
		}
		function choose(o) {
			console.log(o);
		}
	</script>
</head>
<body>
<c:if test="${!isSelecting}">
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/userList">人员列表</a></li>
		<li><a href="${base}/sys/userAdd">人员添加</a></li>
	</ul>
</c:if>
	<form class="breadcrumb form-search " id="searchForm"
		method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="login" id="search_login" type="hidden" value="${search.login}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">
		<input name="organName" id="search_organ" type="hidden" value="${search.organName}">
		<input name="status" id="search_status" type="hidden" value="${search.status}">
		<ul class="ul-form">
			<li><label for="ui_login">登录名：</label>
				<input name="ui_login"	class="input-small" id="ui_login" type="text" maxlength="50"
					value="${search.login}"></li>
			<li><label for="ui_name">姓名：</label>
				<input name="ui_name" class="input-small" id="ui_name" type="text" maxlength="50"
					value="${search.name}"></li>
			<li><label for="ui_organ">组织:</label>
				<input name="ui_organ" class="input-small" id="ui_organ" type="text" maxlength="50"
					value="${search.organName}"></li>
			<li>&nbsp; <select id="ui_status" class="input-small">
					<option value="">全部</option>
					<option value="0">常规人员</option>
					<option value="1">导入人员</option>
				</select>
			</li>
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
				<c:if test="${isSelecting}">
				<th style="text-align:center;"></th>
				</c:if>
				<th class="sort-column" onclick="return sort('${pager.sortActions['login']}')">登录名
					<span class="${pager.sortStates['login'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['login'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">姓名
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>组织</th>
				<th>邮箱</th>
				<th>手机</th>
				<th>创建时间</th>
				<c:if test="${!isSelecting}">
				<th>操作</th>
				</c:if>
			</tr>
		</thead>
		<tbody>

<c:forEach items='${dealerList}' var='dealer'>
			<tr>
				<td style="text-align:center;">
					<a href="javascript:;" class="btn btn-primary btn-mini"
						id="user_${dealer.id}"
						onclick="choose({id:${dealer.id},name:'${dealer.name}'})">选择</a>
				</td>
				<td><c:out value='${dealer.login}'/></td>
				<td><c:out value='${dealer.name}'/></td>
				<td><c:out value='${dealer.organName}'/></td>
				<td><c:out value='${dealer.email}'/></td>
				<td><c:out value='${dealer.mobile}'/></td>
				<td><fmt:formatDate pattern="yyyy-MM-dd hh:mm" value='${dealer.createDate}'/></td>
				<c:if test="${!isSelecting}">
				<td><a href="${base}/sys/userModify?id=${dealer.id}"
					class="btn btn-primary btn-mini">修改</a>
					<a onclick="return merge({id:${dealer.id},name:'${dealer.name}'})"
						class="btn btn-primary btn-mini" href="javascript:;">合并</a>
					<a onclick="return remove(${dealer.id})"
						class="btn btn-primary btn-mini" href="javascript:;">删除</a>
				</td>
				</c:if>
			</tr>
</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>