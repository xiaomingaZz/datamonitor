<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.*" %>
<%
    String id=StringUtils.trim(request.getParameter("id"));
	String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-","");
	String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-","");
	int start = Integer.parseInt(StringUtils.trim(request.getParameter("start")));
	int limit = Integer.parseInt(StringUtils.trim(request.getParameter("limit")));
	int top = start + limit;
	
	cxsj1 = cxsj1.replace("-","");
    if("".equals(id) || "-1".equals(id)){
		id=Constant.fjm.substring(0,1);
	}

	
	JSONArray  ja=new JSONArray();
	int num=0;
	Connection conn= null;
	Statement st = null;
	Statement st2 = null; 
	ResultSet rs = null;
	String sql="select top "+top+" WJMC,PATH FROM TR_LOG  WHERE  ZT='4' AND CJRQ >='"+cxsj1+"' and CJRQ <='"+cxsj2+"'  and  FYDM like'"+id+"%'";
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		st2 = conn.createStatement();
		rs = st2.executeQuery("select count(*) from TR_LOG  WHERE   ZT='4' AND CJRQ >='"+cxsj1+"' and CJRQ <='"+cxsj2+"'  and  FYDM like'"+id+"%'");
		if(rs.next()){
			num = rs.getInt(1);
		}
		if(num>0 && num > start){
			st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
			rs=st.executeQuery(sql);
			if(start >0) rs.absolute(start);
			String xmlname="";
			int i = 0;
			while(rs.next()){
			   i++;
			   if(i >  limit) break;
				xmlname=StringUtils.trim(rs.getString("PATH")) + StringUtils.trim(rs.getString("WJMC"));
				JSONObject jo=new JSONObject();
				jo.put("AJBS", xmlname);
				ja.add(jo);
			}
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
