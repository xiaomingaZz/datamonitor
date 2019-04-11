<%@ page language="java"  pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%
   	response.reset();
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	String ahdm = request.getParameter("ajbs");
	String xmlname = "";
	byte[] nr = null;
	try{
		 conn=WebAppContext.getNewConn("HbdcdataSource");
		 st = conn.createStatement();
		 rs = st.executeQuery("select XMLNR,XMLWJ from EAJ_XML where AHDM='"+ahdm+"'");
		 if(rs.next()){
		 	nr = rs.getBytes(1);
		 	xmlname = rs.getString(2);
		 }
	}catch(Exception e){
		 e.printStackTrace();
	}finally{
		DBUtils.closeConnection(conn);
	}
	
	if(nr == null) return;
	
	response.setContentType("text/xml"); 
    xmlname = java.net.URLEncoder.encode(xmlname, "UTF-8");
    response.setHeader("Content-disposition", "inline; filename=\"" + xmlname + "\"");
    javax.servlet.ServletOutputStream outStream = response.getOutputStream();
   

  	outStream.write(nr);
    outStream.flush();
    outStream.close();
    outStream = null;
    //response.flushBuffer();
    out.clear();
    out = pageContext.pushBody();
   
%>