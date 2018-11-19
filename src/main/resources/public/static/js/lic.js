$(document).ready(function() {
	try{
		// 链接去掉虚框
//		$("a").bind("focus",function() {
//			if(this.blur) {this.blur()};
//		});
		//所有下拉框使用select2
		//$("select").select2();
	}catch(e){
		// blank
	}
});

// 引入js和css文件
function include(id, path, file){
	if (document.getElementById(id)==null){
        var files = typeof file == "string" ? [file] : file;
        for (var i = 0; i < files.length; i++){
            var name = files[i].replace(/^\s|\s$/g, "");
            var att = name.split('.');
            var ext = att[att.length - 1].toLowerCase();
            var isCSS = ext == "css";
            var tag = isCSS ? "link" : "script";
            var attr = isCSS ? " type='text/css' rel='stylesheet' " : " type='text/javascript' ";
            var link = (isCSS ? "href" : "src") + "='" + path + name + "'";
            document.write("<" + tag + (i==0?" id="+id:"") + attr + link + "></" + tag + ">");
        }
	}
}

// 获取URL地址参数
function getQueryString(name, url) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    if (!url || url == ""){
	    url = window.location.search;
    }else{	
    	url = url.substring(url.indexOf("?"));
    }
    r = url.substr(1).match(reg)
    if (r != null) return unescape(r[2]); return null;
}

//获取字典标签
function getDictLabel(data, value, defaultValue){
	for (var i=0; i<data.length; i++){
		var row = data[i];
		if (row.value == value){
			return row.label;
		}
	}
	return defaultValue;
}

// 打开一个窗体
function windowOpen(url, name, width, height){
	var top=parseInt((window.screen.height-height)/2,10),left=parseInt((window.screen.width-width)/2,10),
		options="location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,"+
		"resizable=yes,scrollbars=yes,"+"width="+width+",height="+height+",top="+top+",left="+left;
	window.open(url ,name , options);
}

// 恢复提示框显示
function resetTip(){
	top.$.jBox.tip.mess = null;
}

// 关闭提示框
function closeTip(){
	top.$.jBox.closeTip();
}

//显示提示框
function showTip(mess, type, timeout, lazytime){
	resetTip();
	setTimeout(function(){
		top.$.jBox.tip(mess, (type == undefined || type == '' ? 'info' : type), {opacity:0, 
			timeout:  timeout == undefined ? 2000 : timeout});
	}, lazytime == undefined ? 500 : lazytime);
}

// 显示加载框
function loading(mess){
	if (mess == undefined || mess == ""){
		mess = "正在提交，请稍等...";
	}
	resetTip();
	top.$.jBox.tip(mess,'loading',{opacity:0});
}

// 关闭提示框
function closeLoading(){
	// 恢复提示框显示
	resetTip();
	// 关闭提示框
	closeTip();
}

// 警告对话框
function alertx(mess, closed){
	top.$.jBox.info(mess, '提示', {closed:function(){
		if (typeof closed == 'function') {
			closed();
		}
	}});
	top.$('.jbox-body .jbox-icon').css('top','55px');
}

// 确认对话框
function confirmx(mess, href, closed){
	top.$.jBox.confirm(mess,'系统提示',function(v,h,f){
		if(v=='ok'){
			if (typeof href == 'function') {
				href();
			}else{
				resetTip(); //loading();
				location = href;
			}
		}
	},{buttonsFocus:1, closed:function(){
		if (typeof closed == 'function') {
			closed();
		}
	}});
	top.$('.jbox-body .jbox-icon').css('top','55px');
	return false;
}

