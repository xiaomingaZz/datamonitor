<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="tdh.frame.web.context.*" %>
<%@ page import="tdh.frame.common.UUID,tdh.frame.common.DBUtils" %>
<%
	String users = request.getParameter("users");
	System.out.println(users);
	//往T_SYS_PROMPTS表里面存入信息
	Connection conn = null;
	Statement st = null;
	try{
		conn = WebAppContext.getFrameConn();
		conn.setAutoCommit(false);
		st = conn.createStatement();
		st.execute("delete from T_SYS_PROMPTS where APPID='TEST' AND XXLX='测试'");
		st.execute("insert into T_SYS_PROMPTS (LSHM,APPID,XXLX,JSRR,XXNR,LASTUPDATE)"
		+" values('"+UUID.genUuid()+"','TEST','测试','3201000001','您有&nbsp;<span style=\"color:red\">2</span>条待办事项!',getdate())");
		st.execute("insert into T_SYS_PROMPTS (LSHM,APPID,XXLX,JSRR,XXNR,LASTUPDATE)"
		+" values('"+UUID.genUuid()+"','TEST','测试','3201000001','您有&nbsp;<span style=\"color:red\">3</span>条待办事项!',getdate())");
		conn.commit();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.closeStatement(st);
		DBUtils.closeConnection(conn);
	}
	
%>