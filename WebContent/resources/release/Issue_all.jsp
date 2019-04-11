<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,tdh.frame.common.*" %>
<%@ page import="tdh.frame.web.context.*" %>
<%
	//List<TApp> list =  (List<TApp>)session.getAttribute("app_list");
	String syfs = (String)session.getAttribute("syfs");
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
 %>
<!doctype html public "-//w3c//dtd html 4.01 transitional//en">
<html>
  <head>
    <title>软件更新通知</title>
    <meta http-equiv="description" content="软件发行说明">
    <style type=text/css>
		hr {
			border-right: #999999 thin dashed; border-top: #999999 thin dashed; border-left: #999999 thin dashed; border-bottom: #999999 thin dashed
		}
		.red {
			font-weight: bold; color: #cc0000
		}
		.style6 {
			color: #ffffff
		}
		body {
			margin-top: 0px;
	        margin-bottom: 0px;
			/*background-image: url(../images/11.jpg);*/
		}
		.style7 {
			color: #cc0000
		}
		.style12 {font-weight: bold; color: #012d84;font-size: 14px; }
		.style14 {color: #0349a7}
		.style15 {font-size: 12px}
		.style16 {
			color: #0349a7;
			font-size: 12px;
			font-weight: bold;
		}
		.style17 {color: #0349a7; font-size: 12px; }
		.style21 {color: #ffffff; font-size: 12px; }
		.style25 {color: #ff0000}
		.style26 {
			font-size: 16px;
			color: #ff0000;
		}
		.style28 {color: #0349a7; font-size: 14px; }
		.style32 {font-size: 12px; color: #000000;}
		
		  .kctable td {
			border-bottom-width: 1px;
			border-bottom-style: dotted;
			border-bottom-color: #2F6EA1;
		  }
		  p.detail {margin:5px 0 5px 15px;color:#111;font-size:9pt;}
		
		</style>
		
		<meta content="mshtml 6.00.2900.3492" name=generator>
		<script type="text/javascript">
		function showHistory(){
		    var appid = $("#app").val();
			window.location="Issue_list.jsp?appid="+appid;
		}
		</script>
  </head>
  <body style="margin:5px;height:100%;">
  <div style="height:30px;font-size:18px;"><b>软件更新日志</b></div>
    <%
    try{
	    String sql = "select (select APPJC from T_APP where APPID=T_VERSION.APP_ID) as JC,APP_ID,TITLE,UPDATELOG,REASLE_DATE,VERSION_MAJOR,VERSION_MINOR from T_VERSION  ";
	    if(!"1".equals(syfs)){
	    	sql +=" where APP_ID ='"+WebAppContext.getAppIDEx()+"'";
	    }
	    sql +=" order by REASLE_DATE desc";
		conn = WebAppContext.getConn();
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		while(rs.next()){
		String appid = rs.getString("APP_ID");
	  	String appjc = rs.getString("JC");
	  	if("FRAME".equals(appid)){
	  		appjc = "集成框架";
	  	}
		%>
		<div>
		<h4 style="font-size:11pt;margin:0px;text-decoration:none;background:url('../images/r_arrow.gif') no-repeat left center;padding-left:16px;">[<%=appjc %>]
			更新日期：<%=UtilComm.trim(rs.getString("REASLE_DATE"))%>
			 <em style="{font-style:normal;color:#0a0;}">版本:ver.<%= UtilComm.trim(rs.getString("VERSION_MAJOR"))%>.<%= UtilComm.trim(rs.getString("VERSION_MINOR")) %></em></h4>    
		 <table width="100%"  >
			<tr>
			<tr>
			<td style="border-bottom:1px dashed #ddd;">
			 <p class="detail"><%= UtilComm.trim(rs.getString("UPDATELOG"))%></p>
			</td>
			</tr>
		</table>
		</div>
		<%
		 
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,stmt,rs);
	} 
     %>
  </body>
</html>
