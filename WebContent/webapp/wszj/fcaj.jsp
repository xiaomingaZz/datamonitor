<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%
	String id = StringUtils.trim(request.getParameter("id"));
	String cxsj1 = StringUtils.trim(request.getParameter("cxsj1"));
	cxsj1 = cxsj1.replace("-", "");
	String cxsj2 = StringUtils.trim(request.getParameter("cxsj2"));
	cxsj2 = cxsj2.replace("-", "");
	String isws=StringUtils.trim(request.getParameter("isws"));
	if("".equals(isws)){
		isws="0";
	}
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
	                   						header : '文书',
	                   						dataIndex : "WS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width :200 ,
	                   						renderer:function(val,m,r){
	                   							var ajbs=r.get("AJBS");
	                   							if(val>0){
	                   							return '<a href="#" onclick="wscx('+ ajbs
	                   									+');">查看文书</a>';
	                   							}
	                   						}
	                   					},
	                   					{
	                   						header : '法院名称',
	                   						dataIndex : "FYMC",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :220 ,
	                   						renderer:showTips
	                   					},{
	                   						header : '分级码',
	                   						dataIndex : "FY",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :90 ,
	                   						renderer:showTips
	                   					},
	                   					{
	                   						header : '案件标识',
	                   						dataIndex : "AJBS",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :200 ,
	                   						renderer:showTips,
	                   						renderer:function(val,m,r){
	                   							return '<a href="#" onclick="ajcx('+val+');">'+val+'</a>';
	                   						}
	                   					},
	                   					{
	                   						header : '案号',
	                   						dataIndex : "AH",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :280 ,
	                   						renderer:showTips
	                   					},
	                   					{
	                   						header : '文书不符合规范原因',
	                   						dataIndex : "SBYY",
	                   						align : 'center',
	                   						sortable : true,
	                   						width :280 ,
	                   						renderer:showTips
	                   					}
	                   					]);
	//
	var Store3 = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'fc_data.jsp',
		baseParams:{
			id:'<%=id%>',
			cxsj1:'<%=cxsj1%>',
			cxsj2:'<%=cxsj2%>',
			isws:'<%=isws%>',
			start:0,
			limit:50
		},
		fields : ['FYMC','FY', 'AJBS','AH','SBYY','WS'],
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
				window.open("export.jsp?id=<%=id%>&cxsj1=<%=cxsj1%>&cxsj2=<%=cxsj2%>&isws=<%=isws%>");
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

	function wscx(ajbs) {
		window.open("html.jsp?ajbs="+ajbs);
	}
	
	function ajcx(ajbs){
		window.open("../ajcx/main.jsp?zlbg_ajbs=" + ajbs);
	}
</script>
</head>
<body>

</body>
</html>