// 提示输入对话框
function promptx(title, lable, href, init, closed){
	top.$.jBox("<div class='form-search' style='padding:20px;text-align:center;'>" + lable + "：<input type='text' id='txt' name='txt' value='" + init + "'/></div>", {
			title: title, submit: function (v, h, f){
	    if (f.txt == '') {
	        top.$.jBox.tip("请输入" + lable + "。", 'error');
	        return false;
	    }
		if (typeof href == 'function') {
			href(f.txt);
		}else{
			resetTip(); //loading();
			location = href + encodeURIComponent(f.txt);
		}
	},closed:function(){
		if (typeof closed == 'function') {
			closed();
		}
	},loaded: function(h) {
		
	}});
	return false;
}

// 添加TAB页面
function addTabPage(title, url, closeable, $this, refresh){
	top.$.fn.jerichoTab.addTab({
        tabFirer: $this,
        title: title,
        closeable: closeable == undefined,
        data: {
            dataType: 'iframe',
            dataLink: url
        }
    }).loadData(refresh != undefined);
}

// cookie操作
function cookie(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        var path = options.path ? '; path=' + options.path : '';
        var domain = options.domain ? '; domain=' + options.domain : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
}

// 数值前补零
function pad(num, n) {
    var len = num.toString().length;
    while(len < n) {
        num = "0" + num;
        len++;
    }
    return num;
}

// 转换为日期
function strToDate(date){
	return new Date(date.replace(/-/g,"/"));
}

// 日期加减
function addDate(date, dadd){  
	date = date.valueOf();
	date = date + dadd * 24 * 60 * 60 * 1000;
	return new Date(date);  
}

//截取字符串，区别汉字和英文
function abbr(name, maxLength){  
 if(!maxLength){  
     maxLength = 20;  
 }  
 if(name==null||name.length<1){  
     return "";  
 }  
 var w = 0;//字符串长度，一个汉字长度为2   
 var s = 0;//汉字个数   
 var p = false;//判断字符串当前循环的前一个字符是否为汉字   
 var b = false;//判断字符串当前循环的字符是否为汉字   
 var nameSub;  
 for (var i=0; i<name.length; i++) {  
    if(i>1 && b==false){  
         p = false;  
    }  
    if(i>1 && b==true){  
         p = true;  
    }  
    var c = name.charCodeAt(i);  
    //单字节加1   
    if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {  
         w++;  
         b = false;  
    }else {  
         w+=2;  
         s++;  
         b = true;  
    }  
    if(w>maxLength && i<=name.length-1){  
         if(b==true && p==true){  
             nameSub = name.substring(0,i-2)+"...";  
         }  
         if(b==false && p==false){  
             nameSub = name.substring(0,i-3)+"...";  
         }  
         if(b==true && p==false){  
             nameSub = name.substring(0,i-2)+"...";  
         }  
         if(p==true){  
             nameSub = name.substring(0,i-2)+"...";  
         }  
         break;  
    }  
 }  
 if(w<=maxLength){  
     return name;  
 }  
 return nameSub;  
}

