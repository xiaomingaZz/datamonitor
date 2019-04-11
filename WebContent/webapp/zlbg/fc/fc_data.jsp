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
String bh  = request.getParameter("bh");

int start = Integer.parseInt(StringUtils.trim(request.getParameter("start")));
int limit = Integer.parseInt(StringUtils.trim(request.getParameter("limit")));
int top = start + limit;

JSONArray  ja=new JSONArray();
int num=0;
Connection conn= null;
Statement st = null;
Statement st2 = null;
ResultSet rs = null;
String sql="select top "+top+" AJBS,AH,FY,SBYY,LARQ,JARQ FROM TR_DD WHERE XMLTYPE='ASS' and ZT='4' AND ISNULL(DEL,'')<>'1' AND JYZT='1'  and  FY like'"+id+"%' and FLAG"+MyUtils.numToStr(bh, 2)+"='1' ORDER BY FY";
String sql2="select count(*) from TR_DD  WHERE XMLTYPE='ASS' and  ZT='4' AND ISNULL(DEL,'')<>'1' AND JYZT='1'   and  FY like'"+id+"%' and FLAG"+MyUtils.numToStr(bh, 2)+"='1'";
if(StringUtils.isEmpty(bh)){
	sql="select top "+top+" AJBS,AH,FY,SBYY,LARQ,JARQ FROM TR_DD WHERE XMLTYPE='ASS' and  ZT='4' AND ISNULL(DEL,'')<>'1' AND JYZT='1'  and  FY like'"+id+"%'  ORDER BY FY";	
    sql2="select count(*) from TR_DD  WHERE XMLTYPE='ASS' and  ZT='4' AND ISNULL(DEL,'')<>'1' AND JYZT='1'  and  FY like'"+id+"%'";
}
//System.out.println(sql);
try{
	conn=WebAppContext.getNewConn("HbsjjzdataSource");
	st2 = conn.createStatement();
	rs = st2.executeQuery(sql2);
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
			JSONObject jo=new JSONObject();
			jo.put("AJBS", rs.getString("AJBS"));
			jo.put("AH", rs.getString("AH"));
			jo.put("FY", rs.getString("FY"));
			jo.put("SBYY", rs.getString("SBYY"));
			jo.put("LARQ",rs.getString("LARQ"));
			jo.put("JARQ",rs.getString("JARQ"));
			jo.put("FYMC", Constant.fjmMap.get(rs.getString("FY")));
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