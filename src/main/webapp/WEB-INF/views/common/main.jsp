<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<title>${systemName}</title>
<%@include file="/WEB-INF/views/common/header.jsp"%>
<script type="text/javascript">
function showaccount() {
	$.jBox.open("iframe:${base}/account","个人信息",
			$(top.document).width()-220,$(top.document).height()-200,{
		});
}

$(document).ready(function() {
	$("#menu-left .nav-list a").click(function() {
		$("#menu-left .nav-list li").removeClass("active");
		$(this).parent().addClass("active");
	});
	$("#menu-left .nav-list li:first a:first i").click();
});
</script>
</head>
<body>
	<div id="main" style="width: auto;">
		<div class="navbar navbar-fixed-top" id="header">
			<div class="navbar-inner">
				<div class="brand">
					<span id="productName">${systemName}</span>
				</div>
				<ul class="nav pull-right" id="userControl">
					<li class="dropdown" id="userInfo"><a title="个人信息"
						class="dropdown-toggle" aria-expanded="true" href="#"
						onclick="showaccount()"
						data-toggle="dropdown">您好, <c:out value="${user.name}" />&nbsp;
					</a></li>
					<li><a title="退出登录" href="${base}/logout">退出</a></li>
					<li>&nbsp;</li>
				</ul>
<!-- 
				<div class="nav-collapse">
					<ul class="nav" id="menu" style="float: none;">
						<li class="menu active"><a class="menu"
							href="${base}/d/evalu" target="_blank"><span>套餐试算</span></a></li>
					</ul>
				</div>
 -->
			</div>
		</div>
		<div class="container-fluid">
			<div class="row-fluid" id="content">
				<div id="left" style="width: 200px; height: 401px;">
					<div class="accordion" id="menu-left">

<c:forEach var="entry" items='${menuList}'>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" href="#grp_${entry.key}">
									${entry.key} <i class="icon-chevron-right pull-right"></i></a>
							</div>
							<div id="grp_${entry.key}" class="accordion-body in collapse">
								<div class="accordion-inner">
									<ul class="nav nav-list">
	<c:forEach var="proj_action" items='${entry.value}'>
	<c:set var="proj" value="${projMap[proj_action.key]}"/>
	<c:set var="actId" value="${proj_action.value}"/>
	<c:set var="temp" value="${tempMap[proj.tempId]}"/>
										<li><a href="${base}${temp.mapRoot}/${proj.id}/${actId}"
											target="mainFrame"><i class="icon-user"></i>&nbsp;${proj.name}</a>
										</li>
	</c:forEach>
									</ul>
								</div>
							</div>
						</div>
</c:forEach>

					</div>
				</div>
				<div id="openClose" class="close">&nbsp;</div>
				<div id="right" style="width: 1608px; height: 401px;">
					<iframe name="mainFrame" width="100%" height="650" id="mainFrame"
						src="" frameborder="no" scrolling="yes"
						style="height: 401px; overflow: visible;"></iframe>
				</div>
			</div>
			<div class="row-fluid" id="footer">Copyright © 2017-2018 ${systemName}</div>
		</div>
	</div>
	<script type="text/javascript">
		var leftWidth = 200; // 左侧窗口大小
		var tabTitleHeight = 33; // 页签的高度
		var htmlObj = $("html"), mainObj = $("#main");
		var headerObj = $("#header"), footerObj = $("#footer");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize() {
			var minHeight = 500, minWidth = 980;
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({
				"overflow-x" : strs[1] < minWidth ? "auto" : "hidden",
				"overflow-y" : strs[0] < minHeight ? "auto" : "hidden"
			});
			mainObj.css("width", strs[1] < minWidth ? minWidth - 10 : "auto");
			frameObj.height((strs[0] < minHeight ? minHeight : strs[0])
					- headerObj.height() - footerObj.height()
					- (strs[1] < minWidth ? 42 : 28));
			$("#openClose").height($("#openClose").height() - 5);// 
			wSizeWidth();
		}
		function wSizeWidth() {
			if (!$("#openClose").is(":hidden")) {
				var leftWidth = ($("#left").width() < 0 ? 0 : $("#left")
						.width());
				$("#right").width(
						$("#content").width() - leftWidth
								- $("#openClose").width() - 5);
			} else {
				$("#right").width("100%");
			}
		}
	</script>
	<script src="${baseStatic}/js/wsize.min.js" type="text/javascript"></script>

</body>
</html>