jQuery.validator.addMethod("phone", function(value, el) {
	var re = /^((\+\d{2,3}-)?\d{3,4}-?)?\d{7,8}(-\d{1,4})$/g; // 国家代码，区号，号码，分机号
	return this.optional(el) || (re.test(value));
}, "请填写正确的电话号码");
jQuery.validator.addMethod("mobile", function(value, el) {
	var re = /^(\+\d{2,3}-)?1[3458]\d-?\d{4}-?\d{4}$/g; // 国家代码，区号，号码，分机号
	return this.optional(el) || (re.test(value));
}, "请填写正确的手机号码");
jQuery.validator.addMethod("phoneOrMobile", function(value, el) {
	var re = /^(?:(?:(?:\+\d{2,3}-)?\d{3,4}-?)?\d{7,8}(-\d{1,4}))|(?:(?:\+\d{2,3}-)?1[3458]\d-?\d{4}-?\d{4})$/g;
	return this.optional(el) || (re.test(value));
}, "请填写正确的电话或手机号码");
jQuery.validator.addMethod("login", function(value, el) {
	var re = /^[a-zA-Z_][a-zA-Z0-9_-]*$/;
	return this.optional(el) || (re.test(value));
}, "请使用有效的登录名，可以包含大小写字母、数字、下划线和连字符，且不以数字和连字符开头");
jQuery.validator.addMethod("passwordStrength", function(value, el) {
	var strength = 0;
	if (/\d/.test(value)) strength ++;
	if (/[a-z]/.test(value)) strength ++;
	if (/[A-Z]/.test(value)) strength ++;
	if (/[^0-9a-zA-Z]/.test(value)) strength ++;
	return this.optional(el) || (strength >= 3 && value.length >= 6);
}, "请使用足够强度的密码，包含大小写字母、数字和其他字符等多种字符，且长度至少为6个字符");
function isValidLicenseCode(value) {
	var re = /^[0-9a-zA-Z]{5}-[0-9a-zA-Z]{5}-[0-9a-zA-Z]{5}-[0-9a-zA-Z]{5}-[0-9a-zA-Z]{5}$/g;
	return re.test(value);
}
jQuery.validator.addMethod("licenseCode", function(value, el) {
	return this.optional(el) || isValidLicenseCode(value);
}, "请填写正确格式的 License Code");
jQuery.validator.addMethod("reqselect", function(value, el) {
	var n = Number(value);
	if (!Number.isNaN(n)) {
		return n != 0;
	} else {
		return value != "";
	}
}, "必须填写");
$.validator.addMethod("pattern", function(value, element, param) {
	if (this.optional(element)) {
		return true;
	}
	if (typeof param === "string") {
		param = new RegExp("^(?:" + param + ")$");
	}
	return param.test(value);
}, "格式错误");
jQuery.validator.addMethod("植株样品编号", function(value, el) {
	var re = /^[1-9](?:ZJ|ZF)\d\d$/;
	return this.optional(el) || (re.test(value));
}, "植株样品编号格式错误");
jQuery.validator.addMethod("水样编码", function(value, el) {
	var re = /^(?:SJ|SG)\d\d\d$/;
	return this.optional(el) || (re.test(value));
}, "水样品编码格式错误");
jQuery.validator.addMethod("产流样品编码", function(value, el) {
	var re = /^[A-Z][1-4]SC\d\d\d$/;
	return this.optional(el) || (re.test(value));
}, "产流样品编码格式错误");
jQuery.validator.addMethod("基础土壤样品编码", function(value, el) {
	var re = /^T[A-E]$/;
	return this.optional(el) || (re.test(value));
}, "基础土壤样品编码格式错误");
jQuery.validator.addMethod("监测期土壤样品编码", function(value, el) {
	var re = /^[A-Z][1-4]T[A-E]$/;
	return this.optional(el) || (re.test(value));
}, "监测期土壤样品编码格式错误");
$.validator.addMethod("sumLessThan100", function(value, element, param) {
	if (this.optional(element)) {
		return true;
	}
	var sum = 0; $.each(param, function(_,id) {sum += 1*$(id).val();});
	return sum <= 100;
}, "百分比求和不能超过100");

function b64encode(str) {
	return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g,
		function toSolitBytes(match, p1) {
			return String.fromCharCode('0x' + p1);
	}));
}
function b64decode(str) {
	return decodeURIComponent(atob(str).split('').map(function(c) {
		return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
	}).join(''));
}

function datePickerSettings() {
	return {
		dateFmt:'yyyy-MM-dd', isShowClear: false,
		minDate: '1970-01-01', maxDate: '2099-12-31',
	};
}


function fillSelect(sel, list, nestlist) {
	var oldsel = $(sel).val();
	$(sel).find("option").remove();
	$.each(list, function(i, text) {
		$(sel).append($('<option value="' + i + '">'+ text + '</option>'));
	});
	$(sel).val(oldsel);
	if (Array.isArray(nestlist)) {
	  $.each(nestlist, function(_, nest){
		$(sel).change(function(){
			if (nest.cond && !nest.cond()) return;
			var ids = nest.map[$(this).val() || 0];
			var oldval = $(nest.sel).val();
			$(nest.sel).find("option").remove();
			$.each(ids, function(_, i) {
				$(nest.sel).append($('<option value="' + i + '">'+ nest.list[i] + '</option>'));
			});
			$(nest.sel).val(oldval);
			$(nest.sel).change();
			$(nest.sel).valid();
		});
	  });
	}
}


