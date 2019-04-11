<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%
	String CONTEXT_PATH = WebUtils.getContextPath(request);
	String zlbg_ajbs = StringUtils.trim(request.getParameter("zlbg_ajbs"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>案件信息查询跟踪</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<script type="text/javascript"
	src="<%=CONTEXT_PATH%>/ext/jquery/jquery.js"></script>
<script src="<%=CONTEXT_PATH%>/ext/DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css"
	href="<%=CONTEXT_PATH%>/ext/button/style/button.css">
<link rel="stylesheet" type="text/css"
	href="<%=CONTEXT_PATH%>/ext/button/style/icon.css">
<script type="text/javascript"
	src="<%=CONTEXT_PATH%>/ext/button/script/pico-button.js"></script>
</head>
<body>
	<div>
		<table style="font-size:12px;">
			<tr>
				<td><input id="key" type="text" value="<%=zlbg_ajbs%>"
					style="width:200px;"> <input type="radio" id="c2"
					name="inbox" checked>标识 <input type="radio" id="c1"
					name="inbox">案号</td>
				<td><input type="button" value="查询" onclick="doSearch();"
					id="btnSearch" icon="icon-search" />
				</td>
			</tr>
		</table>
	</div>
	<div id="result" style="font-size:12px;"></div>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		doSearch();
	});

	function doSearch() {
		var key = $("#key").val();
		if (key == '')
			return;
		var type = "1";
		if ($("#c1").attr("checked")) {
			type = "2";
		}
		$("#result").html('正在统计...');
		$.ajax({
			type : "POST",
			url : "result.jsp",
			data : "type=" + type + "&key=" + key,
			success : function(msg) {
				$("#result").html(msg);
			}
		});
	}
	function showXML(ajbs) {
		window.open("../sjbd/xml.jsp?ajbs=" + ajbs);
	}

	function showXML2(fn) {
		window.open("xml.jsp?fn=" + fn);
	}
</script>
</html>
