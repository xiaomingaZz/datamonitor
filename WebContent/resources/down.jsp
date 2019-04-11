<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tdh.frame.lcgl.pub.SmartUpload.SmartUpload" %>
<%
try{
// 新建一个SmartUpload对象
SmartUpload su = new SmartUpload();
// 初始化
su.initialize(pageContext);
// 设定contentDisposition为null以禁止浏览器自动打开文件，
//保证点击链接后是下载文件。若不设定，则下载的文件扩展名为
//doc时，浏览器将自动用word打开它。扩展名为pdf时，
//浏览器将用acrobat打开。
su.setContentDisposition(null);
String fname=(String)request.getParameter("fname");
//fname=new String(fname.getBytes("iso-8859-1"),"UTF-8");
//System.out.println("**file="+fname);
// 下载文件
int p1 = fname.lastIndexOf("\\");
if (p1 >= 0) fname = fname.substring(p1 + 1);

p1 = fname.lastIndexOf("/");
if (p1 >= 0) fname = fname.substring(p1 + 1);

su.downloadFile("/resources/help/"+fname);

} catch(Exception e){ //SmartUploadException

} finally {
  out.clear();
  out=pageContext.pushBody();
//response.getOutputStream().close();
}
%>