var Column = function(obj) { $.extend(this,{type:'VARCHAR(45)',isnull:true},obj); }
Column.prototype.isText = function() { return /CHAR|TEXT/i.test(this.type); }
Column.prototype.isInt = function() { return /INT/i.test(this.type); }
Column.prototype.isNumber = function() { return /INT|FLOAT|DOUBLE|REAL|DECIMAL/i.test(this.type); }
Column.prototype.isDate = function() { return 'DATE' == this.type.toUpperCase(); }
Column.prototype.isDateTime = function() { return /DATE|TIME/i.test(this.type); }
Column.prototype.isBinary = function() { return /BINARY|BLOB/i.test(this.type); }
var Schema = function(obj) {
	$.extend(this,{columns:[],pk:[]},obj);
	var colMap = {};
	$.each(this.columns, function(i,c) {
		colMap[c.name] = new Column(c);
	})
	this.colMap = colMap;
}
Schema.prototype.col = function(name) { return this.colMap[name]; }
var SearchConfig = function(obj) {
	$.extend(this,{mode:"DEFAULT",items:[]},obj);
	var map = {};
	$.each(this.items, function(i,c) {
		map[c.key] = c;
	})
	this._map = map;
}
SearchConfig.prototype.hasOptList = function(key) {
	return key in this._map && !$.isEmptyObject(this._map[key].optList);
}
SearchConfig.prototype.isTags = function(key) {
	return key == "tags" && this.hasOptList(key);
}
SearchConfig.prototype.isSearchable = function(key) {
	return !(key in this._map && this._map[key].searchable);
}
SearchConfig.prototype.optListOf = function(key) {
	return this._map[key].optList;
}
var ViewConfig = function(obj) {
	$.extend(this, {items:[]}, obj);
	var map = {};
	$.each(this.items, function(i,c) {
		map[c.key] = c;
	})
	this._map = map;
}
ViewConfig.prototype.headerOf = function(key) {
	return (key in this._map && this._map[key].header) ?
			this._map[key].header : key;
}
ViewConfig.prototype.textOf = function(key, value) {
	if (key in this._map && this._map[key].optList) {
		var list = this._map[key].optList;
		if (value in list) return list[value];
	}
	return value;
}

