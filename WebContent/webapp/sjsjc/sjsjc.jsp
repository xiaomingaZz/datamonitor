<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Date,java.util.Calendar"%>
<%@page import="tdh.frame.web.util.WebUtils"%>
<%@page import="tdh.framework.util.StringUtils"%>
<%@page import="java.text.SimpleDateFormat,tdh.util.CalendarUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String CONTEXT_PATH =  WebUtils.getContextPath(request);
	
	String fydm = StringUtils.trim(request.getParameter("fy"));
	if("".equals(fydm)){
		fydm = "42";
	}
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
	
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	calendar.add(Calendar.DAY_OF_MONTH,-1);
	String jssj = sdf.format(calendar.getTime());
	String kssj = jssj.substring(0,4)+"年01月01日";
	
	String gzOption = "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>收结存比对</title>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/jquery/jquery.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/js/fixedTable.js"></script>
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/ztree/jquery.ztree.core-3.5.min.js"></script>
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/ext/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="<%=CONTEXT_PATH%>/ext/js/tree.js"></script>
<link rel="stylesheet" type="text/css" href="<%=CONTEXT_PATH%>/ext/css/flat.css">
<link rel="stylesheet" href="<%=CONTEXT_PATH%>/ext/loadmask/jquery.loadmask.css" type="text/css" /> 
<script type='text/javascript' src='<%=CONTEXT_PATH%>/ext/loadmask/jquery.loadmask.js'></script>

<script src="<%=CONTEXT_PATH%>/ext/DatePicker/WdatePicker.js"></script>

</head>
<body>

<div style="margin:0px 5px;padding: 0px;">
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
		<tr>
			<td width="235px" >
				<table cellpadding="0" cellspacing="0" border="0">
	 	 			<tr><td class="tab_top_left"></td><td class="tab_top_center"></td><td class="tab_top_right"></td></tr>
	 	 			<tr>
	 	 				<td class="tab_left"></td>
	 	 				<td class="tab_center">
	 	 					<input type="hidden" id="ywcbValue">
							<input type="hidden" id="ywcb">
							<div id="ywcbContent" class="menuContent" style="position:relative;overflow-x:hidden;overflow-y:auto;height:500px;">
								<ul id="ywcbTree" class="ztree" style="margin-top:0px;width:210px;height:100%;padding:0px;"></ul>
							</div>
	 	 				</td>
	 	 				<td class="tab_right"></td>
	 	 			</tr>
	 	 			<tr><td class="tab_bottom_left"></td><td class="tab_bottom_center"></td><td class="tab_bottom_right"></td></tr>
	 	 		</table>
			</td>
			<td valign="top" style="border: 1px solid #2FBBDC;">
				<div id="tableContent" style='background-color: #F4F4F4;'>
					
	 	 			<div style="width: 100%;height: 30px;font-size: 13px;background-color: #F4F4F4;">
	 	 			<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td align="left" >
							&nbsp;&nbsp;
								统计月份
								<input type="text" id="kssj" value="<%=kssj%>" readonly class='selDate'/>
								至
								<input type="text" id="jssj" value="<%=jssj%>" readonly class='selDate'/>
							
							&nbsp;&nbsp;
							<input type="button" value="查询" onclick="javascript:doCx()" class="s_btn">
							&nbsp;&nbsp;
							<input type="button" value="导出" onclick="javascript:doExport('table')" class="s_btn">
							</td>
							<td align='right'>数据加工截止时间：<span id='sj' style='color:blue;'></span></td>
						</tr>
					</table>
	 	 			</div>
	 	 			<div id="table" style="width:100%;height: 500px;overflow-y:auto;overflow-x:hidden;"></div>
				</div>
				<div style='height:60px;font-size:10px;'>
					说明：<br>
					所有的数据统计都是截止至昨天23:59:59，即T-1天，即今天查看数据，统计口径都是截止昨晚的
				</div>
			</td>
		</tr>
	</table>
</div>
<jsp:include page="/webapp/export/xls.jsp"></jsp:include>
</body>
<script type="text/javascript">
	var contextPath = '<%=CONTEXT_PATH%>';
	var fydm = '<%=fydm%>';
	
	function bindRq() {
		
		$("#kssj").bind("click",function() {
			WdatePicker({
				dateFmt : "yyyy年MM月dd日"
			});
		});
		
		$("#jssj").bind("click",function() {
			WdatePicker({
				dateFmt : "yyyy年MM月dd日"
			});
		});
		
	}
	
	$(document).ready(function(){
		bindRq();
		initTree([{'contentid':'ywcbContent','treeid':'ywcbTree','inputid':'ywcb','selected':['<%=fydm%>'],'expand':true,'hide':false,
			'valueid':'ywcbValue','onClick':ywcbClick,'url':contextPath+'/webapp/sjsjc/sjsjc_tree.jsp?'+"FYDM="+fydm}]);
		
		sizeChange(true);
		loadTable(1,true);
	});

	function ywcbClick(value){
		loadTable();
	}
	
	function gzClick(){
		
	}
	
	function loadData(url,args,callback){
		$.ajax({type: "POST",url: url+"?etc="+new Date().getTime(),data: args,'dataType':'json',success: function(msg){callback(msg);}});
	}

	function loadTable(start,first){
		var fydm=$('#ywcbValue').val();
		if(fydm==null||fydm==''||ywcb==undefined){
			fydm = '<%=fydm%>';
		}
		var kssj = $("#kssj").val().replace("年","").replace("月","").replace("日",""); 
		var jssj = $("#jssj").val().replace("年","").replace("月","").replace("日",""); ; 
		var limit = $("#limit option:selected").val(); 
		$("#tableContent").mask("正在加载数据,请稍候..."); 
		loadData('sjsjc_data.jsp',{'kssj':kssj,'jssj':jssj,'FYDM':fydm},function(json){
			$("#tableContent").unmask();
			$("#table").html(json.table);
			$("#sj").html(json.sj);
			if(first){
				$("#detail").FixedHead({ tableLayout: "fixed" });
			}else{
				$("#detail").sizeChange();
			}
			
		});
	}
	
	function sizeChange(first){
		var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		// 125 log高度 22 上下边框高度 5 最下边距
		$("#ywcbContent").css({'height':h-22-5});
		// 125 log高度 30 分页区高度 2 div 边框高度 5 最下边距
		// 235 承办宽度 10 左右边距
		$("#table").css({'height':h-30-2-5-60,'width':w-235-10});
		if(!first){
			$("#detail").sizeChange();
		}
	}
	
	function doCx(){
		loadTable();
	}
	
	window.onresize = function(){sizeChange(false);};
	
	function showVideo(url){
		var width = window.screen.availWidth - 10;
		var height = window.screen.availHeight - 30;
		var Left_size = (screen.width) ? (screen.width - width) / 2 : 0;
		var Top_size = (screen.height) ? (screen.height - height) / 2 : 0;
		window.open(url, '_blank', 'width=' + width + 'px, height=' + height + 'px, left=' + Left_size + 'px, top=' + Top_size + 'px,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
	}
	
	function doFc(dm,kssj,jssj,flag){
		window.open('fc/sjc_fc.jsp?fy='+dm+'&flag='+flag+'&kssj='+kssj+'&jssj='+jssj);
	}
</script>
</html>