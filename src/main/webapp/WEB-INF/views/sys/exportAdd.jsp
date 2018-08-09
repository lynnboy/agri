<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>新建导出任务</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
function importNewProj() {
	top.$.jBox.open("iframe:${base}/sys/importNewProj","作为新项目导入",
		$(top.document).width()-220,$(top.document).height()-200,{
	});
}
function importToProj() {
	top.$.jBox.open("iframe:${base}/sys/importToProj","导入到现有项目",
		$(top.document).width()-220,$(top.document).height()-200,{
	});
}

$(document).ready(function() {
});
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/sys/export">导出任务</a></li>
		<li class="active"><a href="${base}/sys/exportAdd">新建导出</a></li>
	</ul>
	<br />

<div class="container-fluid">

<%@include file="/WEB-INF/views/common/message.jsp"%>

<h3>选择项目</h3>

<div class="control-group">

<label class="control-label">
数据导入目录:
 <input type="text" class="readonly" readonly="readonly" value="C:\AgriExport">
</label>

</div>

<table class="table table-bordered">
<tr>
	<th>项目</th>
	<th>模板</th>
	<th>说明</th>
	<th>内容</th>
	<th>导出操作</th>
	<%-- 
	<th>操作</th>
	 --%>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 清查测试</td>
	<td>种植业基本情况清查 <span class="label label-warning">planting-1.0.0</span></td>
	<td></td>
	<td>数据表:5 数据项:0 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 种植业清查2017</td>
	<td>种植业基本情况清查 <span class="label label-warning">planting-1.0.0</span></td>
	<td></td>
	<td>数据表:5 数据项:4 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 典型地块调查2017</td>
	<td>典型地块调查 <span class="label label-warning">survey-1.0.0</span></td>
	<td></td>
	<td>数据表:8 数据项:3 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 地表径流与地下淋融监测-2017</td>
	<td>地表径流与地下淋融监测 <span class="label label-warning">monitor-1.0.0</span></td>
	<td></td>
	<td>数据表:17 数据项:2 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 畜禽清粪调查测试</td>
	<td>典型畜禽养殖单元清粪方式与粪污处理利用调查 <span class="label label-warning">feces-1.0.0</span></td>
	<td></td>
	<td>数据表:1 数据项:0 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 调查数据-2008</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td>2008年调查数据</td>
	<td>数据表:5 数据项:25091 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 调查数据-2010</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td>2010年调查数据</td>
	<td>数据表:3 数据项:79 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 调查数据-2012</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td>2012年调查数据</td>
	<td>数据表:6 数据项:1401 文件:1</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 调查数据-2014</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td>2014年调查数据</td>
	<td>数据表:6 数据项:1362 文件:1</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 调查数据-2016</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td>2016年调查数据</td>
	<td>数据表:4 数据项:1062 文件:1</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 监测数据</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td>2017年监测数据</td>
	<td>数据表:18 数据项:1636 文件:1</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 统计数据</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td></td>
	<td>数据表:6 数据项:99 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 文献数据</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td></td>
	<td>数据表:8 数据项:129 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 流失数据</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td></td>
	<td>数据表:4 数据项:607 文件:10</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 评估数据</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td></td>
	<td>数据表:3 数据项:83 文件:15</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 预警数据</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td></td>
	<td>数据表:3 数据项:20 文件:5</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> 减排数据</td>
	<td>面源污染数据库 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td></td>
	<td>数据表:3 数据项:83 文件:3</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

<tr>
	<td><i class="icon-list-alt"></i> test4</td>
	<td>测试模板 <span class="label label-warning">viewdb-1.0.0</span></td>
	<td></td>
	<td>数据表:2 数据项:0 文件:0</td>
	<td>
		<a href="${base}/sys/exportProj"
		 class="btn btn-primary btn-mini">导出项目数据</a>
	</td>
</tr>

</table>

</div>

</body>
</html>