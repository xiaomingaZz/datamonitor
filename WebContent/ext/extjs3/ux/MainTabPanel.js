/**
 * Filename: 主页面TAB显示
 * Company: 南京通达海信息科技有限公司
 * 
 * @author: gezy
 * @version: 1.0 
 * Create at: 2011-03-07 下午02:05:50
 * 
 * Modification History: Date Author Version Description
 * ------------------------------------------------------------------
 * gezy 1.0 1.0 Version
 */
Ext.namespace('Ext.ux.MainTabPanel');
Ext.ux.MainTabPanel= function(config) {
	Ext.apply(this, config);
	this.initUIComponents();
	Ext.ux.MainTabPanel.superclass.constructor.call(this);
}
Ext.extend(Ext.ux.MainTabPanel, Ext.TabPanel, {
	initUIComponents : function() {
		Ext.apply(this,{
		    activeTab : 0,
		    tabPosition:'top',
		    enableTabScroll : true,
			resizeTabs      : true,
			minTabWidth     : 120,
            defaults  : {
                autoScroll : false,
                closable : true
            },
            plugins:[new Ext.ux.TabScrollerMenu({
				maxText  : 15,
				pageSize : 5
			}),new Ext.ux.TabCloseMenu()
			]
		})
	},
	/**
	 * 添加功能节点至TabPanel
	 * @param {} id 树节点的ID（添加的PANEL 的id默认为 树节点的id加 ——Panel）
	 * @param {} url 连接到的HTML 地址
	 */
	addNode:function(id,title,url){
		//panel id
		var pId = id+"_panel";  
		var fId = id+"_frame";
		var p = this.getComponent(pId);
		var needFlash = false;
		//alert(url);
		if(!p){
			p = new Ext.Panel({
			    id:pId,
			    title:title,
			    //iconCls : 'icon_app_list',
			    //tabTip :title,
			    layout:'fit',
			    border:false,
			    //html:'<iframe scrolling=no id='+fId+' frameborder=0 src="'+url+'" width=100%  height=100%></iframe>'
			    items: {xtype:'iframePanel',src:url,id:fId,border:false}
			}); 
			this.add(p);
		}else{
		  needFlash = true;
		}
		this.setActiveTab(p);
		//alert(fId);
		if(needFlash){
		 Ext.getCmp(fId).setUrl(url);
		 Ext.getCmp(fId).refresh();
		 //document.getElementById(fId).src = url;
		}
	}
});
