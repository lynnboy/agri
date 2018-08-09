<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>订单申请</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
var numkey = 1;
function addRow(list){
	var  licCodeTpl = $("#licCodeTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"").replace(/@i@/,numkey);
	var row = $(list).append(Mustache.render(licCodeTpl));
	$(list).find("[name^=code_]").each(function(){
		$(this).rules("add", { required: true, licenseCode: true,
			messages: { required: '请填写 License Code' } });
	});
	numkey++;
}
function delRow(obj){
	var g = $(obj).closest('.control-group');
	$(obj).parent().remove();
	g.find("input").each(function() { $(this).valid(); });
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
	$("#userNum0 option").remove();
	$("#userNum2 option").remove();
	$.each(userNums, function(i, num) {
		$("#userNum0").append($('<option value="' + num + '">'+ num + '</option>'));
		$("#userNum2").append($('<option value="' + num + '">'+ num + '</option>'));
	});
	
	$("#inputForm").validate({
		rules: {
			customerName: 'required',
			code_0: { required: true, licenseCode: true },
			userNum: { required: true, digits: true, range:[1,999] },
			issueDate: { required: true, dateISO: true },
			userAddNum: { required: true, digits: true, range:[1,999] },
			issueDateForChange: { required: true, dateISO: true },
		},
		ignore: ".ignore",
		messages: {
			customerName: '请选择客户',
			code_0: { required: '请填写 License Code', },
			userNum: { required: '请填写新增用户数' },
			issueDate: { required: "请选择预计生效时间" },
			userAddNum: { required: '请填写新增用户数' },
			issueDateForChange: { required: "请选择预计生效时间" },
		},
		//errorClass: "error",
		//success: function(label) { var el = $(label).closest('.control-group').removeClass('error').addClass('success'); },
		//success: "success",
		unhighlight: function(el, err, valid) {
			//$(el).tooltip('destroy');
			var g = $(el).closest('.control-group');
			var inputs = g.find("input[name^=code_]");
			for (var i = 0; i < inputs.length; i++) if (!isValidLicenseCode(inputs[i].value)) return;
			g.removeClass('error');
		},
		highlight: function (el, err, valid) {
			$(el).closest('.control-group').addClass('error');
		},
		errorPlacement: function (err, el) {
			if (el.parent().hasClass('input-append')) el = el.siblings().last();
			err.insertAfter(el);
		//	if ($(el).next("div").hasClass('tooltip')) {
		//		$(el).attr('data-original-title', $(err).text()).tooltip("show");
		//	} else {
		//		$(el).attr('title', $(err).text()).tooltip("show");
		//	}
		},
		//submitHandler: function(form) {},
	});
	$("#ordertypeTabs a").on('shown', function(e) {
		$(e.target.getAttribute('href')).find("input").removeClass('ignore');
		if (e.relatedTarget) $(e.relatedTarget.getAttribute('href')).find("input").addClass('ignore');
	});
	$('#ordertypeTabs a:first').tab('show');
});
function orderCreate() {
	var valid = $("#inputForm").valid();
	if (valid) confirmx('请您务必确认输入信息正确有效。', function() {
		var codes = $.map($('[name^=code_]'), function(e) { return e.value; });
		$('#code').val(codes.join(','));
		var active = $('#tabPanels .tab-pane.active');
		$('#hiddenUserAddNum').val(active.find('[id^=userNum]').val());
		$('#hiddenUsedDate').val(active.find('[id^=issueDate]').val());
		$("#inputForm").submit();
	});
	return false;
}
var datePickerSettings0 = {
		dateFmt:'yyyy-MM-dd', isShowClear: false,
		minDate: new Date(new Date().valueOf()+1000*3600*24*7).toISOString().substr(0,10), // yyyy-MM-dd, 7天后
		maxDate: '2099-12-31',
};
var datePickerSettings2 = {
		dateFmt:'yyyy-MM-dd', isShowClear: false,
		minDate: new Date(new Date().valueOf()+1000*3600*24*7).toISOString().substr(0,10), // yyyy-MM-dd, 7天后
		maxDate: '2099-12-31',
};
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/dealer/orderList">订单列表</a></li>
		<li class="active"><a href="${base}/dealer/orderCreate">订单申请</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/dealer/orderCreate" method="post">
		<input id="hiddenUserAddNum" name="userAddNum" type="hidden" />
		<input id="hiddenUsedDate" name="usedDate" type="hidden" />

		<div class="control-group">
			<label class="control-label" for="customerButton">客户名称:</label>
			<div class="controls">
				<input name="customerId" id="customerId" type="hidden">
				<div class="input-append">
					<input name="customerName" class="required" id="customerName" type="text" readonly="readonly"
						placeholder="请选择客户" data-msg-required="">
					<a class="btn" id="customerButton" href="javascript:">&nbsp;<span class="icon-search"></span>&nbsp;</a>
				</div>
				<script type="text/javascript">
					$("#customerButton").click(function(){
					top.$.jBox.open("iframe:${base}/dealer/customerSelectList", "选择客户",$(top.document).width()-220,$(top.document).height()-200,{
						id:"customerSelectDialog",
						buttons:{}, 
						loaded:function(h){
							$(".jbox-content", top.document).css("overflow-y","hidden");
							h.find("iframe")[0].contentWindow.choose = function(customer) {
								$("#customerId").val(customer.id);
								$("#tenantId").val(customer.tenantId); $("#tenantId").attr('placeholder', '尚无客户ID');
								$("#customerName").val(customer.name);
								$("#customerName").valid();
								top.$.jBox.close("customerSelectDialog");
							};
						}
					});
				});
				</script>
			</div>
		</div>
		<div class="control-group">
			<label for="tenantId" class="control-label">客户ID:</label>
			<div class="controls">
				<input id="tenantId" name="tenantId" placeholder="请选择客户" value="" maxlength="50"
					class="required" type="text" disabled="disabled" /> 
			</div>
		</div>

