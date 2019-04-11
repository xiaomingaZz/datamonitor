/**
 * new Ext.ux.ComboBoxTree({
		   editable : false,
		   fieldLabel : '考核人',
		   name:'khrr',
		   id:'khrr',
		   align : 'center',
		   // this.resizable=true;
		   // all:所有节点
		   // exceptRoot:除了根节点
		   // folder:ֻ目录
		   // leaf：子节点
		   selectNodeModel :'leaf',
		   maxHeight:320,
			enableTbar:true,
			autoScroll:false,
		tree :{
					          xtype:'treepanel',
					    	  autoScroll:true,
					    	  width:'100%',
					          dataUrl:CONTEXT_PATH+'/fgkp/fagl/store/zzjg_store.jsp',
					          root : new Ext.tree.AsyncTreeNode({id:'-1',text:'顶层'}),
					          rootVisible:false
					     }
		         })
 */
 /**
  * * 
						 * enableTbar 显示tbar 
						 *   simpleTbar 显示tbar
  */
Ext.ux.ComboBoxTree = function() {
	this.treeId = Ext.id() + '-tree';
	this.maxHeight = arguments[0].maxHeight || arguments[0].height
			|| this.maxHeight;
	this.tpl = new Ext.Template('<tpl for="."><div style="height:'
			+ this.maxHeight + 'px"><div id="' + this.treeId
			+ '"></div></div></tpl>');
	this.store = new Ext.data.SimpleStore({
				fields : [],
				data : [[]]
			});
	this.selectedClass = '';
	this.mode = 'local';
	this.triggerAction = 'all';
	this.onSelect = Ext.emptyFn;
	this.editable = false;
	// this.resizable=true;
	// all:所有节点
	// exceptRoot:除了根节点
	// folder:ֻ目录
	// leaf：子节点
	this.selectNodeModel = arguments[0].selectNodeModel || 'exceptRoot';

	this.addEvents('afterchange');

	Ext.ux.ComboBoxTree.superclass.constructor.apply(this, arguments);
}

Ext.extend(Ext.ux.ComboBoxTree, Ext.form.ComboBox, {
	// bug处
	assertValue : function() {
	},
	initResizer : function() {
		var resizer = new Ext.Resizable(this.list, {
					width : this.width,
					height : this.maxHeight,
					minWidth : 100,
					minHeight : 50
				});
		resizer.addListener('resize', function(res, w, h) {
					this.maxHeight = h - this.handleHeight
							- this.list.getFrameWidth('tb') - this.assetHeight;
					this.listWidth = w;
					this.innerList.setWidth(w - this.list.getFrameWidth('lr'));
					this.restrictHeight();
					this.tree.setHeight(h);
					this.tree.setWidth(w);
				}, this);
	},
	expand : function() {
		Ext.ux.ComboBoxTree.superclass.expand.call(this);
		if (this.tree.rendered) {
			return;
		}
		var me = this;
		if (this.enableTbar) {
			this.tree.tbar = [{
						text : '确定',
						iconCls:'icon_drop_yes',
						handler : me.confirm.createDelegate(me)
					},'-', {
						text : '取消',
						iconCls:'icon_cancel',
						handler : me.cancel.createDelegate(me)
					},'-', {
						text : '清除',
						iconCls:'icon_preferences',
						handler : me.clearValue.createDelegate(me)
					},'-']
		}
		if(this.simpleTbar){
        	this.tree.tbar = [{
						text : '确定',
						handler : me.simpleConfirm.createDelegate(me)
					},'-', {
						text : '取消',
						handler : me.cancel.createDelegate(me)
					},'-', {
						text : '清除',
						handler : me.clearValue.createDelegate(me)
					},'-']
        }
		Ext.apply(this.tree, {
					height : this.maxHeight,
					border : false,
					autoScroll : true
				});
		if (this.tree.xtype) {
			this.tree = Ext.ComponentMgr.create(this.tree, this.tree.xtype);
		}
		this.tree.on('afterrender', this.initResizer, this);
		this.tree.render(this.treeId);

		var root = this.tree.getRootNode();
		if (!root.isLoaded())
			root.reload();
        if(!!!this.enableTbar){
			this.tree.on('click', function(node) {
						//	具体业务 可重构
						var a = node.attributes;
						if(a.lx&&a.lx=='1'){
							return;
						}
						var selModel = this.selectNodeModel;
						var isLeaf = node.isLeaf();
						if ((node == root) && selModel != 'all') {
							return;
						} else if (selModel == 'folder' && isLeaf) {
							return;
						} else if (selModel == 'leaf' && !isLeaf) {
							return;
						}
						var oldNode = this.getNode();
						if (this.fireEvent('beforeselect', this, node, oldNode) !== false) {
							this.setValue(node);
							this.collapse();
	
							this.fireEvent('select', this, node, oldNode);
							(oldNode !== node) ? this.fireEvent('afterchange',
									this, node, oldNode) : '';
						}
					}, this);
        }
	},
	/**
	 * id , text
	 * 
	 * @param {}
	 *            node
	 */
	setValue : function(node,nodeId) {
		var text,id;
		if(Ext.isObject(node)){
		    text= node.text;
		    id = node.id;
		}else{
		    text = node;
		    id = nodeId;
		}
		//Ext.form.ComboBox.superclass.setValue.call(this, text);
		this.setRawValue(text);
		if(this.hiddenValue){
			this.hiddenValue = id||text;
		}

		this.value = id||text;
		return this;
		// if(arguments.length>1){
		// var a = arguments[0];
		// var b = arguments[1];
		// this.node = {
		// text:b,
		// id:a
		// }
		// }else{
		// this.node = node;
		// }
		// var text = this.node.text;
		// this.lastSelectionText = text;
		// if (this.hiddenField) {
		// this.hiddenField.value = this.node.id;
		// }
		// Ext.form.ComboBox.superclass.setValue.call(this, text);
		// this.setRawValue(text);
		// this.value = this.node.id;
	},

	getValue : function() {
		return typeof this.value != 'undefined' ? this.value : '';
	},

	getNode : function() {
		return this.node;
	},

	clearValue : function() {
		Ext.ux.ComboBoxTree.superclass.clearValue.call(this);
		this.tree.getRootNode().cascade(function(n){
			n.checked=false;
			n.attributes.checked=false;
			n.ui.toggleCheck(false);
			return true;
		});
		this.node = null;
	},

	// private
	destroy : function() {
		Ext.ux.ComboBoxTree.superclass.destroy.call(this);
		// Ext.destroy([this.node, this.tree]);
		Ext.destroy([this.tree]);
		delete this.node;
	},
	onSelect : Ext.emptyFn,
	onViewClick : Ext.emptyFn,

	confirm : function() {
		var nodes = this.tree.getChecked();
		var vals = [];
		var txts = [];
		for (var i = 0, len = nodes.length; i < len; i++) {
			vals.push(nodes[i].id);
			txts.push(nodes[i].text);
		}
		this.setValue({
					id : vals.join(','),
					text : txts.join(',')
				})
		this.collapse();
	},
	
	simpleConfirm : function() {
		if(!node.isLeaf()){
			return false;
		}
		var node = this.tree.getSelectionModel().getSelectedNode();;
		this.setValue({
					id : node.id,
					text :node.text
				})
		this.collapse();
	},
	cancel : function() {
		this.collapse();
	}
});

Ext.reg('combotree', Ext.ux.ComboBoxTree);