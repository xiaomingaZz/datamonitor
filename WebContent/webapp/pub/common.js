//去掉空格
function trim(value){
  if (value) value = value.replace(/^\s*|\s*$/g,"");
  if (!value) return "";
  else return value;
}
//如果输入框中有"&"符号，替换掉
function trimstr(value){
  if (value) value = value.replace(/^\s*|\s*$/g,"");
  if (!value) return "";
  else return value = value.replace(/&/g,"");
}
//对参数编码
function encodeStr(val){
  return encodeURIComponent(encodeURIComponent(trim(val)));
}
//打开模式窗口
function openModal(url, args,width,height) {
  var ua = navigator.userAgent.toLowerCase();
  //alert(ua);
  if (window.ActiveXObject && ua.indexOf('msie 6.')>=0) {  //IE6
    height = height + 40;
    //alert('66666');
  }
  var rtn = window.showModalDialog(url,args,'dialogWidth='+width+'px;dialogHeight='+height+'px;resizeable=no;scroll=yes;status=no;help=no;');
  return rtn;
}
//最大化打开普通窗口
function openMax(url) { 
  var width = window.screen.availWidth - 10;
  var height = window.screen.availHeight - 30;
  var Left_size = (screen.width) ? (screen.width-width)/2 : 0;
  var Top_size = (screen.height) ? (screen.height-height)/2 : 0;
  window.open(url, '_blank', 'width=' + width + 'px, height=' + height + 'px, left=' + Left_size + 'px, top=' + Top_size + 'px,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes' );
}
//打开普通窗口居中，自定义大小，可最大化
function openWindow(url, width, height) {
  var Left_size = (screen.width) ? (screen.width-width)/2 : 0;
  var Top_size = (screen.height) ? (screen.height-height)/2 : 0;
  window.open(url, '_blank', 'width=' + width + 'px, height=' + height + 'px, left=' + Left_size + 'px, top=' + Top_size + 'px,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes' );
}

//以下方法用于自适应页面。设置fitHeight值,当页面宽度大于fitHeight时候，主表格宽度为fitHeight，
//否则为宽度为100%
var fitHeight = 1000;
if(!Array.prototype.map)
  Array.prototype.map = function(fn,scope) {
  var result = [],ri = 0;
  for (var i = 0,n = this.length; i < n; i++){
    if(i in this){
      result[ri++]  = fn.call(scope ,this[i],i,this);
     }
   }
   return result;
  };

var getWindowSize = function(){
  return ["Height","Width"].map(function(name){
     return window["inner"+name] ||
      document.compatMode === "CSS1Compat" && document.documentElement[ "client" + name ]
       || document.body[ "client" + name ]
    });
}
window.onload = function(){
  if(!+"\v1" && !document.querySelector) { // for IE6 IE7
     document.body.onresize = resize;
   } else { 
     window.onresize = resize;
    }
   function resize(tablename,fitheight) {
     if (document.getElementById("maintable")) {
        if(parseInt(document.body.clientWidth) > fitHeight) {
            maintable.width = fitHeight;
     } else {
            maintable.width = "100%";
     }
    }
   }
 }

//检测val是否在str中.str的格式为"xxx1,xxx2"
function inVal(val, str) {
  if (trim(val) == "") return false;
  var flag = false;
  var arr = str.split(",");
  for (var i = 0; i < arr.length; i++) {
    if (val == arr[i]) {
      flag = true;
      break;
    }
  }
  return flag;
}

function doExcel(tableid){ //读取表格中每个单元到EXCEL中
    var curTbl = document.getElementById(tableid);
    //var curTbl = show1.document.getElementById('goaler');
    var oXL = new ActiveXObject("Excel.Application");
    //创建AX对象excel
    var oWB = oXL.Workbooks.Add();
    //获取workbook对象
    var oSheet = oWB.ActiveSheet;
    //激活当前sheet
    var Lenr = curTbl.rows.length;
    //取得表格行数
    var Lenc = curTbl.rows(1).cells.length;
    //取得第一行的列数
    var k = 0;
    for (j = 0; j < Lenc; j++){
      k++ ;
      oSheet.Columns(k).ColumnWidth = curTbl.rows(0).cells(j).width / 8.2;  //设置列宽度
      if(k==3){
        oSheet.Columns(k).NumberFormatLocal="@";
      }
    }
    for (i = 0; i < Lenr; i++){
      var Lenc = curTbl.rows(i).cells.length;
      //取得每行的列数
      var k = 0;
      for (j = 0; j < Lenc; j++){
        k++ ;
        oSheet.Cells(i + 1,k).value = curTbl.rows(i).cells(j).innerText;
        oSheet.Cells(i + 1,k).Font.Size = 10;
        oSheet.Cells(i + 1,k).WrapText=true;
        if (i == 0)oSheet.Cells(i + 1,k).HorizontalAlignment = 3;
          //赋值
      }
    }
    oXL.Visible = true;
    //设置excel可见属性
  }
