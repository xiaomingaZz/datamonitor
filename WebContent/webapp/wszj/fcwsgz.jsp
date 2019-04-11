<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%
	String id = StringUtils.trim(request.getParameter("id"));
	String cxsj1 = StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-", "");
	String cxsj2 = StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-", "");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文书反查</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<%@include file="/ext/inc/ext-js3.jsp"%>
<script type="text/javascript">
function showTips(value, meta, rec) {
	return '<div ext:qtip="' + value + '">' + value + '</div>';
};

Ext.onReady(function(){
	
	var Sm3 = new Ext.grid.CheckboxSelectionModel({
		singleSelect:false//可多选
	});
	//列表
	var Cm3 = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					{
	                   						header : '裁判文书质检规则',
	                   						dataIndex : "WS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width :200, 
	                   						id : 'autoExp'
	                   					},
	                   					{
	                   						header : '不符合规则数',
	                   						dataIndex : "SL",
	                   						align : 'center',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :100
	                   						
	                   					}
	                   					]);
	//
	var Store3 = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'fc_wsgz.jsp',
		baseParams:{
			id:'<%=id%>',
			cxsj1:'<%=cxsj1%>',
			cxsj2:'<%=cxsj2%>',
			start:0,
			limit:50
		},
		fields : ['WS','SL','FY'],
		root : 'root',
		totalProperty : 'totalCount'
	});
				//
				var Grid3 = new Ext.grid.GridPanel({
					id : 'Grid3',
					layout : "fit",
					region : 'east',
					split : true,
					autoExpandColumn :'autoExp', //指定自动扩张列
					title : "",
					stripeRows : true,// 显示斑马线
					columnLines : true,//true显示列分割线
					cm : Cm3,
					sm : Sm3,
					store : Store3,
					loadMask : {
						msg : "正在加载，请稍候..."
					}
				});
				new Ext.Viewport({
					layout : 'fit',
					items : Grid3
				});
				Store3.load();

			});
function fcWsxq(fjm,line){
	window.open("fcwsxq.jsp?id=" + fjm + "&cxsj1=<%=cxsj1%>)&cxsj2=<%=cxsj2%>&line="+line);
}

</script>
</head>
<body>

</body>
</html>