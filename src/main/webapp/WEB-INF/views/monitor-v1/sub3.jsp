<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>记录 - ${id}</title>

<script type="text/javascript">
function addrecord() {
	var jbox = top.$.jBox;
	jbox.open("iframe:${base}${basepath}addlog",
			"添加试验进程及操作记录",
			$(top.document).width()-220, $(top.document).height()-200,{
		id: "映射dialog",
		buttons:{},
		loaded: function(h) {
			var win = h.find("iframe")[0].contentWindow;
			win.cancel = function() {
				jbox.close("映射dialog");
			};
			win.save = function(data) {
				refresh();
			};
		},
		closed: function() { },
	});
}

$(document).ready(function() {
});

function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
function search(){
	var query = searcher.collectQuery();
	$("#search_query").val(b64encode(JSON.stringify(query)));
	return pageTo(1);
}
function sort(o){ $("#orderBy").val(o); return pageTo(1); }
function refresh() { return pageTo($("#pageNo").val()); }

function remove(which2, id){
	confirmx('确认要删除该条数据吗？', function(){
		$.post("${base}${basepath}remove" + which2, {id:id}, function(result,status){
			alertx(result, function(){ refresh(); });
		})
	});
	return false;
}

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

<h3>试验进程及操作记录</h3>

<form class="breadcrumb" id="searchForm" style="">
	<input name="pageNo" id="pageNo" type="hidden" value="${pager.pageNo}">
	<input name="pageSize" id="pageSize" type="hidden" value="${pager.pageSize}">
	<input name="orderBy" id="orderBy" type="hidden" value="${pager.orderBy}">
	<input name="queryB64" id="search_query" type="hidden" value="${search.queryB64}">

	<div id="search" class="xcolumns"></div>
	<div class="clearfix"></div>
</form>

<table class="table table-striped table-bordered" id="contentTable">
<thead>
	<tr>
		<th class="sort-column" onclick="return sort('${pager.sortActions['日期']}')">日期
			<span class="${pager.sortStates['日期'] == 'ASC' ? 'icon-chevron-up' :
				pager.sortStates['日期'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
		</th>
		<th>各项田间工作简述</th>
		<th>备注</th>
<c:if test="${mode == 'edit'}"> 
		<th>操作</th>
</c:if>
	</tr>
</thead>
<tbody>
<c:forEach var="g" items="${recordlist}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.日期}'/></td>
				<td>${row.各项田间工作简述}</td>
				<td>${row.备注}</td>
<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify8/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(8, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
</tbody>
</table>

<%--
<%@include file="/WEB-INF/views/common/paginator.jsp"%>
 --%>

<c:if test="${mode == 'edit'}"> 
<div>
	<a class="btn btn-primary" href="${base}${basepath}add8">添加记录</a>
</div>
</c:if>

<br/>
<h3>数据记录</h3>	

<div class="accordion" id="accordion">
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1">
        种植情况记录
      </a>
    </div>
    <div id="collapse1" class="accordion-body collapse in">
      <div class="accordion-inner">

	<table class="table table-striped table-bordered table-condensed"
		id="contentTable1">
		<thead>
			<tr>
				<th>处理编码</th>
				<th>种植季</th>
				<th>作物名称</th>
				<th>作物品种</th>
				<th>种植方式</th>
				<th>种植日期</th>
				<th>收获日期</th>
<c:if test="${mode == 'edit'}"> 
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist1}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.处理编码}</td>
				<td>${row.种植季}</td>
				<td>${row.作物名称}</td>
				<td>${row.作物品种}</td>
				<td>${row.种植方式}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.种植日期}'/></td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.收获日期}'/></td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify1/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(1, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add1">添加记录</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse2">
        植株产量记载及植株样品记录
      </a>
    </div>
    <div id="collapse2" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable2">
		<thead>
			<tr>
				<th>植株样品编号</th>
				<th>种植季</th>
				<th>作物名称</th>
				<th>产量 (kg/666.7m<sup>2</sup>)</th>
				<th>植株样品鲜重 (g)</th>
				<th>植株样品烘干重 (g)</th>
				<th>取样日期</th>
				<th>含水率 (%) (烘干基)</th>
				<th>全氮 (N, %) (烘干基)</th>
				<th>全磷 (P, %) (烘干基)</th>
				<th>全钾 (K, %) (烘干基)</th>

<c:if test="${mode == 'edit'}"> 
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist2}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.植株样品编码}</td>
				<td>${row.种植季}</td>
				<td>${row.产量}</td>
				<td>${row.植株样品鲜重}</td>
				<td>${row.植株样品烘干重}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.取样日期}'/></td>
				<td>${row.含水率}</td>
				<td>${row.全氮}</td>
				<td>${row.全磷}</td>
				<td>${row.全钾}</td>

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
			<a class="btn btn-primary" href="${base}${basepath}add2">添加记录</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse3">
        施肥记录
      </a>
    </div>
    <div id="collapse3" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable3">
		<thead>
			<tr>
				<th rowspan="2">处理编码</th>
				<th rowspan="2">种植季</th>
				<th rowspan="2">作物名称</th>
				<th rowspan="2">肥料名称</th>
				<th rowspan="2">肥料类别及编码</th>
				<th rowspan="2">肥料含水率 (以烘干基计) (%)</th>
				<th colspan="3">肥料养分含量 (%)</th>
				<th rowspan="2">施肥日期</th>
				<th rowspan="2">施肥方式</th>
				<th rowspan="2">施肥量 (kg/666.7m<sup>2</sup>)</th>
