/**
 * @author 陈举民
 * @version 1.0
 * @link http://chenjumin.javaeye.com
 */
/**
  var config = {
    id: "tg1", 数据展现table id
    width: "260", 宽度
    height:"410", 高度
    renderTo: "gntree", 父divid
    headerAlign: "left", 标题栏 居中 居左 居右
    headerHeight: "25", 标题栏高度
    trheight: "20", 数据展现table td高度
    dataAlign: "left", 数据展现table td内容 居中 居左 居右
    indentation: "15", 图片 缩进像素
    folderOpenIcon: "<%=WebUtils.getContextPath(request)%>/ext/TreeGrid/images/folderOpen.gif", 打开图片
    folderCloseIcon: "<%=WebUtils.getContextPath(request)%>/ext/TreeGrid/images/folderClose.gif", 关闭图片
    defaultLeafIcon: "<%=WebUtils.getContextPath(request)%>/ext/TreeGrid/images/defaultLeaf.gif", 叶节点图片
    hoverRowBackground: "false",
    folderColumnIndex: "0",
    itemClick: "itemClickEvent",
    //checkboxClick:"ckclick",
    //selectChange:"sechange",
    
    columns:[
    {headerText: "功能/模块", dataField: "name", headerAlign: "center",width:'170',  handler: "customOrgName"},
    {headerText: "", dataField: "refer", headerAlign: "center",width:'10', handler: "customRefer"},
    {headerText: "范围", dataField: "select",headerAlign: "center", dataAlign: "center", width: "70", handler: "customSelect"}
    ],
    data:[]
  };
*/
 
