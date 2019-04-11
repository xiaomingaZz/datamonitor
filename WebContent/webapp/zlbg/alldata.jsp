<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="tdh.frame.web.context.*" %>
<%@page import="tdh.*" %>
<%@page import="tdh.util.*" %>
<%@page import="tdh.tr.*" %>
<%
	//String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
	//cxsj1 = cxsj1.replace("-","");
	//String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
	//cxsj2 = cxsj2.replace("-","");
	String id=StringUtils.trim(request.getParameter("id"));
	if("".equals(id) || "-1".equals(id)){
		id=Constant.fjm.substring(0,1);
	}
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	int total = 0;int jysb = 0,dels=0;
	try{
		StringBuilder query  = new StringBuilder();
		query.append("select count(*) ");
		query.append(" from TR_DD where  XMLTYPE='ASS' AND ISNULL(DEL,'')<>'1' AND ((ZT='4'AND JYZT='1') or ZT='3')");
		query.append(" AND FY like '"+id+"%'");
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		st=conn.createStatement();
		rs=st.executeQuery(query.toString());
		if(rs.next()){
			total = rs.getInt(1);
		}
		StringBuilder query2  = new StringBuilder();
		query2.append("select count(*) ");
		query2.append(" from TR_DD where  XMLTYPE='ASS' AND ISNULL(DEL,'')<>'1'  AND ZT='4'AND JYZT='1'");
		query2.append(" AND FY like '"+id+"%'");
		rs=st.executeQuery(query2.toString());
		if(rs.next()){
			jysb = rs.getInt(1);
		}
		rs = st.executeQuery("select count(*) from TR_DD WHERE XMLTYPE='ASS' AND (ZT = '3' OR ZT='4')  AND ISNULL(DEL,'')='1' AND FY like '"+id+"%' ");
		if(rs.next()){
			dels = rs.getInt(1);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn, st, rs);
	}
	double prec = 0;
	if(jysb >0){
		prec = ((double)(total - jysb) / total )* 100;
	}else{
		prec = 100;
	}
%>
<div style="font-size:15px;">解析案件总数:&nbsp;<%=total %>&nbsp;,校验规则失败案件数:&nbsp;<span style="color:red;"><%=jysb %></span>&nbsp;，合格率:&nbsp;<%=StringUtils.formatDouble(prec,"#0.00" )%>%&nbsp;&nbsp;删除案件数:&nbsp;<%=dels %></div>