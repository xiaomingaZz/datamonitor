Ext.onReady(function(){   
      
            var item1 = new Ext.Panel({
                title: '系统参数设定',
                contentEl: 'cl',
                cls:'empty'
            });

            var item2 = new Ext.Panel({
                title: '系统参数设定',
                contentEl: 'cl',
                cls:'empty'
            });


            var accordion = new Ext.Panel({
				title: '系统菜单',
                region:'west',
				split:true,
				collapsible: true,
                width: 170,
                minSize: 150,
                maxSize: 400,
                margins:'5 0 5 5',
                layout:'accordion',
                layoutConfig:{
                    animate:true
                },
                items: [item1, item2]
            });

            var viewport = new Ext.Viewport({
                layout:'border',
                items:[ 
				    new Ext.BoxComponent({ // raw
                    region:'north',
                    el: 'north',
                    height:70
                    }),
                    accordion, {
                    region:'center',
                    margins:'5 5 5 0',
                    cls:'empty',
                    bodyStyle:'background:#f1f1f1',
                    html:'<iframe name="console" width=100% height=100% frameborder=0></iframe>'
                }]
            });
	   
});