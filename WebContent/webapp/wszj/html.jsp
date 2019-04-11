<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*"%>
<%
	response.reset();
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	String ajbs = request.getParameter("ajbs");
	String filename = "文书详情";
	byte[] nr = null;
	try {
		conn = WebAppContext.getNewConn("HbdcdataSource");
		st = conn.createStatement();
		rs = st.executeQuery("select JZ.NR from EAJ_SL SL,EAJ_JZ_"
				+ ajbs.substring(ajbs.length() - 1)
				+ " JZ WHERE SL.CPWSXH=JZ.XH AND SL.AHDM='" + ajbs
				+ "' AND JZ.AHDM='" + ajbs + "'");

		if (rs.next()) {
			nr = rs.getBytes(1);
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBUtils.closeConnection(conn);
	}

	if (nr == null)
		return;

	response.setContentType("text/html;charset=UTF-8");
	filename = java.net.URLEncoder.encode(filename, "UTF-8");
	response.setHeader("Content-disposition", "inline; filename=\""
			+ filename + "\"");
	javax.servlet.ServletOutputStream outStream = response
			.getOutputStream();

	outStream.write(nr);
	outStream.flush();
	outStream.close();
	outStream = null;
	//response.flushBuffer();
	out.clear();
	out = pageContext.pushBody();
%>