<c:if test="${mode == 'edit'}"> 
				<th rowspan="2">操作</th>
</c:if>
			</tr>
			<tr>
				<td>N</td>
				<td>P<sub>2</sub>O<sub>5</sub></td>
				<td>K<sub>2</sub>O</td>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist3}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.处理编码}</td>
				<td>${row.种植季}</td>
				<td>${row.作物名称}</td>
				<td>${row.肥料名称}</td>
				<td>${row.肥料类别及编码}</td>
				<td>${row.肥料含水率}</td>
				<td>${row.N}</td>
				<td>${row.P2O5}</td>
				<td>${row.K2O}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.施肥日期}'/></td>
				<td>${row.施肥方式}</td>
				<td>${row.施肥量}</td>

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
			<a class="btn btn-primary" href="${base}${basepath}add3">添加记录</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse4">
        降雨/灌溉水样
      </a>
    </div>
    <div id="collapse4" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable4">
		<thead>
			<tr>
				<th>灌溉/降水水样编码</th>
				<th>灌溉/降水日期</th>
				<th>水量 (mm)</th>
				<th>生育时期</th>
				<th>是否产流</th>
				<th>取样日期</th>
				<th>总氮 (N, mg/L)</th>
				<th>可溶性总氮 (N, mg/L)</th>
				<th>硝态氮 (N, mg/L)</th>
				<th>铵态氮 (N, mg/L)</th>
				<th>总磷 (P, mg/L)</th>
				<th>可溶性总磷 (P, mg/L)</th>
				<th>pH</th>
<c:if test="${mode == 'edit'}"> 
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist4}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.水样编码}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.日期}'/></td>
				<td>${row.水量}</td>
				<td>${row.生育时期}</td>
				<td>${row.是否产流}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.取样日期}'/></td>
				<td>${row.总氮}</td>
				<td>${row.可溶性总氮}</td>
				<td>${row.硝态氮}</td>
				<td>${row.铵态氮}</td>
				<td>${row.总磷}</td>
				<td>${row.可溶性总磷}</td>
				<td>${row.ph}</td>

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
			<a class="btn btn-primary" href="${base}${basepath}add4">添加记录</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse5">
        小区产流记载及水样品记录
      </a>
    </div>
    <div id="collapse5" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable5">
		<thead>
			<tr>
				<th>产流样品编码</th>
				<th>种植季</th>
				<th>产流量 (L/监测单元)</th>
				<th>产流日期</th>
				<th>总氮 (N, mg/L)</th>
				<th>可溶性总氮 (N, mg/L)</th>
				<th>硝态氮 (N, mg/L)</th>
				<th>铵态氮 (N, mg/L)</th>
				<th>总磷 (P, mg/L)</th>
				<th>可溶性总磷 (P, mg/L)</th>
