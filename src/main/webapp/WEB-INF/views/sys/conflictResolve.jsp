<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>解决导入冲突: 典型地块监测-2018</title>

<script type="text/javascript">
function showData() {
	top.$.jBox.open("iframe:${base}/sys/conflictData1",
			"查看数据: 典型地块监测-2018 编号 110111L1 (现有数据)",
		$(top.document).width()-220,
		$(top.document).height()-200,
		{ opacity:0 });
}
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
		<li><a href="${base}/sys/conflict">导入冲突</a></li>
		<li class="active"><a href="${base}/sys/conflictResolve">解决导入冲突: <i class="icon-list-alt"></i> 地表径流与地下淋溶监测-2018</a></li>
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
			<li><label for="ui_login">数据表:</label>
				<input name="ui_login"	class="input-mini" id="ui_login" type="text" maxlength="50"
					value=""></li>
			<li><label for="ui_login">编号:</label>
				<input name="ui_login"	class="input-mini" id="ui_login" type="text" maxlength="50"
					value=""></li>
			<li><label for="ui_login">状态:</label>
				<input name="ui_login"	class="input-mini" id="ui_login" type="text" maxlength="50"
					value=""></li>
			<li><label for="ui_login">提交人员:</label>
				<input name="ui_login"	class="input-mini" id="ui_login" type="text" maxlength="50"
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
				<th class="sort-column">数据表</th>
				<th class="sort-column">数据编号</th>
				<th></th>
				<th class="sort-column">状态</th>
				<th class="sort-column">提交人</th>
				<th class="sort-column">单位</th>
				<th class="sort-column">提交时间</th>
				<th></th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td rowspan="2">地块信息</td>
				<td rowspan="2">110111L1</td>
				<td class="inactive">现有数据</td>
				<td><span class="label label-info">已审核</span></td>
				<td>崔庆</td>
				<td>房山区农业环境和生产监测站</td>
				<td>2017-05-24 14:30</td>
				<td>
					<a href="${base}/sys/conflictData1"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">保留现有数据</button>
				</td>
			</tr>
			<tr>
				<td class="inactive">导入数据</td>
				<td><span class="label label-info">已审核</span></td>
				<td>崔庆</td>
				<td>房山区农业环境和生产监测站</td>
				<td>2017-05-24 14:30</td>
				<td>
					<a href="${base}/sys/conflictData1"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">导入数据</button>
				</td>
			</tr>

			<tr>
				<td rowspan="2">地块信息</td>
				<td rowspan="2">110112L1</td>
				<td class="inactive">现有数据</td>
				<td><span class="label label-info">已审核</span></td>
				<td>周永香</td>
				<td>通州区农业技术推广站</td>
				<td>2017-07-09 08:27</td>
				<td>
					<a href="javascript:;" onclick="showData()"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">保留现有数据</button>
				</td>
			</tr>
			<tr>
				<td class="inactive">导入数据</td>
				<td><span class="label label-info">已审核</span></td>
				<td>周永香</td>
				<td>通州区农业技术推广站</td>
				<td>2017-07-09 08:27</td>
				<td>
					<a href="javascript:;" onclick="showData()"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">导入数据</button>
				</td>
			</tr>

			<tr>
				<td rowspan="2">地块信息</td>
				<td rowspan="2">110111L2</td>
				<td class="inactive">现有数据</td>
				<td><span class="label label-info">已审核</span></td>
				<td>崔庆</td>
				<td>房山区农业环境和生产监测站</td>
				<td>2017-05-26 12:23</td>
				<td>
					<a href="javascript:;" onclick="showData()"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">保留现有数据</button>
				</td>
			</tr>
			<tr>
				<td class="inactive">导入数据</td>
				<td><span class="label label-info">已审核</span></td>
				<td>崔庆</td>
				<td>房山区农业环境和生产监测站</td>
				<td>2017-05-26 12:23</td>
				<td>
					<a href="javascript:;" onclick="showData()"
						class="btn btn-primary btn-mini">查看数据</a>
					<button class="btn btn-primary btn-mini">导入数据</button>
				</td>
			</tr>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>