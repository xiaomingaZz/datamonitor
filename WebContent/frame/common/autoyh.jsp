<%@ page language="java" import="java.sql.*" pageEncoding="UTF-8"%>
<%@page import="tdh.frame.web.context.*,tdh.frame.common.*,java.net.URLDecoder;"%> 
<% 
   String q = request.getParameter("q");
   if(q == null) q = ""; 
   q = URLDecoder.decode(q,"utf-8"); 
   q  = "%"+q.toLowerCase()+"%";
   Connection conn = null;
   PreparedStatement stmt = null;
   ResultSet rs = null;
   String fydm = WebAppContext.getCurrentFydm();
   try{
   		String sql = "select top 20 YHXM,YHDM from T_USER where DWDM='"+fydm+"' and isnull(SFJY,'')<> '1' and YHXM like ? or XMSZM like ? or XMQP like ? order by YHXM";
   		conn = WebAppContext.getFrameConn();
   		stmt = conn.prepareStatement(sql);
   		stmt.setString(1,q);
   		stmt.setString(2,q);
   		stmt.setString(3,q);
   		rs = stmt.executeQuery();
   		while(rs.next()){
   			out.print(rs.getString("YHXM")+"|"+rs.getString("YHDM")+"\n");
   		}
   }catch(Exception e){
   		e.printStackTrace();
   }finally{
   	    DBUtils.close(conn,stmt,rs);
   }
%> 