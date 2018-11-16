<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${entry.title}</title>

<script type="text/javascript">
$(document).ready(function() {
	$('#diagramtabs a:first').tab('show');
	$('.tab-pane').each(function() {
		var url = $(this).find("a").attr('href');
		$(this).find(".svg").load(url, function(result,status){
			if (status == "success") $(this).find("svg").svgPanZoom();
			if (status == "error") alertx(result);
		});
	});
});
</script>
<style type="text/css">
</style>
</head>
<body>
	<ul class="nav nav-tabs">

<c:forEach var="act" items="${actions}">
		<li class='<c:if test="${act.active}">active</c:if>'>
			<a href="${base}${act.url}">
			<c:if test="${empty act.icon}"><i class='${act.icon}'>&nbsp;</i></c:if>
				${act.title}</a>
		</li>
</c:forEach>
	</ul>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<div class="container-fluid">

<ul id="diagramtabs" class="nav nav-pills">
<c:forEach items='${tableids}' var='tid'>
<li><a href="javascript:;" data-toggle="pill" data-target="#diag${tid}">${tablenames[tid]}</a></li>
</c:forEach>
</ul>
<div class="tab-content">
<c:forEach items='${tableids}' var='tid'>
<c:set var="tbl" value="${tables[tid]}"/>
<c:set var="hdrs" value="${headers[tid]}"/>
<div class="tab-pane" id="diag${tid}">

	<table class="table table-striped table-condensed table-bordered"
		id="覆膜情况表">
		<thead>
			<tr>
<c:forEach items='${hdrs}' var='hdr'>
			<th>${hdr}</th>
</c:forEach>
			</tr>
		</thead>
		<tbody>
<c:forEach items='${tbl}' var='row'>
			<tr>
<c:forEach items='${hdrs}' var='hdr'>
			<td>${row[hdr]}</td>
</c:forEach>
			</tr>
</c:forEach>
		</tbody>
	</table>

</div>
</c:forEach>
</div>

</div>

</body>
</html>