<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="tdh.util.VelocityUtils"%>
<%@page import="tdh.frame.web.context.*"%>
<%@ page import="tdh.framework.util.StringUtils" %>
<%@page import="java.sql.*"%>
<%@page import="tdh.frame.common.*"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="tdh.*" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	response.setHeader("Pragma", "no-cache");
	
	List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
	
	String id=StringUtils.trim(request.getParameter("id"));
	String cxsj1=StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-","");
	String cxsj2=StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-","");

    if("".equals(id) || "-1".equals(id)){
		id=Constant.fjm.substring(0,1);
	}
	
	Connection conn= null;
	Statement st = null;
	ResultSet rs = null;
	String sql="select  FYDM,CJRQ,WJMC,PATH,SBYY FROM TR_LOG  WHERE ZT='4' AND CJRQ >='"+cxsj1+"' and CJRQ <='"+cxsj2+"' and  FYDM like'"+id+"%'";
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		
		st = conn.createStatement();
		rs=st.executeQuery(sql);
		while(rs.next()){
			Map<String,Object> row = new HashMap<String,Object>();
			row.put("FYDM",StringUtils.trim(rs.getString("FYDM")));
			row.put("CJRQ",StringUtils.trim(rs.getString("CJRQ")));
			row.put("WJMC",StringUtils.trim(rs.getString("WJMC")));
			row.put("PATH",StringUtils.trim(rs.getString("PATH")));
			row.put("SBYY",StringUtils.trim(rs.getString("SBYY")));
			list.add(row);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn, st, rs);
	}
	
	response.setContentType("application/vnd.ms-excel;charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment;filename=\"export.xls\"");
   	VelocityContext context = new VelocityContext();
   	context.put("cnts",list.size()+1);
   	context.put("cntItems",list);
	VelocityUtils.write("/export_zip.xml",context,request,response);
%>