<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>种植模式数据</title>

	<script type="text/javascript">
	$(document).ready(function() {
		$('#btnSubmit').click(function(){
			top.$.jBox.open("iframe:${base}/survey/add2and3", "添加农药使用记录",$(top.document).width()-220,$(top.document).height()-200,{
			});
		});
	});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_地块编码").val($("#ui_地块编码").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/agri/list">数据列表</a></li>
		<li class="active"><a href="${base}/agri/add">农药使用状况记录列表</a></li>
	</ul>

<p>
<strong>行政区划: 110114-102-203 - 北京市昌平区某县某乡某某村3组<br></strong>
<strong>地块: 110114-DK001<br></strong>
<strong>地块面积: 30 亩<br></strong>
<strong>种植模式: 【DB05】 东北半湿润平原区-旱地-其他大田作物<br></strong>
</p>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable1">
		<thead>
			<tr>
				<th rowspan="2">编号</th>
				<th rowspan="2">作物</th>
				<th rowspan="2">农药商品名称</th>
				<th rowspan="2">类别</th>
				<th rowspan="2">施用量<br>(g/亩), (ml/亩)</th>
				<th colspan="3">主要有效成分名称及含量</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>成分1</th>
				<th>成分2</th>
				<th>成分3</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>1</td>
				<td>【LC02】 - 小麦</td>
				<td>超级杀虫剂一号</td>
				<td>杀虫剂</td>
				<td>2000</td>
				<td>DDT 58%</td>
				<td></td>
				<td></td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
			<tr>
				<td>2</td>
				<td>【LC02】 - 小麦</td>
				<td>一扫空</td>
				<td>除草剂</td>
				<td>1000</td>
				<td>??? 52%</td>
				<td>XXXXXXXX 15%</td>
				<td></td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<button id="btnSubmit" class="btn btn-primary" type="button"
			 		 value="添加处理">添加</button>
		</div>
		<br/>

</body>
</html>