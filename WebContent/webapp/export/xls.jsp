<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<div style="display:none;" >
  <form target="forExport" id="exportform" method="POST" action="<%=basePath %>/HtmlToXls">
  <input type="hidden" id="exportfilename" name="exportfilename" value="导出文件">
  <textarea  name="exporthtml" id="exporthtml"></textarea>
  </form>
  </div>
<iframe id="forExport" name="forExport" style="display:none;" ></iframe>
<script>
function doExport(containerid){
	$("#exporthtml").val($("#"+containerid).html());
	$("#exportform").submit();
}
</script>