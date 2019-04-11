<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%
    String fjm = request.getParameter("fjm");
    String fn =  request.getParameter("fn");
	JSONArray  ja=new JSONArray();
	int num=0;
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	String sql="select CJRQ,XMLNAME,ERRCODE,ERRMSG,FILENAME,FJM,ZIPNAME FROM TR_FILES  WHERE FJM='"+fjm+"' and FILENAME='"+fn+"' order by CJRQ ";
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		while(rs.next()){
			JSONObject jo=new JSONObject();
			jo.put("CJRQ", rs.getString("CJRQ"));
			jo.put("XMLNAME", rs.getString("XMLNAME"));
			jo.put("ERRCODE", rs.getInt("ERRCODE"));
			if(rs.getInt("ERRCODE")==1){
				jo.put("ERRMSG", "目录错误");
			}else{
			  jo.put("ERRMSG", StringUtils.trim(rs.getString("ERRMSG")));
			}
			jo.put("FILENAME", rs.getString("FILENAME"));
			jo.put("FJM", rs.getString("FJM"));
			jo.put("ZIPNAME", rs.getString("ZIPNAME"));
			ja.add(jo);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn, st, rs);
	}
	JSONObject json=new JSONObject();
	json.put("root", ja.toString());
	json.put("totalCount", num);
	out.print(json);
%>
