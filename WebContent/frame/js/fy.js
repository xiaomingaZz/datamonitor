var cxxturl = ""; //存放完整的load地址，包括当前查询条件
var imgpath  = "";

function setUrl(url){
	cxxturl = url;
}

function setImagePath(imgPath) {
	imgpath = imgPath;
}


function setCallbackFunction(fn){
	customCallbackFunction = fn;
}

var customCallbackFunction = function(){}



//start从0开始
function refsh(start){
  document.getElementById("load").style.visibility = "visible";
  document.all.start.value = start;
  if (cxxturl.indexOf("?") >= 0) {
  	url = cxxturl + "&start=" + start + "&limit=" + document.all.limit.value;
  }else{
  	url = cxxturl + "?start=" + start + "&limit=" + document.all.limit.value;
  }
  //url = url +"&ect="+new Date().getTime();
  mygrid.clearAll();
  mygrid.loadXML(url,loadCallBack);
}
//点击数字显示全部，或者在自己的页面里覆写此方法
function showAllList (obj){
  if (!obj.value || obj.value=='0') return;
  //alert(document.getElementById("totalnum").style.color);
  if (document.getElementById("totalnum").style.color!='blue') return;
  //alert(obj.value);
  document.getElementById("load").style.visibility = "visible";
  mygrid.clearAll();
  if(cxxturl.indexOf("?") <0){
  	 url = cxxturl +"?start=0&limit=0";
  }else{
  	 url = cxxturl +"&start=0&limit=0";
  }
  mygrid.loadXML(url,loadCallBack);
}
function sy_onclick(){
  var start=document.all.start.value;
  var RowCount=  document.all.totalnum.value * 1;
  var pagerows= document.all.limit.value * 1;
  var begin= start* 1;
  var PageCount=Math.ceil(RowCount / pagerows);
  var curPage=0;
  
  if(start == "0") curPage=1;
  else{
    curPage= Math.floor(begin / pagerows) +1;
  }
  if(curPage>PageCount) curPage   =   PageCount;   
    if(PageCount == 1){
      return; 
    }else{
      if(curPage > 1){
        refsh(0) ;         
      }else{
        return;   
      }
   }
}
 
function left_onclick(){
  var start=document.all.start.value;
  var RowCount=  document.all.totalnum.value * 1;
  var pagerows= document.all.limit.value * 1;
  var begin= start* 1;
  var PageCount=Math.ceil(RowCount / pagerows);
  var curPage=0;
   if(start == "0") 
     curPage=1;
   else{
     curPage= Math.floor(begin / pagerows)+1;
   }  
   if(curPage>PageCount)   curPage   =   PageCount;   
     if(PageCount == 1){
       return; 
     }else{
       if(curPage > 1){
         refsh((curPage-2)*pagerows );
       }else{
         return;       
       }
     }
}

function right_onclick(){
  var start=document.all.start.value;
  var RowCount=  document.all.totalnum.value * 1;
  var pagerows= document.all.limit.value * 1;
  var begin= start* 1;
  var PageCount=Math.ceil(RowCount / pagerows);
  var curPage=0;

  if(start == "0") curPage=1;
  else{
    curPage= Math.floor(begin / pagerows) +1;
  }  
  if(curPage>PageCount) curPage   =   PageCount;   
    if(PageCount == 1){
      return; 
    }else{
     if(curPage >= PageCount){
        return; 
     }else{
       refsh(curPage*pagerows);
     }
    }
}

function wy_onclick(){

  var start=document.all.start.value;
  var RowCount=  document.all.totalnum.value * 1;
  var pagerows= document.all.limit.value * 1;
  var begin= start* 1;
  var PageCount=Math.ceil(RowCount / pagerows);
   var curPage=0;
  if(start == "0")
    curPage=1;
  else{
    curPage= Math.floor(begin / pagerows) + 1;
  }    
  if(curPage>PageCount)   curPage   =   PageCount;   
    if(PageCount == 1){
      return; 
    }else{
      if(curPage >= PageCount){
        return; 
      }else{
        refsh((PageCount-1)*pagerows );
       }
    }
}


function loadCallBack(){
  document.all.totalnum.value=mygrid.getUserData("","totalnumber");
  afterload();
  customCallbackFunction();
}

function afterload() {
	//分页图片地址
	var sy = "";
	var left = "";
	var right = "";
	var wy = "";
  var start = document.all.start.value;//本页第一条记录
  var limit = document.all.limit.value;
  var total = document.all.totalnum.value;
  if (total == null || total == "") total = "0";
  if (start == null || start == "") start = "0";
  if (limit == null || limit == "") limit = "20";
  var rowCount = parseInt(total);//总记录数
  var pageRows = parseInt(limit);//每页最多记录数
  var pageCount = Math.ceil(rowCount/pageRows);//总页数
  var curPage = 0;//当前页号
  if (start == "0") {
    curPage = 1;
  } else {
    curPage = Math.floor(parseInt(start) / pageRows) + 1;
  }
  if (curPage > pageCount) {
    curPage = pageCount;
  }
  if (rowCount == 0 || pageCount == 1) {
    sy = imgpath +"/frame/images/left1a.gif";
    left = imgpath +"/frame/images/left2a.gif";
    right = imgpath +"/frame/images/right1a.gif";
    wy = imgpath +"/frame/images/right2a.gif";
  } else {
    if (curPage > 1) {
      sy = imgpath +"/frame/images/left1b.gif";
      left = imgpath +"/frame/images/left2b.gif";
    } else {
      sy = imgpath +"/frame/images/left1a.gif";
      left =imgpath +"/frame/images/left2a.gif";
    }
    if (curPage >= pageCount) {
      right = imgpath +"/frame/images/right1a.gif";
      wy = imgpath +"/frame/images/right2a.gif";
    } else {
      right = imgpath +"/frame/images/right1b.gif";
      wy = imgpath +"/frame/images/right2b.gif";
    }
  }

  document.getElementById("sy").src=sy; 
  document.getElementById("left").src=left;
  document.getElementById("right").src=right;
  document.getElementById("wy").src=wy;
  document.getElementById("curPage").value=curPage;
  document.getElementById("PageCount").value=pageCount;
  document.getElementById("load").style.visibility = "hidden";
}