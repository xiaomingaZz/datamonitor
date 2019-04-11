<%@ page language="java" import="java.text.*" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="tdh.frame.common.DBUtils" %>
<%@ page import="tdh.frame.web.context.WebAppContext" %>
<%
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	String yydm =  WebAppContext.getYydm();
	String yhdm =  WebAppContext.getCurrentUser().getYhdm();
	JSONArray arr = new JSONArray();
	SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	try{	
		conn = WebAppContext.getFrameConn();
		st = conn.createStatement();
		rs = st.executeQuery("select LOGINIP,LOGINTIME from TU_LOGININFO where YYDM='"+yydm+"' and YHDM='"+yhdm+"' and  DEPLOYID='"+WebAppContext.getWebConfig().getDeployid()+"' ");
		
		while(rs.next()){
			JSONObject obj = new JSONObject();
			obj.put("LOGINIP",rs.getString(1));
			obj.put("LOGINTIME",f.format(rs.getTimestamp(2)));
			arr.add(obj);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,st,rs);
	}
	out.print("{root:"+arr.toString()+"}");
%>

