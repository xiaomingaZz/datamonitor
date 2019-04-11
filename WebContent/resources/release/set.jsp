<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="tdh.frame.web.context.*" %>
<%@ page import="tdh.frame.common.*" %>
<%
	Connection conn = null;
	Statement st = null;
	ResultSet rs = null;
	String yhdm = WebAppContext.getCurrentUser().getYhdm();
	String yydm = WebAppContext.getAppIDEx();
	String lastrq = "";
	String type = request.getParameter("type");
	try{
		conn = WebAppContext.getFrameConn();
		st = conn.createStatement();
		
		if("1".equals(type)){
			String sql = "select max(REASLE_DATE) from T_VERSION";
			if(!WebAppContext.isFrame()){
				sql +="  where APP_ID='"+yydm+"'";
			}
			rs = st.executeQuery(sql);
			
			if(rs.next()){
				lastrq = rs.getString(1);
			}
			if(!UtilComm.isEmpty(lastrq)){
				st.executeUpdate("delete from T_VERSION_LOG where YHDM='"+yhdm+"' and APP_ID='"+yydm+"'" );
				st.executeUpdate("insert into  T_VERSION_LOG(YHDM,APP_ID,REASLE_DATE) "+
				" values('"+yhdm+"','"+yydm+"','"+lastrq+"')");
				conn.commit();
			}
		}else{
			st.executeUpdate("delete from T_VERSION_LOG where YHDM='"+yhdm+"' and APP_ID='"+yydm+"'" );
			conn.commit();
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.closeResultSet(rs);
		DBUtils.closeStatement(st);
		DBUtils.closeConnection(conn);
	}
%>
