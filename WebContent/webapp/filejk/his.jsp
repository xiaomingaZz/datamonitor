<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String fjm = request.getParameter("fjm");
	String fn = request.getParameter("fn");
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>文件历史</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<%@include file="/ext/inc/ext-js3.jsp"%>
	<script type="text/javascript">
		Ext.onReady(function(){
		         var Cm3 = new Ext.grid.ColumnModel([
         					new Ext.grid.RowNumberer(),
         					{
         						header : '采集日期',
         						dataIndex : "CJRQ",
         						align : 'left',
         						sortable : true,
         						width :70 
         					},
         					{
         						header : '分级码',
         						dataIndex : "FJM",
         						align : 'left',
         						sortable : true,
         						width :50 
         					},
         					{
         						header : '错误代码',
         						dataIndex : "ERRCODE",
         						align : 'left',
         						sortable : true,
         						width :60 
         					},
         					{
         						header : '文件名称',
         						dataIndex : "FILENAME",
         						align : 'left',
         						id:'autoExp',
         						sortable : true,
         						width :50,
         						renderer:function(val,m,r) {
         							var errmsg = r.get("ERRMSG");
         							var zip = r.get("ZIPNAME");
         							return '<div ext:qtip="zip:'+zip+'<br>错误:' + errmsg + '">' + val + '</div>';
         						}
         					}]);
				//
				var Store3 = new Ext.data.JsonStore({
					autoDestroy : true,
					autoLoad : false,
					method : "post",
					url :'hisStore.jsp?fjm=<%=fjm%>&fn=<%=fn%>',
					fields : [ 'CJRQ','ERRCODE','ERRMSG','FILENAME','FJM','ZIPNAME'],
					root : 'root',
					totalProperty : 'totalCount'
				});
				
				var Grid3= new Ext.grid.GridPanel({
					id : 'Grid3',
					layout : "fit",
					autoExpandColumn :'autoExp', //指定自动扩张列
			        stripeRows : true,// 显示斑马线
					columnLines : true,//true显示列分割线
					cm : Cm3,
					store : Store3,
					loadMask :{msg : "正在加载，请稍候..."}
				});
				
					new Ext.Viewport({
					layout:'fit',
					items:Grid3
					});
					Store3.load();
		});
	</script>
  </head>
  <body>
  </body>
</html>
