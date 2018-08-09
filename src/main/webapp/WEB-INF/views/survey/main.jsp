<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<title>农业面源污染监测系统</title>
<%@include file="/WEB-INF/views/common/header.jsp"%>
<script type="text/javascript">
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
					<span id="productName">农业面源污染调查系统 </span>
				</div>
				<ul class="nav pull-right" id="userControl">
					<li class="dropdown" id="userInfo"><a title="个人信息"
						class="dropdown-toggle" aria-expanded="true" href="#"
						data-toggle="dropdown">您好, <c:out value="${manager.name}" />&nbsp;
					</a></li>
					<li><a title="退出登录" href="${base}/s/logout">退出</a></li>
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
				<div id="left" style="width: 160px; height: 401px;">
					<div class="accordion" id="menu-left">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" href="#group1">
									<i class="icon-edit"></i> 填报 <i class="icon-chevron-right pull-right"></i></a>
							</div>
							<div class="accordion-body in collapse"
								aria-expanded="false">
								<div class="accordion-inner">
									<ul class="nav nav-list">
										<li class="active"><a href="${base}/survey/list1"
											target="mainFrame"><i class="icon-list-alt"></i> 种植业清查2017</a>
										</li>
										<li class="active"><a href="${base}/survey/list2"
											target="mainFrame"><i class="icon-list-alt"></i> test</a>
										</li>
										<li class="active"><a href="${base}/survey/list2"
											target="mainFrame"><i class="icon-list-alt"></i> 典型地块调查2017</a>
										</li>
										<li class="active"><a href="${base}/survey/list3"
											target="mainFrame"><i class="icon-list-alt"></i> 典型畜禽调查2017</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" href="#group2">
									<i class="icon-edit"></i> 审核 <i class="icon-chevron-right pull-right"></i></a>
							</div>
							<div class="accordion-body in collapse"
								aria-expanded="false">
								<div class="accordion-inner">
									<ul class="nav nav-list">
										<li class="active"><a href="${base}/survey/list11"
											target="mainFrame"><i class="icon-list-alt"></i> 种植业清查2017</a>
										</li>
										<li class="active"><a href="${base}/survey/list21"
											target="mainFrame"><i class="icon-list-alt"></i> test</a>
										</li>
										<li class="active"><a href="${base}/survey/list21"
											target="mainFrame"><i class="icon-list-alt"></i> 典型地块调查2017</a>
										</li>
										<li class="active"><a href="${base}/survey/list31"
											target="mainFrame"><i class="icon-list-alt"></i> 典型畜禽调查2017</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" href="#group3">
									<i class="icon-edit"></i> 汇总 <i class="icon-chevron-right pull-right"></i></a>
							</div>
							<div class="accordion-body in collapse"
								aria-expanded="false">
								<div class="accordion-inner">
									<ul class="nav nav-list">
										<li class="active"><a href="${base}/survey/list13"
											target="mainFrame"><i class="icon-list-alt"></i> 种植业清查2017</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="openClose">&nbsp;</div>
				<div id="right" style="width: 1648px; height: 401px;">
					<iframe name="mainFrame" width="100%" height="650" id="mainFrame"
						src="" frameborder="no" scrolling="yes"
						style="height: 401px; overflow: visible;"></iframe>
				</div>
			</div>
			<div class="row-fluid" id="footer">Copyright © 2017-2018
				农业面源污染监测系统</div>
		</div>
	</div>
	<script type="text/javascript">
		var leftWidth = 160; // 左侧窗口大小
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
