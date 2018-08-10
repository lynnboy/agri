<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<html>
<head>
<title>地块数据列表</title>

	<script type="text/javascript">
		$(document).ready(function() {
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
		<li class="active"><a href="${base}/agri/add">处理</a></li>
	</ul>

<p>
地块编码: 13005812<br>
地块地址: 地址 地址 地址  某县 某乡 某村
</p>

<%@include file="/WEB-INF/views/common/bubble.jsp"%>

<h3>小区处理映射</h3>

<table class="table table-bordered table-condensed">
<tr>
<th>小区 1</th>
<th>小区 2</th>
<th>小区 3</th>
<th>小区 4</th>
<th>小区 5</th>
<th>小区 6</th>
<th>小区 7</th>
<th>小区 8</th>
<th>小区 9</th>
</tr>
<tr>
<td>TR1</td>
<td>TR2</td>
<td>TR3</td>
<td>TR2</td>
<td>TR1</td>
<td>TR3</td>
<td>TR2</td>
<td>TR3</td>
<td>TR1</td>
</tr>
</table>

<dl class="dl-horizontal">
<dt>TR1</dt><dd>tr1 处理说明 tr1 处理说明 tr1 处理说明 tr1 处理说明 tr1 处理说明 tr1 处理说明 tr1 处理说明 tr1 处理说明</dd>
<dt>TR2</dt><dd>tr2 处理说明 tr2 处理说明 tr2 处理说明 tr2 处理说明 tr2 处理说明 tr2 处理说明 tr2 处理说明 tr2 处理说明</dd>
<dt>TR3</dt><dd>tr3 处理说明 tr3 处理说明 tr3 处理说明 tr3 处理说明 tr3 处理说明 tr3 处理说明 tr3 处理说明 tr3 处理说明</dd>
</dl>

<div><a id="btnmap" class="btn btn-primary" type="button"
 href="${base}/agri/processMap"
 value="修改处理映射">修改处理映射</a>
 <a id="btnmap" class="btn btn-primary" type="button"
 href="${base}/agri/processDesc"
 value="编辑处理说明">编辑处理说明</a>
 </div>
<br/>

<h3>处理详细列表</h3>

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
				<th rowspan="2">处理编码</th>
				<th rowspan="2">种植季</th>
				<th colspan="2">平地或梯田平作</th>
				<th colspan="1">平地或梯田垄作</th>
				<th colspan="1">坡地非梯田平作</th>
				<th colspan="2">坡地非梯田垄作</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>翻耕深度</th>
				<th>排水沟</th>
				<th>垄</th>
				<th>种植方向</th>
				<th>种植方向</th>
				<th>垄</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>TR1</td>
				<td>1 季</td>
				<td>20cm</td>
				<td>无</td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR2</td>
				<td>1 季</td>
				<td>不翻耕</td>
				<td>深10cm,宽15cm,间距15m</td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR3</td>
				<td>1 季</td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td class="inactive"></td>
				<td>横坡</td>
				<td>高10cm,宽20cm,间距50cm</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd1" class="btn btn-primary" type="button"
			 href="${base}/agri/processAdd1"
			 value="添加处理">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
        肥料
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
				<th colspan="3">化肥 (单位 kg/667m<sup>2</sup>)</th>
				<th colspan="6">有机肥 (单位 kg/667m<sup>2</sup>)</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>N</th>
				<th>P<sub>2</sub>O<sub>5</sub></th>
				<th>K<sub>2</sub>O</th>
				<th>类型</th>
				<th>含水率</th>
				<th>投入量</th>
				<th>N</th>
				<th>P<sub>2</sub>O<sub>5</sub></th>
				<th>K<sub>2</sub>O</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>TR1</td>
				<td>1 季</td>
				<td>0</td>
				<td>0</td>
				<td>0</td>
				<td>无</td>
				<td>0%</td>
				<td>0</td>
				<td>0</td>
				<td>0</td>
				<td>0</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR2</td>
				<td>2 季</td>
				<td>0</td>
				<td>0</td>
				<td>0</td>
				<td>无</td>
				<td>0%</td>
				<td>0</td>
				<td>0</td>
				<td>0</td>
				<td>0</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR3</td>
				<td>3 季</td>
				<td>50</td>
				<td>100</td>
				<td>50</td>
				<td>【FM01】商品有机肥</td>
				<td>10%</td>
				<td>100</td>
				<td>200</td>
				<td>40</td>
				<td>15</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd2" class="btn btn-primary" type="button"
			 href="${base}/agri/processAdd2"
			 value="添加处理">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseThree">
        灌溉与秸秆
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
				<th colspan="5">秸秆</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>是否灌溉</th>
				<th>灌水方式</th>
				<th>灌水量 (mm)</th>
				<th>是否还田</th>
				<th>秸秆名称</th>
				<th>方式</th>
				<th>还田量 (kg/667m<sup>2</sup>)</th>
				<th>还田比例</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>TR1</td>
				<td>1 季</td>
				<td>否</td>
				<td>无灌溉</td>
				<td>0</td>
				<td>无</td>
				<td></td>
				<td>无</td>
				<td>0</td>
				<td>0%</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
			<tr>
				<td>TR2</td>
				<td>2 季</td>
				<td>是</td>
				<td>大水漫灌</td>
				<td>50</td>
				<td>是</td>
				<td>LC02水稻</td>
				<td>覆盖</td>
				<td>20</td>
				<td>35%</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd3" class="btn btn-primary" type="button"
			 href="${base}/agri/processAdd3"
			 value="添加处理">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapseFour">
        地膜与植物篱
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
				<th colspan="7">地膜</th>
				<th colspan="6">植物篱</th>
				<th rowspan="2">操作</th>
			</tr>
			<tr>
				<th>是否盖膜</th>
				<th>厚度</th>
				<th>覆盖比例</th>
				<th>覆盖量</th>
				<th>回收量</th>
				<th>是否揭膜</th>
				<th>揭膜日期</th>

				<th>是否种植</th>
				<th>种类</th>
				<th>栽种日期</th>
				<th>带宽</th>
				<th>间距</th>
				<th>条带数量</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>TR1</td>
				<td>1 季</td>
				<td>是</td>
				<td>2.1</td>
				<td>50%</td>
				<td>30</td>
				<td>22</td>
				<td>是</td>
				<td>2016-09-20</td>
				<td>是</td>
				<td>某种植物篱</td>
				<td>2016-03-04</td>
				<td>60</td>
				<td>350</td>
				<td>2</td>
				<td>
					<button class="btn btn-primary btn-mini">修改</button>
					<button class="btn btn-primary btn-mini">删除</button>
				</td>
			</tr>
		</tbody>
	</table>

		<div>
			<a id="btnAdd4" class="btn btn-primary" type="button"
			 href="${base}/agri/processAdd4"
			 value="添加处理">添加处理</a>
		</div>
		<br/>

      </div>
    </div>
  </div>
</div>
</body>
</html>