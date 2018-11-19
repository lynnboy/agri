<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块照片</title>

<script type="text/javascript">
var mode = '${mode}';
function refresh() {
	location.reload();
}
function remove(id){
	confirmx('确认要删除这个照片吗？', function(){
		$.post("${base}${basepath}remove/" + id, function(result,status){
			alertx(result, function(){ refresh(); });
		})
	});
	return false;
}

$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
			代码2: { required: true, pattern: /^\d{3}$/ },
		},
		messages: {
			代码2: { pattern: '请输入3位数字编码' },
		},
		unhighlight: function(el, err, valid) {
			var g = $(el).closest('.control-group');
			g.removeClass('error');
		},
		highlight: function (el, err, valid) {
			$(el).closest('.control-group').addClass('error');
		},
		errorPlacement: function (err, el) {
			if (el.parent().hasClass('input-append')) el = el.siblings().last();
			err.insertAfter(el);
		},
	});
});
</script>
</head>
<body>
	<ul class="nav nav-tabs">
<c:forEach var="act" items="${actions}">
		<li class='<c:if test="${act.active}">active</c:if>'>
			<a href="${base}${act.url}">
			<c:if test="${empty act.icon}"><i class='${act.icon}'>&nbsp;</i></c:if>
				${act.title}</a>
		</li>
</c:forEach>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
<c:if test="${mode != 'view'}">

<form id="inputForm" class="form-horizontal"
 enctype="multipart/form-data"
 action="${base}${basepath}add" method="post">

<h4>上传新照片</h4>
<hr>

		<div class="control-group">
			<div class="controls">
				<input id="file" name="file" type="file" class="required input-xlarge"></input>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label for="拍摄日期" class="control-label">拍摄日期:</label>
			<div class="controls">
				<input id="拍摄日期" name="拍摄日期" type="text"
					class="input-small Wdate" maxlength="50"
					onchange="return $(this).valid();"
					onfocus="WdatePicker(datePickerSettings());">
			</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="上 传" />
		</div>
<br>
</form>
</c:if>

<form id="dummyForm" class="form-horizontal">

<h4>地块照片</h4>
<br>

<c:if test="${empty list}">
<div class="wall">
该地块尚无照片。
</div>
</c:if>
<c:if test="${not empty list}">
              <div id="myCarousel" class="carousel slide">
                <ol class="carousel-indicators">
<c:forEach var="image" varStatus="status" items="${list}">
                  <li data-target="#myCarousel" data-slide-to="${status.index}"
                  <c:if test="${status.first}">class="active"</c:if>
                  ></li>
</c:forEach>
                </ol>
                <div class="carousel-inner">
<c:forEach var="image" varStatus="status" items="${list}">
                  <div class="item<c:if test='${status.first}'> active</c:if>">
                    <img src="${base}${basepath}${image.id}" alt="">
                    <div class="carousel-caption">
<c:if test="${not empty image.拍摄日期}">
                      <p class="pull-left">拍摄日期: ${image.拍摄日期}</p>
</c:if>
<c:if test="${mode != 'view'}">
                      <span class="pull-right">
                      <button class="btn btn-small" onclick="remove('${image.id}'); return false;">
                      <i class="icon-trash"></i> 删除</button></span>
</c:if>
                    </div>
                  </div>
</c:forEach>
                </div>
                <a class="left carousel-control" href="#myCarousel" data-slide="prev">&lsaquo;</a>
                <a class="right carousel-control" href="#myCarousel" data-slide="next">&rsaquo;</a>
              </div>
</c:if>

		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button"
				value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>