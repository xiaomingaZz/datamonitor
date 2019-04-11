/**
 * Filename:    extjs.js
 * Description: 通用JS 
 * Copyright:   Copyright (c)2010 
 * Company:     南京通达海信息科技有限公司
 * @author:     gezy
 * @version: 1.0 Create at: 2010-10-14 下午05:03:17
 * 
 * Modification History: Date Author Version Description
 * ------------------------------------------------------------------ 2010-10-14
 * gezy 1.0 1.0 Version
 */
ExtJs = {};
ExtJs.getContextPath = function(){
   return CONTEXT_PATH; 
};

/**
 * 消息提示框
 * @param {} message 内容
 * @param {} params 参数
 */
ExtJs.show = function(message,params){
    var cfg = {
         title:'提示',
         width:320,
         frame:true,
         msg:message||'',
         buttons : Ext.Msg.OK,
         closable:true,
         icon:Ext.MessageBox.INFO,
         fn:Ext.emptyFn(), 
         prompt:false,
         multiline:false
    };
    if(params){
       Ext.apply(cfg,params);
    }
    Ext.MessageBox.show(cfg);
};
/**
 * 消息确认框
 * @param {} confirmInfo String 确认提示
 * @param {} showResult function（btn）确认后的回调函数 参数btn
 */ 
ExtJs.confirm = function(confirmInfo,showResult){
   Ext.MessageBox.confirm('确认', confirmInfo, showResult);
};

/**
 * 消息确认框
 * @param {} confirmInfo String 确认提示
 * @param {} showResult function（btn）确认后的回调函数 参数btn
 */ 
ExtJs.alert = function(message){
   ExtJs.show(message,{title:'提示',icon:Ext.MessageBox.WARNING});
};

/**
 * 消息输入框
 * @param {} title String 标题
 * @param {} msg String 提示
 * @param {} showResult function（btn）确认后的回调函数 参数btn
 */ 
ExtJs.prompt = function(title,msg,showResult){
   Ext.MessageBox.prompt(title,msg, showResultText);
};
/**
 * 多行消息输入框
 * @param {} title String 标题
 * @param {} msg String 提示
 * @param {} showResult function（btn）确认后的回调函数 参数btn
 */ 
ExtJs.multiConfirm = function(title,msg,showResult){
   Ext.MessageBox.show({
           title: title,
           msg: msg,
           width:300,
           buttons: Ext.MessageBox.OKCANCEL,
           multiline: true,
           fn: showResult
       });
};
/**
 * 多行消息输入框
 * @param {} title String 标题
 * @param {} msg String 提示
 * @param {} showResult function（btn）确认后的回调函数 参数btn
 */ 
ExtJs.confirm3 = function(title,msg,showResult){
   Ext.MessageBox.show({
           title:title,
           msg: msg,
           buttons: Ext.MessageBox.YESNOCANCEL,
           fn: showResult,
           icon: Ext.MessageBox.QUESTION
       });
};

ExtJs.openModal = function(url, args, width, height){
    var ua = navigator.userAgent.toLowerCase();
	if (window.ActiveXObject && ua.indexOf('msie 6.') >= 0) { // IE6
	    height = height + 40;
	  }
	  var rtn = window.showModalDialog(url, args, 'dialogWidth=' + width + 'px;dialogHeight=' + height + 'px;resizeable=no;scroll=no;help=no;toolbar=no,location=no,directories=no,status=no,menubar=no');
	  return rtn;
}

ExtJs.openMaxWindow = function(url){
	 var rtn = window.open(url);
}

ExtJs.requestFail = function(){
    ExtJs.alert("请求发生异常,请联系管理员.");
}

/**
 *  AJAX 请求失败出错信息(删除)
 */ 
 
/*
Ext.Ajax.on('requestcomplete', function(conn, resp, opns){
    if(resp.getResponseHeader('exception')){
        new Ext.Window({
        	width:600,
        	height:450,
        	autoScroll:true,
        	html:resp.responseText
        }).show();
    }else if (resp.getResponseHeader('userstatus')){
        new Ext.Window({
        	width:300,
        	height:200,
        	autoScroll:true,
        	html:'登录已超时,请重新登录'
        }).show();
    }
}, this);*/