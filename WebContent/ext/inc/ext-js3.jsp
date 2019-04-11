<%@ page language="java" pageEncoding="utf-8"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%
  String CONTEXT_PATH =  WebUtils.getContextPath(request);
 %>
<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/ext/extjs3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/ext/inc/css/icons.css" />
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/extjs3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/extjs3/ext-all.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/extjs3/ExtJs.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/extjs3/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/extjs3/ActionResult.js"></script>
<script>
  var CONTEXT_PATH  = '<%=CONTEXT_PATH%>';
  Ext.BLANK_IMAGE_URL = "<%=CONTEXT_PATH%>/ext/extjs3/resources/images/default/s.gif";
  Ext.QuickTips.init(); 
</script>

