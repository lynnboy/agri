<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>授权码创建</title>
<meta name="decorator" content="default" />
	<script type="text/javascript">
		$(document).ready(function() {
			$("#inputForm").validate({
				rules: {
					count: { required: true, digits: true, range: [1,1000] },
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

		function save(filename, data, type) {
		    if (navigator.msSaveBlob) {
		        var blob = new Blob([data], {type:type});
				navigator.msSaveBlob(blob, filename);
		    } else if (window.URL && URL.createObjectURL) {
		        var a = document.createElement('a');
		        var blob = new Blob([data], {type:type});
		        a.href = URL.createObjectURL(blob);
		        a.download = filename;
		        document.body.appendChild(a);
		        a.click();
		        document.body.removeChild(a);
		        URL.revokeObjectURL(a.href);
		    } else {
				w = window.open('about:blank');
				w.document.write(data);
		    }
		}
		function create(){
			$("#inputForm").validate().form() &&
			$.post("${base}/sys/licenseCreate", {
					serviceProvider: $("#serviceProvider").val(),
					serviceType: $("#serviceType").val(),
					suiteType: $("#suiteType").val(),
					count: $("#count").val(),
				}, function(result,status){
					return save('keylist.txt', result, 'text/plain;charset=utf8');
				});
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/sys/licenseList">授权码列表</a></li>
		<li class="active"><a href="${base}/sys/licenseCreate">授权码创建</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/licenseCreate" method="post" target="_blank">
		<input id="id" name="id" type="hidden" value="" />

		<div class="control-group">
			<label for="serviceProvider" class="control-label">服务提供商:</label>
			<div class="controls">
				<select id="serviceProvider" name="serviceProvider" class="input-xlarge">
					<option value="0">请选择</option>
					<option value="1" selected="selected">NTWare</option>
				</select>
			</div>
		</div>

		<div class="control-group">
			<label for="serviceType" class="control-label">服务类型:</label>
			<div class="controls">
				<select id="serviceType" name="serviceType" class="input-xlarge">
					<option value="0">请选择</option>
					<option value="1" selected="selected">uniFlow</option>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label for="suiteType" class="control-label">授权码套餐:</label>
			<div class="controls">
				<select id="suiteType" name="suiteType" class="input-xlarge">
					<option value="0" >请选择</option>
					<option value="1" selected="selected">120人月</option>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label for="count" class="control-label">创建数量:</label>
			<div class="controls">
				<input id="count" name="count" class="required" type="number" value="1"
					maxlength="3" /> <span class="help-inline"><font
					color="red">*</font> </span>
			</div>
		</div>
		<div class="form-actions">
		<!-- 
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="创  建" />&nbsp;
		 -->
			<a class="btn btn-primary" onclick="return create();" href="javascript:;">创 建</a>&nbsp;
			<input id="btnCancel" class="btn" type="button" value="取  消" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>