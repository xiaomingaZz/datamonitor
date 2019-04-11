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
    var ifrmPanel = new Ext.Panel({
		id:"ifrmPanel",
		region : "south",
		layout : "fit",
		height : 40,
		border : false,
		bodyBorder : false,
		hidden : true,//
		html : "<iframe id='ifrm' name='ifrm' border='0'>1</iframe>"
	});
	
	//列表
	var mainCm = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					{
	                   						header : '法院名称',
	                   						dataIndex : "FYMC",
	                   						align : 'left',
	                   						sortable : true,
	                   						id : 'autoExp',
	                   						width : 200,
	                   						renderer : showTips
	                   					},
	                   					{
	                   						header : '到达数',
	                   						dataIndex : "DDS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100
	                   					},{
	                   						header : '已入库数',
	                   						dataIndex : "RKS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100
	                   					},{
	                   						header : '解析异常数',
	                   						dataIndex : "YCS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100,
	                   						renderer:function(val,m,r){
	                   							var fjm="'"+r.get("FYDM")+"'";
	                   							if(val>0){
	                   								return '<a href="#" onclick="fcData(' + fjm
	        										+ ');">' + val + '</a>';
	                   							}else{
	                   								return val;
	                   							}
	                   						}
	                   					},{
	                   						header : '待入库数(含加载)',
	                   						dataIndex : "DRKS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100
	                   					},{
	                   						header : '正在加载数',
	                   						dataIndex : "ZZJZ",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100
	                   					},{
	                   						header : '删除数',
	                   						dataIndex : "SCS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 100
	                   					}]);
	//
	mainStore = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'mainStore.jsp',
		baseParams:{
			id:'',
			cxsj1:defaultSj,
			cxsj2:defaultSj
		},
		fields : [ 'FYMC','FYDM','DDS','RKS','DRKS','YCS','ZZJZ','SCS'],
		root : 'root',
		totalProperty : 'totalCount'
	});
   	//
	mainGrid = new Ext.grid.GridPanel({
		id : 'mainGrid',
		layout : "fit",
		region:'center',
		height:500,
		//border : false,
		//title : "信息采用记录",
        stripeRows : true,// 显示斑马线
		columnLines : true,//true显示列分割线
	    autoExpandColumn :'autoExp', //指定自动扩张列
		cm : mainCm,
		sm : mainSm,
		store : mainStore,
		loadMask : {msg : "正在加载，请稍候..."}
	});
	//列表
	var Cm2 = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					{
	                   						header : '异常原因',
	                   						dataIndex : "YCYY",
	                   						align : 'left',
	                   						sortable : true,
	                   						width : 400,
	                   						renderer : showTips
	                   					},
	                   					{
	                   						header : '异常数',
	                   						dataIndex : "YCS",
	                   						align : 'center',
	                   						sortable : true,
	                   						width : 120,
	                   						renderer :showTips
	                   					}]);
	//
	Store2 = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url :'ycyyStore.jsp',
		baseParams:{
			id:'',
			cxsj1:defaultSj,
			cxsj2:defaultSj
		},
		fields : [ 'FYDM','YCYY','YCS'],
		root : 'root',
		totalProperty : 'totalCount'
	});
	
   	//
	Grid2= new Ext.grid.GridPanel({
		id : 'Grid2',
		layout : "fit",
		region:'south',
		height:200,
		split:true,
        stripeRows : true,// 显示斑马线
		columnLines : true,//true显示列分割线
		cm : Cm2,
		sm : Sm2,
		store : Store2,
		//bbar : pb2,
		loadMask : {msg : "正在加载，请稍候..."},
		listeners :{
			"click":function(){
				var sm  = Grid2.getSelectionModel();
				var isSel = sm.hasSelection();
				if(isSel){
					var record = sm.getSelected();
					var ycyy = record.get("YCYY");
					doycqdSearch(fydm,ycyy);
				}
			},
			load :function(){
				  Grid3.removeAll();
		    	  if(Store2.getCount()>=1){
		            Grid2.getSelectionModel().selectRow(0);
		            var record = Store2.getAt(0);
					var ycyy = record.get("YCYY");
					doycqdSearch(fydm,ycyy);
		    	  }else{
		    	  }  
		      }
		}
	});
	//列表
	var Cm3 = new Ext.grid.ColumnModel([
	                   					new Ext.grid.RowNumberer(),
	                   					
	                   					{
	                   						header : '文件名称',
	                   						dataIndex : "XMLNAME",
	                   						align : 'center',
	                   						sortable : true,
	                   						id : 'autoExp',
	                   						width :50 ,
	                   						//value， cellmeta， record， rowIndex， columnIndex， store
	                   						renderer : function(val, m, r) {
	                   							var vals = val.split("_");
	                   							var name = vals[2];
	                   							name = name.replace(".xml","");
	                   							return '<a href="#" onclick="openfcData('+name+');">'+name+'</a>';
	                						}
//	                   						,
//	                   						renderer : function(value, meta, rec) {
//	                                     	   if(value>0){
//	                                     	   return '<A href="javascript:void(0);" return false;"  >下载</A>';
//	                                     			}
//	                                     		}
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
			ycyy:""
		},
		fields : [ 'XMLNAME'],
		root : 'root',
		totalProperty : 'totalCount'
	});
	//分页控件
	var pb3 =  new Ext.PagingToolbar({
		pageSize : _PAGESIZE,   //
		store : Store3,   //
		autoload:false,
		displayInfo : true,
		displayMsg : '显示 记录 {0} - {1} / {2}',
		emptyMsg : "暂未搜索到相关记录"
   	});
   	//
	Grid3= new Ext.grid.GridPanel({
		id : 'Grid3',
		layout : "fit",
		region:'east',
		width:300,
		title : "异常文件清单",
        stripeRows : true,// 显示斑马线
		columnLines : true,//true显示列分割线
		cm : Cm3,
		sm : Sm3,
		store : Store3,
		autoExpandColumn :'autoExp',
		bbar : pb3,
		loadMask :{msg : "正在加载，请稍候..."},
		listeners :{
			"click":function(){
				
			}
		}
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
			{   layout : "border",
				region:'center',
				border:false,
				items:[
					mainGrid ,Grid2
				]
			},
			Grid3,Treepanel,ifrmPanel ] 
		}],
		listeners:{
			afterrender : function(){
				//$("#larq1").bind("focus", function() {WdatePicker({dateFmt : 'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'larq2\')}'});});
				//$("#larq2").bind("focus", function() {WdatePicker({dateFmt : 'yyyy-MM-dd',minDate:'#F{$dp.$D(\'larq1\')}'});});
				doSearch();
			}
		}
	});
	
});


