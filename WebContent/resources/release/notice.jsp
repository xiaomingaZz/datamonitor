<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="tdh.frame.web.context.*" %>
<%@ page import="java.sql.*,tdh.frame.common.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  </head>
  <body>
  <div style="margin:5px;overflow-y:auto;height:100%;">
  <table width="100%" style="font-size:13px;table-layout:fixed;white-space:nowrap;">
  <%
  Connection conn = null;
  Statement stmt = null;
  ResultSet rs = null;
  try{
  	conn = WebAppContext.getFrameConn();
  	stmt = conn.createStatement();
  	String sql = "select REASLE_DATE,APP_ID,VERSION,TITLE,(select APPJC from T_APP where APPID=T_VERSION.APP_ID) as JC  from T_VERSION order by REASLE_DATE desc";
  	if(!"FRAME".equals(WebAppContext.getAppIDEx())){
  		sql = "select REASLE_DATE,APP_ID,VERSION,TITLE,(select APPJC from T_APP where APPID=T_VERSION.APP_ID) as JC  from T_VERSION  where APP_ID='"+WebAppContext.getAppIDEx()+"'  order by REASLE_DATE desc";
  	}
  	rs = stmt.executeQuery(sql);
  	int count = 0;
  	while(rs.next()){
  	count++;
  	if(count>8) break;
  	String appid = rs.getString("APP_ID");
  	String appjc = rs.getString("JC");
  	if("FRAME".equals(appid)){
  		appjc = "集成框架";
  	}
  	//int version = rs.getInt("VERSION");
  	String info = UtilComm.convertRq2(rs.getString("REASLE_DATE"))+":["+appjc+"]"+rs.getString("TITLE");
 %>
    <tr>
      <td style="height:20px;overflow:hidden;white-space:nowrap;text-overflow: ellipsis;-o-text-overflow: ellipsis">
      <%=info%></td>
    </tr>
 <%
   }
  }catch(Exception e)
  {
      e.printStackTrace();
  }finally{
  	DBUtils.close(conn,stmt,rs);
  }
%>
</table>
</div>
  </body>
</html>
