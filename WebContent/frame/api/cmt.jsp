<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="tdh.frame.api.TDHMessengerClient" %>
<%
	String jsr = request.getParameter("jsr");
	String title = request.getParameter("title");
	String nr = request.getParameter("nr");
	String fydm = request.getParameter("fydm");
	
	TDHMessengerClient  client = new TDHMessengerClient();
	if(client.SendMessage(fydm,jsr,title,nr)){
		out.print("<script>alert('发送成功!');window.location.href='THDMessageExample.jsp';</script>");
	}else{
	    out.print("<script>alert('发送失败!');window.location.href='THDMessageExample.jsp';</script>");
	}
%>
