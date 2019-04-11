/**
*系统提示信息。
*/
var msgWin;
var msgWinClose = true;

function showSysInfo(){
	window.open('resources/release/Issue_all.jsp');
}

 Ext.onReady(function(){
    var eBody = Ext.getBody();
    var msgWinConfig = { width: 350, height: 230 };
    var openMsgWinConfig = { width: 29, height: 28 };
    var openMsgWin = new Ext.Window({
         closable: false, shadow: false, border:false,resizable: false, x: eBody.getWidth() - openMsgWinConfig.width, y: eBody.getHeight() - openMsgWinConfig.height,
         width: openMsgWinConfig.width, height: openMsgWinConfig.height,
         layout:'fit'
         , items: [{plain:true,html:'<img title="系统消息" style="cursor:hand;" onclick="hideMsg();" src="resources/images/tools/advanced_search.png">'}]
         , flyIn: function() {
             var myWin = openMsgWin;
             myWin.show();
             myWin.getEl().shift({ x: eBody.getWidth() - myWin.getWidth(), y: eBody.getHeight() - myWin.getHeight() });
         }
         , flyOut: function() {
             if (!this.isVisible()) { return; }
             var myWin = openMsgWin;
             myWin.getEl().shift({ x: eBody.getWidth() - myWin.getWidth(), y: eBody.getHeight() });
             myWin.hide();
         }
    });
    
  
    msgWin = new Ext.Window({
                resizable: false,
                title:'<span style="font-size:12px;">系统更新消息</span><span style="width:180px;"></span><a href="#"  style="color:red;font-size:12px;" onclick="showSysInfo();">更多信息</a>',
                x: eBody.getWidth() - msgWinConfig.width, y: eBody.getHeight(), width: msgWinConfig.width, height: msgWinConfig.height, shadow: false
                ,
                //bbar:['->','<input type="checkbox" id="ifshow">下次登录后不再提示'],
                layout:'fit', 
                listeners: {
                    beforeclose: function () {
                        //var win = this;
                        //win.flyOut();
                        //return false;
                        msgWinClose = true;
                        
                        /*
                        if($("#ifshow").attr("checked")==true){
				    		$.ajax({
				  			type:'POST',
				  			url:'/resources/release/do.jsp'
				  			});
				    	}
				    	*/
                    }
                }
                , flyIn: function () {
                    var myWin = this;
                    myWin.show();
                    myWin.getEl().shift({
                        x: eBody.getWidth() - myWin.getWidth(),
                        y: eBody.getHeight() - myWin.getHeight(),
                        opacity: 80,
                        easing: 'easeOut',
                        duration: .35
                    });
                    //openMsgWin.flyOut();
                    myWin.isFlyIn = true; 
                }
                , flyOut: function () {
                    var myWin = this;
                    myWin.getEl().shift({
                        y: eBody.getHeight()
                    });
                    //openMsgWin.flyIn();
                    //myWin.hide();
                    myWin.close();
                    
                    myWin.isFlyIn = false;
                }
                //自动设置位置
                , autoPosition: function () {
                    if (this.isFlyIn) { this.flyIn(); } else { this.flyOut(); }
                }
                /*
                ,
                listeners:{
                	afterrender:function()
                	{
                		this.load({url:'./resources/release/notice.jsp?etc='+new Date().getTime()});
                	}
                }
                */
            });

            Ext.EventManager.onWindowResize(function () {
               if(!msgWinClose){
                  msgWin.autoPosition();
                }
            });
                 
            
            Ext.defer(function(){
              //
              msgWin.flyIn();
              msgWinClose = false;
              msgWin.load({url:'./resources/release/notice.jsp?etc='+new Date().getTime()});            
            }
            ,3000); 
         
            Ext.defer(function(){
               if(!msgWinClose){
	            	msgWin.flyOut();
            	}
            },15000);  
			
			
}); 
