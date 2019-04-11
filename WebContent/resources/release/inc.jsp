<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="tdh.security.lic.License"%>
<%@ page import="tdh.frame.common.*,tdh.frame.web.context.*"%>
<%@ page import="tdh.frame.web.util.*"%>
<%@ page import="java.sql.*"%>
<%    
	License lic2 = (License)application.getAttribute(License.WEB_KEY);//注册信
	String productID = lic2.getProduct();
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	if(WebAppContext.getWebConfig().isOnlineShow()){
		out.print("<script>var isOnline = true;</script>");	
	}else{
		out.print("<script>var isOnline = false;</script>");
	}
	if(WebAppContext.getWebConfig().isIPWarn()){
		out.print("<script>var isIPWarn = true;</script>");	
	}else{
		out.print("<script>var isIPWarn = false;</script>");
	}
	if(WebAppContext.getWebConfig().isPlayMp3()){
		out.print("<script>var isPlayMp3 = true;</script>");	
	}else{
		out.print("<script>var isPlayMp3 = false;</script>");
	}
	String userid = WebAppContext.getCurrentUser().getYhdm();
	%>
	<script type="text/javascript">
	 var ipWarnWin;
	 var _current_fydm = '<%=WebAppContext.getCurrentFydm()%>';
	 function showIpMore(){
	 	ipWarnWin.show();
	 	Ext.getCmp('ipgrid').getStore().reload();
	 }
	 Ext.onReady(function(){
		  //2013-7-1 施健伟 增加客户端心跳包请求
		  //用于检测是否在线配合服务端统计在线人员以及消息服务	
		  //2013-10-22 施健伟 心跳报改成总是有效，用于判断是否超期（已注销）或者用户和session的用户不匹配	
		  
		  var cm = new Ext.grid.ColumnModel([ 
		  {
				header : 'IP地址',
				width : 150,
				dataIndex : "LOGINIP",
				hideable : false
			},{
				header : "登录时间",
				dataIndex : "LOGINTIME",
				sortable : true,
				align : 'left',
				width : 150,
				hideable : false
			}]);
			
		  var grid = new Ext.grid.GridPanel({
				cm : cm,
				id:'ipgrid',
				store: new Ext.data.JsonStore({
				    url: 'resources/release/logininfo.jsp',
				    root: 'root',
				    fields: ["LOGINIP","LOGINTIME"]
				}),
				stripeRows : true,
				loadMask : {
					msg : '正在加载数据，请稍侯……'
				}
		   });
	
		  ipWarnWin = new Ext.Window({
		  		title:'登录提醒',
		  		width:400,
		  		height:200,
		  		closeAction:'hide',
		  		layout:'fit',
		  		items:grid
		  });
		  
			var task = {
			    run: function(){
			       Ext.Ajax.request({
			           params:{userid:'<%=userid%>' },
			       	   url:CONTEXT_PATH +'/UpdateActiveUserTime',
					   success: function(resp){
					      if(resp.responseText.trim() == 'expire'){
					    	    var win = new Ext.Window({
						    	    title:'系统消息',
						    		width: 400,
						    		height: 120,
						    		modal:true,
						    		plain : true,
						    		//bodyStyle : "padding:2px;background-color:#ffffff",
						    		closable : false,
						    		html:'<div style="text-align:center;height:50px;color:red;"><br>对不起,您的登录超期或者已被注销,请重新登录!</div>',
						    		buttonAlign:'center',
						    		buttons:[{
						    		text:'重新登录'
						    		,handler:function(){
						    			window.location.reload();
						    		}}]
						    	}).show();
						    	Ext.TaskMgr.stop(task); 
					      }else{
					      	//
					      	var res = resp.responseText.trim();
					      	var data = res.split(";");
					      	if(isOnline){
					     	  document.getElementById('_onlineCount').innerHTML=data[0]
					     	}
					     	//
					     	if(isIPWarn){
					     		if(data[1] != '0'){
					     			document.getElementById('ipwarn_panel').style.display="block";
					     		}else{
					     			document.getElementById('ipwarn_panel').style.display="none";
					     		}
					     	}
					      }
					   },
					   failure: function(){}
			       });
			    },
			    interval: 1000 * 60 //1 second
			};		
			Ext.TaskMgr.start(task);		
		});
	</script>
	<%
	try{
		conn = SpringBeanUtils.getConn(request);
		stmt = conn.createStatement();
		String lastmax = "0",lastmy="0";
		String sql = "select max(REASLE_DATE) from T_VERSION";
		String sq12 = "select REASLE_DATE from T_VERSION_LOG where YHDM='"+userid+"' AND APP_ID='"+productID+"' ";
	  	if(!"FRAME".equals(productID)){
	  		sql = "select max(REASLE_DATE) from T_VERSION  where APP_ID='"+productID+"'";
	  	}
	  	rs = stmt.executeQuery(sql);
	  	if(rs.next()){
	  		lastmax = UtilComm.trim(rs.getString(1));
	  	}
	  	rs.close();
	  	rs = stmt.executeQuery(sq12);
	  	if(rs.next()){
	  		lastmy = UtilComm.trim(rs.getString(1));
	  	}
	  	if(UtilComm.isEmpty(lastmax)) lastmax ="0";
	  	if(UtilComm.isEmpty(lastmy)) lastmy ="0";
	  	
	  	if(Integer.parseInt(lastmax)>Integer.parseInt(lastmy)){
	  		%>
	  		<script src="<%=WebUtils.getContextPath(request) %>/frame/js/SysMsg.js"></script>
	  		<%
	  	}
	}catch(Exception  e){
		e.printStackTrace();
	}finally{
		DBUtils.close(conn,stmt,rs);
	}

%>