<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="tdh.frame.common.*"%>
<%@ page import="tdh.frame.web.context.*"%>
<%
	String appid = request.getParameter("appid");
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	List<Map<String,Object>> datalist = new ArrayList<Map<String,Object>>();
	try{
		String sql = "select APP_ID,(select APPMC from T_APP where APPID=T_VERSION.APP_ID) AS MC, VERSION,VERSION_MAJOR,VERSION_MINOR,REASLE_DATE from T_VERSION where APP_ID='"+appid+"' order by REASLE_DATE desc";
		conn = WebAppContext.getFrameConn();
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		while(rs.next()){
			Map<String,Object> data = new HashMap<String,Object>();
			data.put("APP_ID",UtilComm.trim(rs.getString("APP_ID")));
			data.put("MC",UtilComm.trim(rs.getString("MC")));
			data.put("VERSION",rs.getInt("VERSION"));
			data.put("VERSION_MAJOR",UtilComm.trim(rs.getString("VERSION_MAJOR")));
			data.put("VERSION_MINOR",UtilComm.trim(rs.getString("VERSION_MINOR")));
			data.put("REASLE_DATE",UtilComm.trim(rs.getString("REASLE_DATE")));
			datalist.add(data);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,stmt,rs);
	}
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>软件更新通知</title>
    <meta http-equiv="description" content="软件发行说明">
    <STYLE type=text/css>
		HR {
			BORDER-RIGHT: #999999 thin dashed; BORDER-TOP: #999999 thin dashed; BORDER-LEFT: #999999 thin dashed; BORDER-BOTTOM: #999999 thin dashed
		}
		.red {
			FONT-WEIGHT: bold; COLOR: #cc0000
		}
		.style6 {
			COLOR: #ffffff
		}
		BODY {
			MARGIN-TOP: 0px;
	        MARGIN-BOTTOM: 0px;
			background-image: url(../images/11.jpg);
		}
		.style7 {
			COLOR: #cc0000
		}
		.style12 {FONT-WEIGHT: bold; COLOR: #012d84;font-size: 14px; }
		.style14 {color: #0349a7}
		.style15 {font-size: 12px}
		.style16 {
			color: #0349a7;
			font-size: 12px;
			font-weight: bold;
		}
		.style17 {color: #0349a7; font-size: 12px; }
		.style21 {COLOR: #ffffff; font-size: 12px; }
		.style25 {color: #FF0000}
		.style26 {
			font-size: 16px;
			color: #FF0000;
		}
		.style28 {color: #0349a7; font-size: 14px; }
		.style32 {font-size: 12px; color: #000000;}
		</STYLE>
		
		<META content="MSHTML 6.00.2900.3492" name=GENERATOR>
  </head>
  <body style="margin:5px;">
    
<TABLE cellSpacing=0 cellPadding=0   width="100%" align=center bgColor=#e1effd border=0>
  <TBODY>
  <TR>
               
    <TD vAlign=top width="99%" bgColor=#f3f9fc>
    
      <TABLE class=div_d cellSpacing=0 cellPadding=0 width="100%" align=center 
      border=0>
        <TBODY>
        <TR>
          <TD bgColor=#b2d8eb>
            <TABLE cellSpacing=0 cellPadding=0 border=0 width="100%">
              <TBODY>
              <TR>
                <TD width="120" class=zzbg background="../images/zzbg.jpg">
                <IMG 
                  height=30  src="../images/rd.gif" width=25 
                  align=absMiddle><SPAN class=style12>软件更新历史</SPAN></TD>
                <TD vAlign=bottom width="40">
                   <IMG height=30 
                  src="../images/zzbgy.jpg" 
           		 width=12></TD>
            <td align="right" style="font-size:12px;"><a href="javascript:window.history.back(-1);">返&nbsp;回</a>&nbsp;&nbsp;</td>
              </TR></TBODY>
            </TABLE>
            </TD>
         </TR>
         </TBODY>
        </TABLE>
        </td></tr>
        
        <tr><td>
        
      <table class=div_d cellspacing=1 cellpadding=2 width="100%" align=center 
      bgcolor=#c1dff0>
        <tbody>
          <tr class=style14 align="middle">
            <td width=80 height=26 background="../images/zzbg.jpg"><div align="center" class="style15 style14"><strong>版本号</strong></div></td>
            <td width=* background="../images/zzbg.jpg"><div align="center" class="style16">软件名称</div></td>
            <td width=100 background="../images/zzbg.jpg"><div align="center" class="style16">发布时间</div></td>
            <td width=80 background="../images/zzbg.jpg"><div align="center" class="style16">查看详细</div></td>
          </tr>
          <%for(Map<String,Object> row : datalist){ 
            String mc = (String)row.get("MC");
          	if("FRAME".equals(appid)){
          		mc = "集成框架";
          	}
          %>
          <tr bgcolor="#FFFFFF" class="MsoNormalTable" style='mso-yfti-irow:1;height:17.25pt'>
            <td  class="style17" style='background:white;padding:1.5pt 1.5pt 1.5pt 1.5pt;height:17.25pt'>
              <p class=MsoNormal align=center style='text-align:center; color: #0349a7; font-size: 12px;'>
              <span lang=EN-US><%=row.get("VERSION_MAJOR")+"."+row.get("VERSION_MINOR") %></span></p></td>
            <td class="style17" style='background:white;padding:1.5pt 1.5pt 1.5pt 1.5pt;height:17.25pt'>
              <p class=MsoNormal style15 style14><%=mc %></p></td>
            <td class="style17" style='background:white;padding:1.5pt 1.5pt 1.5pt 1.5pt;height:17.25pt'>
              <p class=MsoNormal align=center style='text-align:center; color: #0349a7; font-size: 12px;'><span lang=EN-US><%=row.get("REASLE_DATE") %></span></p></td>
            <td class="style14" style='background:white;padding:1.5pt 1.5pt 1.5pt 1.5pt;height:17.25pt'>
              <p class=MsoNormal align=center style='text-align:center; font-size: 12px; color: #0349a7;'><span lang=EN-US>
              <a href="Issue.jsp?appid=<%=appid %>&version=<%=row.get("VERSION") %>" ><span lang=EN-US>详细</span></a></span></p></td>
          </tr>  
          <%} %>    
        </tbody>
      </table>   
         
       </TD>
  </TR></TBODY></TABLE>
  </body>
</html>
