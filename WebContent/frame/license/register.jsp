<%@ page language="java"  pageEncoding="utf-8"%>
<%@ page import="tdh.security.lic.License" %>
<%@ page import="tdh.security.lic.ServerState" %>
<%
      License lic = (License)application.getAttribute(License.WEB_KEY);
      String state =  (String)application.getAttribute(ServerState.WEB_KEY);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>通达海软件-许可信息</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
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
	<script type="text/javascript">
		function submitsignatureForm(){
		  if (document.getElementsByName("signature")[0].value ==""){
		  	alert("请输入新的数字签名");
		  	return false;
		  }
		   if (confirm("确认更新新的许可证书?")){
			 document.all.f1.submit();
		   }
		}
	</script>
  </head>
   <%
   String type = lic.getLicenseType();
   String mc ="正式版";
   if("Trial".equals(type))
   {
   		mc="试用版";
   }
   %>
  <body background="../images/back.gif">
       <br>
       <br>
       <table width="750px" border="0">
            <tr><td colspan=2 class="lab" style="text-align: center"><b>软件许可证书信息</b></td></tr>
       	    <tr><td class="lab" width=120 >软件名称</td><td width=630><%=lic.getProduct() %></td></tr>
       	    <tr><td class="lab">授权单位</td><td><%=lic.getUserNameDecode() %></td></tr>
       	    <tr><td class="lab">软件版本</td><td><%=mc %></td></tr>
       	    <tr><td class="lab">有效日期至</td><td><%=lic.getExpiresDate() %></td></tr>
       	    <tr><td class="lab">绑定IP</td><td>未绑定</td></tr>
       	    <tr><td class="lab">数字签名</td><td ><%=lic.getSignature() %></td></tr>
       	    <tr><td class="lab">当前系统状态</td><td><%=state %></td></tr>
       	    <tr>
       	    	<td colspan=2 align=center>
       	    	<input type="button" value="更新许可证书" onclick="submitsignatureForm();">
       	    	<input type="button" value="联系我们">
       	    	</td>
       	    </tr>
       </table>
       <div id="sminfo" >
       	  <form name="f1" method="post" action="register_cmt.jsp">
       	  	<table  width="750px">
       	  		<tr>
       	  			<td width=120 class="lab">新数字签名</td>
       	  			<td><textarea style="width:100%" rows=4 name="signature"></textarea></td>
       	  		</tr>
       	  	</table>
       	  </form>
       </div> 
       <p>恶意篡改或者盗用他人的签名造成损失，本公司概不负责。请保护您的合法权益，使用认证的数字签名。</p>
  </body>
</html>
