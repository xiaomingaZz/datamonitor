<%@ page language="java" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>通达海消息系统测试接口页面</title>
  </head>
  <body>
    <form action="cmt.jsp" method="POST" >
    	<table>
    	    <tr>
    		<td>法院代码</td>
    		<td><input type="text" name="fydm" style="width:200px;"></td>
    		</tr>
    		<tr>
    		<td>接收人</td>
    		<td><input type="text" name="jsr" style="width:200px;"></td>
    		</tr>
    		<tr>
    		<td>消息标题</td>
    		<td><input type="text" name="title" style="width:200px;"></td>
    		</tr>
    		<tr>
    		<td>消息内容</td>
    		<td><input type="text" name="nr" style="width:200px;"></td>
    		</tr>
    		<tr>
    			<td colspan="2"><input type="submit"></td>
    		</tr>
    	</table>
    </form> 
  </body>
</html>
