<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>导入冲突</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_login").val($("#ui_login").val());
			$("#search_name").val($("#ui_name").val());
			$("#search_organ").val($("#ui_organ").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
		function refresh() { return pageTo($("#pageNo").val()); }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/conflict">导入冲突</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/sys/userList" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="login" id="search_login" type="hidden" value="${search.login}">
		<input name="name" id="search_name" type="hidden" value="${search.name}">
		<input name="organName" id="search_organ" type="hidden" value="${search.organName}">
		<ul class="ul-form">
			<li><label for="ui_login">项目:</label>
				<input name="ui_login"	class="input-medium" id="ui_login" type="text" maxlength="50"
					value=""></li>
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
				<th class="sort-column" onclick="return sort('${pager.sortActions['login']}')">项目
					<span class="${pager.sortStates['login'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['login'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['login']}')">冲突数量
					<span class="${pager.sortStates['login'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['login'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">导入时间
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">来源
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">来源类型
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">内容
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th></th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td><i class="icon-list-alt"></i> 地表径流与地下淋溶监测-2018 <span class="label label-warning">monitor-1.0.0</span></td>
				<td>3</td>
				<td>2018-07-14 13:47</td>
				<td><i class="icon-file"></i> 北京市监测数据2018.zip</td>
				<td>文件导入</td>
				<td>数据表:17 数据项:23 文件:14</td>
				<td><a href="${base}/sys/conflictResolve"
						class="btn btn-primary btn-mini">解决冲突</a></td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 监测测试 <span class="label label-warning">monitor-1.0.0</span></td>
				<td>16</td>
				<td>2018-07-05 19:22</td>
				<td><i class="icon-file"></i> 北京市监测数据2018.zip</td>
				<td>文件导入</td>
				<td>数据表:6 数据项:23 文件:14</td>
				<td><a href="${base}/sys/conflictResolve"
						class="btn btn-primary btn-mini">解决冲突</a></td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 地块调查测试 <span class="label label-warning">survey-1.0.0</span></td>
				<td>24</td>
				<td>2018-07-05 19:19</td>
				<td><i class="icon-file"></i> 北京市面源污染调查2017.zip</td>
				<td>文件导入</td>
				<td>数据表:6 数据项:23 文件:14</td>
				<td><a href="${base}/sys/conflictResolve"
						class="btn btn-primary btn-mini">解决冲突</a></td>
			</tr>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>