<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>项目列表</title>
<script type="text/javascript">
$(document).ready(function() {
});
function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
function search(){
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
		<li class="active"><a href="${base}/sys/projList">项目列表</a></li>
	</ul>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<div class="container-fluid">

<c:forEach items='${templates}' var='temp'>

<h3><i class="icon-list-alt"></i> <c:out value='${temp.name}'/>
<small>版本  <c:out value='${temp.version}' /></small>
</h3>

<p>工作流程：
<c:forEach items='${temp.projectInfo.workflow}' var='flow'>
	<span class="label label-info"><c:out value='${temp.projectInfo.stateMap[flow.srcState].name}'/></span>
	<span class="label label-success"><c:out value='${temp.projectInfo.taskMap[flow.action].name}'/><span class="icon-arrow-right"></span></span>
</c:forEach>
</p>

<table class="table table-bordered">
<tr>
	<th>项目实例</th>
	<th>说明</th>
	<th>创建日期</th>
	<th>操作</th>
</tr>
<c:forEach items='${projects[temp.id]}' var='proj'>
<tr>
	<td><i class="icon-list-alt"></i> <c:out value='${proj.name}'/></td>
	<td><c:out value='${proj.desc}'/></td>
	<td><fmt:formatDate pattern="yyyy-MM-dd" value='${proj.createDate}' /></td>
	<td>
		<a href="${base}/sys/projectModify?tempId=${temp.id}&id=${proj.id}"
		 class="btn btn-primary btn-mini">修改</a>
		<button onclick="return remove(${proj.id})"
		 class="btn btn-primary btn-mini">作废</button>
	</td>
</tr>
</c:forEach>
</table>

<a href="${base}/sys/projectAdd?tempId=${temp.id}" class="btn btn-primary">创建项目实例</a>

<hr/>

</c:forEach>

</div>

</body>
</html>