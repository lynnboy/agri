<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>作为新项目导入</title>

<script type="text/javascript">
$(document).ready(function() {
});
</script>
</head>
<body>

<div class="container-fluid">

<%@include file="/WEB-INF/views/common/message.jsp"%>

<ul id="diagramtabs" class="nav nav-pills">
<li><a href="javascript:;" data-toggle="pill" data-target="#tab1">地块信息</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab2">土壤剖面信息</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab3">小区编码与处理对应</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab4">处理说明</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab5">种植季与作物对应</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab6">处理描述:耕作</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab7">处理描述:施肥</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">处理描述:灌溉秸秆还田</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">处理描述:地膜植物篱</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">种植记录</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">植株产量记载及植株样品记录</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">施肥记录</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">降水灌溉水样品</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">小区产流记载及水样品记录</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">基础土壤样品</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">监测期土壤样品</a></li>
<li><a href="javascript:;" data-toggle="pill" data-target="#tab8">试验进程及操作记录</a></li>
</ul>
<div class="tab-content">
<div class="tab-pane" id="tab1">

	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/${action}" method="post">
		
		<div><br></div>
		<div class="control-group">
			<label for="name" class="control-label">地块编码:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="110111L1"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">地块地址:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="北京市房山区琉璃河镇务滋村"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">农户姓名:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="欧阳奇"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">农户电话:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="18611179476"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">负责人姓名:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="崔庆"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">负责人电话:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="01069361495"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">负责人Email:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="fsjcz1893@163.com"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">联系人姓名:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="李荣花"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">联系人电话:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="01069361477"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">联系人Email:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="fsnyhb1477@163.com"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">经度:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="116.14382"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">纬度:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="39.62679"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">海拔:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="53.9"/>
			</div>
		</div>
	</form>

</div>


<div class="tab-pane" id="tab3">

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable">
		<thead>
			<tr>
				<th>地块编码</th>
				<th>小区编码</th>
				<th>处理代码</th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td>110111L1</td>
				<td>A1</td>
				<td>CK</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>A2</td>
				<td>CK</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>A3</td>
				<td>CK</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>B1</td>
				<td>KF</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>B2</td>
				<td>KF</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>B3</td>
				<td>KF</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>C1</td>
				<td>BMP</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>C2</td>
				<td>BMP</td>
			</tr>
			<tr>
				<td>110111L1</td>
				<td>C3</td>
				<td>BMP</td>
			</tr>

		</tbody>
	</table>

</div>
</div>


</div>

</body>
</html>