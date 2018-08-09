<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8"%>
	<div class="pagination pagination-small pagination-centered">
		<ul>
<c:forEach items='${pager.pages}' var='p'>
<c:choose>
	<c:when test="${p == 0}">
			<li class="disabled"><span>...</span></li>
	</c:when>
	<c:when test="${p == pager.pageNo}">
			<li class="active"><a href="javascript:">${p}</a></li>
	</c:when>
	<c:otherwise>
			<li class=""><a href="javascript:" onclick="pageTo(${p})">${p}</a></li>
	</c:otherwise>
</c:choose>
</c:forEach>
			<li class="disabled controls"><span>第 <input
					onkeypress="var e=window.event||event;var c=e.keyCode||e.which;if(c==13)pageTo(parseInt(this.value)||1);"
					onclick="this.select();" type="text" value="${pager.pageNo}"> / ${pager.pageCount} 页
					
			</span></li>
			<li><span>第 ${pager.firstNo} - ${pager.lastNo} 条，共 ${pager.queryCount}/${pager.totalCount} 条</span></li>

<!-- 
			<li class="disabled controls"><span>每页</span></li>
<c:forEach items='${pager.pageSizes}' var='size'>
<c:choose>
	<c:when test="${pager.pageSize == size}">
			<li class="active"><a href="javascript:">${size}</a></li>
	</c:when>
	<c:otherwise>
			<li class=""><a href="javascript:" onclick="pageBy(${size})">${size}</a></li>
	</c:otherwise>
</c:choose>
</c:forEach>
 -->
		</ul>
		<div style="clear: both;"></div>
	</div>
