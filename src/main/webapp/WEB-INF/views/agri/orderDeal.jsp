<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>订单处理</title>

</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/sys/orderList">订单列表</a></li>
		<li class="active"><a href="${base}/sys/orderDeal?id=${order.id}">订单处理</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>
	<form id="inputForm" class="form-horizontal"
		action="${base}/sys/order" method="post">
		<input id="id" name="id" type="hidden" value="${order.id}" />

		<div class="control-group">
			<label class="control-label">客户名称:</label>
			<div class="controls">
				<div class="input-append">
					<input name="customerId" class="required" id="customerId" type="hidden" value="${customer.id}">
					<input name="customerName" class="required" id="customerName" type="text" readonly="readonly"
						value="${customer.name}" data-msg-required="">
				</div>
			</div>
		</div>
		<div class="control-group">
			<label for="clientID" class="control-label">客户ID:</label>
			<div class="controls">
				<input id="tenantId" name="tenantId" value="${customer.tenantId}"
					readonly maxlength="50" class="required" type="text" />
			</div>
		</div>
		<div class="control-group">
			<label for="code" class="control-label">License Code:</label>
<c:forEach items='${keys}' var='key'>
			<div class="controls">
				<input id="code" name="code" class="required" type="text"
					readonly value="${key}" maxlength="50" />
			</div>
</c:forEach>
		</div>
		<div class="control-group">
			<label for="userAddNum" class="control-label">新增用户数:</label>
			<div class="controls">
				<input id="userAddNum" name="userAddNum" class="email" type="text"
					readonly value="${order.userCount}" maxlength="100" />
			</div>
		</div>
		<div class="control-group">
			<label for="usedDate" class="control-label">预计生效时间:</label>
			<div class="controls">
				<input name="usedDate" type="text" readonly="readonly"
					maxlength="20" class="required"
					value="<fmt:formatDate pattern="yyyy-MM-dd hh:mm" value='${order.issueDate}' />" />
			</div>
		</div>
		<div class="control-group">
			<label for="remark" class="control-label">备注:</label>
			<div class="controls">
					<textarea id="remark" name="remark" maxlength="200"
					readonly class="input-xlarge" rows="3">${order.remarks}</textarea>
			</div>
		</div>

		<div class="form-actions">
<c:if test="${order.status == 0}">
			<a id="btnMake" class="btn btn-primary" href="${base}/sys/orderView?id=${order.id}" target="_blank">
				查看电子订单</a>&nbsp;
			<a id="btnConfirm" class="btn btn-primary" href="${base}/sys/orderConfirm?id=${order.id}">
				确 认</a>&nbsp;
</c:if>
<c:if test="${order.status == 1}">
			<a id="btnFinish" class="btn btn-primary" href="${base}/sys/orderFinish?id=${order.id}">
				结 束</a>&nbsp;
</c:if>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form>
</body>
</html>