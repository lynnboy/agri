<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块数据列表</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_地块编码").val($("#ui_地块编码").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
		function refresh() { window.location.reload(); }
		
		function remove(id){
			confirmx('确认要作废该项目吗？', function(){
				$.post("${base}/sys/projectDeprecate", {id:id}, function(result,status){
					alertx(result, function(){ refresh(); });
				})
			});
			return false;
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${base}/sys/importProj">项目模板列表</a></li>
	</ul>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<div class="container-fluid">

<table class="table table-bordered">
<tr>
	<th>项目模板</th>
	<th>版本</th>
	<th>说明</th>
	<th>导入日期</th>
	<th>项目数量</th>
	<%-- 
	<th>操作</th>
	 --%>
</tr>
<c:forEach items='${templates}' var='temp'>
<tr>
	<td><i class="icon-list-alt"></i> <c:out value='${temp.name}'/></td>
	<td><c:out value='${temp.version}'/></td>
	<td><c:out value='${temp.desc}'/></td>
	<td><fmt:formatDate pattern="yyyy-MM-dd" value='${temp.createDate}' /></td>
	<td><c:out value='${fn:length(projects[temp.id])}'/></td>
	<%-- 
	<td>
		<a href="${base}/sys/projectModify?tempId=${temp.id}&id=${proj.id}"
		 class="btn btn-primary btn-mini">修改</a>
		<button onclick="return remove(${proj.id})"
		 class="btn btn-primary btn-mini">作废</button>
	</td>
	 --%>
</tr>
</c:forEach>
</table>

<%-- 
<a href="${base}/sys/projectAdd?tempId=${temp.id}" class="btn btn-primary">创建项目实例</a>
 --%>

<hr/>

</div>

</body>
</html>