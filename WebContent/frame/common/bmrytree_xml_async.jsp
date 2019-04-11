<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="tdh.frame.web.context.*"%>
<%@ page import="tdh.frame.common.*"%>
<%
  String id = request.getParameter("id");
  if(id == null ) id = "0";
  id = id.trim();
  if("".equals(id)) id ="0";
  Connection conn = null;
  Statement st = null;
  ResultSet rs = null;
  out.println("<tree id=\""+id+"\">");
  try{
  	  String sql = null;
  	  conn = WebAppContext.getFrameConn();
  	  UserBean  user = WebAppContext.getCurrentUser();
  	  st = conn.createStatement();
	  if("0".equals(id)){ //加载部门数据
	  		sql = "select BMDM,BMMC,(select count(*) from T_USER where T_DEPART.BMDM=T_USER.YHBM and isnull(SFJY,'')<>'1' ) AS CNT "
	  		+" from T_DEPART where DWDM='"+user.getFydm()+"' and isnull(FBMDM,'') ='' and  isnull(SFJY,'')<>'1' order by PXH,BMDM";
	  		rs = st.executeQuery(sql);
	  		while(rs.next()){
	  		     String bmdm = rs.getString("BMDM");
	  		     String bmmc = rs.getString("BMMC");
	  		     int cnt  = rs.getInt("CNT");
	  		     if(cnt > 0){
	  		     	 if(cnt>=1) cnt = 1;
		  			 out.println("<item id='dept"+bmdm+"' text='"+bmmc+"' child='"+cnt+"' >");
	       			 out.println("<userdata name=\"isry\">0</userdata>");
	       			 out.println("</item>");
	  		     }	  		   
	  		}
	  }else{ //读取人员信息
	  	 	sql = "select YHDM,YHXM,YHZW from T_USER where isnull(SFJY,'')<>'1' and YHBM like '"+id.substring(4)+"%'"
	  	 	+" order by PXH,YHDM";
	  	 	rs = st.executeQuery(sql);
	  	 	while(rs.next()){
	  	 		  String yhdm = rs.getString("YHDM");
	  		      String yhxm = rs.getString("YHXM");
	  		      String yhzw = rs.getString("YHZW");
	  		      out.println("<item id='"+yhdm+"' text='"+yhxm+"' >");
	  		      out.println("<userdata name=\"isry\">1</userdata>");
		   		  out.println("<userdata name=\"yhzw\">");
                  out.println(UtilComm.convertBzdm(yhzw));
				  out.println("</userdata>");
		   		  out.println("</item>");
	  	 	}
	  }
  }catch(Exception e){
  	 e.printStackTrace();
  }finally{
  		DBUtils.close(conn,st,rs);	
  }
  out.println("</tree>"); 
%>