TreeGrid = function(_config){
	_config = _config || {};
	
	var s = "";
	var rownum = 0;
	var __root;
    var dataWidth ="";
	
	var __selectedData = null;
	var __selectedId = null;
	var __selectedIndex = null;

	var folderOpenIcon = (_config.folderOpenIcon || TreeGrid.FOLDER_OPEN_ICON);
	var folderCloseIcon = (_config.folderCloseIcon || TreeGrid.FOLDER_CLOSE_ICON);
	var defaultLeafIcon = (_config.defaultLeafIcon || TreeGrid.DEFAULT_LEAF_ICON);

    var htmlarr = new Array();

	//显示表头行
	drowHeader = function(){
        //s += "<div id='divHead' style=\"pading:0px 0px 0px 0px;margin-top:0px;overflow-y:hidden;width:'"+(_config.width ||'100%')+"';height:'" + (_config.headerHeight || "25") + "';background-color:#FFFFFF;border:0px solid #a4bed4;\">"
        htmlarr.push("<table height='" + (_config.headerHeight || "25") + "' style='margin-top:0px;table-layout: fixed;border-top:0px solid #a4bed4' id='gridHeader'  cellspacing='0' cellpadding='0' width='"+(_config.width)+"'  class='TreeGrid'>");
		//s += drowBz();
        htmlarr.push("<tr class='header' height='" + (_config.headerHeight || "25") + "'>");
		var cols = _config.columns;
        var dataWidth=0;
		for(i=0;i<cols.length;i++){
			var col = cols[i];
            dataWidth +=(parseInt(col.width )|| parseInt('0'));
			htmlarr.push("<td  style='border-right:1px solid #808080;border-bottom:1px solid #808080' align='" + (col.headerAlign || _config.headerAlign || "center") + "' width='" + (col.width || "") + "'>" + (col.headerText || "&nbsp;") + "</td>");
		}
        htmlarr.push("<td width='"+(parseInt(_config.width)-dataWidth)+"' style='border-bottom:1px solid #808080'>&nbsp;</td>");
		htmlarr.push("</tr>");
        htmlarr.push("</table>");
        //s +="</div>";
        return dataWidth;
	}
//控制每列宽度
    drowBz = function (){
        var trhw = '<tr style="height: auto;">';
        var cols = _config.columns;
        for(i=0;i<cols.length;i++){
            var col = cols[i];
            trhw +='<th style="height: 0px; width: '+col.width+'px"></th>'
        }
        trhw +='<tr>';

        return trhw;
    }
	
	//递归显示数据行
	drowData = function(){
		var rows = _config.data;
        if (typeof(rows) == "undefined"){
           return;
        }
		var cols = _config.columns;
		drowRowData(rows, cols, 1, "");
	}
	
	//局部变量i、j必须要用 var 来声明，否则，后续的数据无法正常显示
	drowRowData = function(_rows, _cols, _level, _pid){
		var folderColumnIndex = (_config.folderColumnIndex || 0);

		for(var i=0;i<_rows.length;i++){
			var id = _pid + "_" + i; //行id
            var row = _rows[i];
			htmlarr.push("<tr id='TR" + id + "' pid='" + ((_pid=="")?"":("TR"+_pid)) + "' open='Y' data=\"" + TreeGrid.json2str(row) + "\" rowIndex='" + rownum++ + "' height='"+(_config.trheight || "20")+"'>");
			for(var j=0;j<_cols.length;j++){
				var col = _cols[j];
				htmlarr.push("<td valign=middle width='"+(col.width || "")+"' align='" + (col.dataAlign || _config.dataAlign || "left") + "'");
				//层次缩进
				if(j==folderColumnIndex){
					htmlarr.push(" style='text-indent:" + (parseInt((_config.indentation || "20"))*(_level-1)) + "px;'> ");
				}else{
					htmlarr.push(">");
				}
				//节点图标
				if(j==folderColumnIndex){
					if(row.children&&row.children.length>0){ //有下级数据
						htmlarr.push("<img border='0' align='absbottom' folder='Y' trid='TR" + id + "' src='" + folderOpenIcon + "' class='image_hand'>");
					}else{
						htmlarr.push("<img border='0' align='absbottom' src='" + defaultLeafIcon + "' class='image_nohand'>");
					}
				}
				//单元格内容
				if(col.handler){
					htmlarr.push((eval(col.handler + ".call(new Object(), row, col)") || "") + "</td>");
				}else{
					htmlarr.push((row[col.dataField] || "") + "</td>");
				}
			}
			htmlarr.push( "</tr>");
			//递归显示下级数据
			if(row.children&&row.children.length>0){
				drowRowData(row.children, _cols, _level+1, id);
			}
		}
	}
	
	//主函数
	this.show = function(){
        __root = jQuery("#"+_config.renderTo);
        __root.css({'overflow-x':'auto','height':'100%','pading':'0px 0px 0px 0px','vertical-align': 'top','align':'left','overflow':'hidden','background':'#FFFFFF','border':'1px solid #a4bed4'});
        var h1 = parseInt(__root.attr('clientHeight'));
        var dataHeight = h1 - parseInt(_config.trheight)-5;
		s = "";
		htmlarr = new Array();
		this.id = _config.id || ("TreeGrid" + TreeGrid.COUNT++);
        dataWidth = drowHeader();

        htmlarr.push("<div id='gridData' style=\"pading:0px 0px 0px 0px;overflow:hidden;text-align:left;width:'"+(_config.width ||'100%')+"';height:'"+dataHeight+"';background:#FFFFFF;border:0px solid #a4bed4;border-top:0px solid #808080\">");
		htmlarr.push("<table style='table-layout: fixed;' id='" + this.id + "'   width='"+dataWidth+"' cellspacing=0 cellpadding=0  class='TreeGrid'>");
        htmlarr.push(drowBz());//待检查
		drowData();
		htmlarr.push("</table>");
        htmlarr.push("</div>");
        s = htmlarr.join("");
        __root.append(s);
		//初始化动作
		init();
        setScroll();
	}
 /**
 *更新数据，用新数据替换原有数据。
 *2010-08-05 刘明滨
 */
    //更新数据
    this.fresh = function(datanew){
        __root = jQuery("#"+_config.renderTo);
        __root.css({'overflow-x':'auto','height':'100%','pading':'0px 0px 0px 0px','vertical-align': 'top','align':'left','overflow':'hidden','background':'#FFFFFF','border':'1px solid #a4bed4'});
        var h1 = parseInt(__root.attr('clientHeight'));
        var dataHeight = h1 - parseInt(_config.trheight)-5;
        _config.data = datanew;
        s = "";
        htmlarr = new Array();
        drowHeader();
        htmlarr.push("<div id='gridData' style=\"float: none;overflow:hidden;text-align:left;width:'"+(_config.width ||'100%')+"';height:'"+dataHeight+"';background:#FFFFFF;border:0px solid #a4bed4;border-top:0px solid #808080\">");
        htmlarr.push("<table style='table-layout: fixed;' id='" + this.id + "' cellspacing=0 width='"+dataWidth+"' cellpadding=0 class='TreeGrid'>");
        //递归算法，结果拼在变量s中。s的巨大导致拼串的效率低下。周小伟
        drowData();
        htmlarr.push("</table>");
        htmlarr.push("</div>");
        s = htmlarr.join("");
        __root.empty();
        __root.append(s);
        //初始化动作
        init();
        setScroll();
    }

    setScroll = function(){
       var obj = document.getElementById("gridData");
       var tab = document.getElementById(_config.id);
       obj.style.width = _config.width;
       var h1 = obj.clientHeight; 
       var h2 = obj.scrollHeight; 
      if (h1 < h2) {
         obj.style.overflowY="scroll";
       } else {
         obj.style.overflowY="hidden";
       }
    }
	init = function(){
		//以新背景色标识鼠标所指行
  
        __root = jQuery("#gridData");
		if((_config.hoverRowBackground || "false") == "true"){
			__root.find("tr").hover(
				function(){
					if(jQuery(this).attr("class") && jQuery(this).attr("class") == "header") return;
					jQuery(this).addClass("row_hover");
				},
				function(){
					jQuery(this).removeClass("row_hover");
				}
			);
		}

		//将单击事件绑定到tr标签
		__root.find("tr").bind("click", function(){
			__root.find("tr").removeClass("row_active");
			jQuery(this).addClass("row_active");
			
			//获取当前行的数据
			__selectedData = this.data || this.getAttribute("data");
			__selectedId = this.id || this.getAttribute("id");
			__selectedIndex = this.rownum || this.getAttribute("rowIndex");

			//行记录单击后触发的事件
			if(_config.itemClick){
				eval(_config.itemClick + "(__selectedId, __selectedIndex, TreeGrid.str2json(__selectedData))");
			}
		});
 /**
 *将单击事件绑定到input type=checkbox
 *2010-08-05 刘明滨
 */
        //将单击事件绑定到input type=checkbox
        if(_config.checkboxClick){  
                        
            __root.find("input[type='checkbox']").bind("click", function(){
                var id = $(this).attr("id");
                eval(_config.checkboxClick+"(id,__selectedId, __selectedIndex, TreeGrid.str2json(__selectedData))");    
            });     
        }
 /**
 *将change事件绑定到input type=checkbox
 *2010-08-05 刘明滨
 */
        //将change事件绑定到select
        if(_config.selectChange){
            __root.find("select").bind("change",function(){
                var id = $(this).attr("id");
                eval(_config.selectChange+"(id,__selectedId, __selectedIndex, TreeGrid.str2json(__selectedData))");
            });     
        }
		//展开、关闭下级节点
		__root.find("img[folder='Y']").bind("click", function(){
			var trid = this.trid || this.getAttribute("trid");
			var isOpen = __root.find("#" + trid).attr("open");
			isOpen = (isOpen == "Y") ? "N" : "Y";
			__root.find("#" + trid).attr("open", isOpen);
			showHiddenNode(trid, isOpen);
            setScroll();
		});
	}

	//显示或隐藏子节点数据
	showHiddenNode = function(_trid, _open){
		if(_open == "N"){ //隐藏子节点
			__root.find("#"+_trid).find("img[folder='Y']").attr("src", folderCloseIcon);
			__root.find("tr[id^=" + _trid + "_]").css("display", "none");
		}else{ //显示子节点
			__root.find("#"+_trid).find("img[folder='Y']").attr("src", folderOpenIcon);
			showSubs(_trid);
		}
	}

	//递归检查下一级节点是否需要显示
	showSubs = function(_trid){
		var isOpen = __root.find("#" + _trid).attr("open");
		if(isOpen == "Y"){
			var trs = __root.find("tr[pid=" + _trid + "]");
			trs.css("display", "");
			
			for(var i=0;i<trs.length;i++){
				showSubs(trs[i].id);
			}
		}
	}

	//展开或收起所有节点
	this.expandAll = function(isOpen){
		var trs = __root.find("tr[pid='']");
		for(var i=0;i<trs.length;i++){
			var trid = trs[i].id || trs[i].getAttribute("id");
			showHiddenNode(trid, isOpen);
		}
	}
	
	//取得当前选中的行记录
	this.getSelectedItem = function(){
		return new TreeGridItem(__root, __selectedId, __selectedIndex, TreeGrid.str2json(__selectedData));
	}

};

