<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="tdh.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.frame.system.*" %>
<%@page import="tdh.*" %>
<%
String rootid = Constant.fjm;
String dqmc = Constant.dqmc;
JSONArray faArr = new JSONArray();
Connection conn= null;
Statement st = null;
ResultSet rs = null;
try{
	JSONObject root = new JSONObject();
	JSONArray  zyArr = new JSONArray();
	conn = WebAppContext.getNewConn("HbsjjzdataSource");
	st = conn.createStatement();
	rs = st.executeQuery("select DM_CITY,NAME_CITY FROM T_CITY where DM_CITY like '"+rootid.substring(0,1)+"%' order by DM_CITY");
	while(rs.next()){
		JSONObject json = new JSONObject();
		json.put("id", rs.getString("DM_CITY"));
		json.put("text", rs.getString("NAME_CITY"));
		json.put("leaf", true);
		json.put("fl", "fy");
		zyArr.add(json);
	}
	root.put("id", rootid.substring(0,1));
	root.put("expanded", true);
	root.put("text", dqmc);
	root.put("children", zyArr.toArray());
	faArr.add(root);
}catch(Exception e){
	e.printStackTrace();
}finally{
	DBUtil.closeConn(conn);
}
out.print(faArr.toString());
%>