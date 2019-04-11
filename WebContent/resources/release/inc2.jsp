<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="tdh.security.lic.License"%>
<%@ page import="tdh.frame.common.*"%>
<%@ page import="tdh.frame.web.util.*"%>
<%@ page import="java.sql.*"%>
<%!
	    public String  showRelease(String appid,int version){
		StringBuilder output = new StringBuilder();
		output.append("<script>");
		output.append("showVersion('"+appid+"','"+version+"');");
		output.append("</script>");
		return output.toString();
	}		
%>
<%
        StringBuilder output = new StringBuilder();
        output.append("<script>");
		output.append("function showVersion(appid,version){");
		output.append("window.open('resources/release/Issue.jsp?appid='+appid+'&version='+version+''");
		output.append(",'_blank'");
		output.append(",'width=510px, height=390px,resizable=yes,left=0px, top=0px,status=no,location=no'");
		output.append(");");
		output.append("}");
		output.append("</script>");
		out.print(output);
	//String path = request.getContextPath();
	//String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	UserBean user2 = (UserBean) session.getAttribute("user"); //当前用户信息
	License lic2 = (License)application.getAttribute(License.WEB_KEY);//注册信息
	//String  syfs = (String)session.getAttribute("syfs"); //是否框架
	//
	String productID = lic2.getProduct();
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	try{
		conn = SpringBeanUtils.getConn(request);
		stmt = conn.createStatement();
		rs = stmt.executeQuery("SELECT isnull(MAX(VERSION),0) from T_VERSION where APP_ID='"+productID+"'");
		int now_version = 0; //服务版本
		if(rs.next()){
			now_version = rs.getInt(1);
		}
		rs.close();
		if(now_version ==0){
			
		}else{
			//
			rs = stmt.executeQuery("SELECT isnull(LAST_VERSION,0),AUTO_SHOW from T_VERSION_LOG  where YHDM='"+user2.getYhdm()+"' and APP_ID='"+productID+"'");
			int my_version = 0; //用户
			String auto_show = "1";
			if(rs.next()){
				my_version = rs.getInt(1);
				auto_show =  rs.getString(2);
			}	
			
				
			if(now_version > my_version){ //需要提示
				out.print(showRelease(productID,now_version));			
			}else {	
				if("1".equals(auto_show)){
					out.print(showRelease(productID,now_version));
				}
			}
		}
	}catch(Exception  e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,stmt,rs);
	}

%>