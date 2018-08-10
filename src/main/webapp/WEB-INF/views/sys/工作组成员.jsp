<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>工作组成员</title>
<script type="text/javascript">
$(document).ready(function() {
	$("#inputForm").validate({
		rules: {
			login: { required: true, login: true },
			password: { required: true, passwordStrength: true, },
			confirmNewPassword: { required: true, equalTo: '#newPassword' },
			name: 'required',
			email: { required: true, email: true },
			phone: 'phone',
			mobile: 'mobile',
		},
		messages: {
			login: { required: '请填写登录名' },
			password: { required: '请填写密码' },
			confirmNewPassword: { required: '请填写密码', equalTo: "请填写相同的密码" },
			name: '请填写代理商名',
			email: { required: '请填写邮箱', email: '邮箱格式不正确' },
		},
		unhighlight: function(el, err, valid) {
			var g = $(el).closest('.control-group');
			g.removeClass('error');
		},
		highlight: function (el, err, valid) {
			$(el).closest('.control-group').addClass('error');
		},
	});
	
	query("");
	getMembers();
});
var selected = [];
var groups = {};
var memberMap = {};
function getMembers() {
	$.getJSON("${base}/sys/wgMemberList?id=${group.id}",
	function(res, status) {
		var list = res;
		selected = [];
		groups = {};
		memberMap = {};
		$.each(list, function(idx, member) {
			selected.push(member.id);
			memberMap[member.id] = member;
			if (!groups[member.organId]) {
				groups[member.organId] = { id: member.organId, organ: member.organName, members: []};
			}
			groups[member.organId].members.push(member);
		});
		fillMember();
	});
}
var queryMap = {};
var alllist = {};
function query(pattern) {
	$.getJSON("${base}/sys/wgSearchUser?pattern=" + pattern,
	function(res, status) {
		var list = res;
		queryMap = {};
		alllist = {};
		$.each(list, function(idx, member) {
			queryMap[member.id] = member;
			if (!alllist[member.organId]) {
				alllist[member.organId] = { id: member.organId, organ: member.organName, members: []};
			}
			alllist[member.organId].members.push(member);
		});
		fillQuery();
	});
}
function fillMember() {
	var list = $("#memberList")
	list.find("optgroup").remove();
	$.each(groups, function(idx, group){
		var g = $('<optgroup label="' + group.organ + '"></optgroup>')
		$.each(group.members, function(_, member) {
			g.append($('<option value="' + member.id + '">' + member.name + '</option>'))
		});
		list.append(g);
	});
}
function fillQuery() {
	var list = $("#queryList")
	list.find("optgroup").remove();
	$.each(alllist, function(idx, group){
		var g = $('<optgroup label="' + group.organ + '"></optgroup>')
		$.each(group.members, function(_, member) {
			var disable = $.inArray(member.id, selected) != -1;
			var opt = $('<option value="' + member.id + '">' + member.name + '</option>');
			if (disable) {
				opt.attr("disabled", "disabled").addClass("muted");
			}
			g.append(opt);
		});
		list.append(g);
	});
}
function updateQuery() {
	var pattern = $("#pattern").val();
	query(pattern);
	return false;
}
function updateQueryDisables() {
	$("#queryList option").each(function() {
		var id = $(this).attr("value");
		var disable = $.inArray(id, selected) != -1;
		if (disable) {
			$(this).attr("disabled", "disabled").addClass("muted");
		} else {
			$(this).removeAttr("disabled").removeClass("muted");
		}
	});
}
function add() {
	$("#queryList option:selected").each(function() {
		var id = $(this).attr("value");
		if ($.inArray(id, selected) == -1) {
			selected.push(id);
			var member = queryMap[id];
			memberMap[id] = member;
			if (!groups[member.organId]) {
				groups[member.organId] = { id: member.organId, organ: member.organName, members: []};
			}
			groups[member.organId].members.push(member);
		}
	});
	updateQueryDisables();
	fillMember();
	return false;
}
function remove() {
	$("#memberList option:selected").each(function() {
		var id = $(this).attr("value");
		var members = [];
		var member = memberMap[id];
		$.each(groups[member.organId].members, function(idx, mem) {
			if (mem.id != id) members.push(mem)
		});
		if (members.length == 0) {
			delete groups[member.organId];
			$(this).parent().remove();
		} else {
			groups[member.organId].members = members;
		}
		$(this).remove();
	});
	var newsel = [];
	$("#memberList option").each(function() {
		var id = $(this).attr("value");
		newsel.push(id);
	});
	selected = newsel;

	updateQueryDisables();
	return false;
}
function updateMembers() {
	$("#idlist").val(selected.join(','));
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/sys/wgList">工作组列表</a></li>
		<li class="active"><a href="${base}/sys/wgMember?id=${group.id}">工作组成员</a></li>
	</ul>
	<br />
<%@include file="/WEB-INF/views/common/message.jsp"%>

<div class="container-fluid">
工作组：<i class="icon-edit"></i> <strong>${group.name}</strong><br>
项目：<i class="icon-list-alt"></i> <strong>${group.projName}</strong><br>
任务：<span class="label label-success">${actionName}</span><br>
授权条件：<strong>
<c:if test="${group.condition.items.size() == 0}">无</c:if>
<c:if test="${group.condition.items.size() != 0}">
${group.condition.items[0].key}
[${group.condition.items[0].pattern}]
</c:if>
</strong>
</div>

<form id="inputForm" class="form-horizontal"
	method="post">

<input id="id" name="id" type="hidden" value="${group.id}" />
<input id="idlist" name="memberList" type="hidden" />

<div class="well well-small">
<div class="span4">
<span class="input-append">
	<input class="input-large" type="text" id="pattern"></input>
	<button class="btn" onclick="return updateQuery();"
	><i class="icon-search"></i></button><br>
</span>
<select multiple id="queryList" class="span4" size="13">
<optgroup label="某单位">
<option disabled class="muted">asdf</option>
<option>张三</option>
</optgroup>
<optgroup label="某单位2">
<option>someone</option>
</optgroup>
</select>
</div>
<div class="span1" style="margin-top:100px">
<button class="btn btn-mini"
 onclick="return add()">添加 <i class="icon-forward"></i></button>
<button class="btn btn-mini"
 onclick="return remove()"><i class="icon-backward"></i> 移除</button>
</div>
<div class="span4">
<select multiple id="memberList" class="span4" size="15">
<optgroup label="某单位">
<option>asdf</option>
<option class="text-info">张三</option>
</optgroup>
</select>
</div>
<div class="clearfix"></div>
</div>

<div class="form-actions">
	<input id="btnSubmit" class="btn btn-primary" type="submit"
		onclick="return updateMembers();"
		value="保 存" />&nbsp; <input id="btnCancel" class="btn" type="button"
		value="返 回" onclick="history.go(-1)" />
</div>
</form>
</body>
</html>