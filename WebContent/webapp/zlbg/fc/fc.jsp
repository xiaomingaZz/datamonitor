<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%
	String id = StringUtils.trim(request.getParameter("id"));
	String bh = StringUtils.trim(request.getParameter("bh"));
	//String cxsj1 = StringUtils.trim(request.getParameter("cxsj1"));
	//cxsj1 = cxsj1.replace("-", "");
	//String cxsj2 = StringUtils.trim(request.getParameter("cxsj2"));
	//cxsj2 = cxsj2.replace("-", "");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据反查</title>
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
	                   						header : '法院',
	                   						dataIndex : "FYMC",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :200 ,
	                   						renderer:showTips
	                   					},
	                   					{
	                   						header : '法院分级码',
	                   						dataIndex : "FY",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :80 ,
	                   						renderer:showTips
	                   					},
	                   					{
	                   						header : '案件标识',
	                   						dataIndex : "AJBS",
	                   						align : 'left',

	                   						sortable : true,
	                   						width :200 ,
	                   						renderer:function(val,m,r){
	                   							return '<a href="#" onclick="ajcx('+val+');">'+val+'</a>';
	                   						}
	                   					},
	                   					{
	                   						header : '案号',
	                   						dataIndex : "AH",
	                   						align : 'left',

	                   						sortable : true,
	                   						width :200 ,
	                   						renderer:showTips
	                   					},
	                   					{
	                   						header : '立案日期',
	                   						dataIndex : "LARQ",
	                   						align : 'left',

	                   						sortable : true,
	                   						width :200 ,
	                   						renderer:showTips
	                   					},
	                   					{
	                   						header : '结案日期',
	                   						dataIndex : "JARQ",
	                   						align : 'left',

	                   						sortable : true,
	                   						width :200 ,
	                   						renderer:showTips
	                   					},
	                   					{
	                   						header : '规则',
	                   						dataIndex : "SBYY",
	                   						align : 'left',

	                   						sortable : true,
	                   						width :400 ,
	                   						renderer:showTips
	                   					}]);
	//
	var Store3 = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'fc_data.jsp',
		baseParams:{
			id:'<%=id%>',
			bh:'<%=bh%>',
			start:0,
			limit:50
		},
		fields : [ 'FY','AJBS','AH','FYMC','LARQ','JARQ','SBYY'],
		root : 'root',
		totalProperty : 'totalCount'
	});
	//分页控件
	var pb3 =  new Ext.PagingToolbar({
		pageSize : 50,   //
		store : Store3,   //
		autoload:false,
		displayInfo : true,
		displayMsg : '{0} - {1} / {2}',
		emptyMsg : "暂未搜索到相关记录",
		items:[{
			text:'导出数据',
			handler:function(){
				window.open("export.jsp?id=<%=id%>&bh=<%=bh%>");
								}
							} ]
						});
				//
				var Grid3 = new Ext.grid.GridPanel({
					id : 'Grid3',
					layout : "fit",
					region : 'east',
					split : true,
					//autoExpandColumn :'autoExp', //指定自动扩张列
					title : "案件清单",
					stripeRows : true,// 显示斑马线
					columnLines : true,//true显示列分割线
					cm : Cm3,
					sm : Sm3,
					store : Store3,
					bbar : pb3,
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
			
function ajcx(ajbs){
	window.open("../../ajcx/main.jsp?zlbg_ajbs=" + ajbs);
	//var win1=window.opener;
	//win1.parent.document.getElementsByName("ajcxiframe").src="../../ajcx/main.jsp?zlbg_ajbs=" + ajbs;
}
</script>
</head>
<body>

</body>
</html>