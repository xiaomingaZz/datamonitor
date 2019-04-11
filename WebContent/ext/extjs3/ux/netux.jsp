<%@ page language="java" pageEncoding="UTF-8"%>
<%
    final String  CONTEXT_PATHnetux = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
%>
<script type="text/javascript">
  var CONTEXT_PATHnetux ='<%=CONTEXT_PATHnetux %>';
</script>
<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATHnetux %>/ext/extjs3/ux/netux.css" rel="stylesheet" />
<script type="text/javascript" src="<%=CONTEXT_PATHnetux %>/ext/extjs3/ux/netux.js"></script>
<script>
Ext.BLANK_IMAGE_URL = CONTEXT_PATHnetux + '/ext/extjs3/resources/images/default/s.gif';
</script>