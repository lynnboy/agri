<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块记录数据</title>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#btnAddLog').click(function(){
				top.$.jBox.open("iframe:${base}/agri/addLog", "添加试验进程及操作记录",$(top.document).width()-220,$(top.document).height()-200,{
				});
			});
		});
		function pageTo(n){ $("#pageNo").val(n); $("#searchForm").submit(); return false; }
		function pageBy(s){ $("#pageSize").val(s); return pageTo(1); }
		function search(){
			$("#search_地块编码").val($("#ui_地块编码").val());
			return pageTo(1);
		}
		function sort(o){ $("#orderBy").val(o); return pageTo(1); }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${base}/agri/list">地块数据列表</a></li>
		<li class="active"><a href="${base}/agri/add">记录</a></li>
	</ul>

<p>
地块编码: 13005812<br>
地块地址: 地址 地址 地址  某县 某乡 某村
</p>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<h3>试验进程及操作记录</h3>

	<table class="table table-striped table-bordered"
		id="contentTable">
		<thead>
			<tr>
				<th class="sort-column" onclick="return sort('${pager.sortActions['地块编码']}')">日期
					<span class="${pager.sortStates['日期'] == 'ASC' ? 'icon-chevron-up' :
						pager.sortStates['日期'] == 'DESC' ? 'icon-chevron-down' : ''}"></span>
				</th>
				<th>各项田间工作简述</th>
				<th>备注</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>2016-01-01</td>
				<td>第一条记录</td>
				<td></td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>2016-01-02</td>
				<td>第二条记录</td>
				<td></td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

<%@include file="/WEB-INF/views/common/paginator.jsp"%>

		<div>
			<button id="btnAddLog" class="btn btn-primary" type="button" value="添加记录">添加记录</button>
		</div>

<br/>
<h3>数据记录</h3>	

