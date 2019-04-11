//check.js tdhFrame 提供，不得修改
//周小伟 20130704

// 主键通常由数字和字母组成
function checkPK(value) {
  var exp = /^[a-zA-Z0-9]*$/
  var objExp = new RegExp(exp);
  if (objExp.test(value) == true) {
    return true;
  }
  return false;
}
function checkInt(value) {
  var exp = /^(([1-9][0-9]*)|[0-9])$/
  var objExp = new RegExp(exp);
  if (objExp.test(value) == true) {
    return true;
  }
  return false;
}
// 检查字符串长度
function checklen(str, len) {
  var i = 0;
  var sunlen = 0;
  for (i = 0; i < str.length; i++) {
    if (str.charCodeAt(i) > 255) {
      sunlen += 2;
    } else {
      sunlen += 1;
    }
    if (sunlen > len) {
      return false;
    }

  }
  return true;
}
// 统计字符串中某字符的个数
function countChar(strAll, charOne) {
  var count = 0;
  for (var i = 0; i < strAll.length; i++) {
    var _char = strAll.charAt(i);
    if (_char == charOne) {
      count++;
    }
  }
  return count;
}

function onlyNum() {
  if (event.shiftKey)
    event.returnValue = false;
  else
  // 第一个if定义除数字外可响应的键,如46对应Delete键,若要响应Tab键,可在后面加上&&!(event.keyCode==9),若要允许输入小数点,则可加上&&!(event.keyCode==190),其它类似
  if (!(event.keyCode == 46) && !(event.keyCode == 8) && !(event.keyCode == 37) && !(event.keyCode == 39))
    // 第二个if定义要响应的数字键,||前面的是响应左边键盘对应的数字,后面是响应小键盘上的数字
    if (!((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105)))
      event.returnValue = false;
}

// 只可以输入数字与小数点(包括小键盘和主键盘)
function numWithDot() {
  if ((event.keyCode == 110 || event.keyCode == 190) && this.value && this.value.indexOf('.') >= 0)
    event.returnValue = false;
  if (!(event.keyCode == 46) && !(event.keyCode == 8) && !(event.keyCode == 37) && !(event.keyCode == 39) && !(event.keyCode == 190) && !(event.keyCode == 110))
    if (!((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105)))
      event.returnValue = false;
}

function clearNoNum(obj) { // 使用方法 onkeyup="clearNoNum(this)"
  // 先把非数字的都替换掉，除了数字和.
  obj.value = obj.value.replace(/[^\d.]/g, "");
  // 必须保证第一个为数字而不是.
  obj.value = obj.value.replace(/^\./g, "");
  // 保证只有出现一个.而没有多个.
  obj.value = obj.value.replace(/\.{2,}/g, ".");
  // 保证.只出现一次，而不能出现两次以上
  obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
}

var aCity = {
  11 : "北京",
  12 : "天津",
  13 : "河北",
  14 : "山西",
  15 : "内蒙古",
  21 : "辽宁",
  22 : "吉林",
  23 : "黑龙江",
  31 : "上海",
  32 : "江苏",
  33 : "浙江",
  34 : "安徽",
  35 : "福建",
  36 : "江西",
  37 : "山东",
  41 : "河南",
  42 : "湖北",
  43 : "湖南",
  44 : "广东",
  45 : "广西",
  46 : "海南",
  50 : "重庆",
  51 : "四川",
  52 : "贵州",
  53 : "云南",
  54 : "西藏",
  61 : "陕西",
  62 : "甘肃",
  63 : "青海",
  64 : "宁夏",
  65 : "新疆",
  71 : "台湾",
  81 : "香港",
  82 : "澳门",
  91 : "国外"
}
function checkzjh(sId) {
  if (sId == "")
    return;
  var iSum = 0;
  var info = "";
  var msg = "";
  if (!/^\d{17}(\d|x)$/i.test(sId)) {
    msg = "身份证输入有误";
  }
  sId = sId.replace(/x$/i, "a");
  if (aCity[parseInt(sId.substr(0, 2))] == null) {
    msg = "身份证输入有误";
  }
  sBirthday = sId.substr(6, 4) + "-" + Number(sId.substr(10, 2)) + "-" + Number(sId.substr(12, 2));
  var d = new Date(sBirthday.replace(/-/g, "/"))
  if (sBirthday != (d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate())) {
    msg = "身份证输入有误";
  }
  for (var i = 17; i >= 0; i--)
    iSum += (Math.pow(2, i) % 11) * parseInt(sId.charAt(17 - i), 11)
  if (iSum % 11 != 1) {
    msg = "身份证输入有误";
  }
  return msg;
}
// 控制text中输入的仅为数字
function keyPress() {
  // var keyCode = event.keyCode;
  if ((String.fromCharCode(event.keyCode) >= '0' && String.fromCharCode(event.keyCode) <= '9')) {
    event.returnValue = true;
  } else {
    event.returnValue = false;
  }
}
// 检查字符串中是否含有非数字的字符
function checkdigitString(rq) {
  if (rq.indexOf(".") == 0) {
    return false;
  }
  var i;
  for (i = 0; i < rq.length; i++) {
    if (isNaN(rq.charAt(i))) {
      if (rq.charAt(i) == ".") {
        continue;
      }
      return false;
    }
  }
  return true;
}

