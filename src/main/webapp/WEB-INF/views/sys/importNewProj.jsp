<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>作为新项目导入</title>

<script type="text/javascript">
$(document).ready(function() {
});
</script>
</head>
<body>

<div class="container-fluid">

<%@include file="/WEB-INF/views/common/message.jsp"%>

	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/${action}" method="post">
		
		<div><br></div>
		<div class="control-group">
			<label for="name" class="control-label">文件名:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="北京市调查数据2016.zip"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">数据包版本:</label>
			<div class="controls">
				<input id="ver" class="readonly" type="text" readonly="readonly"
				 value="viewdb-1.0.0"/>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">项目名称:</label>
			<div class="controls">
				<input id="name" name="name" class="required" type="text" value="${dealer.name }"
					maxlength="50" /> <span class="help-inline"><font
					color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="organId" class="control-label">项目模板:</label>
			<div class="controls">
				<select id="organId" name="organId" class="required">
				<option value="" selected="selected">面源污染数据库 [viewdb-1.0.0]</option>
				</select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">内容:</label>
			<div class="controls">
				<div class="well well-small">
				<ul>
					<li><i class="icon-book"></i> 数据表: <strong>entry</strong> 数据项: 3</li>
					<li><i class="icon-book"></i> 数据表: <strong>diagram</strong> 数据项: 1</li>
					<li><i class="icon-book"></i> 数据表: <strong>模式面积</strong> 数据项: 81</li>
					<li><i class="icon-book"></i> 数据表: <strong>地块施肥</strong> 数据项: 977</li>
					<li><i class="icon-file"></i> 文件: 1</li>
				</ul>
				</div>
			</div>
		</div>
		<div class="control-group">
			<label for="name" class="control-label">人员和组织信息:</label>
			<div class="controls">
			<label class="checkbox"><input type="checkbox" name="merge">根据 <strong>组织</strong> 和 <strong>人员</strong> 的名字进行识别和数据合并</label>
			<span class="help-block">如果找到了匹配的 <strong>常规人员</strong>（非导入人员），则将相关数据项归入这个人员名下。</span>
			</div>
		</div>
		<div class="control-group">
			<label for="remarks" class="control-label">备注:</label>
			<div class="controls">
				<textarea id="remarks" name="remarks" maxlength="200"
					class="input-xlarge" rows="3">${dealer.remarks}</textarea>
			</div>
		</div>

		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="创 建" />&nbsp; <input id="btnCancel" class="btn" type="button"
				value="取 消" onclick="history.go(-1)" />
		</div>
	</form>

</div>

</body>
</html>