<div class="accordion" id="accordion">
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1">
        种植记录
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
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>TR1</td>
				<td>1 季</td>
				<td>小麦</td>
				<td>某小麦品种1</td>
				<td>播种</td>
				<td>2016-02-13</td>
				<td>2016-06-08</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR2</td>
				<td>2 季</td>
				<td>小麦</td>
				<td>某小麦品种2</td>
				<td>播种</td>
				<td>2016-06-30</td>
				<td>2016-09-17</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd1" class="btn btn-primary" type="button"
			 href="${base}/agri/recordAdd1">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse2">
        植株样品
      </a>
    </div>
    <div id="collapse2" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable2">
		<thead>
			<tr>
				<th>样品编号</th>
				<th>种植季</th>
				<th>作物名称</th>
				<th>产量</th>
				<th>鲜重 (g)</th>
				<th>风干重 (g)</th>
				<th>取样日期</th>
				<th>含水率</th>
				<th>全氮(N)</th>
				<th>全磷(P)</th>
				<th>全钾(K)</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>1ZJ01</td>
				<td>1 季</td>
				<td>小麦</td>
				<td>756.50</td>
				<td>1.0</td>
				<td>0.3</td>
				<td>2016-05-03</td>
				<td>70%</td>
				<td>12%</td>
				<td>16%</td>
				<td>20%</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>1ZJ02</td>
				<td>2 季</td>
				<td>小麦</td>
				<td>756.50</td>
				<td>1.0</td>
				<td>0.3</td>
				<td>2016-05-03</td>
				<td>70%</td>
				<td>12%</td>
				<td>16%</td>
				<td>20%</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>1ZF01</td>
				<td>1 季</td>
				<td>小麦</td>
				<td>756.50</td>
				<td>1.0</td>
				<td>0.3</td>
				<td>2016-05-03</td>
				<td>70%</td>
				<td>12%</td>
				<td>16%</td>
				<td>20%</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd2" class="btn btn-primary" type="button"
			 href="${base}/agri/recordAdd2">添加处理</a>
		</div>
		<br/>

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
				<th>处理编码</th>
				<th>种植季</th>
				<th>作物名称</th>
				<th>肥料名称</th>
				<th>肥料类别及代码</th>
				<th>含水率</th>
				<th>N</th>
				<th>P<sub>2</sub>O<sub>5</sub></th>
				<th>K<sub>2</sub>O</th>
				<th>施肥日期</th>
				<th>施肥方式</th>
				<th>施用量(每小区)</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>TR1</td>
				<td>1 季</td>
				<td>小麦</td>
				<td>某某尿素</td>
				<td>【FN01】尿素</td>
				<td>0%</td>
				<td>35%</td>
				<td>0%</td>
				<td>0%</td>
				<td>2016-04-05</td>
				<td>撒施</td>
				<td>50 kg</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR2</td>
				<td>1 季</td>
				<td>小麦</td>
				<td>某某尿素</td>
				<td>【FN01】尿素</td>
				<td>0%</td>
				<td>35%</td>
				<td>0%</td>
				<td>0%</td>
				<td>2016-04-05</td>
				<td>撒施</td>
				<td>50 kg</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR3</td>
				<td>2 季</td>
				<td>水稻</td>
				<td>某某尿素</td>
				<td>【FN01】尿素</td>
				<td>0%</td>
				<td>35%</td>
				<td>0%</td>
				<td>0%</td>
				<td>2016-04-05</td>
				<td>撒施</td>
				<td>50 kg</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd3" class="btn btn-primary" type="button"
			 href="${base}/agri/recordAdd3">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse4">
        降水/灌溉样品
      </a>
    </div>
    <div id="collapse4" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable4">
		<thead>
			<tr>
				<th rowspan="2">样品编码</th>
				<th rowspan="2">灌溉/降水日期</th>
				<th rowspan="2">水量(mm)</th>
				<th rowspan="2">生育时期</th>
				<th rowspan="2">是否产流</th>
				<th rowspan="2">取样日期</th>
				<th colspan="4">氮(N,mg/L)</th>
				<th colspan="2">磷(P,mg/L)</th>
				<th rowspan="2">pH</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>总氮</th>
				<th>可溶性总氮</th>
				<th>硝态氮</th>
				<th>铵态氮</th>
				<th>总磷</th>
				<th>可溶性总磷</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>SG001</td>
				<td>2016-03-14</td>
				<td>350.20</td>
				<td>生育时期1</td>
				<td>否</td>
				<td>2016-03-14</td>
				<td>11.242</td>
				<td>8.763</td>
				<td>4.333</td>
				<td>5.274</td>
				<td>2.421</td>
				<td>1.553</td>
				<td>6.4</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>SJ002</td>
				<td>2016-05-12</td>
				<td>350.20</td>
				<td>生育时期2</td>
				<td>是</td>
				<td>2016-05-13</td>
				<td>11.242</td>
				<td>8.763</td>
				<td>4.333</td>
				<td>5.274</td>
				<td>2.421</td>
				<td>1.553</td>
				<td>6.4</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd4" class="btn btn-primary" type="button"
			 href="${base}/agri/recordAdd4">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse5">
        产流样品
      </a>
    </div>
    <div id="collapse5" class="accordion-body collapse">
      <div class="accordion-inner">
	<table class="table table-striped table-bordered table-condensed"
		id="contentTable5">
		<thead>
			<tr>
				<th rowspan="2">样品编码</th>
				<th rowspan="2">种植季</th>
				<th rowspan="2">产流量(每监测单元)</th>
				<th rowspan="2">产流日期</th>
				<th colspan="4">氮(N,mg/L)</th>
				<th colspan="2">磷(P,mg/L)</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>总氮</th>
				<th>可溶性总氮</th>
				<th>硝态氮</th>
				<th>铵态氮</th>
				<th>总磷</th>
				<th>可溶性总磷</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>A3SC002</td>
				<td>1 季</td>
				<td>1350.20 L</td>
				<td>2016-05-12</td>
				<td>11.242</td>
				<td>8.763</td>
				<td>4.333</td>
				<td>5.274</td>
				<td>2.421</td>
				<td>1.553</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd5" class="btn btn-primary" type="button"
			 href="${base}/agri/recordAdd5">添加处理</a>
		</div>
		<br/>

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
				<th rowspan="2">样品编码</th>
				<th rowspan="2">鲜重(g)</th>
				<th rowspan="2">风干重(g)</th>
				<th rowspan="2">采样日期</th>
				<th rowspan="2">含水率</th>
				<th colspan="5">土壤容重 (g/m<sup>3</sup>)</th>
				<th colspan="3">氮(N,mg/kg)</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>0-20cm</th>
				<th>20-40cm</th>
				<th>40-60cm</th>
				<th>60-80cm</th>
				<th>80-100cm</th>
				<th>硝态氮</th>
				<th>铵态氮</th>
				<th>可溶性总氮</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>TA</td>
				<td>5.0</td>
				<td>4.2</td>
				<td>2016-03-02</td>
				<td>16%</td>
				<td>4.2</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>242.113</td>
				<td>172.341</td>
				<td>350.524</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>TB</td>
				<td>5.0</td>
				<td>4.2</td>
				<td>2016-03-02</td>
				<td>16%</td>
				<td></td>
				<td>4.3</td>
				<td></td>
				<td></td>
				<td></td>
				<td>242.113</td>
				<td>172.341</td>
				<td>350.524</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>TC</td>
				<td>5.0</td>
				<td>4.2</td>
				<td>2016-03-02</td>
				<td>16%</td>
				<td></td>
				<td></td>
				<td>4.4</td>
				<td></td>
				<td></td>
				<td>242.113</td>
				<td>172.341</td>
				<td>350.524</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>TD</td>
				<td>5.0</td>
				<td>4.2</td>
				<td>2016-03-02</td>
				<td>16%</td>
				<td></td>
				<td></td>
				<td></td>
				<td>4.5</td>
				<td></td>
				<td>242.113</td>
				<td>172.341</td>
				<td>350.524</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
			<tr>
				<td>TE</td>
				<td>5.0</td>
				<td>4.2</td>
				<td>2016-03-02</td>
				<td>16%</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>4.6</td>
				<td>242.113</td>
				<td>172.341</td>
				<td>350.524</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd6" class="btn btn-primary" type="button"
			 href="${base}/agri/recordAdd6">添加处理</a>
		</div>
		<br/>

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
				<th>样品编码</th>
				<th>鲜重<br/>(g)</th>
				<th>风干重<br/>(g)</th>
				<th>采样日期</th>
				<th>含水率</th>

				<th>硝态氮<br/>(mg/kg)</th>
				<th>铵态氮<br/>(mg/kg)</th>
				<th>有机质<br/>(g/kg)</th>
				<th>全氮<br/>(g/kg)</th>
				<th>全磷<br/>(g/kg)</th>
				<th>全钾<br/>(mg/kg)</th>
				<th>Olsen-P<br/>(mg/kg)</th>
				<th>CaCl<sub>2</sub>-P<br/>(mg/kg)</th>
				<th>有效钾<br/>(mg/kg)</th>
				<th>pH</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>A3TA</td>
				<td>5.0</td>
				<td>4.2</td>
				<td>2016-03-07</td>
				<td>16%</td>
				<td>321.423</td>
				<td>242.938</td>
				<td>29.423</td>
				<td>19.202</td>
				<td>20.428</td>
				<td>1000.000</td>
				<td>111.111</td>
				<td>1.111</td>
				<td>123.456</td>
				<td>7.3</td>
				<td>
					<button class="btn btn-primary btn-small">修改</button>
					<button class="btn btn-primary btn-small">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd7" class="btn btn-primary" type="button"
			 href="${base}/agri/recordAdd7">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
</div>
</body>
</html>