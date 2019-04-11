<%@ page language="java"  pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
    String clsid = request.getParameter("clsid");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  </head>
  <body>
    <%
    //2代证
   	if("602B8A77-2C86-4652-8D95-6F99E8779F73".equals(clsid)){
    %>
    <OBJECT id="PLUGIN" style="display:none;" 
    classid="clsid:602B8A77-2C86-4652-8D95-6F99E8779F73" 
    codebase="<%=basePath %>/ext/icread/ICReadProj.cab#version=2,1,0,0" >
    <SPAN STYLE="color:red">不能装载2代身份证读卡器控件。请在检查浏览器的选项中检查浏览器的安全设置。</SPAN>
    </OBJECT>
    <%}else if("106E49CF-797A-11D2-81A2-00E02C015623".equals(clsid)){ %>
    <OBJECT id="PLUGIN" style="display:none;" 
    classid="clsid:106E49CF-797A-11D2-81A2-00E02C015623" 
    codebase="<%=basePath %>/ext/alttiff/alttiff.cab#version=1,9,2,1">
    <SPAN STYLE="color:red">不能装载TIFF浏览编辑控件。请在检查浏览器的选项中检查浏览器的安全设置。</SPAN>
    </OBJECT>
    <%}else if("2105C259-1E0C-4534-8141-A753534CB4CA".equals(clsid)){ %>
    <script type="text/javascript">
	var LODOP_PATH = "<%=basePath%>/ext/lodop/"
	</script>
	<script language="javascript" src="<%=basePath%>/ext/lodop/LodopFuncs.js"></script> 
	<object  id="LODOP_OB" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" width=0 height=0>  
	       <embed id="LODOP_EM" type="application/x-print-lodop" width=0 height=0></embed> 
	</object>
	<script type="text/javascript">
	LODOP=getLodop(document.getElementById('LODOP_OB'),document.getElementById('LODOP_EM'));
    </script>
    <%}else if("1663ed61-23eb-11d2-b92f-008048fdd814".equals(clsid)){
    //ScriptX %>
    <OBJECT id="PLUGIN" style="display:none;" 
    classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" 
    codebase="<%=basePath %>/ext/ScriptX/ScriptX.cab#Version=5,60,0,375" >
    <SPAN STYLE="color:red">不能装载ScriptX打印控件。请在检查浏览器的选项中检查浏览器的安全设置。</SPAN>
    </OBJECT>
    <%}else if("15D142CD-E529-4B01-9D62-22C9A6C00E9B".equals(clsid)){ 
    //WebScan%>
    <OBJECT id="PLUGIN" style="display:none;" 
    classid="clsid:15D142CD-E529-4B01-9D62-22C9A6C00E9B" 
    codebase="<%=basePath %>/ext/scan/ScanOnWeb.cab#version=1,0,0,10" >
    <SPAN STYLE="color:red">不能装载ScanOnWeb扫描控件。请在检查浏览器的选项中检查浏览器的安全设置。</SPAN>
    </OBJECT>
    <%} %>
  </body>
</html>