<div class="controls">
<ul class="nav nav-pills" id="ordertypeTabs">
  <li><a href="#neworder" data-toggle="pill">新客户下单</a></li>
  <li><a href="#continueorder" data-toggle="pill">老客户延续时间</a></li>
  <li><a href="#changeorder" data-toggle="pill">老客户追加人数</a></li>
</ul>
</div>
<div class="tab-content" id="tabPanels">
  <div class="tab-pane active" id="neworder">
		<div class="controls alert alert-info"><span class="icon-info-sign"></span>
		客户第一次购买此服务时，请在这里下单</div>
		<div class="control-group">
			<label for="userNum0" class="control-label">用户数:</label>
			<div class="controls">
			<%-- 
				<input id="userNum0" name="userNum" class="required ignore" type="number"
					min="1" max="999" value="1" maxlength="3" /> <span
					class="help-inline"><font color="red">*</font> </span>
			 --%>
			 <select id="userNum0" name="userNum" class="required ignore"></select>
			</div>
		</div>
		<div class="control-group">
			<label for="issueDate0" class="control-label">预计生效时间:</label>
			<div class="controls">
				<input id="issueDate0" name="issueDate" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value=""
					onchange="return $(this).valid();" onclick="WdatePicker(datePickerSettings0);"
					onfocus="WdatePicker(datePickerSettings0);" />
			</div>
			<p>
			<div class="controls alert alert-info"><span class="icon-info-sign"></span> 开通服务预计需要1周时间（自然日），请选择一周后的时间。</div>
		</div>
  </div>
  <div class="tab-pane" id="continueorder">
		<div class="controls alert alert-info"><span class="icon-info-sign"></span>
		正在使用的客户，在有效期结束后希望继续使用此服务的，请在这里下单</div>
		<input id="userNum1" value="0" type="hidden"/>
		<input id="issueDate1" value="" type="hidden"/>
		<hr/>
  </div>
  <div class="tab-pane" id="changeorder">
		<div class="controls alert alert-info"><span class="icon-info-sign"></span>
		正在使用的客户，希望增加用户数时，请在这里下单</div>
		<div class="control-group">
			<label for="userNum2" class="control-label">新增用户数:</label>
			<div class="controls">
			<%-- 
				<input id="userNum2" name="userAddNum" class="required ignore" type="number"
					min="1" max="999" value="1" maxlength="3" /> <span
					class="help-inline"><font color="red">*</font> </span>
			 --%>
			 <select id="userNum2" name="userAddNum" class="required ignore"></select>
			</div>
		</div>
		<div class="control-group">
			<label for="issueDate2" class="control-label">预计生效时间:</label>
			<div class="controls">
				<input id="issueDate2" name="issueDateForChange" type="text" readonly="readonly"
					maxlength="20" class="ignore input-small Wdate" value=""
					onchange="return $(this).valid();" onclick="WdatePicker(datePickerSettings2);"
					onfocus="WdatePicker(datePickerSettings2);" />
			</div>
			<p>
			<div class="controls alert alert-info"><span class="icon-info-sign"></span> 开通服务预计需要1周时间（自然日），请选择一周后的时间。</div>
		</div>
  </div>
</div>
		<div class="control-group">
			<input id="code" name="code" type="hidden" value=""/>
			<label for="code_0" class="control-label">License Code:</label>
			<div class="controls">
				 <div id="codeList" style="">
				     <div class="codewrap" style="margin:1px">
					     <input id="code_0" name="code_0" class="input-xlarge required" type="text" value="" style="ime-mode:disabled" maxlength="29" />
				     </div>
				 </div>
			     <script type="text/template" id="licCodeTpl">//<!--
						  <div class="codewrap input-append" id="divCodeList"style="margin:1px">
							<input name="code_@i@" class="input-xlarge required" type="text" value="" style="ime-mode:disabled" maxlength="29" /> 
							<a class="btn" href="javascript:;" onclick="delRow(this)"><span title="删除" class="close icon-remove-sign"></span></a>
						  </div>//-->
				 </script>
				 <a class="btn" title="添加" id="codeButton" href="javascript:" onclick="addRow('#codeList')"><span class="close icon-plus-sign"></span></a>
			</div>
		</div>
		<div class="control-group">
			<label for="remark" class="control-label">备注:</label>
			<div class="controls">
					<textarea id="remark" name="remark" maxlength="200"
					class="input-xlarge" rows="3"></textarea>
			</div>
		</div>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				onclick="return orderCreate();"
				value="提  交" />&nbsp; <input id="btnCancel" class="btn"
				type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>