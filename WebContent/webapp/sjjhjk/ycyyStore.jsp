<%@page import="tdh.framework.util.StringUtils"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
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
	JSONArray  ja=new JSONArray();
	int num=0;
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	String sql="select SBYY,count(*) AS SL  FROM TR_DD  WHERE ZT='4' AND DDSJ>= '"+cxsj1+" 00:00:00' AND DDSJ<='"+cxsj2+" 23:59:59' and  FY like'"+id+"%' group by SBYY ";
	//System.out.println(sql);
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		st=conn.createStatement();
		rs=st.executeQuery(sql);
		String ycyy="";
		String sl="";
		while(rs.next()){
			num++;
			ycyy=StringUtils.trim(rs.getString("SBYY"));
			if("".equals(ycyy)) continue;
			sl=StringUtils.trim(rs.getString("SL"));
			if(sl.equals("")){
				sl="0";
			}
			JSONObject jo=new JSONObject();
			jo.put("YCYY", ycyy);
			jo.put("YCS", sl);
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