//查询
function doSearch(){
		id="-1";
		mainStore.baseParams.cxsj1 =$('#larq1').val();
		mainStore.baseParams.cxsj2 =$('#larq2').val();
		mainStore.baseParams.id ="";
		mainStore.load({});  
		doycyySearch(id);
}
//查询
function doycyySearch(id){
		Store2.baseParams.cxsj1 =$('#larq1').val();
		Store2.baseParams.cxsj2 =$('#larq2').val();
		Store2.baseParams.id=id;
		Store2.load({});	
}

function fcData(fjm){
	Store2.baseParams.cxsj1 =$('#larq1').val();
	Store2.baseParams.cxsj2 =$('#larq2').val();
	Store2.baseParams.id=fjm;
	Store2.load({});
}
//查询
function doycqdSearch(id,ycyy){
		Store3.baseParams.cxsj1 =$('#larq1').val();
		Store3.baseParams.cxsj2 =$('#larq2').val();
		Store3.baseParams.id=id;
		Store3.baseParams.ycyy =ycyy;
		Store3.load({});  
}
//树点击查询
function DjSearch(id,leaf){
		mainStore.baseParams.cxsj1 =$('#larq1').val();
		mainStore.baseParams.cxsj2 =$('#larq2').val();
		mainStore.baseParams.id=id;
		mainStore.load({});	
		
		doycyySearch();
}
function showMask(){
	mask.show();
}

function hideMask(){
	mask.hide();
}
function openfcData(bh) {
	window.open("../ajcx/main.jsp?zlbg_ajbs=" + ajbs);
}