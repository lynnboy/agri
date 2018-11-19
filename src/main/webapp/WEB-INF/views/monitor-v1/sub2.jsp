<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>处理 - ${id}</title>
<script type="text/javascript">

function editmap() {
	var jbox = top.$.jBox;
	jbox.open("iframe:${base}${basepath}blockmap1", "小区分配与处理映射",
			$(top.document).width()-220, $(top.document).height()-200,{
		id: "小区dialog",
		buttons:{},
		loaded: function(h) {
			var win = h.find("iframe")[0].contentWindow;
			win.cancel = function() {
				jbox.close("小区dialog");
			};
			win.save = function(data) {
				editmap2(data);
			};
		},
		closed: function() { },
	});
}

function editmap2(size) {
	var jbox = top.$.jBox;
	jbox.open("iframe:${base}${basepath}blockmap2?c="+size.count+"&r="+size.repeat,
			"小区分配与处理映射",
			$(top.document).width()-220, $(top.document).height()-200,{
		id: "映射dialog",
		buttons:{},
		loaded: function(h) {
			var win = h.find("iframe")[0].contentWindow;
			win.cancel = function() {
				jbox.close("映射dialog");
			};
			win.save = function(data) {
				$.post("${base}${basepath}blockmap", data, function(result,status){
					alertx(result, function(){
						if (result == "ok") {
							jbox.close("映射dialog");
							refresh();
						}
					});
				})
			};
		},
		closed: function() { },
	});
}

