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
Ext.onReady(function() {
	mask = new Ext.LoadMask(Ext.getBody(),{msg : "正在处理，请稍候..."});
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
	var rarCm = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					{
	                   						header : '法院名称',
	                   						dataIndex : "FYMC",
	                   						align : 'left',
	                   						sortable : true,
	                   						id : 'autoExp',
	                   						renderer:function(v,m,r){
	                   							if(r.get("F")>0){
	                   								return '<span style="color:red;">'+v+'</span>';
	                   							}else{
	                   								return v;
	                   							}
	                   						}
	                   					},
	                   					{
	                   						header : '压缩包总数',
	                   						dataIndex : "Z",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100
	                   					},
	                   					{
	                   						header : '解压成功',
	                   						dataIndex : "S",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100
	                   					},{
	                   						header : '解压失败',
	                   						dataIndex : "F",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100,
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
	rarStore = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'logStore.jsp',
		baseParams:{
			id:'',
			cxsj1:defaultSj,
			cxsj2:defaultSj
		},
		fields : [ 'FYMC','Z','S','F','FJM'],
		root : 'root',
		totalProperty : 'totalCount'
	});
   	//
	rarGrid = new Ext.grid.GridPanel({
		id : 'rarGrid',
		layout : "fit",
		region:'center',
		title:'交换压缩包',
		height:500,
        stripeRows : true,// 显示斑马线
		columnLines : true,//true显示列分割线
	    autoExpandColumn :'autoExp', //指定自动扩张列
		cm : rarCm,
		store : rarStore,
		loadMask : {msg : "正在加载，请稍候..."}
	});
	

	//列表
	var Cm3 = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					
	                   					{
	                   						header : '压缩文件名',
	                   						dataIndex : "AJBS",
	                   						align : 'left',
	                   						id:'autoExp',
	                   						sortable : true,
	                   						width :50 ,
	                   						renderer:showTips
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
		fields : [ 'AJBS'],
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
		title : "解压异常文件清单",
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
				items:rarGrid
			},Grid3,Treepanel ] 
		}],
		listeners:{
			afterrender : function(){
				doSearch();
			}
		}
	});
	
});


//查询
function doSearch(){
		id="-1";
		
		rarStore.baseParams.cxsj1 =$('#larq1').val();
		rarStore.baseParams.cxsj2 =$('#larq2').val();
		rarStore.baseParams.id ="";
		rarStore.load({});  
	
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

		
		rarStore.baseParams.cxsj1 =$('#larq1').val();
		rarStore.baseParams.cxsj2 =$('#larq2').val();
		rarStore.baseParams.id =id;
		rarStore.load({});  
	
		doycyySearch(id);
}