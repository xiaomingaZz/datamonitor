<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html>
  <head>
    <title>广西数据中心数据监控平台</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/ext/inc/ext-js3.jsp"%>
	<script type="text/javascript">
	Ext.onReady(function(){
		var mainPanle = new Ext.Panel({
			layout:'border',
			items:[
			 new Ext.BoxComponent({ 
                 region:'north',
                 el:'north',
                 border:false,
                 height:66
     		 }),
			 new Ext.TabPanel({
				region:'center',
				activeTab: 0,
				 border:false,
				resizeTabs : true,
        		tabWidth : 120,
				items:[
				{title:'收结存对比',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/sjsjc/sjsjc.jsp"></iframe>'},
				{title:'信访案件统计',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/sjsjcxf/sjsjc_xf.jsp"></iframe>'},
                {title:'质量报告',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/zlbg/main.jsp"></iframe>'},
				{title:'每日报送',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/jrxsyj/main.jsp"></iframe>'},
				{title:'解压监控',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/rarrz/main.jsp"></iframe>'},
				{title:'XML监控',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/filejk/main.jsp"></iframe>'},
				{title:'解析监控',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/sjjhjk/main.jsp"></iframe>'},
				{title:'案件信息跟踪',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/ajcx/main.jsp"></iframe>'},
				{title:'文书质检',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/wszj/main.jsp"></iframe>'}
				/*,
				{title:'每日收结案数',html:'<iframe width="100%" height="100%" frameborder="0" src="webapp/mrsja/main.jsp"></iframe>'}*/
				
				]
			})]
		});
		new Ext.Viewport({
			layout:'fit',
			items:mainPanle
		});
	});
	</script>
  </head>
  <body>
  <div style="display:none;">
  	<div id="north">
  	<table width=100% height=100% cellspacing="0" cellpadding="0" border="0">
  		<tr>
  			<td width=550  style="background-repeat:no-repeat;overflow:hidden;" background="images/ver4/head_left.png">
  			<div style="font-size:30px;color:#ffffff;margin-left:90px;"><b>广西法院数据中心监控平台</b></div>
  			</td>
  			<td width="*" style="background:url('images/ver4/head_middle.png');overflow:hidden;" align="right">
  			&nbsp;
  			</td>
  			<td  style="background-repeat:no-repeat;" background="images/ver4/head_right.png"  align="right" width="500">
  			</td>
  		</tr>
  	</table>
  	</div>
  </div>
  </body>
</html>
