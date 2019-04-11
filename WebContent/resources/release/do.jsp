<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="tdh.security.lic.License"%>
<%@ page import="tdh.frame.common.*"%>
<%@ page import="tdh.frame.web.util.*"%>
<%@ page import="java.sql.*"%>
<%
    UserBean user2 = (UserBean) session.getAttribute("user"); //当前用户信息
	License lic2 = (License)application.getAttribute(License.WEB_KEY);//注册信息
	String productID = lic2.getProduct();
	//
	Connection conn = null;
	Statement stmt = null;
    ResultSet rs = null;
    int last_version = 0;
	try{
		conn = SpringBeanUtils.getConn(request);
		stmt = conn.createStatement();
		rs = stmt.executeQuery("select MAX(VERSION) as VERSION FROM T_VERSION where APP_ID='"+productID+"'");
		if(rs.next()){
			last_version = rs.getInt("VERSION");
		}
		if(last_version>0){
			stmt.addBatch("delete from T_VERSION_LOG where YHDM='"+user2.getYhdm()
			                +"' and APP_ID='"+productID+"'");
			stmt.addBatch("insert into T_VERSION_LOG(YHDM,APP_ID,LAST_VERSION,AUTO_SHOW)"
			+" values('"+user2.getYhdm()+"','"+productID+"',"+last_version+",'2')");  
			stmt.executeBatch();
			conn.commit();  
		}          	
	}catch(Exception  e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,stmt,rs);
	}
%>