//公共静态变量
TreeGrid.FOLDER_OPEN_ICON = "images/folderOpen.gif";
TreeGrid.FOLDER_CLOSE_ICON = "images/folderClose.gif";
TreeGrid.DEFAULT_LEAF_ICON = "images/defaultLeaf.gif";
TreeGrid.COUNT = 1;

//将json对象转换成字符串
TreeGrid.json2str = function(obj){
	var arr = [];

	var fmt = function(s){
		if(typeof s == 'object' && s != null){
			if(s.length){
				var _substr = "";
				for(var x=0;x<s.length;x++){
					if(x>0) _substr += ", ";
					_substr += TreeGrid.json2str(s[x]);
				}
				return "[" + _substr + "]";
			}else{
				return TreeGrid.json2str(s);
			}
		}
		return /^(string|number)$/.test(typeof s) ? "'" + s + "'" : s;
	}

	for(var i in obj){
		if(typeof obj[i] != 'object'){ //暂时不包括子数据
			arr.push(i + ":" + fmt(obj[i]));
		}
	}

	return '{' + arr.join(', ') + '}';
}

TreeGrid.str2json = function(s){
	var json = null;
	if(jQuery.browser.msie){
		json = eval("(" + s + ")");
	}else{
		json = new Function("return " + s)();
	}
	return json;
}

//数据行对象
function TreeGridItem (_root, _rowId, _rowIndex, _rowData){
	var __root = _root;
	
	this.id = _rowId;
	this.index = _rowIndex;
	this.data = _rowData;
	
	this.getParent = function(){
		var pid = jQuery("#" + this.id).attr("pid");
		if(pid!=""){
			var rowIndex = jQuery("#" + pid).attr("rowIndex");
			var data = jQuery("#" + pid).attr("data");
			return new TreeGridItem(_root, pid, rowIndex, TreeGrid.str2json(data));
		}
		return null;
	}
	
	this.getChildren = function(){
		var arr = [];
		var trs = jQuery(__root).find("tr[pid='" + this.id + "']");
		for(var i=0;i<trs.length;i++){
			var tr = trs[i];
			arr.push(new TreeGridItem(__root, tr.id, tr.rowIndex, TreeGrid.str2json(tr.data)));
		}
		return arr;
	}
};