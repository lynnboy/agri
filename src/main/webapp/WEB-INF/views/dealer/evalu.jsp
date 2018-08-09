<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="../common/common.jsp"%>
<!DOCTYPE html>
<html style="overflow-x: auto; overflow-y: auto;">
<head>
<title>套餐试算</title>
<%@include file="/WEB-INF/views/common/header.jsp"%>
<style type="text/css">
html, body, table {
	background-color: #f5f5f5;
	width: 100%;
	text-align: center;
}

.form-evalu-heading {
	font-family: Helvetica, Georgia, Arial, sans-serif, 黑体;
	font-size: 36px;
	margin-bottom: 20px;
	color: #0663a2;
}

.form-evalu {
	position: relative;
	text-align: left;
	width: 520px;
	padding: 25px 20px;
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

.form-evalu .control-label {
	font-size: 16px;
	line-height: 23px;
	color: #999;
}

.form-evalu .input-block-level {
	font-size: 16px;
	height: auto;
	margin-bottom: 15px;
	padding: 7px;
	*width: 283px;
	*padding-bottom: 0;
	_padding: 7px 7px 9px 7px;
}

.form-evalu .btn.btn-large {
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

</style>
<script type="text/javascript">
jQuery.validator.prototype.elements = function() {
	var validator = this;
	return $(this.currentForm).find("input, select, textarea")
		.not(":submit, :reset, :image, [disabled]").not(this.settings.ignore)
		.filter(function() {
			if (!this.name && validator.settings.debug && window.console)
			{ console.error("%o has no name assigned", this); }
			return true;
		});
}

jQuery.validator.prototype.elements = function() {
	var validator = this;
	return $(this.currentForm).find("input, select, textarea")
		.not(":submit, :reset, :image, [disabled], [type=hidden]").not(this.settings.ignore)
		.filter(function() {
			if (!this.name && validator.settings.debug && window.console)
			{ console.error("%o has no name assigned", this); }
			return true;
		});
}

$(document).ready(function() {
	var userNums = [ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 150, 200];
	$("#newCustomerCount0 option").remove();
	$("#newCustomerCount2 option").remove();
	$.each(userNums, function(i, num) {
		$("#newCustomerCount0").append($('<option value="' + num + '">'+ num + '</option>'));
		$("#newCustomerCount2").append($('<option value="' + num + '">'+ num + '</option>'));
	});
	$("#tabPanels form").each(function() {
		$(this).validate({
			rules: {
				curCustomerCount: { required: true, digits: true, range: [1, 999]},
				curDueDate: { required: true, dateISO: true },
				newCustomerCount: { required: true, digits: true, range: [0, 999] },
				newSuiteCount: { required: true, digits: true, range: [0, 999] },
				activateDate: { required: true, dateISO: true },
			},
			messages: {
				curCustomerCount: { required: '请填写现有用户数' },
				curDueDate: { required: '请填写服务截止日期' },
				newCustomerCount: { required: '请填写新增用户数' },
				newSuiteCount: { required: '请填写预计要购买的 License 数量' },
				activateDate: { required: '请填写预计生效日期' },
			},
			unhighlight: function(el, err, valid) {
				var g = $(el).closest('.control-group');
				g.removeClass('error');
			},
			highlight: function (el, err, valid) {
				$(el).closest('.control-group').addClass('error');
			},
		});
	});
	$('#ordertypeTabs a:first').tab('show');
});
var issueDateSettings = {
		dateFmt:'yyyy-MM-dd', isShowClear: false,
		minDate: new Date(new Date().valueOf()+1000*3600*24*7).toISOString().substr(0,10), // yyyy-MM-dd, 7天后
		maxDate: '2099-12-31',
};
var dueDateSettings = {
		dateFmt:'yyyy-MM-dd', isShowClear: false,
		minDate: '2010-1-1',
		maxDate: '2099-12-31',
};
function evalu(form) {
	var valid = form.valid();
	if (valid) {
		var data = {
				curCustomerCount: form.find('[name=curCustomerCount]').val(),
				curDueDate: form.find('[name=curDueDate]').val(),
				newCustomerCount: form.find('[name=newCustomerCount]').val(),
				newSuiteCount: form.find('[name=newSuiteCount]').val(),
				activateDate: form.find('[name=activateDate]').val(),
		};
		$.post("${base}/d/evalu", data, function(result, status){
			form.find('[name=totalCustomerCount]').val(result.totalCustomerCount);
			form.find('[name=newDueDate]').val(result.newDueDate);
		}, 'json').error(function(xhr) {
			alertx('发生了错误：' + JSON.parse(xhr.responseText).error);
		});
	}
	return false;
}
</script>
</head>
<body>
	<div style="width: auto;">
		<div class="navbar navbar-fixed-top" id="header">
			<div class="navbar-inner">
				<div class="brand">
					<span id="productName">客户授权管理系统 </span>
				</div>
				<ul class="nav pull-right" id="userControl">
					<li><a title="登录" href="${base}/d/login">登录</a></li>
					<li>&nbsp;</li>
				</ul>
				<div class="nav-collapse">
					<ul class="nav" id="menu" style="float: none;">
						<li class="menu active"><a class="menu"
							href="${base}/d/evalu"><span>套餐试算</span></a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<h1 class="form-evalu-heading">预购买License试算</h1>

	<div class="form-evalu">

	<%@include file="/WEB-INF/views/common/message.jsp"%>

<ul class="nav nav-tabs" id="ordertypeTabs">
  <li><a href="#neworder" data-toggle="tab">新客户下单</a></li>
  <li><a href="#continueorder" data-toggle="tab">老客户延续时间</a></li>
  <li><a href="#changeorder" data-toggle="tab">老客户追加人数</a></li>
</ul>

<div class="tab-content" id="tabPanels">
  <div class="tab-pane active" id="neworder">
		<div class="controls alert alert-info"><span class="icon-info-sign"></span>
		客户第一次购买此服务时，请在这里下单</div>
	<form id="neworderForm" class="form-horizontal"
		action="${base}/d/evalu" >
		<input name="curCustomerCount" value="" type="hidden"/>
		<input name="curDueDate" value="" type="hidden"/>

		<div class="control-group">
			<label for="newCustomerCount0" class="control-label">用户数:</label>
			<div class="controls">
				<select id="newCustomerCount0" name="newCustomerCount" ></select>
			</div>
		</div>
		<div class="control-group">
			<label for="newSuiteCount0" class="control-label">预购买License数:</label>
			<div class="controls">
				<input id="newSuiteCount0" name="newSuiteCount"
					class="required" type="number" maxlength="3" min="1" max="999"
					value="1" />
			</div>
		</div>
		<div class="control-group">
			<label for="activateDate0" class="control-label">预计生效日期:</label>
			<div class="controls">
				<input id="activateDate0" name="activateDate" type="text" readonly="readonly"
					maxlength="20" class="input-small Wdate"
					onclick="WdatePicker($.extend({},issueDateSettings));" />
			</div>
		</div>
		<div class="control-group">
			<div style="text-align: right;">
				<input id="btnSubmit0" class="btn btn-large btn-primary"
					onclick="return evalu($('#neworderForm'));"
					type="button" value="估  算" style="width: 180px;" />
			</div>
		</div>
		<div class="control-group">
			<label for="totalCustomerCount0" class="control-label">用户数:</label>
			<div class="controls">
				<input id="totalCustomerCount0" name="totalCustomerCount" readonly="readonly"
					class="" type="text" maxlength="100" />
			</div>
		</div>
		<div class="control-group">
			<label for="newDueDate0" class="control-label">预计服务截止时间:</label>
			<div class="controls">
				<input id="newDueDate0" name="newDueDate" readonly="readonly" type="text"
					maxlength="100" />
			</div>
		</div>
</form>
  </div>
  <div class="tab-pane" id="continueorder">
		<div class="controls alert alert-info"><span class="icon-info-sign"></span>
		正在使用的客户，在有效期结束后希望继续使用此服务的，请在这里下单
		<br>
		<span class="icon-info-sign"></span> 请通过NTWare网站查询用户数和服务截止日期</div>
	<form id="continueorderForm" class="form-horizontal"
		action="${base}/d/evalu" >
		<input name="newCustomerCount" value="" type="hidden"/>
		<input name="activateDate" value="" type="hidden"/>

		<div class="control-group">
			<label for="curCustomerCount1" class="control-label">当前用户数:</label>
			<div class="controls">
				<input id="curCustomerCount1" name="curCustomerCount"
					class="userName" type="number" maxlength="6" />
			</div>
		</div>
		<div class="control-group">
			<label for="curDueDate1" class="control-label">当前服务截止日期:</label>
			<div class="controls">
				<input id="curDueDate1" name="curDueDate" type="text" readonly="readonly"
					maxlength="20" class="input-small Wdate"
					onclick="WdatePicker($.extend({},dueDateSettings));" />
			</div>
		</div>
		<div class="control-group">
			<label for="newSuiteCount1" class="control-label">预购买License数:</label>
			<div class="controls">
				<input id="newSuiteCount1" name="newSuiteCount"
					class="required" type="number" maxlength="3" min="1" max="999"
					value="1" />
			</div>
		</div>
		<div class="control-group">
			<div style="text-align: right;">
				<input id="btnSubmit1" class="btn btn-large btn-primary"
					onclick="return evalu($('#continueorderForm'));"
					type="button" value="估  算" style="width: 180px;" />
			</div>
		</div>
		<div class="control-group">
			<label for="totalCustomerCount1" class="control-label">用户数:</label>
			<div class="controls">
				<input id="totalCustomerCount1" name="totalCustomerCount" readonly="readonly"
					class="" type="text" maxlength="100" />
			</div>
		</div>
		<div class="control-group">
			<label for="newDueDate1" class="control-label">预计服务截止时间:</label>
			<div class="controls">
				<input id="newDueDate1" name="newDueDate" readonly="readonly" type="text"
					maxlength="100" />
			</div>
		</div>
</form>
  </div>
  <div class="tab-pane" id="changeorder">
		<div class="controls alert alert-info"><span class="icon-info-sign"></span>
		正在使用的客户，希望增加用户数时，请在这里下单
		<br>
		<span class="icon-info-sign"></span> 请通过NTWare网站查询用户数和服务截止日期
		</div>
	<form id="changeorderForm" class="form-horizontal"
		action="${base}/d/evalu" >

		<div class="control-group">
			<label for="curCustomerCount2" class="control-label">当前用户数:</label>
			<div class="controls">
				<input id="curCustomerCount2" name="curCustomerCount"
					class='required' type="number" maxlength="6" min='1' max='999'/>
			</div>
		</div>
		<div class="control-group">
			<label for="curDueDate2" class="control-label">当前服务截止日期:</label>
			<div class="controls">
				<input id="curDueDate2" name="curDueDate" type="text" readonly="readonly"
					maxlength="20" class="input-small Wdate"
					onclick="WdatePicker($.extend({},dueDateSettings));" />
			</div>
		</div>
		<div class="control-group">
			<label for="newCustomerCount2" class="control-label">新增用户数:</label>
			<div class="controls">
				<select id="newCustomerCount2" name="newCustomerCount" ></select>
			</div>
		</div>
		<div class="control-group">
			<label for="newSuiteCount2" class="control-label">预购买License数:</label>
			<div class="controls">
				<input id="newSuiteCount2" name="newSuiteCount"
					class="required" type="number" maxlength="3" min="1" max="999"
					value="1" />
			</div>
		</div>
		<div class="control-group">
			<label for="activateDate2" class="control-label">预计生效日期:</label>
			<div class="controls">
				<input id="activateDate2" name="activateDate" type="text" readonly="readonly"
					maxlength="20" class="input-small Wdate"
					onclick="WdatePicker($.extend({},issueDateSettings));" />
			</div>
		</div>
		<div class="control-group">
			<div style="text-align: right;">
				<input id="btnSubmit2" class="btn btn-large btn-primary"
					onclick="return evalu($('#changeorderForm'));"
					type="button" value="估  算" style="width: 180px;" />
			</div>
		</div>
		<div class="control-group">
			<label for="totalCustomerCount2" class="control-label">新用户数:</label>
			<div class="controls">
				<input id="totalCustomerCount2" name="totalCustomerCount" readonly="readonly"
					class="" type="text" maxlength="100" />
			</div>
		</div>
		<div class="control-group">
			<label for="newDueDate2" class="control-label">预计服务截止时间:</label>
			<div class="controls">
				<input id="newDueDate2" name="newDueDate" readonly="readonly" type="text"
					maxlength="100" />
			</div>
		</div>
</form>
  </div>
</div>

	</div>

	<div class="footer" style="text-align: center">
		Copyright &copy; 2017-2018 <a href="/">客户授权管理系统</a>
	</div>

</body>
</html>