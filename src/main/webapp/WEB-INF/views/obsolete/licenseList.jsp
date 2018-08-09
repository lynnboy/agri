<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>授权码列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_licenseKey").val($("#ui_licenseKey").val());
			$("#search_status").val($("#ui_status").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/licenseList">授权码列表</a></li>
		<li><a href="${base}/sys/licenseCreate">授权码创建</a></li>
	</ul>
	<form class="breadcrumb form-search " id="searchForm"
		action="${base}/sys/licenseList" method="get">
		<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
		<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
		<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
		<input name="licenseKey" id="search_licenseKey" type="hidden" value="${search.licenseKey}">
		<input name="status" id="search_status" type="hidden" value="${search.status}">
		<ul class="ul-form">
			<li><label for="ui_licenseKey">授权码：</label>
				<input name="ui_licenseKey" class="input-medium" id="ui_licenseKey" type="text" maxlength="50"
				value="${search.licenseKey}"></li>
			<li><label for="ui_status">状态：</label>
				<select id="ui_status" name="ui_status" class="input-small">
					<option value=""></option>
					<option value="0" ${search.status == 0?'selected':''}>未使用</option>
					<option value="1" ${search.status == 1?'selected':''}>已占用</option>
					<option value="2" ${search.status == 2?'selected':''}>已使用</option>
				</select></li>
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
				<th class="sort-column" onclick="return sort('${pager.sortActions['licenseKey']}')">授权码
					<span class="${pager.sortStates['licenseKey'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['licenseKey'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>套餐</th>
				<th>生成时间</th>
				<th class="sort-column" onclick="return sort('${pager.sortActions['status']}')">激活状态
					<span class="${pager.sortStates['status'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['status'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>激活时间</th>
			</tr>
		</thead>
		<tbody>

			<c:forEach items='${licenseList}' var='lic'>
				<tr>
					<td><c:out value='${lic.licenseKey}' /></td>
					<td>120人月</td>
					<td><fmt:formatDate pattern="yyyy-MM-dd hh:mm" value='${lic.createDate}' /></td>
					<td><c:out
							value='${lic.status == 0 ? "未使用" : lic.status == 1 ? "已占用" : "已使用"}' /></td>
					<td><fmt:formatDate pattern="yyyy-MM-dd hh:mm" value='${lic.issueDate}' /></td>
				</tr>
			</c:forEach>

		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

</body>
</html>