function isChinaIDCard(StrNo) {
  StrNo = StrNo.toString();
  if (StrNo.length == 15) {
    if (!isValidDate("19" + StrNo.substr(6, 2), StrNo.substr(8, 2), StrNo.substr(10, 2))) {
      return false;
    }
  } else if (StrNo.length == 18) {
    if (!isValidDate(StrNo.substr(6, 4), StrNo.substr(10, 2), StrNo.substr(12, 2))) {
      return false;
    }
  } else {
    alert("输入的身份证号码必须为15位或者18位！");
    return false;
  }

  if (StrNo.length == 18) {
    var a, b, c
    if (!isNumber(StrNo.substr(0, 17))) {
      alert("身份证号码错误,前17位不能含有英文字母！");
      return false;
    }
    a = parseInt(StrNo.substr(0, 1)) * 7 + parseInt(StrNo.substr(1, 1)) * 9 + parseInt(StrNo.substr(2, 1)) * 10;
    a = a + parseInt(StrNo.substr(3, 1)) * 5 + parseInt(StrNo.substr(4, 1)) * 8 + parseInt(StrNo.substr(5, 1)) * 4;
    a = a + parseInt(StrNo.substr(6, 1)) * 2 + parseInt(StrNo.substr(7, 1)) * 1 + parseInt(StrNo.substr(8, 1)) * 6;
    a = a + parseInt(StrNo.substr(9, 1)) * 3 + parseInt(StrNo.substr(10, 1)) * 7 + parseInt(StrNo.substr(11, 1)) * 9;
    a = a + parseInt(StrNo.substr(12, 1)) * 10 + parseInt(StrNo.substr(13, 1)) * 5 + parseInt(StrNo.substr(14, 1)) * 8;
    a = a + parseInt(StrNo.substr(15, 1)) * 4 + parseInt(StrNo.substr(16, 1)) * 2;
    b = a % 11;
    if (b == 2) // 最后一位为校验位
    {
      c = StrNo.substr(17, 1).toUpperCase(); // 转为大写X
    } else {
      c = parseInt(StrNo.substr(17, 1));
    }
    switch (b) {
      case 0 :
        if (c != 1) {
          alert("身份证号码校验位错:最后一位应该为:1");
          return false;
        }
        break;
      case 1 :
        if (c != 0) {
          alert("身份证号码校验位错:最后一位应该为:0");
          return false;
        }
        break;
      case 2 :
        if (c != "X") {
          alert("身份证号码校验位错:最后一位应该为:X");
          return false;
        }
        break;
      case 3 :
        if (c != 9) {
          alert("身份证号码校验位错:最后一位应该为:9");
          return false;
        }
        break;
      case 4 :
        if (c != 8) {
          alert("身份证号码校验位错:最后一位应该为:8");
          return false;
        }
        break;
      case 5 :
        if (c != 7) {
          alert("身份证号码校验位错:最后一位应该为:7");
          return false;
        }
        break;
      case 6 :
        if (c != 6) {
          alert("身份证号码校验位错:最后一位应该为:6");
          return false;
        }
        break;
      case 7 :
        if (c != 5) {
          alert("身份证号码校验位错:最后一位应该为:5");
          return false;
        }
        break;
      case 8 :
        if (c != 4) {
          alert("身份证号码校验位错:最后一位应该为:4");
          return false;
        }
        break;
      case 9 :
        if (c != 3) {
          alert("身份证号码校验位错:最后一位应该为:3");
          return false;
        }
        break;
      case 10 :
        if (c != 2) {
          alert("身份证号码校验位错:最后一位应该为:2");
          return false;
        }
    }
  } else {// 15位身份证号
    if (!isNumber(StrNo)) {
      alert("身份证号码错误,前15位不能含有英文字母！");
      return false;
    }
  }
  return true;
}

function isValidDate(iY, iM, iD) {
  if (iY > 2200 || iY < 1900 || !isNumber(iY)) {
    alert("输入身份证号,年度" + iY + "非法！");
    return false;
  }
  if (iM > 12 || iM <= 0 || !isNumber(iM)) {
    alert("输入身份证号,月份" + iM + "非法！");
    return false;
  }
  if (iD > 31 || iD <= 0 || !isNumber(iD)) {
    alert("输入身份证号,日期" + iD + "非法！");
    return false;
  }
  return true;
}
/**
 * 验证是不是数字
 */
function isNumber(oNum) {
  if (!oNum)
    return false;
  var strP = /^\d+(\.\d+)?$/;
  if (!strP.test(oNum))
    return false;
  try {
    if (parseFloat(oNum) != oNum)
      return false;
  } catch (ex) {
    return false;
  }
  return true;
}
/**
 * 模糊查询中用户输入通配符情况
 */
