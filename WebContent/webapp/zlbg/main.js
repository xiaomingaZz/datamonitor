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
var panel;
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
				url : '../pub/cityFytree.jsp',
				baseParams : {
					fydm : ''
				},
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
					},
					beforeload : function(b) {
						b.getOwnerTree().getLoader().baseParams.fydm = b.id;
					}
				}
			});

			// 列表
			var rarCm = new Ext.grid.ColumnModel([
					new Ext.grid.RowNumberer(),
					{
						header : '数据校验规则',
						dataIndex : "MS",
						align : 'left',
						sortable : true,
						width : 400,
						id : 'autoExp',
						renderer : function(v, m, r) {
							if (r.get("F") > 0) {
							//	return '<span style="color:red;">' + v
								//		+ '</span>';
								return '<div ext:qtip="' + v + '">' + '<span style="color:red;">' + v
									+ '</span>'; + '</div>';
							} else {
							//	return v;
								return'<div ext:qtip="' + v + '">' + v + '</div>';
							}
						}
					},
					{
						header : '数量',
						dataIndex : "F",
						align : 'center',
						sortable : true,
						width : 100,
						renderer : function(val, m, r) {
							var bh = r.get("BH");

							if (val > 0) {
								return '<a href="#" onclick="fcData(' + bh
										+ ');">' + val + '</a>';
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
					id : ''
				},
				fields : [ 'MS', 'BH', 'F' ],
				root : 'root',
				totalProperty : 'totalCount'
			});
			//
			rarGrid = new Ext.grid.GridPanel({
				id : 'rarGrid',
				layout : "fit",
				region : 'center',
				title : '校验规则',
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
			//法院合格率排名
			 panel = new Ext.Panel({
				        id:'panel',
						region : 'east',
						closable : true,
						height : 500,
						width : 350,
						layout : 'fit',
						title : '质量排名',
						items : [ {
							html : "<iframe id='fypm' scrolling='auto' frameborder='0' width='100%' " +
									"height='100%' src=''> </iframe>"
						} ]
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
					}, panel, Treepanel ]
				} ],
				listeners : {
					afterrender : function() {
						doSearch();
						$("#totalInfo").load(
								"alldata.jsp?id=");
					}
				}
			});

		});

// 查询
function doSearch() {
	id = "-1";
//	rarStore.baseParams.cxsj1 = $('#larq1').val();
//	rarStore.baseParams.cxsj2 = $('#larq2').val();
	rarStore.baseParams.id = "";
	rarStore.load({});
	$("#totalInfo").load(
			"alldata.jsp?id=" + id);
	document.getElementById("fypm").src="fypm.jsp";
}

// 树点击查询
function DjSearch(id, leaf) {

//	rarStore.baseParams.cxsj1 = $('#larq1').val();
//	rarStore.baseParams.cxsj2 = $('#larq2').val();
	rarStore.baseParams.id = id;
	rarStore.load({});
	$("#totalInfo").load(
			"alldata.jsp?id=" + id);

}

function fcData(bh) {
	window.open("fc/fc.jsp?id=" + fydm + "&bh=" + bh);
}