<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>种植模式数据</title>

	<script type="text/javascript">
	$(document).ready(function() {
		$('#btnSubmit').click(function(){
			top.$.jBox.open("iframe:${base}/survey/add1and1", "添加种植模式",$(top.document).width()-220,$(top.document).height()-200,{
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
		<li class="active"><a href="${base}/agri/add">种植模式列表</a></li>
	</ul>

<p>
<strong>行政区划: 110114 - 北京市昌平区<br></strong>
</p>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable1">
		<thead>
			<tr>
				<th>编号</th>
				<th>种植模式</th>
				<th>模式面积（亩）</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>1</td>
				<td>BF02 - 北方高原山地区-缓坡地-非梯田-横坡-大田作物</td>
				<td>5300</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
			<tr>
				<td>2</td>
				<td>BF04 - 北方高原山地区-缓坡地-非梯田-园地</td>
				<td>7000</td>
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