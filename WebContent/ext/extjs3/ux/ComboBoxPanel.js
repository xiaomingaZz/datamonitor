/**
 * 
 */
Ext.ux.ComboBoxPanel = function() {
	this.treeId = Ext.id() + '-panel';
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
	this.border =false;
	this.addEvents('afterchange');

	Ext.ux.ComboBoxPanel.superclass.constructor.apply(this, arguments);
};

Ext.extend(Ext.ux.ComboBoxPanel, Ext.form.ComboBox, {
	// bug处
	assertValue : function() {
	},
	initResizer : function() {
		var resizer = new Ext.Resizable(this.list, {
					width : this.listWidth,
					height : this.maxHeight/*,
					minWidth : 200,
					minHeight : 50*/
				});
		resizer.addListener('resize', function(res, w, h) {
					this.maxHeight = h - this.handleHeight
							- this.list.getFrameWidth('tb') - this.assetHeight;
					this.listWidth = w;
					this.innerList.setWidth(w - this.list.getFrameWidth('lr'));
					this.restrictHeight();
					this.panel.setHeight(h);
					this.panel.setWidth(w);
				}, this);
	},
	expand : function() {
		Ext.ux.ComboBoxPanel.superclass.expand.call(this);
		if (this.panel.rendered) {
			return;
		}
		var me = this;
		if (this.enableTbar) {
			this.panel.tbar = [{
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
					},'-'];
		} 
		Ext.apply(this.panel, {
					height : this.maxHeight,
					border : false,
					autoScroll : true
				});
		if (this.panel.xtype) {
			this.panel = Ext.ComponentMgr.create(this.panel, this.panel.xtype);
		}
		this.panel.on('afterrender', this.initResizer, this);
		this.panel.render(this.treeId); 
		var objtype = Ext.getCmp('objtype').getValue(); 
		if(objtype=='FY')
		{ 
			this.panel.getLayout().setActiveItem(0);
		}
		if(objtype=='TS')
		{ 
			this.panel.getLayout().setActiveItem(1);
		}
		if(objtype=='RY')
		{ 
			this.panel.getLayout().setActiveItem(2);
		}
		
		// used to add records to the destination stores
		//var blankRecord =  Ext.data.Record.create(fields); 
        // This will make sure we only drop to the  view scroller element
        //var firstGridDropTargetEl =  firstGrid.getView().scroller.dom;
        //var firstGridDropTarget = new Ext.dd.DropTarget(firstGridDropTargetEl, {
                //ddGroup    : 'firstGridDDGroup',
              //  notifyDrop : function(ddSource, e, data){
                      //  var records =  ddSource.dragData.selections;
                       // Ext.each(records, ddSource.grid.store.remove, ddSource.grid.store);
                       // firstGrid.store.add(records);
                       // firstGrid.store.sort('name', 'ASC');
                       // return true
                //}
       // });


        // This will make sure we only drop to the view scroller element
       // var secondGridDropTargetEl = secondGrid.getView().scroller.dom;
       // var secondGridDropTarget = new Ext.dd.DropTarget(secondGridDropTargetEl, {
                //ddGroup    : 'secondGridDDGroup',
               // notifyDrop : function(ddSource, e, data){
                       // var records =  ddSource.dragData.selections;
                       // Ext.each(records, ddSource.grid.store.remove, ddSource.grid.store);
                       // secondGrid.store.add(records);
                       // secondGrid.store.sort('name', 'ASC');
                       // return true
               // }
        //});
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
		 
	},

	getValue : function() {
		return typeof this.value != 'undefined' ? this.value : '';
	},

	getNode : function() {
		return this.node;
	},

	clearValue : function() {
		Ext.ux.ComboBoxPanel.superclass.clearValue.call(this);
		this.panel.getRootNode().cascade(function(n){
			n.checked=false;
			n.attributes.checked=false;
			n.ui.toggleCheck(false);
			return true;
		});
		this.node = null;
	},
 
	// private
	destroy : function() {
		Ext.ux.ComboBoxPanel.superclass.destroy.call(this); 
		Ext.destroy([this.panel]); 
	},
	onSelect : Ext.emptyFn,
	onViewClick : Ext.emptyFn,
	 
	confirm : function() {},
	collapse : function(){
        if(!this.isExpanded()){
            return;
        } 
        //if(bmCombo.isExpanded())
        //{
        	 //return;
        //}
        //else{
	        this.list.hide();
	        Ext.getDoc().un('mousewheel', this.collapseIf, this);
	        Ext.getDoc().un('mousedown', this.collapseIf, this);
	        this.fireEvent('collapse', this);
        //}
    },
	cancel : function() {
		this.collapse();
	}
});

Ext.reg('combopanel', Ext.ux.ComboBoxPanel);