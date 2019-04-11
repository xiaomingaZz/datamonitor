<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.VelocityUtils"%>
<%@page import="tdh.frame.web.context.*"%>
<%@ page import="tdh.framework.util.StringUtils" %>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="tdh.*" %>
<%@page import="tdh.util.*" %>
<%@page import="tdh.tr.*" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Pragma", "no-cache");
	
	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	
	String id=StringUtils.trim(request.getParameter("id"));
//	String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
//	cxsj1 = cxsj1.replace("-","");
//	String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
//	cxsj2 = cxsj2.replace("-","");
	
	String bh  = StringUtils.trim(request.getParameter("bh"));

    if("".equals(id) || "-1".equals(id)){
		id=Constant.fjm.substring(0,1);
	}
	
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	String filename="export-"+bh+".xls";
	String sql="select AJBS,AH,FY,SBYY,LARQ,JARQ FROM TR_DD WHERE XMLTYPE='ASS' and ZT='4' AND ISNULL(DEL,'')<>'1' AND JYZT='1'  and  FY like'"+id+"%' and FLAG"+MyUtils.numToStr(bh, 2)+"='1'";
	if(StringUtils.isEmpty(bh)){
		sql = "select AJBS,AH,FY,SBYY,LARQ,JARQ FROM TR_DD WHERE XMLTYPE='ASS' and ZT='4' AND ISNULL(DEL,'')<>'1' AND JYZT='1'  and  FY like'"+id+"%' ";
		filename="export.xls";
	}
	sql += " order by FY ";
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		
		st = conn.createStatement();
		rs=st.executeQuery(sql);
		int xh = 0;
		while(rs.next()){
			xh ++;
			Map<String,Object> row = new HashMap<String,Object>();
			row.put("ajbs",StringUtils.trim(rs.getString("AJBS")));
			row.put("ah",StringUtils.trim(rs.getString("AH")));
			row.put("fy",StringUtils.trim(rs.getString("FY")));
			row.put("fymc",Constant.fjmMap.get(rs.getString("FY")));
			row.put("xh",xh);
			row.put("sbyy",StringUtils.trim(rs.getString("SBYY")));
			row.put("larq",StringUtils.trim(rs.getString("LARQ")));
			row.put("jarq",StringUtils.trim(rs.getString("JARQ")));
			list.add(row);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn, st, rs);
	}
	
	response.setContentType("application/vnd.ms-excel;charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment;filename=\""+filename+"\"");
   	VelocityContext context = new VelocityContext();
   	context.put("cnts",list.size()+1);
   	context.put("cntItems",list);
	VelocityUtils.write("/gzajlist.xml",context,request,response);
%>