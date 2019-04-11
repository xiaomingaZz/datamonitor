<%@ page language="java"  pageEncoding="utf-8"%>
<%@ page import="tdh.security.lic.License" %>
<%
      License lic = (License)application.getAttribute(License.WEB_KEY);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>系统受限</title>
	<style>
		html ,body{
			margin:0px;
			text-align:center;
		}
		td{
			word-break:break-all;
			border: 1px solid #cccccc;
	        height: 24px;
		}
		.lab{
			text-align: right;
	        background-color: #E5F3FE;
		}
	</style>
  </head>
  <body background="../images/back.gif">
  <%
   String type = lic.getLicenseType();
   String mc ="正式版";
   if("Trial".equals(type))
   {
   		mc="试用版";
   }
   %>
   <br>
    <br>
     <table width="750px" border="0">
            <tr><td colspan=2 class="lab" style="text-align: center"><b>对不起，您的系统被限制访问!</b></td></tr>
            <tr><td colspan=2 style="height:60px;" align="center">出现以上页面信息，请联系通达海信息技术有限公司。</td></tr>
            <tr><td colspan=2 class="lab" style="text-align: center"><b>软件许可证书信息</b></td></tr>
       	    <tr><td class="lab" width=120 >软件名称</td><td width=630><%=lic.getProduct() %></td></tr>
       	    <tr><td class="lab">授权单位</td><td><%=lic.getUserNameDecode() %></td></tr>
       	    <tr><td class="lab">软件版本</td><td><%=mc %></td></tr>
       	    <tr><td class="lab">有效日期至</td><td><%=lic.getExpiresDate() %></td></tr>
       	    <tr><td class="lab">绑定IP</td><td>未绑定</td></tr>
       	    <tr><td class="lab">数字签名</td><td ><%=lic.getSignature() %></td></tr>
       	    <tr><td colspan=2 style="height:60px;" align="center"><a href="register.jsp">更新软件许可</a></td></tr>
       </table>
  </body>
</html>
