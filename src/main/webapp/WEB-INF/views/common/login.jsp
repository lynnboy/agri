<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<title>${systemName }</title>
<%@include file="/WEB-INF/views/common/header.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#userName").focus();
		// 更换验证码
		$("#image,#change").click(function() {
			$("#image").attr("src", "${base}/servlet/validateCode?time=" + new Date().getTime());
		});
	});
</script>
<style type="text/css">
html, body, table {
	background-color: #f5f5f5;
	width: 100%;
	text-align: center;
}

body { background: url("./static/img/field1.jpg") no-repeat;
 background-size: 100%
}

.form-signin-heading {
	font-family: Helvetica, Georgia, Arial, sans-serif, 黑体;
	font-size: 36px;
	margin-bottom: 20px;
	color: #0663a2;
}

.form-signin {
	position: relative;
	text-align: left;
	width: 300px;
	padding: 25px 29px 29px;
	margin: 0 auto 20px;
	background-color: #fff;
	border: 1px solid #e5e5e5;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	-moz-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
}

.form-signin .checkbox {
	margin-bottom: 10px;
	color: #0663a2;
}

.form-signin .input-label {
	font-size: 16px;
	line-height: 23px;
	color: #999;
}

.form-signin .input-block-level {
	font-size: 16px;
	height: auto;
	margin-bottom: 15px;
	padding: 7px;
	*width: 283px;
	*padding-bottom: 0;
	_padding: 7px 7px 9px 7px;
}

.form-signin .btn.btn-large {
	font-size: 16px;
}

.form-signin div.validateCode {
	padding-bottom: 15px;
}

.mid {
	vertical-align: middle;
}

.header {
	height: 80px;
	padding-top: 20px;
}

.alert {
	position: relative;
	width: 300px;
	margin: 0 auto;
	*padding-bottom: 0px;
}

label.error {
	background: none;
	width: 270px;
	font-weight: normal;
	color: inherit;
	margin: 0;
}
</style>
</head>
<body>
	<div style="width: auto;">
		<div class="navbar navbar-fixed-top" id="header">
			<div class="navbar-inner">
				<div class="brand">
					<span id="productName">${systemName}</span>
				</div>
				<!-- 
				<ul class="nav pull-right" id="userControl">
					<li><a title="登录" href="${base}/s/login">登录</a></li>
					<li>&nbsp;</li>
				</ul>
				<div class="nav-collapse">
					<ul class="nav" id="menu" style="float: none;">
						<li class="menu active"><a class="menu" href="${base}/d/evalu"><span>套餐试算</span></a></li>
					</ul>
				</div>
				 -->
			</div>
		</div>
	</div>
	<div class="header">
		<div id="messageBox" class="alert alert-error hide">
			<button data-dismiss="alert" class="close">×</button>
			<label id="loginError" class="error"></label>
		</div>
	</div>
	<h1 class="form-signin-heading">登录</h1>
	<form id="loginForm" class="form-signin" action="${base}/login"
		method="POST">
		<input name="token" id="token" value="${token}" type="hidden">
		<label class="input-label" for="userName">登录名</label>
			<input id="userName" name="userName" class="input-block-level required"
			autocomplete="off" type="text" style="ime-mode:disabled"
			value="<c:out value="${params.userName}" escapeXml="true"/>" />
		<label class="input-label" for="password">密码</label>
			<input id="password" name="password" class="input-block-level required"
			value="${params.password}" autocomplete="off" type="password"/>
		<label class="input-label" for="validateCode">验证码</label>
		<div>
			<input id="validateCode" name="validateCode"
				class="input-block-level required" autocomplete="off"
				type="text" maxlength="4" style="width: 170px" />
			<img id="image" src="${base}/servlet/validateCode" />
			<a href="#" id="change">看不清？</a>
		</div>
		<label>
		<input id="isAdmin" name="isAdmin" type="checkbox"
			<c:if test="${params.isAdmin}">checked</c:if> />
		管理员
		</label>
		<div id="errorMsg" style="color: red">
			<c:out value="${msg}" escapeXml="true" />
		</div>
		<button type="submit" id="buttonOk" class="btn btn-large btn-primary"
			style="width: 300px; margin-top: 20px">
			登 录
		</button>

	</form>
	<div class="footer">
		Copyright &copy; 2017-2018 <a href="/">${systemName}</a>
	</div>
</body>
</html>