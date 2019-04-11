<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="tdh.frame.system.*" %>
<%@ page import="java.sql.*,tdh.frame.common.*" %>
<%@ page import="tdh.frame.web.context.*" %>
<%
	String appid = request.getParameter("appid");
	String version = request.getParameter("version");
	if(version == null || version.trim().equals("")) version = "0";
	List<TApp> list =  (List<TApp>)session.getAttribute("app_list");
	String syfs = (String)session.getAttribute("syfs");
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String updateLog ="";
	String realse_data ="";
	String major = "",minor="";
	try{
	    String sql = "select UPDATELOG,REASLE_DATE,VERSION_MAJOR,VERSION_MINOR from T_VERSION  ";
		if("0".equals(version)){
			 sql +=" group by APP_ID having APP_ID='"+appid+"' and  VERSION=MAX(VERSION)";
		}else{
			sql  +=" where APP_ID='"+appid+"' and VERSION="+version;
		}
		conn = WebAppContext.getFrameConn();
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		if(rs.next()){
		  updateLog = UtilComm.trim(rs.getString("UPDATELOG"));
		  realse_data = UtilComm.trim(rs.getString("REASLE_DATE"));
		  major = UtilComm.trim(rs.getString("VERSION_MAJOR"));
		  minor = UtilComm.trim(rs.getString("VERSION_MINOR"));
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,stmt,rs);
	} 
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
			background-image: url(../images/11.jpg);
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
      <table cellspacing=0 cellpadding=0 width="100%"  border=0 height="100%">
      <tr>
      <td height="30">
      <table  cellspacing=0 cellpadding=0 width="100%"  border=0 >
      <tr>
          <td  align="left"   height="30" style="width:80px;" background="../images/zzbg.jpg">
          　<span class="style17">软件系统
          </span>
          </td>
          <td   background="../images/zzbg.jpg" >
            <select id="app" onchange="selectApp();">
          <%for(TApp app : list){ %>
            <%if("1".equals(syfs) && "COMM".equals(app.getAppid()) ){ %>
            <option value="FRAME" <%if("FRAME".equals(appid)) out.print("selected"); %>>集成框架</option>
            <%}else if("COMM".equals(app.getAppid())){continue;}else{ %>
          	<option value="<%=app.getAppid() %>" <%if(app.getAppid().equals(appid)) out.print("selected"); %>><%=app.getAppmc() %></option>
          	<%} %>
          <%} %>
          	</select>
          </td>
          <td width="100" align="right" background="../images/zzbg.jpg">
          	<span class="style17"><a  style="cursor:hand;" 
          	 onclick="showHistory();return false;">查看历史&nbsp;</a></span>
          </td>
          </tr>
          </table>
        </td>
        </tr>

      	  <tr>              
    <td  colspan="3"  height=30  bgcolor=#f3f9fc>   
      <table class=div_d cellspacing=0 cellpadding=0 width="100%" align=center 
      border=0>
        <tbody>
        <tr>
          <td bgcolor=#b2d8eb>
            <table cellspacing=0 cellpadding=0 border=0 width="100%">
              <tbody>
              <tr>
                <td width="200">
                <img 
                  height=30 src="../images/rd.gif" width=25 
                  align=absmiddle>
                  软件更新说明
                </td>
                <td valign=bottom>&nbsp;</td>
                <td align="right" style="font-size:12px;">更新时间:<%=realse_data %> Ver.<%=major+"."+minor %></td>
              </tr>
              </tbody>
            </table>
            </td>
         </tr>
         </tbody>      
        </table>  
        </td>
        </tr>
    <tr>
	<td valign="top" colspan="3">
	<table cellspacing=0 cellpadding=2 height="100%"  width="100%" >
	  <tr>
	  <td valign=top style="font-size:13px;" >
	  <%=updateLog%>
	  </td>
	  </tr>
	</table>
	</td>
	</tr>
  </table>   

  </body>
  <script type="text/javascript" src="../../frame/js/jquery.js"></script>
   <script type="text/javascript">
    $(window).unload(function(){
    	if($("#ifshow").attr("checked")==true){
    		$.ajax({
  			type:'POST',
  			url:'do.jsp'
  			});
    	}
    });
    
    function selectApp(){
    	    var appid = $("#app").val();
			window.location="Issue.jsp?appid="+appid;
    }
  </script>
</html>
