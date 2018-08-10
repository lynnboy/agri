<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>导出任务</title>

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
		<li class="active"><a href="${base}/sys/export">导出任务</a></li>
		<li><a href="${base}/sys/exportAdd">新建导出</a></li>
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
			<li><label for="ui_name">模板:</label>
			<select>
			<option>== 全部 ==</option>
			<option>面源污染数据库 viewdb-1.0.0</option>
			<option>农业面源污染典型地块监测 monitor-1.0.0</option>
			<option>农业面源污染调查 survey-1.0.0</option>
			<option>典型畜禽养殖单元清粪方式与粪污处理利用调查 feces-1.0.0</option>
			</select>
					</li>
			<li><label for="ui_organ">状态:</label>
			<select>
			<option>== 全部 ==</option>
			<option>等待中</option>
			<option>进行中</option>
			<option>冲突</option>
			<option>已完成</option>
			<option>已取消</option>
			<option>出错</option>
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
				<th class="sort-column">项目</th>
				<th class="sort-column">导出时间</th>
				<th class="sort-column">状态</th>
				<th class="sort-column">文件</th>
				<th>导出条件</th>
				<th>内容</th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td><i class="icon-list-alt"></i> 典型地块-2018 <span class="label label-warning">survey-1.0.0</span></td>
				<td>2018-05-03 09:43</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 典型地块-2018-20180503-094334.zip</a></td>
				<td>状态: <span class="label label-info">已审核</span></td>
				<td>数据表:7 数据项:42 文件:31</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 典型地块-2018 <span class="label label-warning">survey-1.0.0</span></td>
				<td>2018-05-03 10:16</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 典型地块-2018-20180503-101617.zip</a></td>
				<td>提交时间: 不早于 2017-06-02</td>
				<td>数据表:7 数据项:16 文件:7</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 调查数据-2016 <span class="label label-warning">viewdb-1.0.0</span></td>
				<td>2018-07-24 19:24</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 调查数据-2016-20180724-192453.zip</a></td>
				<td>全部</td>
				<td>数据表:4 数据项:1061 文件:1</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 调查数据-2014 <span class="label label-warning">viewdb-1.0.0</span></td>
				<td>2018-07-24 19:26</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 调查数据-2014-20180724-192617.zip</a></td>
				<td>全部</td>
				<td>数据表:6 数据项:1362 文件:1</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 调查数据-2012 <span class="label label-warning">viewdb-1.0.0</span></td>
				<td>2018-07-24 19:26</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 调查数据-2012-20180724-192655.zip</a></td>
				<td>全部</td>
				<td>数据表:6 数据项:1401 文件:1</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 调查数据-2010 <span class="label label-warning">viewdb-1.0.0</span></td>
				<td>2018-07-24 19:27</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 调查数据-2010-20180724-192721.zip</a></td>
				<td>全部</td>
				<td>数据表:3 数据项:79 文件:0</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 调查数据-2008 <span class="label label-warning">viewdb-1.0.0</span></td>
				<td>2018-07-24 19:28</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 调查数据-2008-20180724-192836.zip</a></td>
				<td>全部</td>
				<td>数据表:5 数据项:10468 文件:0</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 地表径流与地下淋融监测-2017 <span class="label label-warning">monitor-1.0.0</span></td>
				<td>2018-07-27 11:12</td>
				<td><span class="label label-success">已完成</span></td>
				<td><a href="#"><i class="icon-file"></i> 地表径流与地下淋融监测-2017-20180727-111210.zip</a></td>
				<td>状态: <span class="label label-info">待审核</span>, <span class="label label-info">已审核</span>;<br/>
					提交人员: 匹配 "测试*"
				</td>
				<td>数据表:19 数据项:8 文件:0</td>
			</tr>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>