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
	String sql="select  CJRQ,XMLNAME,ERRCODE,ERRMSG,FILENAME,FJM,ZIPNAME FROM TR_FILES  WHERE CJRQ>='"+cxsj1+"'  and CJRQ<='"+cxsj2+"'  and ERRCODE>0  and  FJM like'"+id+"%'";
	try{
		conn=WebAppContext.getNewConn("HbsjjzdataSource");
		
		st = conn.createStatement();
		rs=st.executeQuery(sql);
		while(rs.next()){
			Map<String,Object> row = new HashMap<String,Object>();
			row.put("CJRQ", rs.getString("CJRQ"));
			row.put("XMLNAME", rs.getString("XMLNAME"));
			row.put("ERRCODE", rs.getInt("ERRCODE"));
			if(rs.getInt("ERRCODE")==1){
				row.put("ERRMSG", "目录错误");
			}else{
			   row.put("ERRMSG", StringUtils.trim(rs.getString("ERRMSG")));
			}
			//row.put("ERRMSG", rs.getString("ERRMSG"));
			row.put("FILENAME", rs.getString("FILENAME"));
			row.put("FJM", rs.getString("FJM"));
			row.put("ZIPNAME", rs.getString("ZIPNAME"));
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
	VelocityUtils.write("/export_err.xml",context,request,response);
%>