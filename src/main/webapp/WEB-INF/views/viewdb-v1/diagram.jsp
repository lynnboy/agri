<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>${entry.title}</title>
<meta name="decorator" content="default" />
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

<c:forEach var="entry" items="${entries}">
		<li class='<c:if test="${entry.key == key}">active</c:if>'>
			<a href="${base}${entryBase}/${entry.id}">
				<i class='${entry.type == 0 ? "icon-th" : "icon-picture"}'>&nbsp;</i>
				${entry.title}</a>
		</li>
</c:forEach>
	</ul>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<div class="container-fluid">

<ul id="diagramtabs" class="nav nav-pills">
<c:forEach items='${list}' var='diagram'>
<li><a href="javascript:;" data-toggle="pill" data-target="#diag${diagram.id}">${diagram.name}</a></li>
</c:forEach>
</ul>
<div class="tab-content">
<c:forEach items='${list}' var='diagram'>
<div class="tab-pane" id="diag${diagram.id}">
	<div class="svg" id="svg-${diagram.id}">
	<a href="${base}${diagramBase}/${diagram.id}">打开图表</a>
	</div>
</div>
</c:forEach>
</div>

</div>

</body>
</html>