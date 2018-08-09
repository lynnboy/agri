<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块数据列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			$('#btnSubmit').click(function(){
				top.$.jBox.open("iframe:${base}/agri/addSection", "添加土壤剖面描述",$(top.document).width()-220,$(top.document).height()-200,{
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
		<li><a href="${base}/agri/list">地块数据列表</a></li>
		<li class="active"><a href="${base}/agri/add">土壤剖面</a></li>
	</ul>
<%-- 
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/agri/list" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="地块编码" id="search_地块编码" type="hidden" value="${search.地块编码}">

		<ul class="ul-form">
			<li><label for="ui_地块编码">地块编码：</label>
				<input name="ui_地块编码" class="input-medium" id="ui_地块编码" type="text" maxlength="50"
				value="${search.地块编码}"></li>
			<li class="btns">
				<input class="btn btn-primary" id="btnSubmit" onclick="return search();" type="submit" value="查询"></li>
			<li class="clearfix"></li>
		</ul>
	</form>
 --%>

<p>
地块编码: 13005812<br>
地块地址: 地址 地址 地址  某县 某乡 某村
</p>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable">
		<thead>
			<tr>
				<th class="sort-column" onclick="return sort('${pager.sortActions['地块编码']}')">序号
					<span class="${pager.sortStates['地块编码'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['地块编码'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>发生层次</th>
				<th>厚度(cm)</th>
				<th>颜色</th>
				<th>结构</th>
				<th>新生体类别</th>
				<th>新生体形态</th>
				<th>新生体数量</th>
				<th>坚实度</th>
				<th>根系类型</th>
				<th>动物穴</th>
				<th>石灰反应</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>1</td>
				<td>0 层</td>
				<td>6.3</td>
				<td>灰黑</td>
				<td>团块状结构</td>
				<td></td>
				<td></td>
				<td></td>
				<td>紧实</td>
				<td>细根</td>
				<td>昆虫螨及虫穴</td>
				<td></td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>1</td>
				<td>A 层</td>
				<td>10.4</td>
				<td>黑</td>
				<td>大粒状结构</td>
				<td></td>
				<td></td>
				<td></td>
				<td>稍紧实</td>
				<td></td>
				<td></td>
				<td></td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<input id="btnSubmit" class="btn btn-primary" type="button" value="添加土壤剖面描述" />
		</div>
</body>
</html>