//common.js tdhFrame 提供，不得修改
//周小伟 20130705

// 去掉空格
function trim(value) {
  if (value)
    value = value.replace(/^\s*|\s*$/g, "");
  if (!value)
    return "";
  else
    return value;
}
// 如果输入框中有"&"符号，替换掉
function trimstr(value) {
  if (value)
    value = value.replace(/^\s*|\s*$/g, "");
  if (!value)
    return "";
  else
    return value = value.replace(/&/g, "");
}
// 对参数编码
function encodeStr(val) {
  return encodeURIComponent(encodeURIComponent(trim(val)));
}
// 打开模式窗口
function openModal(url, args, width, height) {
  var ua = navigator.userAgent.toLowerCase();
  if (!width) {
    var width = window.screen.availWidth - 10;
  }

  if (!height) {
    var height = window.screen.availHeight - 30;
  } else {
    if (window.ActiveXObject && ua.indexOf('msie 6.') >= 0) { // IE6
      height = height + 40;
    }
  }

  if (!args) args = "";

  var rtn = window.showModalDialog(url, args, 'dialogWidth=' + width + 'px;dialogHeight=' + height + 'px;resizeable=no;scroll=no;status=no;help=no;');
  return rtn;
}
// 最大化打开普通窗口
function openMax(url) {
  var width = window.screen.availWidth - 10;
  var height = window.screen.availHeight - 30;
  var Left_size = (screen.width) ? (screen.width - width) / 2 : 0;
  var Top_size = (screen.height) ? (screen.height - height) / 2 : 0;
  window.open(url, '_blank', 'width=' + width + 'px, height=' + height + 'px, left=' + Left_size + 'px, top=' + Top_size + 'px,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
}
// 打开普通窗口居中，自定义大小，可最大化
function openWindow(url, width, height) {
  var Left_size = (screen.width) ? (screen.width - width) / 2 : 0;
  var Top_size = (screen.height) ? (screen.height - height) / 2 : 0;
  window.open(url, '_blank', 'width=' + width + 'px, height=' + height + 'px, left=' + Left_size + 'px, top=' + Top_size + 'px,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
}

// 以下方法用于自适应页面。设置fitHeight值,当页面宽度大于fitHeight时候，主表格宽度为fitHeight，
// 否则为宽度为100%
var fitHeight = 1000;
if (!Array.prototype.map)
  Array.prototype.map = function(fn, scope) {
    var result = [], ri = 0;
    for (var i = 0, n = this.length; i < n; i++) {
      if (i in this) {
        result[ri++] = fn.call(scope, this[i], i, this);
      }
    }
    return result;
  };

var getWindowSize = function() {
  return ["Height", "Width"].map(function(name) {
        return window["inner" + name] || document.compatMode === "CSS1Compat" && document.documentElement["client" + name] || document.body["client" + name]
      });
}
window.onload = function() {
  if (!+"\v1" && !document.querySelector) { // for IE6 IE7
    document.body.onresize = resize;
  } else {
    window.onresize = resize;
  }
  function resize(tablename, fitheight) {
    if (document.getElementById("maintable")) {
      if (parseInt(document.body.clientWidth) > fitHeight) {
        maintable.width = fitHeight;
      } else {
        maintable.width = "100%";
      }
    }
  }
}

// 检测val是否在str中.str的格式为"xxx1,xxx2"
function inVal(val, str) {
  if (trim(val) == "")
    return false;
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
// 页面设置为可读
function setPageRead() {
  var inputs = document.getElementsByTagName("INPUT");
  for (var i = 0; i < inputs.length; i++) {
    inputs[i].disabled = true;
  }
  var selects = document.getElementsByTagName("SELECT");
  for (var i = 0; i < selects.length; i++) {
    selects[i].disabled = true;
  }
  var imgs = document.getElementsByTagName("IMG");
  for (var i = 0; i < imgs.length; i++) {
    imgs[i].disabled = true;
  }
  var textareas = document.getElementsByTagName("TEXTAREA");
  for (var i = 0; i < textareas.length; i++) {
    textareas[i].disabled = true;
  }
  var as = document.getElementsByTagName("A");
  for (var i = 0; i < as.length; i++) {
    as[i].disabled = true;
    as[i].onclick = "";
  }
}

// 日期转string
function dateToStr(datetime) {
  var year = datetime.getFullYear();
  var month = datetime.getMonth() + 1;// js从0开始取
  var date = datetime.getDate();

  if (month < 10) {
    month = "0" + month;
  }
  if (date < 10) {
    date = "0" + date;
  }

  var time = year + "-" + month + "-" + date; // 2009-06-12
  return time;
}

// 时间字符串2011-01-01, 转换成Date
function strToDate(str) {
  if (!str) return null;

  var mydate = new Date();
  mydate.setFullYear(parseInt(str.split("-")[0], 10));
  mydate.setMonth(parseInt(str.split("-")[1], 10) - 1);
  mydate.setDate(parseInt(str.split("-")[2], 10));

  return mydate;
}

// Date 加减
function dateAdd(mydate, type, add) {
  if (type="dd") { // 天
    mydate.setDate(mydate.getDate()+add)
  }
  return mydate;
}