var Searcher = function(div, schema, searchConfig, viewConfig, queryList) {
	this.$div = $(div);
	this.schema = schema;
	this.searchConfig = searchConfig;
	this.viewConfig = viewConfig;
	this.nextNo = 0;

	var self = this;

	var $div = this.$div;

	$.each(queryList, function(i,item) {
		self.addQuery(item.key, item.op, item.val);
	});

	var $divbtn = $('<div class="btn-group">').insertAfter($div);
	var $btn = $('<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="javascript:;">')
		.appendTo($divbtn);
	$btn.append('<i class="icon-plus"> </i> 添加条件 <span class="caret"></span>');
	var $ul = $('<ul class="dropdown-menu">').appendTo($divbtn);

	$.each(schema.colMap, function(key, column) {
		if (searchConfig.isSearchable(key)) return;

		if (searchConfig.isTags(key)) {
			var $li = $('<li></li>').appendTo($ul);
			$('<a href="javascript:;">' + viewConfig.headerOf(key) + '</a>').appendTo($li)
				.click(function(){self.addTagsQuery(key)});
			var $subul = $('<ul class="dropdown-menu"></ul>').appendTo($li);

			return;
		}
		
		var submenu = [];
		if (searchConfig.hasOptList(key)) {
			submenu.push({ text: "选项", act: function(){self.addOptListQuery(key);} });
			submenu.push({ text: "多选", act: function(){self.addOptMultiQuery(key);} });
		}
		if (column.isText()) {
			submenu.push({ text: "匹配", act: function(){self.addTextQuery(key, "STR_MATCH");} });
			submenu.push(false);
			submenu.push({ text: "为", act: function(){self.addTextQuery(key, "EQ");} });
			submenu.push({ text: "开始为", act: function(){self.addTextQuery(key, "STR_BEGIN");} });
			submenu.push({ text: "末尾为", act: function(){self.addTextQuery(key, "STR_END");} });
			submenu.push(false);
			submenu.push({ text: "正则表达式匹配", act: function(){self.addTextQuery(key, "STR_REGEX");} });
		}
		if (column.isNumber()) {
			submenu.push({ text: "等于", act: function(){self.addNumQuery(key, "EQ");} });
			submenu.push({ text: "至少为", act: function(){self.addNumQuery(key, "GE");} });
			submenu.push({ text: "最大为", act: function(){self.addNumQuery(key, "LE");} });
			submenu.push(false);
			submenu.push({ text: "文字匹配", act: function(){self.addTextQuery(key, "STR_MATCH");} });
		}
		if (column.isDateTime()) {
			submenu.push({ text: "等于", act: function(){self.addDateQuery(key, "EQ");} });
			submenu.push({ text: "日期不晚于", act: function(){self.addDateQuery(key, "GE");} });
			submenu.push({ text: "日期不早于", act: function(){self.addDateQuery(key, "LE");} });
			submenu.push(false);
			submenu.push({ text: "文字匹配", act: function(){self.addTextQuery(key, "STR_MATCH");} });
		}
		if (submenu.length == 0) return;

		var $li = $('<li class="dropdown-submenu"></li>').appendTo($ul);
		$('<a href="javascript:;">' + viewConfig.headerOf(key) + '</a>').appendTo($li)
			.click(submenu[0].act);
		var $subul = $('<ul class="dropdown-menu"></ul>').appendTo($li);

		$.each(submenu, function(idix, item) {
			if (!item) {
				$('<li class="divider"></li>').appendTo($subul);
				return;
			}
			var $subli = $('<li></li>').appendTo($subul);
			$('<a href="javascript:;">' + item.text + '</a>').appendTo($subli).click(item.act);
		});
	});
}
Searcher.prototype.addQuery = function(key, op, val) {
	var column = this.schema.col(key);

	if (op == "TAGS") return this.addTagsQuery(key, op, val);
	if (op == "IS") return this.addOptListQuery(key, op, val);
	if (op == "IN") return this.addOptMultiQuery(key, op, val);
	if ($.inArray(op, ["EQ", "LE", "GE"]) != -1) {
		if (column.isNumber()) return this.addNumQuery(key, op, val);
		if (column.isDateTime()) return this.addDateQuery(key, op, val);
	}
	return this.addTextQuery(key, op, val);
}
Searcher.prototype.addQueryCommon = function(key, name, op, idkey, idop, idval) {
	var $row = $('<fieldset>').appendTo(this.$div);
	$('<input type="hidden">').attr('id', idkey).val(key).appendTo($row);
	$('<input type="hidden">').attr('id', idop).val(op).appendTo($row);
	$('<a href="javascript:;" onclick="$(this).parent().remove()"><i class="icon-minus">&nbsp;</i></a>').appendTo($row);
	$row.append(" ");
	$('<label>').css('display','inline-block').attr('for', idval).text(name).appendTo($row);
	$row.append(" ");
	return $row;
}
Searcher.prototype.addQueryOpMenu = function($row, op, idop, opmenu, opnames) {
	var $opdiv = $('<div class="btn-group">').appendTo($row);
	var $btn = $('<a class="btn dropdown-toggle" data-toggle="dropdown" href="javascript:;">').appendTo($opdiv);
	var $opname = $('<span>').text(opnames[op] + ' ').appendTo($btn);
	$('<span class="caret">').appendTo($btn);
	var $menu = $('<ul class="dropdown-menu">').appendTo($opdiv);
	$.each(opmenu, function(idx, t) {
		if (!t) {
			$('<li class="divider">').appendTo($menu); return;
		}
		var $li = $('<li>').appendTo($menu);
		var $a = $('<a href="javascript:;">').text(t.text).appendTo($li)
		.click(function() {
			$('#' + idop).val(t.op);
			$opname.text(opnames[t.op]);
		});
	});
}
Searcher.prototype.addOptListQuery = function(key, op, value) {
	if (!this.searchConfig.hasOptList(key)) return;

	op = op || "IS";
	if (op != "IS") return;

	var idkey = "qkey_" + this.nextNo,
		idop = "qop_" + this.nextNo,
		idval = "qval_" + this.nextNo;
	this.nextNo ++;
	var $row = this.addQueryCommon(key, this.viewConfig.headerOf(key), op, idkey, idop, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	$('<span class="add-on">').text("为").appendTo($div);
	var $sel = $('<select>').attr('id', idval).addClass('input-medium').appendTo($div);
	var optList = this.searchConfig.optListOf(key);
	$.each(optList, function(opt, text) {
		var $opt = $('<option>').val(opt).text(text).appendTo($sel);
		if (value == opt) $opt.attr('selected', 'selected');
	});
}
Searcher.prototype.addOptMultiQuery = function(key, op, value) {
	if (!this.searchConfig.hasOptList(key)) return;

	op = op || "IN";
	if (op != "IN") return;

	var idkey = "qkey_" + this.nextNo,
	idop = "qop_" + this.nextNo,
	idval = "qval_" + this.nextNo;
	this.nextNo ++;
	var $row = this.addQueryCommon(key, this.viewConfig.headerOf(key), op, idkey, idop, idval);

	var $div = $('<div>').css({
		display: "inline-block",
		verticalAlign: "middle",
		padding: "0 10px 4px 10px",
		marginBottom: 10,
		border: "solid 1px #ccc",
		borderRadius: 4,
	}).appendTo($row);

	var optList = this.searchConfig.optListOf(key);
	var values = value ? value.split(',') : [];
	$.each(optList, function(opt, text) {
		var $lbl = $('<label>').addClass("checkbox inline").text(text).appendTo($div);
		var $chk = $('<input type="checkbox">')
			.attr('id', idval).val(opt).prependTo($lbl);
		if ($.inArray(opt, values) != -1) $chk.attr('checked', 'checked');
	});
}
Searcher.prototype.addTagsQuery = function(key, op, value) {
	if (!this.searchConfig.hasOptList(key)) return;

	op = op || "TAGS";
	if (op != "TAGS") return;

	var idkey = "qkey_" + this.nextNo,
	idop = "qop_" + this.nextNo,
	idval = "qval_" + this.nextNo;
	this.nextNo ++;
	var $row = this.addQueryCommon(key, this.viewConfig.headerOf(key), op, idkey, idop, idval);

	var $div = $('<div>').css({
		display: "inline-block",
		verticalAlign: "middle",
		padding: "0 10px 4px 10px",
		marginBottom: 10,
		border: "solid 1px #ccc",
		borderRadius: 4,
	}).appendTo($row);

	var optList = this.searchConfig.optListOf(key);
	var values = value ? value.split(',') : [];
	$.each(optList, function(opt, text) {
		var $lbl = $('<label>').addClass("checkbox inline").appendTo($div);
		var $tag = $('<span class="label">').text(text).appendTo($lbl);
		if (text.indexOf('?') != -1) $tag.addClass('label-warning');
		if (text.indexOf('!') != -1) $tag.addClass('label-important');
		var $chk = $('<input type="checkbox">')
			.attr('id', idval).val(opt).prependTo($lbl);
		if ($.inArray(opt, values) != -1) $chk.attr('checked', 'checked');
	});
}
Searcher.prototype.addTextQuery = function(key, op, value) {
	op = op || "STR_MATCH";

	if ($.inArray(op, ["EQ", "STR_MATCH", "STR_BEGIN", "STR_END", "STR_REGEX"]) == -1) return;

	var idkey = "qkey_" + this.nextNo,
	idop = "qop_" + this.nextNo,
	idval = "qval_" + this.nextNo;
	this.nextNo ++;

	var $row = this.addQueryCommon(key, this.viewConfig.headerOf(key), op, idkey, idop, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	var opnames = {"STR_MATCH":"匹配","EQ":"为","STR_BEGIN":"开始为","STR_END":"末尾为","STR_REGEX":"正则"};
	var opmenu = [{op:"STR_MATCH",text:"匹配"}, null,{op:"EQ",text:"为"},{op:"STR_BEGIN",text:"开始为"},{op:"STR_END",text:"末尾为"},null,{op:"STR_REGEX",text:"正则表达式匹配"}];
	this.addQueryOpMenu($div, op, idop, opmenu, opnames);

	$input = $('<input type="text" class="input-small" maxlength="50">')
		.attr('id', idval).val(value).appendTo($div);
}
Searcher.prototype.addNumQuery = function(key, op, value) {
	op = op || "EQ";
	if ($.inArray(op, ["EQ", "LE", "GE"]) == -1) return;

	var idkey = "qkey_" + this.nextNo,
	idop = "qop_" + this.nextNo,
	idval = "qval_" + this.nextNo;
	this.nextNo ++;

	var $row = this.addQueryCommon(key, this.viewConfig.headerOf(key), op, idkey, idop, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	var opnames = {"EQ":"等于","GE":"至少为","LE":"最大为"};
	var opmenu = [{op:"EQ",text:"等于"},{op:"GE",text:"至少为"},{op:"LE",text:"最大为"}];
	this.addQueryOpMenu($div, op, idop, opmenu, opnames);

	$input = $('<input type="number" class="input-small" maxlength="50">')
		.attr('id', idval).val(value).appendTo($div);
}
Searcher.prototype.addDateQuery = function(key, opvalue) {
	op = op || "EQ";
	if ($.inArray(op, ["EQ", "LE", "GE"]) == -1) return;

	var idkey = "qkey_" + this.nextNo,
	idop = "qop_" + this.nextNo,
	idval = "qval_" + this.nextNo;
	this.nextNo ++;

	var $row = this.addQueryCommon(key, this.viewConfig.headerOf(key), op, idkey, idop, idval);

	var $div = $('<div class="input-prepend">').appendTo($row);

	var opnames = {"EQ":"为","GE":"不早于","LE":"不晚于"};
	var opmenu = [{op:"EQ",text:"日期为"},{op:"GE",text:"日期不早于"},{op:"LE",text:"日期不晚于"}];
	this.addQueryOpMenu($div, op, idop, opmenu, opnames);

	$input = $('<input type="text" class="input-small Wdate" maxlength="50">')
		.attr('onchange',"return $(this).valid();")
		.attr('onfocus', "WdatePicker(datePickerSettings());")
		.attr('id', idval).val(value).appendTo($div);
}
Searcher.prototype.collectQuery = function() {
	var queryList = [];
	for (var i = 0; i < this.nextNo; i++) {
		var idkey = "qkey_" + i, idop = "qop_" + i, idval = "qval_" + i;
		if ($('#' + idval).length == 0) continue;

		var key = $('#' + idkey).val();
		var op = $('#' + idop).val();
		var val = !/IN|TAGS/.test(op) ? $('#' + idval).val() :
			$.map($("[id=" + idval + "]:checked"),
					function(e) {return $(e).val()}).join(',');
		queryList.push({ key: key, op: op, val: val });
	}
	return queryList;
}
