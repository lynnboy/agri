<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>导入任务</title>
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
		<li class="active"><a href="${base}/sys/import">导入任务</a></li>
		<li><a href="${base}/sys/importAdd">新建导入</a></li>
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
				<th class="sort-column" onclick="return sort('${pager.sortActions['login']}')">项目
					<span class="${pager.sortStates['login'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['login'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">模板
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">时间
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['name']}')">状态
					<span class="${pager.sortStates['name'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['name'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>文件</th>
				<th></th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td><i class="icon-list-alt"></i> 调查数据-2010 <span class="label label-info">新项目</span></td>
				<td><i class="icon-list-alt"></i> 面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
				<td>2017-07-24 19:24</td>
				<td><span class="label label-success">已完成</span></td>
				<td><i class="icon-file"></i> 北京市调查数据2010.zip</td>
				<td>数据表:3 数据项:78 文件:0</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 调查数据-2012 <span class="label label-info">新项目</span></td>
				<td><i class="icon-list-alt"></i> 面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
				<td>2017-07-24 19:26</td>
				<td><span class="label label-success">已完成</span></td>
				<td><i class="icon-file"></i> 北京市调查数据2012.zip</td>
				<td>数据表:6 数据项:1395 文件:1</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 地表径流与地下淋溶监测-2018</td>
				<td><i class="icon-list-alt"></i> 地表径流与地下淋溶监测 <span class="label label-warning">monitor-1.0.0</span></td>
				<td>2018-05-03 09:43</td>
				<td><span class="label label-important">冲突</span></td>
				<td><i class="icon-file"></i> 北京市监测-朝阳-2018.zip</td>
				<td>数据表:6 数据项:23 <b>冲突数据项:3</b> 文件:14</td>
			</tr>

			<tr>
				<td><i class="icon-list-alt"></i> 地表径流与地下淋溶监测-2018</td>
				<td><i class="icon-list-alt"></i> 地表径流与地下淋溶监测 <span class="label label-warning">monitor-1.0.0</span></td>
				<td>2018-05-03 09:45</td>
				<td><span class="label label-info">等待中</span></td>
				<td><i class="icon-file"></i> 北京市监测-顺义-2018.zip</td>
				<td><a onclick="return remove(${dealer.id})"
						class="btn btn-primary btn-mini" href="javascript:;">撤销</a></td>
			</tr>
		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>