function refresh() { window.location.reload(); }
function remove(which2, id){
	confirmx('确认要删除该条数据吗？', function(){
		$.post("${base}${basepath}remove" + which2, {id:id}, function(result,status){
			alertx(result, function(){ refresh(); });
		})
	});
	return false;
}
$(document).ready(function() {
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

<p>

地块编码: ${id}<br>
承担单位: ${maindata.承担单位}<br>
地块地址: ${maindata.地块地址}

</p>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<h3>小区与处理编码对应</h3>

<table class="table table-bordered table-condensed">
<tr>
<c:forEach var="block" items="${blocklist}">
<th>${block.小区编码}</th>
</c:forEach>
</tr>
<tr>
<c:forEach var="block" items="${blocklist}">
<td>${block.处理编码}</td>
</c:forEach>
</tr>
</table>

<dl class="dl-horizontal">
<c:forEach var="pcode" items="${usedCodeList}">
<dt>${pcode.处理编码}</dt><dd>${pcode.描述}</dd>
</c:forEach>
</dl>

<div>

<c:if test="${mode == 'edit'}"> 
<button class="btn btn-primary" onclick="editmap()">修改处理映射</button>
 <a class="btn btn-primary" href="${base}${basepath}codes">编辑处理说明</a>
</c:if>

</div>
<hr>

<h3>处理描述</h3>

<div class="accordion" id="accordion2">
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
        耕作
      </a>
    </div>
    <div id="collapseOne" class="accordion-body collapse in">
      <div class="accordion-inner">

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable1">
		<thead>
			<tr>
				<th rowspan="3">处理编码</th>
				<th rowspan="3">种植季</th>
				<th colspan="9">平地或坡地梯田</th>
				<th colspan="5">坡地非梯田</th>
<c:if test="${mode == 'edit'}"> 
				<th rowspan="3">操作</th>
</c:if>
			</tr>
			<tr>
				<th colspan="6">平作</th>
				<th colspan="3">垄作</th>
				<th colspan="1">平作</th>
				<th colspan="4">垄作</th>
			</tr>
			<tr>
				<th>是否翻耕</th>
				<th>翻耕深度 (cm)</th>
				<th>有无排水沟</th>
				<th>排水沟深 (cm)</th>
				<th>排水沟宽 (cm)</th>
				<th>排水沟间距 (m)</th>

				<th>垄高 (cm)</th>
				<th>垄宽 (cm)</th>
				<th>垄间距 (cm)</th>

				<th>种植方向</th>
				<th>种植方向</th>

				<th>排水沟深 (cm)</th>
				<th>排水沟宽 (cm)</th>
				<th>排水沟间距 (m)</th>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist1}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.处理编码}</td>
				<td>${row.种植季}</td>
				<td>${row.是否翻耕}</td>
				<td>${row.翻耕深度}</td>
				<td>${row.有无排水沟}</td>
				<td>${row.排水沟深}</td>
				<td>${row.排水沟宽}</td>
				<td>${row.排水沟间距}</td>
				<td>${row.垄高1}</td>
				<td>${row.垄宽1}</td>
				<td>${row.垄间距1}</td>
				<td>${row.种植方向1}</td>
				<td>${row.种植方向2}</td>
				<td>${row.垄高2}</td>
				<td>${row.垄宽2}</td>
				<td>${row.垄间距2}</td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify1/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(1,${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add1">添加处理</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
        施肥
      </a>
    </div>
    <div id="collapseTwo" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable2">
		<thead>
			<tr>
				<th rowspan="2">处理编码</th>
				<th rowspan="2">种植季</th>
				<th colspan="3">化肥施用量 (折纯, kg/666.7m<sup>2</sup>)</th>
				<th rowspan="2">有机肥种类</th>
				<th rowspan="2">有机肥含水率 (%)</th>
				<th rowspan="2">有机肥施用量 (实物) (kg/666.7m<sup>2</sup>)</th>
				<th colspan="3">有机肥施用量 (折纯, kg/666.7m<sup>2</sup>)</th>
<c:if test="${mode == 'edit'}"> 
				<th rowspan="2">操作</th>
</c:if>
			</tr>
			<tr>
				<th>N</th>
				<th>P<sub>2</sub>O<sub>5</sub></th>
				<th>K<sub>2</sub>O</th>

				<th>N</th>
				<th>P<sub>2</sub>O<sub>5</sub></th>
				<th>K<sub>2</sub>O</th>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist2}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.处理编码}</td>
				<td>${row.种植季}</td>
				<td>${row.化肥N}</td>
				<td>${row.化肥P2O5}</td>
				<td>${row.化肥K2O}</td>
				<td>${row.有机肥种类}</td>
				<td>${row.有机肥含水率}</td>
				<td>${row.有机肥}</td>
				<td>${row.有机肥N}</td>
				<td>${row.有机肥P2O5}</td>
				<td>${row.有机肥K2O}</td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify2/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(2, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add2">添加处理</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseThree">
        灌溉、秸秆还田
      </a>
    </div>
    <div id="collapseThree" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable3">
		<thead>
			<tr>
				<th rowspan="2">处理编码</th>
				<th rowspan="2">种植季</th>
				<th colspan="3">灌溉</th>
				<th colspan="5">秸秆还田</th>
<c:if test="${mode == 'edit'}"> 
				<th rowspan="2">操作</th>
</c:if>
			</tr>
			<tr>
				<th>是否灌溉</th>
				<th>灌溉方式</th>
				<th>灌溉量 (mm)</th>

				<th>是否秸秆还田</th>
				<th>秸秆名称</th>
				<th>还田方式</th>
				<th>还田量 (kg/666.7m<sup>2</sup>)</th>
				<th>还田比例 (%)</th>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist3}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.处理编码}</td>
				<td>${row.种植季}</td>
				<td>${row.是否灌溉}</td>
				<td>${row.灌溉方式}</td>
				<td>${row.灌溉量}</td>
				<td>${row.是否秸秆还田}</td>
				<td>${row.秸秆名称}</td>
				<td>${row.还田方式}</td>
				<td>${row.还田量}</td>
				<td>${row.还田比例}</td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify3/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(3, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add3">添加处理</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseFour">
        地膜、植物篱
      </a>
    </div>
    <div id="collapseFour" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable4">
		<thead>
			<tr>
				<th rowspan="2">处理编码</th>
				<th rowspan="2">种植季</th>
				<th colspan="7">地膜覆盖</th>
				<th colspan="6">坡地植物篱种植情况</th>
<c:if test="${mode == 'edit'}"> 
				<th rowspan="2">操作</th>
</c:if>
			</tr>
			<tr>
				<th>是否覆膜</th>
				<th>地膜厚度 (mm)</th>
				<th>覆膜日期</th>
				<th>覆膜量 (kg/666.7m<sup>2</sup>)</th>
				<th>覆膜比例 (%)</th>
				<th>是否揭膜</th>
				<th>揭膜日期</th>

				<th>是否种植</th>
				<th>植物篱种类</th>
				<th>栽种日期</th>
				<th>植物篱带宽 (cm)</th>
				<th>植物篱间距 (cm)</th>
				<th>植物篱条带数量 (条)</th>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist4}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.处理编码}</td>
				<td>${row.种植季}</td>

				<td>${row.是否覆膜}</td>
				<td>${row.地膜厚度}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.覆膜日期}'/></td>
				<td>${row.覆膜量}</td>
				<td>${row.覆膜比例}</td>
				<td>${row.是否揭膜}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.揭膜日期}'/></td>

				<td>${row.植物篱是否种植}</td>
				<td>${row.植物篱种类}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.栽种日期}'/></td>
				<td>${row.植物篱带宽}</td>
				<td>${row.植物篱间距}</td>
				<td>${row.植物篱条带数量}</td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify4/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(4, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add4">添加处理</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
</div>
</body>
</html>