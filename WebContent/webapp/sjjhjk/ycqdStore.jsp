<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="tdh.frame.web.dao.PageBean"%>
<%@page import="tdh.frame.web.dao.jdbc.PaginateJdbc"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="tdh.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.*" %>
<%
    String id=StringUtils.trim(request.getParameter("id"));
	String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
	String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
    if("".equals(id) || "-1".equals(id)){
		id=Constant.fjm.substring(0,1);
	}
    String ycyy=StringUtils.trim(request.getParameter("ycyy")); 
	JSONArray  ja=new JSONArray();
	int num=0;
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	String sql="select XMLNAME   FROM TR_DD  WHERE ZT='4' AND DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59' and  FY like'"+id+"%' and  SBYY='"+ycyy+"'";
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		st=conn.createStatement();
		rs=st.executeQuery(sql);
		String xmlname="";
		while(rs.next()){
			num++;
			xmlname=StringUtils.trim(rs.getString("XMLNAME"));
			JSONObject jo=new JSONObject();
			jo.put("XMLNAME", xmlname);
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
