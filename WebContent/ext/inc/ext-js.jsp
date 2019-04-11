<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%
  String CONTEXT_PATH =  WebUtils.getContextPath(request);
 %>
<link rel="stylesheet" type="text/css" href="<%=WebUtils.getContextPath(request)%>/ext/extjs/resources/css/ext-all.css" />
<script type="text/javascript" src="<%=WebUtils.getContextPath(request)%>/ext/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=WebUtils.getContextPath(request)%>/ext/extjs/ext-all.js"></script>
<script type="text/javascript" src="<%=WebUtils.getContextPath(request)%>/ext/extjs/ext-lang-zh_CN.js"></script>
<script>
  var CONTEXT_PATH  = '<%=CONTEXT_PATH%>';
  Ext.BLANK_IMAGE_URL = "<%=WebUtils.getContextPath(request)%>/ext/extjs/resources/images/default/s.gif";
  Ext.QuickTips.init(); 
</script>

