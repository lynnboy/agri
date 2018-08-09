<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>新建导入任务</title>
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
		<li><a href="${base}/sys/import">导入任务</a></li>
		<li class="active"><a href="${base}/sys/importAdd">新建导入</a></li>
	</ul>
	<br />

<div class="container-fluid">

<%@include file="/WEB-INF/views/common/message.jsp"%>

<h3>数据包文件</h3>

<div class="control-group">

<label class="control-label">
数据导入暂存目录:
 <input type="text" class="readonly" readonly="readonly" value="C:\AgriImport">
</label>

<div>
<label class="control-label">
上传数据包文件
<input type="file" class="file input-large">
<button class="btn btn-small">上传</button>
</label>
</div>

<div>
<a class="btn btn-primary"><i class="icon-refresh">&nbsp;</i> 重新扫描</a>
</div>

</div>

<table class="table table-bordered">
<tr>
	<th>文件名</th>
	<th>版本</th>
	<th>内容</th>
	<th>生成时间</th>
	<th>导入操作</th>
	<%-- 
	<th>操作</th>
	 --%>
</tr>

<tr>
	<td><i class="icon-file"></i> 测试数据.zip</td>
	<td>test-1.0.0</td>
	<td>数据表:3 数据项:83 文件:15</td>
	<td>2017-10-17 12:12</td>
	<td>
		未找到项目模板
	</td>
</tr>

<tr>
	<td><i class="icon-file"></i> 北京市调查数据2008.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:5 数据项:25010 文件:0</td>
	<td>2017-07-09 17:50</td>
	<td>
		<button onclick="importNewProj()"
		 class="btn btn-primary btn-mini">作为新项目导入</button>
		<button onclick="importToProj()"
		 class="btn btn-primary btn-mini">导入到现有项目</button>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市调查数据2010.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:3 数据项:79 文件:0</td>
	<td>2017-07-09 17:54</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市调查数据2012.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:6 数据项:1400 文件:1</td>
	<td>2017-07-09 17:56</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市调查数据2014.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:6 数据项:1361 文件:1</td>
	<td>2017-07-09 18:02</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市调查数据2016.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:4 数据项:1061 文件:1</td>
	<td>2017-07-09 18:05</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市监测数据.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:18 数据项:1636 文件:1</td>
	<td>2017-07-09 18:22</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市统计数据.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:6 数据项:99 文件:0</td>
	<td>2017-07-09 18:29</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 文献数据.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:8 数据项:129 文件:0</td>
	<td>2017-07-09 18:33</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市流失数据.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:5 数据项:607 文件:10</td>
	<td>2017-07-09 18:34</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市评估数据.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:3 数据项:83 文件:15</td>
	<td>2017-07-09 18:34</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市预警数据.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:3 数据项:20 文件:5</td>
	<td>2017-07-09 18:35</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>
<tr>
	<td><i class="icon-file"></i> 北京市减排数据.zip</td>
	<td>viewdb-1.0.0</td>
	<td>数据表:3 数据项:83 文件:3</td>
	<td>2017-07-09 18:35</td>
	<td>
		<a href="${base}/sys/importNewProj"
		 class="btn btn-primary btn-mini">作为新项目导入</a>
		<a href="${base}/sys/importToProj"
		 class="btn btn-primary btn-mini">导入到现有项目</a>
	</td>
</tr>

</table>

</div>

</body>
</html>