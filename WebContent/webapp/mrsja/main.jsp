<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat,java.util.*"%>
<%@page import="tdh.*" %>
<%
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   Calendar cal = Calendar.getInstance();
   //cal.add(Calendar.DATE,-1);
   String now = sdf.format(cal.getTime()); 
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>数据中心监控平台</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">   
	<%@include file="/ext/inc/ext-js3.jsp"%>
	<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/jquery/jquery.js"></script>
	<script type='text/javascript' src='<%=CONTEXT_PATH%>/frame/js/common.js'></script>
	<script src="<%=CONTEXT_PATH%>/ext/DatePicker/WdatePicker.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/ext/button/style/button.css">
	<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/ext/button/style/icon.css">
	<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/button/script/pico-button.js"></script>
	<script type="text/javascript">
	var defaultSj = '<%=now%>';
	var fymc = '<%=Constant.dqmc%>';
	</script>
	<script type="text/javascript" src="main.js"></script>
</head>
<body>
<div width="100%" height="50" style="display:none;">
<table id="btTable" valign="top" width="100%" height="50"   style="text-align:left;font-size:12px;border:1px solid #99BBE8;" bgcolor=#E8F7FF>
		<tr height="25" >
		  <td  colspan="2" align="center" style="border:1px solid #99BBE8;font-size:15pt;"><span color=#429EE7>数据中心每日上报收结案数统计</span>
		  </td>
		</tr>
		<tr height="25">
			<td width="240">
		 	<input type=text id=larq1 readonly  value="<%=now%>"
	              style="width: 121px"> <img id=larq1_img
	              style="vertical-Align: bottom;cursor:hand;" 
	              onclick="WdatePicker({el:'larq1'})"
	              src="<%=CONTEXT_PATH%>/frame/images/datePicker.gif">
		</td>
		<td align="left" width="3000"> 
		<input type="button"  value="查询" onclick="doSearch();" id="btnSearch" icon="icon-search" />
		</td>
		<%--<td align="right">
			<input type="button"  value="导出到Excel" onclick="downLoad();" icon="icon-excel" /> 
		</td>
		--%></tr>	
</table>
</div>
</body>
<script type="text/javascript">
function downLoad(){
	window.open("exportall.jsp?id="+fydm+"&cxsj1="+$('#larq1').val()+"&cxsj2="+$('#larq2').val());
}
</script>
</html>