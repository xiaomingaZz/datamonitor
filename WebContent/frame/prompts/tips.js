/**
 * 页面提示Tips
 * 
 */
Ext.onReady(function() {
	var tips = new Ext.ux.TipsWindow({
		layout : "fit",
		title : "<span style='font-size:12px;'>系统提示</span>",
		width : 280,
		id : "TIPS",
		height : 55,
		autoHide : 270,// 270s后自动隐藏,单位是s
		plain : false,
		bodyStyle : "padding:2px;background-color:#ffffff"
	});

    if(isPlayMp3)
    {
		soundManager.setup({
			url : CONTEXT_PATH + "/frame/prompts/sound/swf/",
			flashVersion : 9,
			debugMode : false,
			useFlashBlock : false,
			onready : function() {
				soundManager.createSound({
					id : "msgSound",
					autoLoad : true,
					autoPlay : false,
					url :  CONTEXT_PATH +"/frame/prompts/sound/mp3/msg.mp3",
					volume : 80
				});
			}
		});
	}

	var tipsTask = {
		run : function() {
			// 取未待办数量,若大于0,则显示窗口,播放声音
			Ext.Ajax.request({
				url:CONTEXT_PATH +'/SysPromptsRequest',
				method : "POST",
				params : { time : new Date().getTime()},
				success : function(response) {
					var result = response.responseText;
					if (result !='') {
					   if(isPlayMp3) 
					   {
					   	soundManager.play("msgSound");
					   }
						tips.show();
						tips.update(result);
						myGod('_tipsDiv',2000,-1);
					}
				}
			});
		},
		interval : 300 * 1000
	// 重复的时间,300s
	}
	
	
	function myGod(id,w,n){
		try{
			var box=document.getElementById(id);
			var can=true,w=w||1500,fq=fq||10,n=n==-1?-1:1;
			if(box){
				box.innerHTML+=box.innerHTML;
				box.onmouseover=function(){can=false};
				box.onmouseout=function(){can=true};
				var max=parseInt(box.scrollHeight/2);
				new function (){
					try{
						var stop=box.scrollTop%18==0&&!can;
						if(!stop){
							var set=n>0?[max,0]:[0,max];
							box.scrollTop==set[0]?box.scrollTop=set[1]:box.scrollTop+=n;
						};
						setTimeout(arguments.callee,box.scrollTop%18?fq:w);
					}catch(e){
					}
				};
			}
		}catch(e){
		}
	 };
	 

	Ext.TaskMgr.start(tipsTask);
	
})

function tipsGoto(url){
     if(url == '') return;
	 $('#frameTarget').attr('src',url);
	 Ext.getCmp('TIPS').hide();
}