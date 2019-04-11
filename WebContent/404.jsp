<%@page import="tdh.frame.web.util.RequestUtils" pageEncoding="UTF-8"%>
<%!private final static transient org.apache.commons.logging.Log logger = org.apache.commons.logging.LogFactory.getLog("404_jsp");%>
<%
	String errorUrl = RequestUtils.getErrorUrl(request);
	//boolean isContent = (errorUrl.endsWith(".html") || errorUrl.endsWith(".jsp"));
	logger.warn("Requested url not found: " + errorUrl+" Referrer: "+request.getHeader("REFERER"));
	response.setStatus(HttpServletResponse.SC_OK); 
	response.addHeader("__404_error","true");
%>
<html>
	<head>
		<title></title>
	</head>
	<body>
		<h2>找不到该页面</h2>
		<br/>
		<b>url:<%=errorUrl %></b>
	</body>
	
</html>