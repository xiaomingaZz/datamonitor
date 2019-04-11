<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="tdh.security.lic.impl.*" %>
<%@ page import="tdh.security.lic.*" %>
<%@ page import="tdh.frame.web.log.*" %>
<%
   String signature =  request.getParameter("signature");
   LicFacotry factory  =   LicFactoryImpl.getInstance();
   License lic = factory.decodeSignature(signature);
   boolean flag = false;
   if (lic == null){
   		//Lic错误.
   }else{
       try{
   	     	factory.saveToFile(lic,factory.getLicFilePath(application));
   	     	factory.refreshLicense(lic,application);
   	     	application.setAttribute(ServerState.WEB_KEY,factory.getWebContextState(application));
   	     	flag = true;
   	   	}catch(Exception e){
   	   		Logger.error("许可认证",e);
   	   	}
   }
   if (flag){
%>
<script>
	window.location.href="register.jsp";
</script>
<%}else{ %>
<script>
	alert("无效的许可！");
	window.history.back();
</script>
<%}%>

