/**
 * @author zqw
 * 用于加载ztree 
 * treeRender = [{},{},..] ztree渲染器
 * 数组中的每个对象为一个tree 包含显示该tree的
 * @requires url:数据源加载地址,'contentid','treeid','inputid','valueid'
 * @requires contentid:显示ztree的容器主要为一个div
 * @requires treeid :ztree的id
 * @requires inputid:ztree值输入的地方，需要给该组件一个点击事件显示tree:showMenu(inputid,contentid)
 * @requires valueid:用于保存选择值得事件
 * 在页面加载时需要使用initTree(treeRender)初始化ztree
 * 在contendid对应的容器中可以添加clear(inputid,valueid) 清空数据，hideMenu(contentid)隐藏ztree
 */
var setting = {
		view : {
			dblClickExpand : false
		},
		data : {
			simpleData : {
				enable : true
			}
		},
		callback : {
			beforeClick : beforeClick,
			onClick : onClick
		}
	};

//包含{'url','contentid','treeid','inputid','valueid'}
var treeRender=[];

function initTree(ren){
	//后台获取案由树数据
	treeRender = ren;
	for(var i=0;i<treeRender.length;i++){
		var obj = treeRender[i];
		var args={};
		if(obj.hasOwnProperty('args')){
			args=obj["args"];
		}
		var selected = null;
		if(obj.hasOwnProperty('selected')){
			selected = obj['selected'];
		}
		var expand = false;
		if(obj.hasOwnProperty('expand')){
			expand = obj['expand'];
		}
		loaddata(obj['url'],$('#'+obj['treeid']),obj['treeid'],args,selected,expand);
	}
}

function loaddata(url,tree,treeid,args,selected,expand){
	$.ajax({
		type:'post',
		dataType:'json',
		url:url,
		args:args,
		success:function(data,status){
			var treeObj = $.fn.zTree.init(tree,setting,data);
			var nodes = treeObj.getNodes();
			if(expand){
				for(var i=0;i<nodes.length;i++){
					treeObj.expandNode(nodes[i]);
				}
			}
			if(selected!=null){
				for(var i=0;i<selected.length;i++){
					var node = treeObj.getNodeByParam("id", selected[i]);
					treeObj.selectNode(node,false);
				}
			}
		}
	});
}

//显示树形窗口
function showMenu(inputid,contentid) {
	var inputCom = $("#"+inputid);
	var inputOffset = $("#"+inputid).offset();
	$("#"+contentid).css({
		'left' : inputOffset.left + "px",
		'top' : inputOffset.top + inputCom.outerHeight() + "px",
		'background': '#d0d0d0',
		'border' : '1px solid #CCCCCC',
		'padding' : '0px',//内边距
		'margin' : '1px',//外边距
		'text-align': 'right'
	}).slideDown("fast");
	$("body").bind("mousedown", onBodyDown);
}

function treeclear(inputid,valueid){
	$("#"+inputid).attr("value","");
	$("#"+valueid).attr("value","");
}

function hideMenu(contentid) {
	$("#"+contentid).fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}

//bodyDown
function onBodyDown(event) {
	for(var i=0;i<treeRender.length;i++){
		var obj = treeRender[i];
		if (!(event.target.id == obj["contentid"] || $(event.target).parents("#"+obj["contentid"]).length > 0)) {
			if(!obj.hasOwnProperty('hide')||obj['hide']){
				hideMenu(obj["contentid"]);// 点击后，隐藏 
			}
		}
	}
}

function beforeClick(treeId, treeNode) {
	return treeNode;
}

function onClick(e, treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj(treeId);
	var nodes = zTree.getSelectedNodes();
	var v = "";
	var value = "";
	nodes.sort(function compare(a, b) {
		return a.id - b.id;
	});
	for ( var i = 0, l = nodes.length; i < l; i++) {
		v += nodes[i].name + ",";
		value += nodes[i].id + ",";
	}
	if (v.length > 0){
		v = v.substring(0, v.length - 1);
	}
	if (value.length > 0){
		value = value.substring(0, value.length - 1);
	}
	for(var i=0;i<treeRender.length;i++){
		var obj=treeRender[i];
		if(obj["treeid"]==treeId){
			$("#"+obj["inputid"]).attr("value",v);
			$("#"+obj["valueid"]).attr("value",value);
			if(obj.hasOwnProperty('onClick')){
				obj["onClick"](value);
			}
			if(!obj.hasOwnProperty('hide')||obj['hide']){
				hideMenu(obj["contentid"]);// 点击后，隐藏 
			}
			return;
		}
	}
}