function getsql(sql) {
  var tpstr = "%,_,[,]";
  var a = tpstr.split(",");
  var temp = "";
  for (i = 0; i < a.length; i++) {
    sql = replaceAll(sql, a[i], "/" + a[i]);
    // sql = sql.replace(new RegExp(temp,"gm"),"/" + temp);
    // sql = sql.replace(new RegExp(a[0],"gm"),"/" + a[0]);
  }
  sql = replaceAll(sql, "'", "''");
  return sql;
}

function replaceAll(str, a, b) {
  var strlen = str.length;
  var temp = "", temp1 = str;
  var tempindex;
  var alen = a.length, blen = b.length;
  var aindex = str.indexOf(a)
  str += a;
  // alert(aindex)
  if (aindex >= 0) {
    temp += str.substring(0, aindex)
    // alert("temp:"+temp)

    while (aindex < strlen) {
      tempindex = aindex;
      aindex = aindex + alen + str.substring(aindex + alen).indexOf(a)
      // alert(tempindex + alen+","+aindex )
      temp += b + str.substring(tempindex + alen, aindex)
      // alert(aindex)
    }
  }
  if (temp == "")
    temp = temp1;
  return temp;
}

// 验证身份证号码、出生日期、性别
function checkCsrqXb(sfzhm, csrq, xb) {
  var tongguo = true;
  if (sfzhm) {
    if (csrq) {
      var birthday;
      if (sfzhm.length == 15) {
        birthday = new Date(sfzhm.substr(6, 2), sfzhm.substr(8, 2) - 1, sfzhm.substr(10, 2));
      } else if (sfzhm.length == 18) {
        birthday = new Date(sfzhm.substr(6, 4), sfzhm.substr(10, 2) - 1, sfzhm.substr(12, 2));
      } else {
        alert("身份证号码格式不对！");
        return false;
      }
      if (csrq != dateToStr(birthday)) {
        alert("出生日期跟身份证号码不一致！");
        tongguo = false;
      }
    }
    if (Number(sfzhm.slice(14, 17)) % 2 && xb == "09_00003-2") {
      alert("性别跟身份证号码不一致！");
      tongguo = false;
    }
  }
  return tongguo;
}

function isValidStr( inStr,name ){
  if(inStr.indexOf("\\") != -1){
    alert( name + "不能包含反斜杠\符号！");
    return false;
  }
  var ignoreStr="'\"<>#$%^&*+";
  for(i=0;i<inStr.length;i++){
    if(ignoreStr.indexOf(inStr.substring(i,i+1)) != -1){
      alert( name + "不能包含'和\"以及<>#$%^&*+符号，请重新输入！");
      return false;
    }
  }
  return true;
}

// 手机号码校验，进检测1开头和11位
function checkMobile(s) {
  // var regu =/^[1][3,5][0-9]{9}$/; //限定 13 15开头手机
  var regu = /^[1][0-9]{10}$/;
  var re = new RegExp(regu);
  if (re.test(s)) {
    return true;
  } else {
    return false;
  }
}

/* 填写金额 */
function check_double(obj) {
  if (obj.value != '') {
    var reg = /^[-\+]?\d+(\.\d+)?$/;
    if (!obj.value.match(reg)) {
      alert("请填写数字！");
      obj.focus();
      return false;
    }
  }
  return true;
}


/* 填写整数 */
function check_int(obj) {
  if (obj.value != '') {
    var reg = /^[-\+]?\d+$/;
    if (!obj.value.match(reg)) {
      alert("请填写数字！");
      obj.focus();
      return false;
    }
  }
  return true;
}



/*
 * 处理过长的字符串，截取并添加省略号 注：半角长度为1，全角长度为2
 * 
 * pStr:字符串 pLen:截取长度
 * 
 * return: 截取后的字符串
 */
function autoAddEllipsis(pStr, pLen) {

  var pStr;
  var len = lenReg(pStr);
  if (len > pLen) {
    pStr = cutString(pStr, pLen) + "...";
  }
  pStr = pStr.replace(/,/g,'');
  return pStr;
}

// 求字节数
function lenReg(str) {
  return str.replace(/[^\x00-\xFF]/g, '**').length;
};
//按字节截取字符串
function cutString(orignal, count) {
  // 原始字符不为null，也不是空字符串 
  // 将原始字符串转换为utf-8编码格式 
  // orignal = new String(orignal.getBytes(), "utf-8"); 
  // 要截取的字节数大于0，且小于原始字符串的字节数 
  if (count > 0 && count < lenReg(orignal)) {

    var buff = [];
    var c;
    for (var i = 0; i < count; i++) {

      c = orignal.charAt(i);

      buff.push(c);

      if (lenReg(c) > 1) {
        // 遇到中文汉字，截取字节总数减1 
        --count;
      }
    }

    return buff.toString();
  }

  return orignal;
}