<c:if test="${mode == 'edit'}"> 
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist5}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.产流水样编码}</td>
				<td>${row.种植季}</td>
				<td>${row.产流量}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.产流日期}'/></td>
				<td>${row.总氮}</td>
				<td>${row.可溶性总氮}</td>
				<td>${row.硝态氮}</td>
				<td>${row.铵态氮}</td>
				<td>${row.总磷}</td>
				<td>${row.可溶性总磷}</td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify5/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(5, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add5">添加记录</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse6">
        基础土壤样品
      </a>
    </div>
    <div id="collapse6" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable6">
		<thead>
			<tr>
				<th>基础土壤样品编码</th>
				<th>样品鲜重 (g)</th>
				<th>样品风干重 (g)</th>
				<th>采样日期</th>
				<th>含水率 (风干基) (%)</th>
				<th>土壤容重 (g/cm<sup>3</sup>)</th>
				<th>硝态氮 (N, mg/kg)</th>
				<th>铵态氮 (N, mg/kg)</th>
				<th>可溶性总氮 (N, mg/kg)</th>
<c:if test="${mode == 'edit'}"> 
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist6}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.基础土壤样品编码}</td>
				<td>${row.样品鲜重}</td>
				<td>${row.样品风干重}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.采样日期}'/></td>
				<td>${row.含水率}</td>
				<td>${row.土壤容重}</td>
				<td>${row.硝态氮}</td>
				<td>${row.铵态氮}</td>
				<td>${row.可溶性总氮}</td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify6/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(6, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add6">添加记录</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse7">
        监测期土壤样品
      </a>
    </div>
    <div id="collapse7" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable7">
		<thead>
			<tr>
				<th>监测期土壤样品编码</th>
				<th>样品鲜重 (g)</th>
				<th>样品风干重 (g)</th>
				<th>采样日期</th>
				<th>含水率 (风干基) (%)</th>
				<th>硝态氮 (N, mg/kg)</th>
				<th>铵态氮 (N, mg/kg)</th>
				<th>有机质 (风干基) (g/kg)</th>
				<th>全氮 (风干基) (N, g/kg)</th>
				<th>全磷 (风干基) (P, g/kg)</th>
				<th>全钾 (风干基) (K, g/kg)</th>
				<th>Olsen-P (风干基) (P, mg/kg)</th>
				<th>CaCl<sub>2</sub>-P (风干基) (P, mg/kg)</th>
				<th>有效钾 (风干基) (K, g/kg)</th>
				<th>pH (风干基)</th>
<c:if test="${mode == 'edit'}"> 
				<th>操作</th>
</c:if>
			</tr>
		</thead>
		<tbody>
<c:forEach var="g" items="${sublist7}">
			<tr><th colspan="100">监测年份: ${g.key}</th></tr>
<c:forEach var="row" items="${g.value}">
			<tr>
				<td>${row.监测期土壤样品编码}</td>
				<td>${row.样品鲜重}</td>
				<td>${row.样品风干重}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value='${row.采样日期}'/></td>
				<td>${row.含水率}</td>
				<td>${row.土壤容重}</td>
				<td>${row.硝态氮}</td>
				<td>${row.铵态氮}</td>
				<td>${row.有机质}</td>
				<td>${row.全氮}</td>
				<td>${row.全磷}</td>
				<td>${row.全钾}</td>
				<td>${row.OlsenP}</td>
				<td>${row.Cacl2P}</td>
				<td>${row.有效钾}</td>
				<td>${row.ph}</td>

<c:if test="${mode == 'edit'}"> 
				<td>
			<a class="btn btn-primary btn-mini" href="${base}${basepath}modify7/${row.id}">修改</a>
			<a class="btn btn-primary btn-mini" href="javascript:;" onclick="remove(7, ${row.id})">删除</a>
				</td>
</c:if>
			</tr>
</c:forEach>
</c:forEach>
		</tbody>
	</table>

<c:if test="${mode == 'edit'}"> 
		<div>
			<a class="btn btn-primary" href="${base}${basepath}add7">添加记录</a>
		</div>
		<br/>
</c:if>

      </div>
    </div>
  </div>
</div>
</body>
</html>