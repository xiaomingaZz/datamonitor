/**
 * 数据交换查询
 * 
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
var cxsj1 = "", cxsj2 = "", fydm = "";
var _PAGESIZE = 25;// 每一页记录数
var treeLoader;
Ext.onReady(function() {
	mask = new Ext.LoadMask(Ext.getBody(), {
		msg : "正在处理，请稍候..."
	});
	var mainSm = new Ext.grid.CheckboxSelectionModel({
		singleSelect : false
	// 可多选
	});
	var Sm2 = new Ext.grid.CheckboxSelectionModel({
		singleSelect : false
	// 可多选
	});
	var Sm3 = new Ext.grid.CheckboxSelectionModel({
		singleSelect : false
	// 可多选
	});
	treeLoader = new Ext.tree.TreeLoader({
		url : '../pub/citytree.jsp',
		baseParams : {},
		clearOnLoad : true
	});
	// 部门法院树
	var Treepanel = new Ext.tree.TreePanel({
		title : "&nbsp;",
		iconCls : "icon_group",
		split : true,
		xtype : "treepanel",
		id : "fyTree",
		width : 200,
		layout : "fit",
		region : "west",
		autoScroll : true, // 滚动条
		rootVisible : false,
		root : new Ext.tree.AsyncTreeNode({
			id : "-1",
			text : "顶层"
		}),
		loader : treeLoader,
		listeners : // 监听事件
		{
			'click' : function(node, e) {
				fydm = node.id;
				DjSearch(node.id);
			}
		}
	});

	// 列表
	var rarCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header : '法院名称',
				dataIndex : "FYMC",
				align : 'left',
				sortable : true,
				id : 'autoExp'
			},
			{
				header : '当日收案数',
				dataIndex : "SAS",
				align : 'center',
				sortable : true,
				width : 100,
				renderer : function(val, m, r) {
					var dm = r.get("DM");
					var v = r.get("FYMC");
					if (val > 0 && v != "合计") {
						return '<a href="#" onclick="fcSaData(' + dm + ');">'
								+ val + '</a>';
					} else {
						return val;
					}
				}
			},
			{
				header : '当日结案数',
				dataIndex : "JAS",
				align : 'center',
				sortable : true,
				width : 100,
				renderer : function(val, m, r) {
					var dm = r.get("DM");
					var v = r.get("FYMC");
					if (val > 0 && v != "合计") {
						return '<a href="#" onclick="fcJaData(' + dm + ');">'
								+ val + '</a>';
					} else {
						return val;
					}
				}
			} ]);
	//
	rarStore = new Ext.data.JsonStore({
		autoDestroy : true,
		autoLoad : false,
		method : "post",
		url : 'logStore.jsp',
		baseParams : {
			id : '',
			cxsj1 : defaultSj
		},
		fields : [ 'FYMC', 'SAS', 'JAS', 'DM' ],
		root : 'root',
		totalProperty : 'totalCount'
	});
	//
	rarGrid = new Ext.grid.GridPanel({
		id : 'rarGrid',
		layout : "fit",
		region : 'center',
		title : '结案统计',
		height : 500,
		stripeRows : true,// 显示斑马线
		columnLines : true,// true显示列分割线
		autoExpandColumn : 'autoExp', // 指定自动扩张列
		cm : rarCm,
		store : rarStore,
		loadMask : {
			msg : "正在加载，请稍候..."
		}
	});

	new Ext.Viewport({
		layout : 'fit',
		border : false,
		items : [ {
			layout : "border",
			border : false,
			items : [ {
				layout : "fit",
				region : 'north',
				border : false,
				height : 67,
				contentEl : 'btTable'
			}, {
				layout : "fit",
				region : 'center',
				border : false,
				items : rarGrid
			}, Treepanel ]
		} ],
		listeners : {
			afterrender : function() {
				doSearch();
			}
		}
	});

});

// 查询
function doSearch() {
	id = "-1";
	rarStore.baseParams.cxsj1 = $('#larq1').val();
	rarStore.baseParams.id = "";
	rarStore.load({});

}

// 树点击查询
function DjSearch(id, leaf) {
	rarStore.baseParams.cxsj1 = $('#larq1').val();
	rarStore.baseParams.id = id;
	rarStore.load({});

}

function fcSaData(dm) {
	window.open("lb.jsp?id=" + fydm + "&cxsj1=" + $('#larq1').val() + "&dm="
			+ dm + "&flag=SA");
}
function fcJaData(dm) {
	window.open("lb.jsp?id=" + fydm + "&cxsj1=" + $('#larq1').val() + "&dm="
			+ dm + "&flag=JA");
}