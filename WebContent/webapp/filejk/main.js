/**
 * 数据交换查询
 * @author chenjx 2015.01.26
 */
function showTips(value, meta, rec) {
	return '<div ext:qtip="' + value + '">' + value + '</div>';
};
var mask;
var mainStore;
var mainGrid;
var Store2;
var Grid2;
var Store3;
var Grid3;
var cxsj1="",cxsj2="",fydm="";
var _PAGESIZE =25;//每一页记录数
var treeLoader;
var win;
Ext.onReady(function() {
    win = new Ext.Window({
    	title : "文件历史",
		layout : "fit",
		width : 800,
		height : 400,
		closeAction : "hide",
		modal : true,
		animate : true,
		resizable : false,
		html:'<iframe id="kframe" width="100%" height="100%" frameborder="0"></iframe>'
    });
	var mainSm = new Ext.grid.CheckboxSelectionModel({
		singleSelect:false//可多选
	});
	var Sm2 = new Ext.grid.CheckboxSelectionModel({
		singleSelect:false//可多选
	});
	var Sm3 = new Ext.grid.CheckboxSelectionModel({
		singleSelect:false//可多选
	});
	treeLoader = new Ext.tree.TreeLoader({
		url:'../pub/citytree.jsp', 
		baseParams: {
		},
		clearOnLoad : true
	});
	//部门法院树
    var Treepanel = new Ext.tree.TreePanel({
    	title :"&nbsp;",
		iconCls : "icon_group",
		split : true,
		xtype : "treepanel",
		id : "fyTree",
		width : 200,
		layout : "fit",
		region : "west",
		autoScroll	 : true, //滚动条
		rootVisible:false, 
		root : new Ext.tree.AsyncTreeNode({ 
			id : "-1", 
			text : "顶层" 
		}), 
		loader : treeLoader,
		listeners : // 监听事件
		{
			'click' : function(node, e) {
				fydm=node.id;
				DjSearch(node.id);
			}
		}
	});
   

		//列表
	var fileCm = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					{
	                   						header : '法院名称',
	                   						dataIndex : "FYMC",
	                   						align : 'left',
	                   						sortable : true,
	                   						id : 'autoExp',
	                   						renderer:function(v,m,r){
	                   							if(r.get("V5")>0 || r.get("V6")>0){
	                   								return '<span style="color:red;">'+v+'</span>';
	                   							}else{
	                   								return v;
	                   							}
	                   						}
	                   					},
	                   					{
	                   						header : '文件总数',
	                   						dataIndex : "V1",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 70
	                   					},
	                   					{
	                   						header : '案件XML',
	                   						dataIndex : "V2",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 70
	                   					},{
	                   						header : '删除XML',
	                   						dataIndex : "V3",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 70
	                   					},{
	                   						header : '机构XML',
	                   						dataIndex : "V4",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 70
	                   					},{
	                   						header : '目录错误',
	                   						dataIndex : "V5",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 70
	                   					},{
	                   						header : 'xsd校验失败',
	                   						dataIndex : "V6",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 80,
	                   						renderer : function(val, m, r) {
	                							var fjm = "'"+r.get("FJM")+"'";

	                							if (val > 0) {
	                								return '<a href="#" onclick="fcData(' + fjm
	                										+ ');">' + val + '</a>';
	                							} else {
	                								return val;
	                							}
	                						}
	                   					}]);
	//
	fileStore = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'fileStore.jsp',
		baseParams:{
			id:'',
			cxsj1:defaultSj,
			cxsj2:defaultSj
		},
		fields : [ 'FYMC','V1','V2','V3','V4','V5','V6','FJM'],
		root : 'root',
		totalProperty : 'totalCount'
	});
   	//
	fileGrid = new Ext.grid.GridPanel({
		id : 'fileGrid',
		layout : "fit",
		region:'center',
		title:'XML文件日志',
		height:500,
        stripeRows : true,// 显示斑马线
		columnLines : true,//true显示列分割线
	    autoExpandColumn :'autoExp', //指定自动扩张列
		cm : fileCm,
		store : fileStore,
		loadMask : {msg : "正在加载，请稍候..."}
	});
	
	
	//列表
	var Cm3 = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					{
	                   						header : '类型',
	                   						dataIndex : "ERRCODE",
	                   						align : 'left',
	                   						sortable : true,
	                   						width :60 ,
	                   						renderer:function(val){
	                   							if(val == 1){
	                   								return "目录错误";
	                   							}else{
	                   								return "xsd失败";
	                   							}
	                   						}
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
	                   					},{
	                   						header : '历史',
	                   						dataIndex : "FILENAME",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :50,
	                   						renderer:function(val,m,r) {
	                   							var fjm = r.get("FJM");
	                   							var fn = r.get("FILENAME");
	                   							return '<a onclick="showHis(\''+fjm+'\',\''+fn+'\');">查看</a>';
	                   						}
	                   					}]);
	//
	Store3 = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'ycqdStore.jsp',
		baseParams:{
			id:'',
			cxsj1:defaultSj,
			cxsj2:defaultSj,
			ycyy:"",
			start:0,
			limit:25
		},
		fields : [ 'ERRCODE','ERRMSG','FILENAME','FJM','ZIPNAME'],
		root : 'root',
		totalProperty : 'totalCount'
	});
	//分页控件
	var pb3 =  new Ext.PagingToolbar({
		pageSize : _PAGESIZE,   //
		store : Store3,   //
		autoload:false,
		displayInfo : true,
		displayMsg : '{0} - {1} / {2}',
		emptyMsg : "暂未搜索到相关记录"
   	});
   	//
	Grid3= new Ext.grid.GridPanel({
		id : 'Grid3',
		layout : "fit",
		region:'east',
		width:400,
		split:true,
		autoExpandColumn :'autoExp', //指定自动扩张列
		title : "XML错误清单",
        stripeRows : true,// 显示斑马线
		columnLines : true,//true显示列分割线
		cm : Cm3,
		sm : Sm3,
		store : Store3,
		bbar : pb3,
		loadMask :{msg : "正在加载，请稍候..."}
	});
	new Ext.Viewport({
		layout:'fit',
		border:false,
		items:[{
			layout : "border",
			border : false,
			items:[{
				layout : "fit",
				region:'north',
				border:false,
				height:67,
				contentEl:'btTable'
			}, 
			{   layout : "fit",
				region:'center',
				border:false,
				items:fileGrid
			},Grid3,Treepanel ] 
		}],
		listeners:{
			afterrender : function(){
				doSearch();
			}
		}
	});
	
});

function showHis(fjm,filename){
	win.show();
	document.getElementById('kframe').src="his.jsp?fjm="+fjm+"&fn="+filename;
}

//查询
function doSearch(){
		id="-1";
		
		fileStore.baseParams.cxsj1 =$('#larq1').val();
		fileStore.baseParams.cxsj2 =$('#larq2').val();
		fileStore.baseParams.id ="";
		fileStore.load({});  
		
		doycyySearch(id);
}
//查询
function doycyySearch(id){
		Store3.baseParams.cxsj1 =$('#larq1').val();
		Store3.baseParams.cxsj2 =$('#larq2').val();
		Store3.baseParams.id=id;
		Store3.load();	
}
function fcData(fjm){
	Store3.baseParams.cxsj1 =$('#larq1').val();
	Store3.baseParams.cxsj2 =$('#larq2').val();
	Store3.baseParams.id=fjm;
	Store3.load();
}

//树点击查询
function DjSearch(id,leaf){
		
		fileStore.baseParams.cxsj1 =$('#larq1').val();
		fileStore.baseParams.cxsj2 =$('#larq2').val();
		fileStore.baseParams.id =id;
		fileStore.load({});  
		doycyySearch(id);
}